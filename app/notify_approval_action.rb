require "json"
require "app/sender"
require "app/pipeline_attribute"

def handler(event:, context:)
  notify_approval_action = NotifyApprovalAction.new(event, context)
  notify_approval_action.notify
end

class NotifyApprovalAction
  def initialize(event, context)
    @event = event
    @event_message = JSON.parse(event["Records"].first["Sns"]["Message"])
  end

  def notify
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
              value: build_response_value(:approved),
              confirm: {
                title: {
                  type: "plain_text",
                  text: "Are you sure?"
                },
                confirm: {
                  type: "plain_text",
                  text: "Approve"
                },
                deny: {
                  type: "plain_text",
                  text: "Cancel"
                }
              }
            },
            {
              type: "button",
              text: {
                type: "plain_text",
                text: "Reject",
                emoji: true
              },
              style: "danger",
              value: build_response_value(:rejected)
            }
          ]
        }
      ]
    }

    sender = Sender.new(ENV["SLACK_URI"])
    sender.send!(params)
  end

  private

  attr_reader :event, :event_message, :pipeline

  def pipeline
    PipelineAttribute.new(event_message["approval"])
  end

  def build_response_value(action)
    JSON.generate(
      action: action.to_s.capitalize!,
      token: pipeline.token,
      pipeline_name: pipeline.pipeline_name,
      stage_name: pipeline.stage_name,
      action_name: pipeline.action_name
    )
  end
end

