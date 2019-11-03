require "json"
require "app/sender"
require "app/pipeline_attribute"

def handler(event:, context:)
  event_message = JSON.parse(event["Records"].first["Sns"]["Message"])
  pipeline = PipelineAttribute.new(event_message["approval"])

  params = {
    blocks: [
      {
        type: "section",
        fields: [
          {
            type: "mrkdwn",
            text: "*Pipeline Name*\n#{pipeline.pipeline_name}"
          },
          {
            type: "mrkdwn",
            text: "*Revision ID*\n#{pipeline.revision_id}"
          }
        ]
      },
      {
        type: "actions",
        elements: [
          {
            type: "button",
            text: {
              type: "plain_text",
              text: "Approve",
              emoji: true
            },
            style: "primary",
            value: build_response_value(pipeline, :approved)
          },
          {
            type: "button",
            text: {
              type: "plain_text",
              text: "Reject",
              emoji: true
            },
            style: "danger",
            value: build_response_value(pipeline, :rejected)
          }
        ]
      }
    ]
  }

  sender = Sender.new(ENV["SLACK_URI"])
  sender.send!(params)
end

def build_response_value(pipeline, action)
  JSON.generate(
    action: action.to_s.capitalize!,
    token: pipeline.token,
    pipeline_name: pipeline.pipeline_name,
    stage_name: pipeline.stage_name,
    action_name: pipeline.action_name,
  )
end
