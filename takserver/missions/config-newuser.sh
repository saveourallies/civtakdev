#!/bin/bash

function main(){

  echo "0. Create a new "user" Certificate and "server package" to connect to ${SERVER_NAME}"
  read -p "Username: " username
  echo "Creating user: ${username}"
  echo 
  echo "1. TAK SSL client Certificate.."
  create_user_certificate $username

  echo "2. Add TAK-Server User - Cert Auth"
  create_takserver_user $username

  echo "3. Setup Server Connect Package.."
  setup_server_connect $username

}

function create_user_certificate(){
  ./makeCert.sh client ${SERVER_NAME}-user-"$1"
}

function create_takserver_user(){
  java -jar /opt/tak/utils/UserManager.jar usermod -c /opt/tak/certs/files/${SERVER_NAME}-user-"$1".pem $1 | tee -a scrape_file.txt
}

function setup_server_connect(){
  mkdir /opt/tak/certs/files/${SERVER_NAME}-connect-"$1"
  mkdir /opt/tak/certs/files/${SERVER_NAME}-connect-"$1"/certs
  mkdir /opt/tak/certs/files/${SERVER_NAME}-connect-"$1"/MANIFEST
  cp /opt/tak/certs/files/${SERVER_NAME}-user-"$1".p12 /opt/tak/certs/files/${SERVER_NAME}-connect-"$1"/certs
  cp /opt/tak/certs/files/truststore-${INTERMEDIATE}.p12 /opt/tak/certs/files/${SERVER_NAME}-connect-"$1"/certs
  create_pref_and_manifest_files $1
  zip_server_package "${SERVER_NAME}-connect-${1}"
}

function create_pref_and_manifest_files {
  # . "${config_file}"
  username=$1
  config_file="/opt/configurator/template-config.pref"
  manifest_file="/opt/configurator/template-manifest.xml"
  template_str=$(cat "${config_file}")
  eval "echo \"${template_str}\"" > /opt/tak/certs/files/${SERVER_NAME}-connect-"$1"/certs/config.pref
  template_str=$(cat "${manifest_file}")
  eval "echo \"${template_str}\"" > /opt/tak/certs/files/${SERVER_NAME}-connect-"$1"/MANIFEST/manifest.xml
}

function zip_server_package(){
  cd /opt/tak/certs/files/"$1"
  jar -cvMf ${1}.zip MANIFEST certs
  mv ${1}.zip /opt/tak/certs/shared
}

# execution begins here

INTERMEDIATE="${SERVER_NAME}CA1"
start_dir=$PWD
cd /opt/tak/certs
main
cd $start_dir