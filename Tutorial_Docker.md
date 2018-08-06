## Docker를 사용한 설치

####  Linux에서 Docker 설치하기
Docker CE(Community Edition)X86-64, Docker EE(Enterprise edition) X86-64를 운용할 수 있는 최신 환경이면 됩니다.

* Docker CE: 무료 사용 버전
* Docker EE: 상용 버전, 무료 Hosted Trial 사용 가능. 각종 OS들에 대한 지원 추가제공.
* 모든 상황에서 방법이 없으면 [Docker를 Binary로부터 설치할 수 있는 방법](https://docs.docker.com/install/linux/docker-ce/binaries/)이 있습니다.

|Platform|Docker CE X86_64|Docker EE X86_64|Note |
|----|----|----|----|
|CentOS|O|O| CentOS 7이상. [Installation Guide](https://docs.docker.com/install/linux/centos/) |
|Devian|O||Stretch (stable) / Raspbian Stretch Jessie 8.0 (LTS) / Raspbian Jessie Wheezy 7.7 (LTS). [Installation Guide](https://docs.docker.com/install/linux/docker-ce/debian/) |
|Fedora|O||Fedora 24, 25 [Installation Guide](https://docs.docker.com/install/linux/docker-ce/fedora/) |
|Oracle Linux||O| 7.3 이상. [Installation Guide](https://docs.docker.com/install/linux/docker-ee/oracle/) |
|Red Hat Enterprise Linux||O|64bit version Redhat Enterprise linux 7 on an X86 or S390x. [Installation Guide](https://docs.docker.com/install/linux/docker-ee/rhel/) |
|SUSE Linux Enterprise server||O|SUSE 12.x version (OpenSUSE지원 안함). [Installation Guide](https://docs.docker.com/install/linux/docker-ee/suse/) |
|Ubuntu|O|O| EE : Xenial 16.04 (LTS) / Trusty 14.04 (LTS) , CE : Zesty 17.04 / Xenial 16.04 (LTS) / Trusty 14.04 (LTS). [Installation Guide](https://docs.docker.com/install/linux/ubuntu/)|

자세한 정보는 Docker 홈페이지의 <https://docs.docker.com/install/> 페이지를 참조하여서 설치하시면 됩니다.

* TIP : Docker 사용자 설정

  ```
  Add the docker group if it doesn't already exist:
  $ sudo groupadd docker

  Add the connected user "$USER" to the docker group. Change the user name to match your preferred user if you do not want to use your current user:
  $ sudo gpasswd -a $USER docker

  Either do a "newgrp docker" or log out/in to activate the changes to groups.
  ```

#### Windows / Mac에서 Docker 설치하기

Docker 홈페이지의 <https://docs.docker.com/install/> 페이지를 참조하여서 설치하시면 됩니다.


#### Docker 동작 확인 하기

 "docker version" 명령어로 Docker 가 정상 설치되었는지 확인합니다.  다음의 화면을 참고하셔서 확인하십시오.
```
$ docker version
Client:
 Version:	17.12.0-ce
 API version:	1.35
 Go version:	go1.9.2
 Git commit:	c97c6d6
 Built:	Wed Dec 27 20:03:51 2017
 OS/Arch:	darwin/amd64

Server:
 Engine:
  Version:	17.12.0-ce
  API version:	1.35 (minimum version 1.12)
  Go version:	go1.9.2
  Git commit:	c97c6d6
  Built:	Wed Dec 27 20:12:29 2017
  OS/Arch:	linux/amd64
  Experimental:	true
$
```

### loopchain Docker Image

#### loopchain Docker Image 종류

loopchain의 Docker image는 다음의 3종류가 있습니다.

* looprs: RadioStation docker image
* looppeer: Peer docker image
* loopchain-fluentd: log를 저장하기 위해서 수정한 fluentd image

#### Docker image 받기

아래 화면과 같이 ```docker pull``` 명령을 이용하여서 Docker hub로부터 loopchain docker image들을 다운 받아옵니다.

```
$ docker pull loopchain/looprs
$ docker pull loopchain/looppeer
$ docker pull loopchain/loopchain-fluentd
```


### Docker image를 이용하여서 로컬 컴퓨터에서 loopchain 네트워크 구성
1. [**Local computer에서 RadioStation과 1개의 Peer로 Blockchain network 구성하기**](./Tutorial_1R1P.md)
2. [**Local computer에서 RadioStation과 2개의 Peer로 Blockchain network 구성하기**](./Tutorial_1R2P.md)
