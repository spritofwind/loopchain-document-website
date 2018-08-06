#!/usr/bin/env bash

##############################################
#           환경변수등록
##############################################

export TAG=latest
export CONF=$(pwd)/conf
export LOGS=$(pwd)/logs
export FLUENTD=$(pwd)/fluentd
export STORAGE_RS=$(pwd)/storageRS
export STORAGE_PEER_0=$(pwd)/storage0
export STORAGE_PEER_1=$(pwd)/storage1
export STORAGE_PEER_2=$(pwd)/storage2
export STORAGE_PEER_3=$(pwd)/storage3
export SCORE_PEER_0=$(pwd)/score0
export SCORE_PEER_1=$(pwd)/score1
export SCORE_PEER_2=$(pwd)/score2
export SCORE_PEER_3=$(pwd)/score3
export SSH_KEY_FOLDER=/Users/donghanlee/.ssh/id_tutorial

##############################################
#       로그 및 데이터 디렉토리 생성
##############################################
if [ ! -d ${LOGS} ]
    then    mkdir -p ${LOGS}
fi

if [ ! -d ${STORAGE_RS} ]
    then    mkdir -p ${STORAGE_RS}
fi

if [ ! -d ${STORAGE_PEER_0} ]
    then    mkdir -p ${STORAGE_PEER_0}
fi

if [ ! -d ${STORAGE_PEER_1} ]
    then    mkdir -p ${STORAGE_PEER_1}
fi

if [ ! -d ${STORAGE_PEER_2} ]
    then    mkdir -p ${STORAGE_PEER_2}
fi

if [ ! -d ${STORAGE_PEER_3} ]
    then    mkdir -p ${STORAGE_PEER_3}
fi

if [ ! -d ${SCORE_PEER_0} ]
    then    mkdir -p ${SCORE_PEER_0}
fi

if [ ! -d ${SCORE_PEER_1} ]
    then    mkdir -p ${SCORE_PEER_1}
fi

if [ ! -d ${SCORE_PEER_2} ]
    then    mkdir -p ${SCORE_PEER_2}
fi

if [ ! -d ${SCORE_PEER_3} ]
    then    mkdir -p ${SCORE_PEER_3}
fi

##############################################
#           로그서버실행
##############################################
docker run -d \
--name loop-logger \
--publish 24224:24224/tcp \
--volume ${FLUENTD}:/fluentd \
--volume ${LOGS}:/logs \
loopchain/loopchain-fluentd:${TAG}

##############################################
# Radio Station 실행
##############################################
docker run -d --name radio_station \
-v ${CONF}:/conf \
-v ${STORAGE_RS}:/storage \
-p 7102:7102 \
-p 9002:9002 \
--log-driver fluentd --log-opt fluentd-address=localhost:24224 \
loopchain/looprs:${TAG} \
python3 radiostation.py -o /conf/rs_conf.json

##############################################
#           Peer0 실행
##############################################
docker run -d --name peer0 \
-v $(pwd)/conf:/conf \
-v $(pwd)/storage0:/storage \
-v $(pwd)/score0:/score \
-v ${SSH_KEY_FOLDER}:/root/.ssh/id_rsa \
-e "DEFAULT_SCORE_HOST=github.com" \
--link radio_station:radio_station \
--log-driver fluentd --log-opt fluentd-address=localhost:24224 \
-p 7100:7100 -p 9000:9000 \
loopchain/looppeer:${TAG} \
python3 peer.py -o /conf/peer_conf0.json -p 7100 -r radio_station:7102

##############################################
#           Peer1 실행
##############################################
docker run -d --name peer1 \
-v $(pwd)/conf:/conf \
-v $(pwd)/storage1:/storage \
-v $(pwd)/score1:/score \
-v ${SSH_KEY_FOLDER}:/root/.ssh/id_rsa \
-e "DEFAULT_SCORE_HOST=github.com" \
--link radio_station:radio_station \
--log-driver fluentd --log-opt fluentd-address=localhost:24224 \
-p 7200:7200 -p 9100:9100 \
loopchain/looppeer:${TAG} \
python3 peer.py -o /conf/peer_conf1.json -p 7200 -r radio_station:7102


##############################################
#           Peer2 실행
##############################################
docker run -d --name peer2 \
-v $(pwd)/conf:/conf \
-v $(pwd)/storage2:/storage \
-v $(pwd)/score2:/score \
-v ${SSH_KEY_FOLDER}:/root/.ssh/id_rsa \
-e "DEFAULT_SCORE_HOST=github.com" \
--link radio_station:radio_station \
--log-driver fluentd --log-opt fluentd-address=localhost:24224 \
-p 7300:7300 -p 9200:9200 \
loopchain/looppeer:${TAG} \
python3 peer.py -o /conf/peer_conf2.json -p 7300 -r radio_station:7102


##############################################
#           Peer3 실행
##############################################
docker run -d --name peer3 \
-v $(pwd)/conf:/conf \
-v $(pwd)/storage3:/storage \
-v $(pwd)/score3:/score \
-v ${SSH_KEY_FOLDER}:/root/.ssh/id_rsa \
-e "DEFAULT_SCORE_HOST=github.com" \
--link radio_station:radio_station \
--log-driver fluentd --log-opt fluentd-address=localhost:24224 \
-p 7400:7400 -p 9300:9300 \
loopchain/looppeer:${TAG} \
python3 peer.py -o /conf/peer_conf3.json -p 7400 -r radio_station:7102
