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

  local data="{\"deviceToken\":\"$2\",\"broker\":\"tcp://broker:1883\",\"userUid\":\"$3\",\"location\":{\"longitude\":-0.2983,\"latitude\":55.5212},\"disposition\":\"INDOOR\"}"

  echo $data | jq "."

  curl --request "POST" \
       --location "$1/twirp/devicereg.DeviceRegistration/ClaimDevice" \
       --header "Content-Type: application/json" \
       --verbose \
       --data "$data" \
  #     | jq "."
}

function create_stream {
  print "create a stream"

  local data="{\"brokerAddress\":\"tcp://broker:1883\",\"deviceTopic\":\"device/sck/$2/readings\",\"devicePrivateKey\":\"abc123\",\"recipientPublicKey\":\"hij567\",\"userUid\":\"alice\",\"location\":{\"longitude\":0.023,\"latitude\":55.253},\"disposition\":\"INDOOR\"}"

  echo $data | jq "."

  curl --request "POST" \
       --location "$1/twirp/encoder.Encoder/CreateStream" \
       --header "Content-Type: application/json" \
       --verbose \
       --data "$data" \
     | jq "."
}

function delete_stream {
  print "delete a stream"

  local data="{\"streamUid\":\"$2\"}"

  echo $data | jq "."

  curl --request "POST" \
       --location "$1/twirp/encoder.Encoder/DeleteStream" \
       --header "Content-Type: application/json" \
       --verbose \
       --data "$data" \
     | jq "."
}

"$@"
