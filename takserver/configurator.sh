#!/bin/bash

function main(){
  INTERMEDIATE="${SERVER_NAME}CA1"
  setup

  echo "Creating Certificates"

  create_tak_server_certificates

  echo "tak certs done, enrollment next: $ENROLLMENT_TYPE"
  
  if [ "$ENROLLMENT_TYPE" = "manual_enrollment" ]; then
    create_user_and_admin_certificates
  fi

  echo "wait for plugins service to start.."
  wait_for_plugin_service_to_start
  echo "plugins service has been started"

  chmod +x /opt/tak/utils/UserManager.jar
  if [ "$ENROLLMENT_TYPE" = "manual_enrollment" ]; then
    echo "manual enrollment begins..."
    for i in $(seq 1 "$ADMINS_COUNT"); do
      create_tak_server_admin_user $i
      if [ "$SERVER_NAME" != "" ]; then
        create_manual_enrollment_mission_package "Admin" $i
      else
        copy_manual_enrollment_certificates_to_shared_directory "Admin" $i
      fi
    done

    for i in $(seq 1 "$USER_COUNT"); do
      create_tak_server_client_user $i
      if [ "$SERVER_NAME" != "" ]; then
        create_manual_enrollment_mission_package "User" $i
      else
        copy_manual_enrollment_certificates_to_shared_directory "User" $i
      fi
    done

    if [ "$SERVER_NAME" != "" ]; then
      copy_manual_enrollment_mission_packages_to_shared_directory
    fi

  else
    echo "Automated enrollment selected, first admin.."
    create_automated_enrollment_admin_account
    echo "Automated enrollment, now client..."
    create_automated_enrollment_client_account
    echo "Create Mission File Structure..."
    setup_automated_enrollment_mission_package_file_structure
    if [ "$SERVER_NAME" != "" ]; then
      echo "Creating Mission package"
      create_automated_enrollment_mission_package
      zip_mission_package "mission_package"
      copy_automated_enrollment_mission_package_to_shared_directory
    else
      cp /opt/tak/certs/files/truststore-${SERVER_NAME}CA1.p12 /opt/tak/certs/shared/
    fi
  fi
}


function setup(){
  if [ -d /opt/tak/certs/files ]; then
      exit 0
  fi
  cd /opt/tak/certs || echo "/opt/tak/certs folder doesn't exist"
}

function create_tak_server_certificates(){
  ./makeRootCa.sh --ca-name ${SERVER_NAME}CA0 &&
      if [ "$ENROLLMENT_TYPE" = "automated_enrollment" ]; then
        yes | ./makeCert.sh ca ${SERVER_NAME}CA1
      fi &&
      echo "Making Server Cert: ${IP_OR_DOMAIN_NAME}"
      ./makeCert.sh server ${IP_OR_DOMAIN_NAME}
}

function setup_manual_enrollment_mission_package_file_structure(){
    mkdir /opt/tak/certs/files/Takserver-"$1"-"$2"
    mkdir /opt/tak/certs/files/Takserver-"$1"-"$2"/certs
    if [ "$SERVER_NAME" != "" ]; then
      mkdir /opt/tak/certs/files/Takserver-"$1"-"$2"/manifest
    fi
}

function create_user_and_admin_certificates(){
  for i in $(seq 1 "$ADMINS_COUNT"); do
    setup_manual_enrollment_mission_package_file_structure "Admin" $i
    ./makeCert.sh client Takserver-Admin-"$i"
  done

  for i in $(seq 1 "$USER_COUNT"); do
    setup_manual_enrollment_mission_package_file_structure "User" $i
    ./makeCert.sh client Takserver-User-"$i"
  done
}

function wait_for_plugin_service_to_start(){
  JPSOUT=$(jps | grep takserver-pm | cut -d " " -f 1)
  echo "JPSOUT: ${JPSOUT}"
  until jmap -histo:live "$JPSOUT" | grep "tak.server.plugins.service.PluginService"; do
    echo "waiting..for...tak.server.plugins.service.PluginService"
    sleep 1
  done
}

function create_tak_server_admin_user(){
    java -jar /opt/tak/utils/UserManager.jar certmod -A /opt/tak/certs/files/Takserver-Admin-"$1".pem | tee -a scrape_file.txt
}

