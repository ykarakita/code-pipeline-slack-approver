# CodePipeline Slack Approver
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Perform AWS CodePipeline approval action from Slack.

![](https://github.com/ykarakita/code-pipeline-slack-approver/raw/master/images/screen_shot_01.png)

![](https://github.com/ykarakita/code-pipeline-slack-approver/raw/master/images/screen_shot_03.png)

## Setup
1. Create Slack App if you don't have yet.
1. Activate Incoming Webhook and generate Webhook URL.
1. Deploy this application with parameters from [here](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:524176662322:applications~CodePipelineSlackApprover).
1. Register generated API Gateway endpoint URL to Slack Interactive Components Request URL. You can get API Gateway endpoint URL in CloudFormation Outputs console.
1. Go to CodePipeline console, edit your CodePipeline Approval Action and set SNS Topic `CodePipelineApprovalAction`.

## Parameters
| Parameter | Required | Default Value | Description |
| :--- | :--- | :--- | :--- |
| SlackUri | True | - | Incoming Webhook URI in your Slack Workspace |
| PipelineName | True | - | CodePipeline name |
| TimeZone | False | UTC | Timezone in your country |
