## GitHub으로부터 설치 - MacOS 기준
이 문서에서는 MacOS를 기준으로 먼저 설명을 하도록 하겠습니다. 다른 운영체제에서의 설치 방법에 대해서는 추후에 추가될 예정입니다.

### Python 설치
일반적으로 MacOS에 기본으로 설치되어 있는 Python은 2.7.x입니다.따라서, Python 3.6이상의 버전으로 설치를 해야만 합니다.
버전 확인 방법은 다음과 같습니다.
```
$ python -V
Python 2.7.10
$
```
맥에서 가장 쉽게 Python 3.6이상의 버전을 설치하는 방법은 Homebrew를 이용하는 방법입니다. Homebrew를 설치하는 것은 매우 간단합니다. 터미널에서 다음의 명령어를 복사하여서 붙여 넣고 실행하시면 됩니다. 맥에 기본적으로 설치되어 있는 ruby를 사용하여서 Homebrew를 설치하는 것입니다.

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
설치 중에 비밀번호를 입력하는 부분이 있는데, 컴퓨터 비밀번호를 입력 됩니다.

이제 python3를 Homebrew를 이용해서 설치합니다. 터미널에서 "brew install python3" 명령어를 입력합니다.

```
$ brew install python3
Updating Homebrew...
==> Auto-updated Homebrew!
Updated 1 tap (homebrew/core).
==> Updated Formulae
abyss              calabash           dmenu              erlang@18          heroku             octave             pipenv             sonar-scanner
bedops             dfmt               dynare             erlang@19          libfabric          paket              prometheus         xmrig

.....(중간 생략)....

Python has been installed as
  /usr/local/bin/python3

Unversioned symlinks `python`, `python-config`, `pip` etc. pointing to
`python3`, `python3-config`, `pip3` etc., respectively, have been installed into
  /usr/local/opt/python/libexec/bin

If you need Homebrew's Python 2.7 run
  brew install python@2

Pip, setuptools, and wheel have been installed. To update them run
  pip3 install --upgrade pip setuptools wheel

You can install Python packages with
  pip3 install <package>
They will install into the site-package directory
  /usr/local/lib/python3.6/site-packages

See: https://docs.brew.sh/Homebrew-and-Python
==> Summary
🍺  /usr/local/Cellar/python/3.6.4_4: 4,615 files, 97.4MB
$
```

Python3가 설치 완료가 정상적으로 되었는지 버전을 확인합니다.
```
$ python3 -V
Python 3.6.4

```




### 사용자 환경 구축

