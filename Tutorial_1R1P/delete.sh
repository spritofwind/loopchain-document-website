#!/usr/bin/env bash

docker rm -f $(docker ps -a -q --filter name=loop-logger --filter name=radio_station --filter name=peer0)
