# Install  TAK Server

Get the TAK server docker image to your linux host. We are using a VM at Azure.

```sh
$ more /etc/issue
Ubuntu 24.04.1 LTS 
```

## Unzip it

If needed, install zip, can `cd` to the directory.

Unzip the downloaded file.

```sh
sudo apt install zip -y

unzip takserver-docker-5.2-RELEASE-43.zip
```

### Set the DB password

deep in `tak/CoreConfig.example.xml`

```xml
    <repository enable="true" numDbConnections="16" primaryKeyBatchSize="500" insertionBatchSize="500">
      <connection url="jdbc:postgresql://tak-database:5432/cot" username="martiuser" password="XXXXX" />
    </repository>
```

### Build the DB

```sh
$ docker build -t takserver-db:"$(cat tak/version.txt)" -f docker/Dockerfile.takserver-db .
```


### Run the Container

But you may want to create a persistent volume on the host first.

```sh
sudo mkdir -p /opt/docker/tak/db
sudo chown -R devadmin:devadmin /opt/docker/tak/db
```

Now create the volume for the TAK DB.

```sh
docker volume create \
  --driver local \
  --opt type=none \
  --opt o=bind \
  --opt device=/opt/docker/tak/db \
  tak_db
```

Next run the container.

```sh
  docker run -d \
    -v docker_db:/var/lib/postgresql/data:z \
    -v  $(pwd)/tak:/opt/tak:z \
    -p 5432:5432 \
    --network takserver \
    --network-alias tak-database \
    --name takserver-db-"$(cat tak/version.txt)" \
    takserver-db:"$(cat tak/version.txt)"
```

### Run Tak Server

Next the server build

```sh
docker build -t takserver:"$(cat tak/version.txt)" -f docker/Dockerfile.takserver .
```

Now we can run the takserver itself.

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

more fun to just do this in a shell instead of docker exec everytime
```sh
civtakdevdevadmin@intaker-dev-vm0:~/dev/civtakdev$ docker exec -it takserver bash
root@c12d42ba05d6:/# whoami
root
root@c12d42ba05d6:/# more /etc/issue
Ubuntu 22.04.5 LTS \n \l

root@c12d42ba05d6:/# pwd
/
```


## Certs Time

```sh
docker exec -it takserver bash -c "cd /opt/tak/certs && ./makeRootCa.sh"
```

```
root@c12d42ba05d6:/opt/tak/certs# ./makeRootCa.sh
Please set the following variables before running this script: STATE, CITY, ORGANIZATIONAL_UNIT. \n
  The following environment variables can also be set to further secure and customize your certificates: ORGANIZATION, ORGANIZATIONAL_UNIT, CAPASS, and PASS.
```

> **Note:** I used a combination of editing the `cert-metadata.sh` (for the `CAPASS`), and passing some environment variables from the host.

Should set the CAPASS and Client Cert Pass.

### Make CA Root

Make your root CA.

> `./makeRootCa.sh`

### Create a Server Cert

Make server cert

> `./makeCert.sh server takserver.example.com`

Should match DNS.

Need to update the name in Config.

### Create Client Certs

Make client certs

> `./makeCert.sh client kdtz`

Distribute the .p12

Move the client files out of the files folder ASAP. Treat as secured entities.

## Watch TAK server logs

> ```
> tail -f tak/logs/takserver-messaging.log
> tail -f tak/logs/takserver-api.log
> ```

After reboot, one more cert, this time for the Admin console (port 8443).


```
cd /opt/tak
java -jar utils/UserManager.jar certmod -A certs/files/takserver.pem
```

## Host Security Limits for "nofile" ??

Do this as root on host.

`echo -e "*    soft    nofile 32768\n*    hard    nofile 32768" | sudo tee --append /etc/security/limits.conf > /dev/null`

But why.

Shows up like this at bottom of the `/etc/security/limits.conf` file.

```
*    soft    nofile 32768
*    hard    nofile 32768
```
## Make user Admin

```
root@09bcc02e9df5:/opt/tak# java -jar utils/UserManager.jar certmod -A certs/files/kdtz.pem
New User Added:
        Username:      'kdtz'
        Role:          ROLE_ADMIN
        Fingerprint:   89:2C:B9:08:6A:D7:B6:2F:66:65:6D:56:CC:EA:C8:18:E3:41:E7:24:A4:A5:AF:D3:9D:9E:3E:6F:1E:BB:58:26
        Groups (read and write permission):        
                __ANON__

root@09bcc02e9df5:/opt/tak#
```