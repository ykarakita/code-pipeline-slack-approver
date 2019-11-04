require "cgi"
require "aws-sdk-codepipeline"
require "app/sender"
require "app/action_payload_parser"

def handler(event:, context:)
  approval_result_callback = ApprovalResultCallback.new(event, context)
  approval_result_callback.response_to_user
  approval_result_callback.pipeline_put_approval_result

  { statusCode: 200 }
end

class ApprovalResultCallback
  def initialize(event, context)
    @event = event
  end

  def response_to_user
    sender = Sender.new(action_payload.payload["response_url"])
    sender.send!(response_params)
  end

  def pipeline_put_approval_result
    client.put_approval_result(
      {
        pipeline_name: action_value["pipeline_name"],
        stage_name: action_value["stage_name"],
        action_name: action_value["action_name"],
        result: {
          summary: "#{action_payload.action} by #{action_payload.username}",
          status: action_payload.action
        },
        token: action_value["token"]
      }
    )
  end

  private

  attr_reader :event

  def action_payload
    event_body = URI.decode(event["body"])
    payload = JSON.parse(CGI.parse(event_body)["payload"].first)
    @action_payload ||= ActionPayloadParser.new(payload)
  end

  def action_value
    action_payload.action_value
  end

  def client
    @client ||= Aws::CodePipeline::Client.new
  end

  def emoji
    action_payload.action == "Approved" ? ":white_check_mark:" : ":x:"
  end

  def response_params
    {
      blocks: [
        action_payload.payload["message"]["blocks"].first,
        {
          type: "context",
          elements: [
            {
              type: "mrkdwn",
              text: "*Result:* #{emoji} #{action_payload.action}"
            },
            {
              type: "mrkdwn",
              text: "*ExecutedBy:* #{action_payload.username}"
            },
            {
              type: "mrkdwn",
              text: "*ExecutedAt:* #{action_payload.action_ts.to_s}"
            }
          ]
        }
      ]
    }
  end
end
