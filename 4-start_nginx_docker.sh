#!/bin/sh

curl -X POST -H "Content-Type: application/json" http://$1:8080/v2/apps -d@marathon/nginx.json
