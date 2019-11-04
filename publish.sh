#!/bin/bash

set -eu

CONF=${1:-deploy.conf}

source $CONF

rm -rf target

mkdir target
zip -r target/app app LICENSE README.md

sam package --region us-east-1 --template-file template.yml --output-template-file target/packaged.yml --s3-bucket sam-artifacts-524176662322-us-east-1
sam publish --region us-east-1 --template target/packaged.yml
