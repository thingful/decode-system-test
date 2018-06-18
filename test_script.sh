#!/usr/bin/env bash

set -euo pipefail

# This script attempts to invoke the RPC methods exposed by our components via
# Curl just for quick local sanity checking. Requires base64, curl and jq tools
# installed and available on the current $PATH to run.

function print {
  echo "--> $1"
}

function claim_device {
  print "claim device"

  local data="{\"deviceToken\":\"$1\",\"broker\":\"tcp://broker:1883\",\"userUid\":\"$2\",\"location\":{\"longitude\":-0.2983,\"latitude\":55.5212},\"disposition\":\"INDOOR\"}"

  echo $data | jq "."

  curl --request "POST" \
       --location "http://localhost:8082/twirp/devicereg.DeviceRegistration/ClaimDevice" \
       --header "Content-Type: application/json" \
       --verbose \
       --data "$data" \
  #     | jq "."
}

function create_stream {
  print "create a stream"

  local data="{\"brokerAddress\":\"tcp://broker:1883\",\"deviceTopic\":\"device/sck/$1/readings\",\"devicePrivateKey\":\"abc123\",\"recipientPublicKey\":\"hij567\",\"userUid\":\"alice\",\"location\":{\"longitude\":0.023,\"latitude\":55.253},\"disposition\":\"INDOOR\"}"

  echo $data | jq "."

  curl --request "POST" \
       --location "http://localhost:8081/twirp/encoder.Encoder/CreateStream" \
       --header "Content-Type: application/json" \
       --verbose \
       --data "$data" \
     | jq "."
}

function delete_stream {
  print "delete a stream"

  local data="{\"streamUid\":\"$1\"}"

  echo $data | jq "."

  curl --request "POST" \
       --location "http://localhost:8081/twirp/encoder.Encoder/DeleteStream" \
       --header "Content-Type: application/json" \
       --verbose \
       --data "$data" \
     | jq "."
}

function write_data {
  print "write data"

  local encrypted_msg=$(echo secret | base64)

  local data="{\"public_key\":\"$1\",\"user_uid\":\"$2\",\"data\":\"$encrypted_msg\"}"

  curl --request "POST" \
       --location "http://localhost:8080/twirp/datastore.Datastore/WriteData" \
       --header "Content-Type: application/json" \
       --verbose \
       --data "$data" \
    | jq "."
}

"$@"
