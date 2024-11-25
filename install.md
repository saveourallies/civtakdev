# Install  TAK Server

Get the TAK server docker image to your Linux host. We are using a VM at Azure.

```sh
$ more /etc/issue
Ubuntu 24.04.1 LTS 
```

## Unzip it

If needed, install zip, and `cd` to the directory. Unzip the downloaded file.

```sh
sudo apt install zip -y
unzip takserver-docker-5.2-RELEASE-43.zip
```

### Set the DB password

Edit the `tak/CoreConfig.xml` file to set the database password.
```xml
<repository enable="true" numDbConnections="16" primaryKeyBatchSize="500" insertionBatchSize="500">
  <connection url="jdbc:postgresql://tak-database:5432/cot" username="martiuser" password="XXXXX" />
</repository>
```

### Build the DB

Build the TAK server database Docker image.

```sh
docker build -t takserver-db:"$(cat tak/version.txt)" -f docker/Dockerfile.takserver-db .
```

### Run the Container

Create a persistent volume on the host first.

```sh
sudo mkdir -p /opt/docker/tak/db
sudo chown -R devadmin:devadmin /opt/docker/tak/db
```

Create the volume for the TAK DB.

```sh
docker volume create \
  --driver local \
  --opt type=none \
  --opt o=bind \
  --opt device=/opt/docker/tak/db \
  tak_db
```

Run the container.

```sh
docker run -d \
  -v docker_db:/var/lib/postgresql/data:z \
  -v $(pwd)/tak:/opt/tak:z \
  -p 5432:5432 \
  --network takserver \
  --network-alias tak-database \
  --name takserver-db-"$(cat tak/version.txt)" \
  takserver-db:"$(cat tak/version.txt)"
```

### Run TAK Server

Build the TAK server Docker image.

```sh
docker build -t takserver:"$(cat tak/version.txt)" -f docker/Dockerfile.takserver .
```

Run the TAK server.

```sh
docker run -d \
  -v $(pwd)/tak:/opt/tak:z \
  -p 8089:8089 \
  -p 8443:8443 \
  -p 8444:8444 \
  -p 8446:8446 \
  -p 9000:9000 \
  -p 9001:9001 \
  --network takserver \
  --name takserver \
  --rm takserver:"$(cat tak/version.txt)"
```

### Check Docker Container Shell

Access the shell of the running container.

```sh
docker exec -it takserver bash
```

```sh
root@c12d42ba05d6:/# whoami
root
root@c12d42ba05d6:/# more /etc/issue
Ubuntu 22.04.5 LTS \n \l
root@c12d42ba05d6:/# pwd
/
```

## Certs Time

Generate the root CA certificate.

```sh
docker exec -it takserver bash -c "cd /opt/tak/certs && ./makeRootCa.sh"
```

```sh
root@c12d42ba05d6:/opt/tak/certs# ./makeRootCa.sh
Please set the following variables before running this script: STATE, CITY, ORGANIZATIONAL_UNIT. \n
The following environment variables can also be set to further secure and customize your certificates: ORGANIZATION, ORGANIZATIONAL_UNIT, CAPASS, and PASS.
```

> **Note:** Edit the `cert-metadata.sh` file for the `CAPASS`, and pass some environment variables from the host.

### Make CA Root

Run the script to create the root CA.

```sh
./makeRootCa.sh
```

### Create a Server Cert

Generate the server certificate.

```sh
./makeCert.sh server takserver.example.com
```

Ensure the name matches the DNS.

### Create Client Certs

Generate client certificates.

```sh
./makeCert.sh client kdtz
```

Distribute the `.p12` files securely.

## Watch TAK Server Logs

Monitor the TAK server logs.

```sh
tail -f tak/logs/takserver-messaging.log
tail -f tak/logs/takserver-api.log
```

### Make a User an Admin

Make a user an admin.

```sh
cd /opt/tak
java -jar utils/UserManager.jar certmod -A certs/files/kdtz.pem
```

## Host Security Limits for "nofile"

Increase the file descriptor limits on the host.

```sh
echo -e "*    soft    nofile 32768\n*    hard    nofile 32768" | sudo tee --append /etc/security/limits.conf > /dev/null
```

Verify the changes in the `/etc/security/limits.conf` file.

```sh
*    soft    nofile 32768
*    hard    nofile 32768
```

### Make User Admin

Add a user as an admin.

```sh
java -jar utils/UserManager.jar certmod -A certs/files/kdtz.pem
```

```sh
New User Added:
  Username:      'kdtz'
  Role:          ROLE_ADMIN
  Fingerprint:   89:2C:B9:08:6A:D7:B6:2F:66:65:6D:56:CC:EA:C8:18:E3:41:E7:24:A4:A5:AF:D3:9D:9E:3E:6F:1E:BB:58:26
  Groups (read and write permission):        
    __ANON__
```

## Security

Refer to the TAK security best practices.

[TAK Security Best Practices](https://mytecknet.com/tak-security-best-practices/)