# CodePipeline Slack Approver

Approve CodePipeline Approve Action with Slack

<img src="https://github.com/ykarakita/code-pipeline-slack-approver/raw/master/images/screen_shot_01.png" width=80%>

<img src="https://github.com/ykarakita/code-pipeline-slack-approver/raw/master/images/screen_shot_03.png" width=80%>


## Setup
1. Create Slack App
1. Activate Incoming Webhooks in your Slack WorkSpace.
1. Deploy this application with parameters from [here](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:524176662322:applications~CodePipelineSlackApprover).
1. Register generated API Gateway endpoint URL to Slack Interactive Components Request URL. You can get API Gateway endpoint URL in CloudFormation Outputs.
1. Go to CodePipeline console, edit your CodePipeline Approval Action and choose SNS Topic `CodePipelineApprovalAction`.

## Parameters
| Parameter | Required | Default Value | Description |
| :--- | :--- | :--- | :--- |
| SlackUri | True | - | Incoming Webhook URI in your Slack Workspace |
| PipelineName | True | - | CodePipeline name |
| TimeZone | False | UTC | Timezone in your country |
