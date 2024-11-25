#!/bin/bash

readonly MANUAL_ENROLLMENT=manual_enrollment
readonly AUTOMATED_ENROLLMENT=automated_enrollment

ENROLLMENT_TYPE=${AUTOMATED_ENROLLMENT}

function main() {
  check_and_change_ownership "$HOME/.docker/"
  check_docker_compose_version
  set_env_for_takserver_enrollment_type
  echo "--- check vars ----"
  echo "Domain or IP ENV: ${IP_OR_DOMAIN_NAME}"
  echo "CAPASS: ${CAPASS}"
  echo "SERVER_NAME: ${SERVER_NAME}"
  echo "TAKSERVER_ADDRESS: ${TAKSERVER_ADDRESS}"

#   echo -e "This script will take the following actions:
#       1.  assumes Takserver is already unzipped int this directory
#       2. Run 'docker compose up -d' (you must have docker-cli installed) and confirm that your containers were created.
#       3. Wait for cert creation and attempt to automatically import. You may need to do this manually if it fails.
#       4. Open your browser to your local IP address

#       ** If you are running Ubuntu 19.01 or later, you must manually import your Admin cert after this script. **"

#   read -p "Do you want to continue [y/n]: " INPUT
#   [ "$INPUT" = "n" ] && exit 0

#   echo "Domain or IP ENV: ${IP_OR_DOMAIN_NAME}"
#   echo "CAPASS: ${CAPASS}"
#   echo "SERVER_NAME: ${SERVER_NAME}"

  docker pull eclipse-temurin:17-jammy
  docker pull postgres:15.1

#   unzip_takserver
  compose_and_check_container_status



  wait_for_plugin_service
  wait_for_shared_volumes


  echo "Running the Army Software Factory Configurator"
  sudo docker exec takserver /opt/configurator/configurator.sh

#   sudo chown -R "$_USER:$_GROUP" ./plugins

#   if [[ "$ENROLLMENT_TYPE" == "${MANUAL_ENROLLMENT}" ]]; then
#     wait_for_cert_validation
#     import_cert_to_keychain
#   fi

#   if [[ "$OSTYPE" != "darwin"* ]]; then
#     copy_files_to_shared_folder
#   fi

#   open_browser_to_takserver
}

check_and_change_ownership() {
    CURRENT_USER=$(id -un)
    CURRENT_GROUP=$(id -gn)

    if [ ! -d "$1" ]; then
        echo "Directory $1 does not exist."
        return 1
    fi

    OS_TYPE=$(uname)

    # shellcheck disable=SC2044
    for item in $(find "$1"); do
        if [[ "$OS_TYPE" == "Darwin" ]]; then
            ITEM_USER=$(stat -f "%Su" "$item")
            ITEM_GROUP=$(stat -f "%Sg" "$item")
        else
            ITEM_USER=$(stat -c '%U' "$item")
            ITEM_GROUP=$(stat -c '%G' "$item")
        fi

        if [ "$ITEM_USER" != "$CURRENT_USER" ] || [ "$ITEM_GROUP" != "$CURRENT_GROUP" ]; then
            sudo chown "$CURRENT_USER:$CURRENT_GROUP" "$item"
        fi
    done
}

function check_docker_compose_version() {
  COMPOSE_VERSION=$(docker compose-version || docker compose version)

  if [[ "$COMPOSE_VERSION" == *"v1"* ]]; then
    echo -e "Docker compose V1 is deprecated. Please upgrade your docker version to use docker compose V2."
    read -p
    exit 1
  fi
}

function set_env_for_takserver_enrollment_type() {
  if grep -q "ENV ENROLLMENT_TYPE=manual_enrollment" "Dockerfile-takserver"; then
    ENROLLMENT_TYPE=${MANUAL_ENROLLMENT}
    set_takserver_address 8443
  else
    set_takserver_address 8446
  fi

  RESOURCE=$(ls takserver-docker-*.zip)
  RESOURCE_FOLDER=./${RESOURCE%.zip}
  USER_AUTH_FILE=/opt/tak/UserAuthenticationFile.xml
  PK_FILE_PATH=./shared/Takserver-Admin-1/certs/Takserver-Admin-1.p12
  _USER=$(id -un)
  _GROUP=$(id -gn)
}

function set_takserver_address() {
  set_machine_ip
  PORT=$1
  TAKSERVER_ADDRESS="https://$IP:$PORT"
}

function set_machine_ip() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    IP=$(ifconfig | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | head -n1)
  else
    IP=$(ip "address" | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | head -n1 | cut -d "/" -f 1)
  fi
}

