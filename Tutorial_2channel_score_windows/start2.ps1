docker run -d --name loop-logger --publish 24224:24224/tcp --volume $pwd/fluentd:/fluentd --volume $pwd/logs:/logs loopchain/loopchain-fluentd:latest


docker run -d --name radio_station -v $pwd/conf:/conf -v $pwd/storageRS:/storage -p 7102:7102 -p 9002:9002 --log-driver fluentd --log-opt fluentd-address=localhost:24224 loopchain/looprs:latest python3 radiostation.py -o /conf/rs_conf.json



docker run -d --name peer0 -v $pwd/conf:/conf -v $pwd/storage0:/storage -v $pwd/score0:/score --link radio_station:radio_station --log-driver fluentd --log-opt fluentd-address=localhost:24224 -p 7100:7100 -p 9000:9000 loopchain/looppeer:latest python3 peer.py -o /conf/peer_conf0.json -p 7100 -r radio_station:7102

docker run -d --name peer1 -v $pwd/conf:/conf -v $pwd/storage1:/storage -v $pwd/score1:/score --link radio_station:radio_station --log-driver fluentd --log-opt fluentd-address=localhost:24224 -p 7200:7200 -p 9100:9100 loopchain/looppeer:latest python3 peer.py -o /conf/peer_conf1.json -p 7200 -r radio_station:7102
