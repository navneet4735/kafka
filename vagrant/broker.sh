# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash

# Usage: brokers.sh <broker ID> <public hostname or IP> <list zookeeper public hostname or IP + port>

set -e

BROKER_ID=$1
PUBLIC_ADDRESS=$2
PUBLIC_ZOOKEEPER_ADDRESSES=$3

cd /opt/kafka

sed \
    -e 's/broker.id=0/'broker.id=$BROKER_ID'/' \
    -e 's/#advertised.host.name=<hostname routable by clients>/'advertised.host.name=$PUBLIC_ADDRESS'/' \
    -e 's/zookeeper.connect=localhost:2181/'zookeeper.connect=$PUBLIC_ZOOKEEPER_ADDRESSES'/' \
    /opt/kafka/config/server.properties > /opt/kafka/config/server-$BROKER_ID.properties

echo "Killing server"
bin/kafka-server-stop.sh || true
sleep 5 # Because kafka-server-stop.sh doesn't actually wait
echo "Starting server"
bin/kafka-server-start.sh /opt/kafka/config/server-$BROKER_ID.properties 1>> /tmp/broker.log 2>> /tmp/broker.log &