1. 먼저 Github에 공개되어 있는  [**loopchain 프로젝트**](https://github.com/theloopkr/loopchain.git)를 clone 합니다.
2. 터미널에서 프로젝트 폴더로 이동한 다음에 아래의 명령어로 사용자 환경을 구축합니다.

```
$ virtualenv -p python3 .  # Create a virtual environment
$ source bin/activate    # Enter the virtual environment
$ pip3 install -r requirements.txt  # Install necessary packages in the virtual environment
$ ./generate_code.sh #  gRPC generates codes necessary for communication
```
혹은, 프로젝트에 포함되어 있는 스크립트를 사용하는 방법으로 더 쉽게 설정할 수도 있습니다.
```
$ ./setup.sh
$ source bin/activate
$ ./setup.sh
$ ./generate_code.sh
```

### Unit Test 실행.
설치가 완료되면 전체 Unit Test를 실행하여서 정상 작동 여부를 확인합니다.
```
$ ./run_test.sh
```

### loopchain 환경 설정
기본적으로 loopchain 설정은 파일에 의해서 관리됩니다.

* **./loopchain/configure_default.py**
  * 이 파일은 loopchain의 기본 설정을 저장하고 있는 파일입니다.
  * 반드시 존재해야 하는 필수 파일입니다.
* **./loopchain/configure_user.py**
  * 이 파일은 loopchain의 사용자 정의 설정을 기록하는 파일입니다.
  * 필요하다면 추가 할 수 있는 파일이고 필수 파일은 아닙니다.
  * 이 파일은 configure_default.py 파일 보다는 높은 우선 순위를 가지고 있습니다.
  * 개발 환경에 따라 변화하는 환경설정을 기록할 수 있습니다.
  * 예를 들어서 "IP_LOCAL"의 값을 바꾸고 싶다면 configure_user.py 파일에 바꾸기 원하는 환경 설정을 추가하십시오 : IP_LOCAL = '123.456.789.10'
* **./loopchain/configure.json**
  * 이 파일은 개발 환경에 따라서 사용자 정의할 수 있는 환경설정 파일입니다.
  * json 형식에 따라서 환경 설정 파일을 기록할 수 있습니다.
  * 이 파일은 모든 설정 파일보다 우선 순위가 높습니다(configure_default.py, configure_user.py, etc.).
  * peer.py 혹은 radiostation.py를 실행시킬 때 -o -o {JSON FILE PATH} 혹은 --configure_file_path {JSON FILE PATH} option으로 적용시킬 수 있습니다.

### Deplyment

#### loopchain 실행
이전의 "**설정 가이드**"에서 언급을 하였듯이 RadioStation을 제일 먼저 실행시키고 Peer들을 실행합니다.

1.**RadioStation을 실행합니다.**
```
$  ./radiostation.py  # Execute RadioStation.
```
RadioStation을 실행하면 다음과 같은 로그를 확인할 수 있습니다. 이 로그의 의미는 로컬에서 9002번 포트로 다른 Peer들의 연결을 기다리고 있다는 의미입니다. 이제 RadioStation 서비스를 성공적으로 시작한 것입니다.
```
$ ./radiostation.py
'2018-03-15 18:19:06,184 DEBUG Popen(['git', 'version'], cwd=/Users/donghanlee/loopchain, universal_newlines=False, shell=None)'
'2018-03-15 18:19:06,220 DEBUG Popen(['git', 'version'], cwd=/Users/donghanlee/loopchain, universal_newlines=False, shell=None)'
'2018-03-15 18:19:06,564 INFO RadioStation main got argv(list): []'
'2018-03-15 18:19:06,565 INFO Set RadioStationService IP: 127.0.0.1'
'2018-03-15 18:19:06,602 INFO (Broadcast Process) Start.'
'2018-03-15 18:19:06,604 DEBUG (Broadcast Process) Status, param() audience(0)'
'2018-03-15 18:19:07,599 DEBUG wait start broadcast process....'
'2018-03-15 18:19:07,601 DEBUG Broadcast Process start({"result": "success", "Audience": "0"})'
```

2.**여러 개의 Peer들을 실행합니다.**
새로운 터미널 화면을 열고 loopchain 프로젝트 폴더로 이동합니다. 그리고 다음의 명령어를 입력하여서 **첫번째 peer**를 실행합니다.
```
$ source bin/activate  # Open python virtual workspace.
$ ./peer.py            # Launch peer.
```
추가적인 설정을 "configure.json"파일에 작성을 하였고 이를 이용해서 peer를 실행시킨 다면 다음과 같은 명령어 입력으로 peer를 실행 할 수 있습니다. (configure.json파일의 위치는 loopchain프로젝트 안에 있는 loopchain 폴더 안에 있습니다. )
```
$ ./peer.py -o ./loopchain/configure.json
```
다음과 같은 로그를 확인하실수 있습니다.
```
...........
'2017-07-20 16:05:13,480 DEBUG peer list update: 1:192.168.18.153:7100 PeerStatus.connected c3c5f2f0-6d19-11e7-875d-14109fdb09f5 (<class 'str'>)'
'2017-07-20 16:05:13,480 DEBUG peer_id: c3c5f2f0-6d19-11e7-875d-14109fdb09f5'
'2017-07-20 16:05:13,480 DEBUG peer_self: <loopchain.baseservice.peer_list.Peer object at 0x106249b00>'
'2017-07-20 16:05:13,481 DEBUG peer_leader: <loopchain.baseservice.peer_list.Peer object at 0x106249b00>'
'2017-07-20 16:05:13,481 DEBUG Set Peer Type Block Generator!'
'2017-07-20 16:05:13,481 INFO LOAD SCORE AND CONNECT TO SCORE SERVICE!'
```

**두번째 peer**를 동일한 방법으로 실행합니다. 이번에는 RadioStation에 연결하는 다른 포트를 사용해야만 합니다.(동일한 로컬 컴퓨터에서 실행되기 때문에 동일한 포트는 사용이 안됩니다.)
```
$ source bin/activate # Open python virtual workspace.
$ ./peer.py -p 7101   # Launch peer with 7101 port
```
각 peer는 RadioStation에 연결될 때 9100 port부터 시작되는 새로운 포트를 수신합니다. 새 peer가 연결될 때마다 RadioStation은 기존 peer 목록을 새 peer에 전달하고 기존 peer에 새로운 peer가 추가되었음을 알립니다.

3.**각 peer들의 상태 체크**
RESTful API를 이용하여서 RadioStation 및 각 peer의 상태를 확인할 수 있습니다.
```
$ curl http://localhost:9002/api/v1/peer/list  # Shows a list of peers that are currently configuring the blockchain network in Radiostation.
$ curl http://localhost:9000/api/v1/status/peer # Shows the current status of peer0
$ curl http://localhost:9001/api/v1/status/peer # Shows the current status of peer1
```

4.**새로운 Transaction 생성**
RESTful API를 사용하여서 peer0에 새로운 Transaction을 보냅니다.
```
$ curl -H "Content-Type: application/json" -d '{"data":"hello"}' http://localhost:9000/api/v1/transactions
{"response_code": "0", "tx_hash": "71a3414d77dbdb34b92757ba75e51d9aa498f6a06609419cdf31327da4e9bf38", "more_info": ""}
$
```

5.**새로 생성된 Transaction의 Height를 체크한다**
```
$ $ curl http://localhost:9000/api/v1/blocks | python -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   404  100   404    0     0  32625      0 --:--:-- --:--:-- --:--:-- 33666
{
    "response_code": 0,
    "block_hash": "33f84bc5c48339943ec802ecb65e11bdb003c3442e42b1a9581f32459f36f582",
    "block_data_json": {
        "prev_block_hash": "af5570f5a1810b7af78caf4bc70a660f0df51e42baf91d4de5b2328de0e83dfc",
        "merkle_tree_root_hash": "71a3414d77dbdb34b92757ba75e51d9aa498f6a06609419cdf31327da4e9bf38",
        "time_stamp": "1521111197115569",
        "height": "1",
        "peer_id": "e54b340a-2824-11e8-bf1c-acde48001122"
    }
}
$
```
