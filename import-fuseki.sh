#!/bin/sh

TTL_OLD="/tmp/opal-data/opal-2020-06/*.ttl"
TTL_NEW="/tmp/opal-data/opal-2020-10/*.ttl"

API_OLD="http://localhost:3030/2020-06/data"
API_NEW="http://localhost:3030/2020-10/data"

for FILE in $TTL_OLD
do
  echo "$FILE"
  curl --location --request POST $API_OLD --header 'Content-Type: multipart/form-data' --form "file.ttl=@${FILE}"
done

for FILE in $TTL_NEW
do
  echo "$FILE"
  curl --location --request POST $API_NEW --header 'Content-Type: multipart/form-data' --form "file.ttl=@${FILE}"
done
