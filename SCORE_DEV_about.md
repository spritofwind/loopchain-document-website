## loopchain SCORE 개발에 대하여

### SCORE 개발

SCORE의 개발은 3단계로 나뉘어 집니다.
  1. 비지니스 모델 타당성 검증
  2. 모델 구현 및 Unit Test
  3. Integration Test 및 모델 배포

#### 비지니스 모델 타당성 검증
SCORE 안에서는 다음과 같은 내용을 통한 비지니스 모델은 불가능합니다.
* **랜덤 값에 의존하는 비지니스 모델**: SCORE 안에서 랜덤 값을 생성하거나, 실행하는 모델은 불가하나, 블록의 해시 혹은 트랜잭션을 이용한 랜덤 값 이용은 가능합니다.
* **외부의 데이터에 의존성이 있는 비지니스 모델**: SCORE 안에서 다른 사이트를 호출하거나, 외부의 데이터를 요구하는 모델은 아직 불가능하나 향후 고려되고 있습니다.
* **시간에 따라 행동하는 혹은 실행시간에 따라 내용이 바뀌는 모델**: 현재 시간(실행시간)은 사용 불가능하며, 블록의 시간 혹은 트랜잭션 시간으로 대체는 가능합니다.
* **부동 소수점 처리 불가**: CPU에 따라 부동 소수점 표현 방식이 달라질 수 있으므로 모든 연산은 정수 단위에서 처리해야 합니다.
* **내부 변수 재사용 금지**: 특정한 변수를 Cache해 놓았다가 쓰는 것은 금지되어야 합니다.

#### 구현
* SCORE를 작성하거나, 개발할 때는 coverage 90% 이상을 목표로 개발 하여야 하며, 퍼포먼스도 고려되어야 합니다.

##### 폴더 및 실행 구조
* / score / 회사명(기관명) / 패키지명 ```ex) /score/loopchain/default/```
* deploy 폴더명은 사용 불가
* 원격 repository를 사용하지 않을 경우 다음과 같이 가능합니다.
  * 회사명(기관명)_패키지명.zip 으로 repository 전체를 압축하여 score에 저장하여 실행
* 패키지 설명 및 실행에 대한 상세내용은 package.json 파일로 정의하며, package.json 정의에 대한 내용은 **[다른 가이드](./package_guide.md)**에서 설명합니다.


#### Unit Test
* 모든 테스트 코드는 SCORE의 패키지 루트에 있어야 하며, 차후 repository 등록 전에 실행됩니다.
* SCORE와 분리해서 논리적인 별도의 Module을 만들어서 Unit Test를 만들어서 수행해야 합니다.


#### Integration Test
* RadioStation / Peer를 실행 합니다.
* POST로 /api/v1/transactions로 아래처럼 데이터를 보냅니다.

```
{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "foo",
    "params": {
	"param1":"value1”
	...
  }
}
```

* packages.json에서 얻은 정의한 함수의 이름과 데이터에 맞춰 Transaction을 만들어준다.
* 형식은 JSON 2.0 RPC방식에 맞춰준다.
* Invoke / Query 모두 같은 방식으로 호출된다.
  * 함수 이름으로 구분한다.


#### SCORE 배포 및 관리

##### local develop folder를 사용하는 방법
1.configure_user.py 파일을 추가합니다. (configure_default.py 와 같은 위치)

```
ALLOW_LOAD_SCORE_IN_DEVELOP = 'allow'
DEVELOP_SCORE_PACKAGE_ROOT = 'develop'
DEFAULT_SCORE_PACKAGE = 'develop/[package]'
```

2./score/develop/[package] 폴더를 만듭니다. [package] 는 원하는 이름으로 작성합니다. (sample 을 사용하는 경우 test_score 로 합니다.)
3./score/sample-test_score/* 파일을 새로운 폴더로 복사합니다.
4.loopchain 네트워크를 실행하여 확인합니다.

##### zip 파일을 사용하는 방법
1.임의의 폴더에서 score 를 작성합니다. ("local develop folder를 사용하는 방법"에서 작성한 SCORE 복사하여도 됩니다.)
2.package.json 의 "id" 값을 "[company_name]-[package]" 로 수정합니다.
3.$ git init . 으로 해당 폴더를 local git repository 로 설정합니다.
4.$ git add . 으로 폴더의 모든 파일을 repository 에 추가 합니다.
5.$ git commmit -a 로 SCORE 파일들을 git 에 commit 합니다.
6.$ zip -r ../[company_name]_[package].zip ./ 으로 repository 를 zip 으로 압축합니다.
7.zip 파일을 /score/ 아래에 둡니다. (/score/[company_name]_[package].zip)
8.configure_user.py 파일을 추가합니다. (configure_default.py 와 같은 위치)

```
DEFAULT_SCORE_PACKAGE = '[company_name]/[package]'
```

9.loopchain 네트워크를 실행하여 확인합니다.

##### repository 를 사용하는 방법
* SCORE의 배포는 특별히 관리되는 repository 를 사용할 수 있습니다.
  * 차후 다수의 repository 를 검색하여, 순위 별로 배포하는 방안도 검토 중입니다.
* remote repository 에서 관리하지 않는 스코어는 내부 repository 가 포함된 zip 파일에서 관리 할 수 있습니다.
* peer 에서 스코어의 배포는 다음의 명령어를 사용합니다.
  * Docker에서 실행시
```
$ docker run -d ${DOCKER_LOGDRIVE} \
--name ${PEER_NAME} --link radio_station:radio_station \
-p ${PORT}:${PORT}  looppeer:${DOCKER_TAG}  \
python3 peer.py -c ${DEPLOY_SCORE}  \
-r radio_station -d -p ${PORT}
```
  * Local에서 실행시

```
$ python3 peer.py -c ${DEPLOY_SCORE}  -r radio_station -d -p ${PORT}
```

  * 참조
    * DEPLOY_SCORE 는 기관명/패키지명 입니다.
    * PEER_NAME은 Peer의 이름을 지칭합니다.
    * PORT는 radio_station 의 위치 IP:PORT 로 설정됩니다.
