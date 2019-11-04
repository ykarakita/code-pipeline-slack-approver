#!/bin/bash

set -eu

cd `dirname $0`

CONF=${1:-./deploy.conf}
source $CONF

cd ..
rm -rf target
mkdir target
zip -r target/app app LICENSE README.md

sam package --template-file template.yaml --output-template-file target/packaged.yaml --s3-bucket sam-artifacts-524176662322-ap-northeast-1
sam deploy --template-file target/packaged.yaml --stack-name code-pipeline-slack-approver --capabilities CAPABILITY_IAM --parameter-overrides $PARAMS
