#!/bin/bash

set -eu

CONF=${1:-deploy.conf}

source $CONF

rm -rf target

mkdir target
zip -r target/app.zip ./app

sam package --region ap-northeast-1 --template-file template.yml --output-template-file target/packaged.yml --s3-bucket sam-artifacts-524176662322-ap-northeast-1
sam publish --region ap-northeast-1 --template target/packaged.yml
