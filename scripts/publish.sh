#!/bin/bash

set -eu

cd `dirname $0`

CONF=${1:-./deploy.conf}
source $CONF

cd ..
rm -rf target
mkdir target
zip -r target/app app LICENSE README.md

sam package --region us-east-1 --template-file template.yaml --output-template-file target/packaged.yaml --s3-bucket sam-artifacts-524176662322-us-east-1
sam publish --region us-east-1 --template target/packaged.yaml
