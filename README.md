# Bisq on Docker

### About

_Bisq on Docker_ allows you to securely host your personal _Bisq_ exchange 24/7 on any server device, like:
 - Network Attached Storage (NAS) devices supporting _Docker_
 - Virtualized Private Server (VPS) supporting _Docker_ compatible OCI containers
 - Any OS supporting _Docker_ compatible OCI containers, like _Linux_, _OS X_, and _Windows_

This _Docker_ image provides _Ubuntu Desktop Linux_ running _MATE_ with pre-installed _Bisq_ Software.
_Bisq on Docker_ can be accessed securely using a Remote Desktop (RDP) application.

### Background

_Bisq_ is an open-source, peer-to-peer application that allows you to buy and sell cryptocurrencies in exchange for national currencies. No registration required.
_Bisq_ is non-custodial in that it never touches or controls user funds. These are held in user-controlled wallets and accounts. Security deposits are done through multi-signature _Bitcoin_ addresses. [1] [2]

More information about _Bisq on Docker_ can be found here. [3]

### Requirement

_Bisq on Docker_ needs at least 2GB of free RAM and 4GB of free disk space.
It’s required to forward (expose) a TCP port to the _Bisq on Docker_ TCP port 3389 for remote access using RDP.

### Warning

The _Bisq_ desktop application contains a _Bitcoin_ and _DAO_ wallet.
It is highly recommended to set up dedicated storage for the _Bisq on Docker_ application data with regular backups in place.

**Always backup your _Bisq_ application wallets and private keys. Otherwise, your funds are lost if you accidentally delete your _Docker_ container and/or data volume containing this information.**

## Quickstart

Use the following command sets up a Bisq on Docker application container storing _Bisq_ desktop application data using the _Docker_ volume bisq-on-docker-data:
```
$ docker run -d --rm --name bisq-on-docker \
    -p 3389:3389 -v bisq-on-docker-data:/bisq fflo/bisq-on-docker
```

On the first startup, the default user account bisq with a random password will be auto-generated. This auto-generated password can be extracted from the container log using:
```
$ docker logs bisq-on-docker
```

If you like you can manually provide the default username and password using the following environment variables on the first startup:
```
$ docker run -d --rm --name bisq-on-docker \
    -p 3389:3389 -v bisq-on-docker-data:/bisq \
    -e BISQ_USER=bisq \
    -e BISQ_PASSWORD=bisqTRADER \
    fflo/bisq-on-docker
```

Instead of using a bisq-on-docker-data container you may also mount any local directory to bisq-on-docker, i.e.
```
$ docker run -d --rm --name bisq-on-docker \
    -p 3389:3389 -v [your-local-Bisq-on-Docker-path]:/bisq \
    fflo/bisq-on-docker
```

### Recommendation

For usage of Bisq on Docker, it is recommended to set up mobile notifications.
Use Bisq Mobile Notifications to stay up-to-date on your trades and receive notifications on your mobile phone.

- Get it on Google Play [4]
- Get it on Apple App Store [5]

## Usage in detail

To start a _Bisq on Docker_ instance running the latest version:
```
$ docker run fflo/bisq-on-docker
```

_Bisq on Docker_ provides different tags so that you can specify the exact version you wish to run. For example, to selectively run version 1.5.4:
```
$ docker run fflo/bisq-on-docker:1.5.4
```

To run a _Bisq on Docker_ container in the background, pass the `-d` option to `docker run`, and give your container a name for easy reference later:
```
$ docker run -d --name bisq-on-docker fflo/bisq-on-docker
```

For remote access using the remote desktop protocol (RDP), it is required to expose the container TCP port 3389:
```
$ docker run -d --name bisq-on-docker \
    -p 3389:3389 fflo/bisq-on-docker
```

_Bisq on Docker_ can be configured using the following environment variables:
- BISQ_USER to setup a bisq user (default: bisq)
- BISQ_PASSWORD to configure a password (default: random auto-generated, pushed to container log)
- TZ to adapt the timezone (default: UTC)

Example command to run _Bisq on Docker_ with individual startup settings, a _Docker_ data container with the name `bisq-on-docker-data` and with the _Docker_ setting to auto-remove the container image of `bisq-on-docker` on stop signal:
```
$ docker run -d --rm --name bisq-on-docker \
    -p 3389:3389 \
    -v bisq-on-docker-data:/bisq \
    -e BISQ_USER=bisq
    -e BISQ_PASSWORD=bisqTRADER \
    -e TZ=UTC \
    fflo/bisq-on-docker
```

It is also possible to set up multiple user accounts providing a file `/root/createusers.txt` using the following syntax:
```
## USERNAME:PASSWORD:SUDO ##
adminuser:adminpassword:Y
bisquser01:bisqpassword01:N
bisquser02:bisqpassword02:N
```

Once you have a Bisq on Docker service running in the background, you can show running containers:
```
$ docker ps
```
Or view the logs of a service:
```
$ docker logs -f bisq-on-docker
```

To stop and restart a running container:
```
$ docker stop bisq-on-docker
$ docker start bisq-on-docker
```

### Data Volumes

By default, _Docker_ will create ephemeral containers. That is, the _Bisq on Docker_ data will not be persisted, and you will need to sync and set up everything from scratch each time you launch a container.

To keep your _Bisq on Docker_ desktop application data between container restarts or upgrades, simply add the -v option to create a data volume:
```
$ docker run -d --rm --name bisq-on-docker \
    -v bisq-on-docker-data:/bisq fflo/bisq-on-docker
$ docker ps
$ docker inspect bisq-on-docker-data
```

Alternatively, you can map the data volume to a location on your host:
```
$ docker run -d --rm --name bisq-on-docker \
   -v "$PWD/bisq:/bisq" fflo/bisq-on-docker
$ ls -alh ./bisq
```

## Honors

_Bisq on Docker_ is based on the awesome work of rattydave. Thank you!

## Debug

By default, _Bisq on Docker_ will dump log information to the _Docker_ logs. To debug use:
```
$ docker logs -t bisq-on-docker
```

## License

_Bisq_ is licensed under the _GNU Affero General Public License v3.0_. [6]

_Ubuntu Linux_ is a collection of thousands of computer programs and documents created by a range of individuals, teams, and companies. Each of these programs may come under a different license. More information about the _Ubuntu Licensing Policy_ can be found here. [7]

Neutrinolabs/xrdp is licensed under the _Apache License 2.0_. [8]

Configuration files and code in this repository are distributed under the _MIT license_.


  [1]: https://bisq.network/vision/
  [2]: https://bisq.network/faq/
  [3]: https://flo.sh/bisq-on-docker/
  [4]: https://play.google.com/store/apps/details?id=com.joachimneumann.bisq
  [5]: https://itunes.apple.com/us/app/bisq-mobile/id1424420411
  [6]: https://github.com/bisq-network/bisq/blob/master/LICENSE
  [7]: https://ubuntu.com/licensing
  [8]: https://github.com/neutrinolabs/xrdp/blob/devel/COPYING