function unzip_takserver() {
  if [ ! -d "tak-server" ]; then
    echo -e "\nExpanding $RESOURCE\n"
    unzip "$RESOURCE" &>/dev/null
    mv "$RESOURCE_FOLDER" "./tak-server"
  fi
}

function compose_and_check_container_status() {

  if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo docker pull eclipse-temurin:17-jammy
    sudo docker pull postgres:15.1
  fi

  if which docker-compose >/dev/null; then
    sudo docker-compose up -d
  else
    sudo docker compose up -d
  fi

  TAKSERVER_CONTAINER_NOT_RUNNING=$(sudo docker ps | grep -E "\btakserver(\s|$)")
  TAKSERVERDB_CONTAINER_NOT_RUNNING=$(sudo docker ps | grep -w "tak-database")

  if [ -z "$TAKSERVER_CONTAINER_NOT_RUNNING" ] || [ -z "$TAKSERVERDB_CONTAINER_NOT_RUNNING" ]; then
    echo "TAK Server containers failed to start.  Shutting down..." && exit 1
  else
    echo "takserver and tak-database containers were successfully created."
  fi
}

function wait_for_plugin_service() {
  JPSOUT=$(sudo docker exec takserver jps | grep takserver-pm | cut -d " " -f 1)

  echo -e "\nWaiting for plugin service to start..."
  until sudo docker exec takserver jmap -histo:live "$JPSOUT" | grep "tak.server.plugins.service.PluginService" &>/dev/null; do
    sleep 3
  done
  echo -e "Plugin Service Started\n"
}

function wait_for_shared_volumes() {
  echo -e "Waiting for shared volume..."
  until [ -d ./shared ]; do
    sleep 3
  done
  echo -e "Shared Volume Created\n"
}

function wait_for_cert_validation() {
  echo -e "Waiting for Admin Cert Validation\n"
  until sudo docker exec takserver cat "$USER_AUTH_FILE" 2>/dev/null | grep -q Takserver-Admin-1 &>/dev/null; do
    sleep 3
  done
}

function wait_for_cert_generation() {
  echo -e "Waiting for cert generation..."
  until test -f "$PK_FILE_PATH"; do
    sleep 2.5
  done
  echo -e "Admin Cert Found!!\n"
}

function import_cert_to_keychain() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    wait_for_cert_generation
    security import "$PK_FILE_PATH" -k ~/Library/Keychains/login.keychain-db -P atakatak
  else

    copy_files_to_shared_folder
    if ! pk12util -d sql:"$HOME"/.pki/nssdb -i "$PK_FILE_PATH" -W atakatak; then
      echo -e "\nCertificate import failed... Either you do not have libnss3-tools installed or something went wrong.\n
      Please import your certificate manually from the ./shared folder

      - Go to Settings > Privacy and Security > Security > Manage Certificates\n"
    fi
  fi
}

function copy_files_to_shared_folder() {
  echo -e "Copying files to shared volume\n"

  sudo docker cp takserver:/opt/tak/certs/files/. ./shared

  if [[ "$ENROLLMENT_TYPE" == "${MANUAL_ENROLLMENT}" ]]; then
    until test -f "$PK_FILE_PATH"; do
      sleep 3
    done
  fi

  sudo chown -R "$_USER:$_GROUP" ./shared
}

function open_browser_to_takserver() {

  sudo docker restart takserver
  echo -e "Waiting for server to receive connections..."

  if command -v wget &>/dev/null; then
    TAKSERVER_RESPONSE=$(wget --spider -S --no-check-certificate "https://$IP:8446" 2>&1 | grep "HTTP/" | awk '{print $2}')
    until [[ "$TAKSERVER_RESPONSE" == "403" ]]; do
      TAKSERVER_RESPONSE=$(wget --spider -S --no-check-certificate "https://$IP:8446" 2>&1 | grep "HTTP/" | awk '{print $2}')
      sleep 1
    done
  else
    TAKSERVER_RESPONSE=$(curl -kw '%{http_code}' -so /dev/null "https://$IP:8446")
    until [[ "$TAKSERVER_RESPONSE" == "403" ]]; do
      TAKSERVER_RESPONSE=$(curl -kw '%{http_code}' -so /dev/null "https://$IP:8446")
      sleep 1
    done
  fi

  echo -e "Opening browser to $TAKSERVER_ADDRESS ..."

  if [[ "$OSTYPE" == "darwin"* ]]; then
    open -a "Google Chrome" "$TAKSERVER_ADDRESS"
  else
    firefox --new-window "$TAKSERVER_ADDRESS" &>/dev/null
  fi
}

source .env
main