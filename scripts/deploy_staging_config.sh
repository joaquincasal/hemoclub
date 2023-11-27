#!/bin/sh

DATA='{ "APP_VERSION":"'
DATA="$DATA$TAG_NAME"
DATA=$DATA'" }'

curl -n -X PATCH https://api.heroku.com/apps/$HEROKU_APP/config-vars --data "$DATA" -H "Content-Type: application/json"  -H "Accept: application/vnd.heroku+json; version=3" --header "Authorization: Bearer ${HEROKU_TOKEN}"
