#!/usr/bin/env bash

set -euo pipefail

# This script attempts to invoke the RPC methods exposed by our components via
# Curl just for quick local sanity checking. Requires base64, curl and jq tools
# installed and available on the current $PATH to run.

function print {
  echo "--> $1"
}

function create_stream {
  print "create a stream"

  local data="{\"device_token\":\"$1\",\"policy_id\":\"$2\",\"recipient_public_key\":\"$3\",\"location\":{\"longitude\":0.023,\"latitude\":55.253},\"exposure\":\"INDOOR\",\"operations\":[]}"

  echo "$data" | jq "."

  curl --request "POST" \
       --location "http://localhost:8081/twirp/decode.iot.encoder.Encoder/CreateStream" \
       --header "Content-Type: application/json" \
       --verbose \
       --data "$data" \
     | jq "."
}

function delete_stream {
  print "delete a stream"

  local data="{\"stream_uid\":\"$1\",\"token\":\"$2\"}"

  echo "$data" | jq "."

  curl --request "POST" \
       --location "http://localhost:8081/twirp/decode.iot.encoder.Encoder/DeleteStream" \
       --header "Content-Type: application/json" \
       --verbose \
       --data "$data" \
     | jq "."
}

function write_data {
  print "write data"

  local encrypted_msg="$(echo secret | base64)"

  local data="{\"public_key\":\"$1\",\"user_uid\":\"$2\",\"data\":\"$encrypted_msg\"}"

  curl --request "POST" \
       --location "http://localhost:8080/twirp/datastore.Datastore/WriteData" \
       --header "Content-Type: application/json" \
       --verbose \
       --data "$data" \
    | jq "."
}

function read_data {
  print "Reading data"

  local data="{\"public_key\":\"$1\", \"page_size\":3}"

  curl --request "POST" \
       --location "http://localhost:8080/twirp/datastore.Datastore/ReadData" \
       --header "Content-Type: application/json" \
       --verbose \
       --data "$data" \
    | jq "."
}

"$@"
