#!/usr/bin/env bash

docker rm -f $(docker ps -aq --filter name=loop-logger --filter name=radio_station --filter name=peer0 --filter name=peer1 --filter name=peer2 --filter name=peer3 --filter name=peer4)