function create_tak_server_client_user(){
    java -jar /opt/tak/utils/UserManager.jar usermod -c /opt/tak/certs/files/Takserver-User-"$1".pem Takserver-User-"$1" | tee -a scrape_file.txt
}

function create_pref_and_manifest_files_by_role_and_count(){
  sed -e"s/{cert_path}/Takserver-$1-$2/" -e"/enrollForCertificateWithTrust/d" -e"/cacheCreds/d" -e"/useAuth/d" tak-server-configurator-template.pref > /opt/tak/certs/files/Takserver-"$1"-"$2"/certs/tak-server-configurator.pref
  sed "s/{cert_path}/Takserver-$1-$2/" tak-server-configurator-manifest.xml > /opt/tak/certs/files/Takserver-"$1"-"$2"/manifest/tak-server-configurator-manifest.xml
}

function zip_mission_package(){
  cd /opt/tak/certs/files/"$1"
  jar -cvf mission_package.zip manifest certs
  cd ../..
}

function create_manual_enrollment_mission_package(){
  mv /opt/tak/certs/files/Takserver-"$1"-"$2".p12 /opt/tak/certs/files/Takserver-"$1"-"$2"/certs
  cp /opt/tak/certs/files/truststore-root.p12 /opt/tak/certs/files/Takserver-"$1"-"$2"/certs
  create_pref_and_manifest_files_by_role_and_count "$1" "$2"
  zip_mission_package Takserver-"$1"-"$2"
}

function copy_manual_enrollment_mission_packages_to_shared_directory(){
  cp /opt/tak/certs/files/truststore-root.p12 shared/ 2>/dev/null
  cp -r /opt/tak/certs/files/Takserver-*/ shared/ 2>/dev/null
  find . -type f -regex '/opt/tak/certs/files/Takserver-Admin-[0-9].pem' -exec cp {} shared/ 2>/dev/null
}

function copy_manual_enrollment_certificates_to_shared_directory(){
  cp /opt/tak/certs/files/Takserver-"$1"-"$2".p12 /opt/tak/certs/files/Takserver-"$1"-"$2"/certs
  cp -r /opt/tak/certs/files/Takserver-"$1"-"$2"/ /opt/tak/certs/shared/
}

function create_automated_enrollment_admin_account(){
    echo "java -jar /opt/tak/utils/UserManager.jar usermod -A ${AUTOMATED_ADMIN_USERNAME}"
    java -jar /opt/tak/utils/UserManager.jar usermod -A -p "${AUTOMATED_ADMIN_PASSWORD}" "${AUTOMATED_ADMIN_USERNAME}"
}

function create_automated_enrollment_client_account(){
    java -jar /opt/tak/utils/UserManager.jar usermod -p "${AUTOMATED_CLIENT_PASSWORD}" "${AUTOMATED_CLIENT_USERNAME}"
}

function setup_automated_enrollment_mission_package_file_structure(){
    echo "creating automated enrollment package file structure"
    mkdir /opt/tak/certs/files/mission_package
    mkdir /opt/tak/certs/files/mission_package/certs
    mkdir /opt/tak/certs/files/mission_package/manifest
}

function create_automated_enrollment_mission_package(){
  cp /opt/tak/certs/files/truststore-${INTERMEDIATE}.p12 /opt/tak/certs/files/mission_package/certs
  create_automated_enrollment_pref_and_manifest_files

  cd /opt/tak/certs/files/mission_package
  jar -cvf mission_package.zip manifest certs
  cd ../..
}

function create_automated_enrollment_pref_and_manifest_files(){
  sed -e"/{cert_path}/d" -e"/clientPassword/d" -e"s/root/${INTERMEDIATE}/" /opt/configurator/tak-server-configurator-template.pref > /opt/tak/certs/files/mission_package/certs/tak-server-configurator.pref
  sed -e"/{cert_path}/d" -e"s/root/${INTERMEDIATE}/" /opt/configurator/tak-server-configurator-manifest.xml > /opt/tak/certs/files/mission_package/manifest/tak-server-configurator-manifest.xml
}

function copy_automated_enrollment_mission_package_to_shared_directory(){
    cp /opt/tak/certs/files/truststore-${INTERMEDIATE}.p12 /opt/tak/certs/shared/
    cp -r /opt/tak/certs/files/mission_package/ /opt/tak/certs/shared/
}

main