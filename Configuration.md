## 설정 가이드
### loopchain network 설정 유의 사항
* RadioStation을 제일 먼저 실행시키고 Peer들을 실행 하셔야 합니다.
* 모든 Peer들은 N:N으로 연결됩니다. 따라서, 모든 Peer들이 서로 IP:Port로 연결할 수 있어야 합니다.
* RadioStation 이나 Peer에서 외부 Host file과 연결을 해주실 폴더들이 있습니다. 이 설정이 없으면 Docker container 가 죽었을 때에 데이터를 잃어버리실 수가 있습니다.
  * **"/storage"**:  RadioStation, Peer들의 데이터를 보관하는 폴더
  * **"/conf"** : 설정 파일들이 담긴 폴더
  * **"/score"** SCORE를 zip해서 띄울 때에, SCORE 파일이 담긴 zip파일의 위치
* Multi Channel 설정 / SCORE 설정은 설정 파일을 잘 확인해 주세요. 설정 파일에 오류가 있으면 찾기 힘듭니다.
* 서로 다른 Host 들에서 띄울 때는 LOOPCHAIN_HOST 설정을 이용해서 RadioStation이 다른 Node들에게 Peer 목록을 띄울 때, 외부 서버 들에서 해당 Node에 접근 할 수 있게 해주세요.
* **최소 노드 수** : 제대로 된 Blockchain network를 구성하기 위해서 약 **4개 이상의 Node**들을 띄우셔야 합니다. 예제에서 1개 혹은 2개만 띄운 것은 일종의 예제로 보시면 됩니다.

### 포트 열기
loopchain을 사용하기 위해 다음의 Port가 열려야 합니다.  Port는 설정에서 변경이 가능합니다.

**RadioStation**

* 7102: gRPC port
* 9002: RESTful port

**Peer**

* 7100:gRPC port
* 9000: RESTful port

---

### 설정 파일
설정파일은 JSON형식으로 된 파일입니다. 예를 들어 아래처럼 만듭니다.

```JSON
{
  "Variable 1":"Value1",
  "Variable 2":"Value2",
  "Variable 3":"Value3",
  .....
}
```

특정한 JSON파일을 만들고 그 안에 내용을 작성하고 Peer를 아래와 같이 -o option을 이용하여서  해당 파일을 읽게 해서 peer를 올립니다.

```$ python3 peer.py -o peer_conf.json .....   ```

이 문서에서 각종 상황 별로, 문제 별로 어떤 옵션을 가지고 설정 파일을 만드는지 정리하여서 작성할 것입니다.
자세한 것은 각 상황 별 **설정 파일**에서 확인하시면 됩니다.

#### Log level 설정하기
_해당 내용이 실제 설정파일에 예제가 없음. 이 옵션 값을 설정파일에서 어떻게 사용하는지 내용 추가 필요_

LOOPCHAIN\_LOG\_LEVEL을 이용하세요. 아래 중 하나의 String값을 가지면 됩니다. 기본값은 "DEBUG"입니다. (제일 많이 모든 로그를 보여줍니다.)

> 옵션값: CRITICAL ,ERROR , WARNING, INFO , DEBUG (오른쪽에서 왼쪽으로 갈수로 더 많은 로그를 남김)

#### Peer의 외부 IP 설정
**LOOPCHAIN_HOST**에 IP값을 설정합니다.

기본적으로 Peer는 시작할 때, 해당 Peer가 속한 Network에서 사설 IP(Private IP) 가지고 다른 Peer들과 통신하려고 합니다. 외부와 통신하지 않고 내부 Network로만 동작하는 경우에는 문제가 없습니다. 그러나 상황에 따라서 공용 IP(Public IP)를 가지고 통신하는 것이 나을 수 있습니다.

예를 들어, Network를 구성하는 Node들이 기존 인터넷 망을 이용하거나 VPN을 이용해서 통신을 하는 경우, Peer의 IP는 기존 인터넷망이나 VPN에서 접근 가능한 IP여야 합니다. 하지만, 안타깝게도 Docker상에서는 이런 상황에서 IP를 가져올 수가 없습니다. 그래서 LOOPCHAIN_HOST를 이용해서 다른 Peer들과 통신을 하기 위해 사용할 공용 IP를 지정할 수 있습니다.

{
  'LOOPCHAIN_HOST':'$현재 node가 보여주어야 하는 IP'
}


#### SCORE 불러오는 Repository URL 바꾸기
DEFAULT\_SCORE\_HOST:현재 Blockchain 서비스에서 SCORE를 가져오기 위해 사용할 Git repository의 URL을 설정해주면 됩니다.
Docker로 Peer를 실행할 때의 `DEFAULT_SCORE_HOST`옵션으로 SCORE를 가져올 Git service URL을 지정합니다.
```
$ docker run -d --name peer0 \
   .....
   -e "DEFAULT_SCORE_HOST=github.com" \
   .....
```

