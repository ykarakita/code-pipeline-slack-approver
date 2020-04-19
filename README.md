# CodePipeline Slack Approver
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Perform AWS CodePipeline approval action from Slack.

![2020-04-19 10 10 29](https://user-images.githubusercontent.com/15671481/79676926-1facae00-8226-11ea-8c85-a40ba363bd38.gif)

## Setup
1. Create Slack App if you don't have yet.
1. Activate Incoming Webhook and generate Webhook URL.
1. Deploy this application with parameters from [here](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:524176662322:applications~CodePipelineSlackApprover).
1. Register generated API Gateway endpoint URL to Slack Interactive Components Request URL. You can get API Gateway endpoint URL in CloudFormation Outputs console.
1. Go to CodePipeline console, edit your CodePipeline Approval Action and set SNS Topic created by stack.

## Parameters
| Parameter | Required | Default Value | Description |
| :--- | :--- | :--- | :--- |
| SlackUri | True | - | Incoming Webhook URI in your Slack Workspace |
| PipelineName | True | - | CodePipeline name |
| TimeZone | False | UTC | Timezone in your country |