#### Multichannel

Multichannel을 사용하기 위해서는 SCORE와 Peer의 정보에 대해서 알고 있어야 합니다.

1. `channel_manage_data.json`을 수정합니다. channel의 이름, channel에서 실행되는 SCORE의 이름 그리고, channel에 join하는 peer들의 목록을 작성합니다.
  ```
  {
    "%CHANNEL_NAME1%": { // 1st channel name
      "score_package": "your_score_package", // 이 채널에서 실행되는 SCORE의 이름
      "peers": [
        {
          "peer_target": "%IP%:%PORT%" // 채널에 포함되는 peer의 정보 & 리스트
        },
       ........
      ]
    },
    "%CHANNEL_NAME2%": {  // 2nd channel name
      "score_package": "your_score_package", // 이 채널에서 실행되는 SCORE의 이름
      "peers": [
        {
          "peer_target": ""%IP%:%PORT%"   // 채널에 포함되는 peer의 정보 & 리스트
        },
        .......
      ]
    }
  }
  ```
  예를 들어서 `wework_0`,`wework_1` 채널이 각각 SCORE `score/code1`,`score/code2`을 사용한다면 다음과 같이 작성이 될 것입니다.
  ```
  {
   "wework_0": {
     "score_package": "score/code1",
     "peers": [
       {
         "peer_target": "~~~~"
       },
       ......
     ]
   },
   "wework_1": {
     "score_package": "score/code2",
     "peers": [
       {
         "peer_target": "~~~~"
       },
       ........
     ]
   }
  }
  ```
2. 설정 파일을 사용하여서 RadioStation을 실행합니다.
  추후에 Docker로 blockchain을 로컬 컴퓨터에서 구현하는 예제에서 자세히 다시 설명이 되겠지만 다음과 같은 순서로 RadioStaion이 설정파일을 읽으면서 실행이 됩니다.
  ```
  $ ./radiostation.py -o rs_config.json
  ```
  1. RadioStaion이 실행 될 때 가장 먼저 `rs_conf.json`설정 파일이 먼저 로딩됩니다. `rs_conf.json` 파일에 `channel_manage_data.json`파일의 위치가 있습니다.
  ```
  {
   "CHANNEL_MANAGE_DATA_PATH" : "./channel_manage_data.json",
   "ENABLE_CHANNEL_AUTH" : true
  }
  ```
  Parameter는 다음과 같은 의미가 있습니다.
    * `CHANNEL_MANAGE_DATA_PATH`: Multichannel을 위한 환경 설정 파일의 위치와 이름
    * `ENABLE_CHANNEL_AUTH`
        * `true` = channel에 등록된 채널만 join이 가능하다.
        * `false`= 어떤 peer도 등록이 가능하다. 따로 peer 목록이 없는 경우에 사용.
  2. `channel_manage_data.json`파일에서 MultiChannel에 대한 환경 설정을 읽어옵니다.
3. Peer를 설정 파일을 이용하여서 실행합니다.
  `peer_config.json`파일이 peer에서 사용하는 설정 파일입니다.
  ```
  {
      "LOOPCHAIN_DEFAULT_CHANNEL" : "wework_0",
      "DEFAULT_SCORE_BRANCH": "master"
  }
  ```
   Parameter들은 다음과 같은 의미가 있습니다.
    * LOOPCHAIN_DEFAULT_CHANNEL : 이 peer에서 사용하는 기본 채널
    * DEFAULT_SCORE_BRANCH : 사용하는 SCORE의 Branch. 기본값은 master입니다.

  터미널에서 다음과 같은 명령어로 실행하면 됩니다.
  ```
  $ ./peer.py -o peer_config.json
  ```




#### RESTful응답의 성능 높이기
USE\_GUNICORN\_HA\_SERVER : 실제 운영단계에 들어가는 Node가 많은 RESTful API에 대한 Request들을 잘 받을 수 있게 gunicorn web service에서 쓸지 말지 결정해주는 변수입니다. 기본값은 False입니다. 실제 서비스에 올릴 때는 반드시 True로 설정되어야 합니다.

#### Network가 느릴 경우 조절해야 하는 것들
상황에 따라서 느린 네트워크에 운용을 하게 된다면 여러가지 네트워크 속도에 장애가 있는지 아닌지 확인하고 설정을 바꿔야 합니다.

**Case 1. RadioStaion의 Hart beat의 시간 조절**

RadioStation은 리더 장애를 파악하기 위해 주기적으로 Peer들에게 Heart Beat를 보내고 허용된 횟수만큼 리더가 응답이 없을 경우 리더를 교체하는 과정을 수행합니다. 그러나 네트워크 사정이 설치되는 환경에 따라 다를 것이기 때문에 아래의 변수들을 RadioStation에서 설정해 주셔야 합니다.

* **SLEEP\_SECONDS\_IN\_RADIOSTATION\_HEARTBEAT** : RadioStation이 Peer의 Status를 확인하는 시간. 단위는 Second. 기본값은 30초.
* **NO\_RESPONSE\_COUNT\_ALLOW\_BY\_HEARTBEAT**: RadioStation이 Status 확인이 안되는 Leader를 교체할 횟수. 기본값은 5회.

**"SLEEP\_SECONDS\_IN\_RADIOSTATION\_HEARTBEAT"** X **"NO\_RESPONSE\_COUNT\_ALLOW\_BY\_HEARTBEAT"**  횟수 만큼 리더 응답이 없으면  RadioStation이 리더를 교체합니다.

**Case 2. Peer들의 연결 Timeout 설정하기**

네트워크 상태에 따라서 아래 변수들을 수정해야 할 수 있습니다. 보통의 경우에는 설정할 필요가 없지만 네트워크가 매우 안좋은 상황에는 시도해볼 수 있습니다.

* **GRPC_TIMEOUT**: gRPC 연결하는 시간의 Timeout 한계치. 단위는 Second.
* **GRPC\_TIMEOUT\_BROADCAST\_RETRY**: gRPC로 data를 broadcasting하는 시간의 Timeout 한계치. 단위는 Second.

#### Hardware 성능의 문제로 Block에 담기는 Tx 숫자를 조절
Blockchain은 검증된 여러 Tx들을 담고 있는 Block들의 연결입니다. 그러나 Hardware와 Network의 제약으로 이를 조절해야 할 경우, 그리고 Tx의 크기가 너무 크게 될 때, 아래의 변수들을 수정해주십시오. 참고로 한개의 Tx안에 담기는 정보가 3MB 이하로 쓰기를 권장합니다.

* MAX\_BLOCK\_TX\_NUM: 블록의 담기는 트랜잭션의 최대 개수
* LEADER\_BLOCK\_CREATION\_LIMIT: Leader 의 block 생성 개수. 한 Leader가 이 개수 이상의 Block을 만들면 다른 Peer로 Leader가 변경.
* BLOCK\_VOTE\_TIMEOUT: Block에 대한 투표 응답을 기다리는 최대 시간. 단위는 Seconds.

#### KeyLoad 설정 방법

##### loopchain Key 구성요소
loopchain에서는 보안 통신, 트랜잭션 서명 등을 위하여 인증서와 키 옵션을 설정해 주어야 합니다.

loopchain에서 사용하는 키는 다음과 같습니다.

* Channel 별 서명 키
     * ecdsa secp256k
     * X.509 인증서, Public key

##### Channel 별 서명 키 옵션 설정
loopchain에서는 트랜잭션 생성 및 블록 생성시 각 Peer를 검증하기위하여 공개키 기반 암호화 알고리즘을 통해 인증 서명을 사용합니다.이때 사용하는 알고리즘은 ecdsa secp256k를 사용하고 인증서 형태와 Public key 형태를 지원합니다.

loopchain Peer는 키를 로드 하기 위해 공개 키의 형태와(cert, public key), 키 세트 로드 방식, 키 위치등을 설정하여야 합니다. json형태로 옵션을 설정해야 하며 다음 예제는 키 옵션 별로 세팅해야 될 세팅을 설명합니다.


ex)
* channel1 = key_file을 통해 load한다면 아래와 같이 해준다.
```
{
    "CHANNEL_OPTION" : {
        "channel1" : {
            "load_cert" : false,
            "consensus_cert_use" : false,
            "tx_cert_use" : false,
            "key_load_type": 0,
            "public_path" : "{public_key path}",
            "private_path" : "{private_key path}",
            "private_password" : "{private_key password}"
        }
    }
}
```

각 Parameter들의 내용들은 다음과 같습니다.

* load_cert :load할 인증서의 type 이 cert 면 true, publickey 면 false
* consensus\_cert\_use: block 및 투표 서명에 사용할 공개키 타입 (true : cert, false : public key)
* tx\_cert\_use : Transaction서명 및 검증에 사용할 공개키 타입 (true : cert, false : public key)
* key\_load\_type : 0 (File에서 읽음)
* public_path : Public key가 있는 위치
* private_path : Private key가 있는 위치
* private_password : Private key의 Password.


----
