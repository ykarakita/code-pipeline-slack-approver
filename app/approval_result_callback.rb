require "cgi"
require "aws-sdk-codepipeline"
require "app/sender"

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
    # Delete button from payload
    payload["message"]["blocks"].delete_at(-1)

    # Add action result to payload
    payload["message"]["blocks"].push(
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: "#{action_value["action"]} by #{username}"
        }
      }
    )
    sender = Sender.new(payload["response_url"])
    sender.send!(payload["message"])
  end

  def pipeline_put_approval_result
    client.put_approval_result(
      {
        pipeline_name: action_value["pipeline_name"],
        stage_name: action_value["stage_name"],
        action_name: action_value["action_name"],
        result: {
          summary: "#{action_value["action"]} by #{username}",
          status: action_value["action"]
        },
        token: action_value["token"]
      }
    )
  end

  private

  attr_reader :event

  def payload
    return @payload unless @payload.nil?

    event_body = URI.decode(event["body"])
    @payload = JSON.parse(CGI.parse(event_body)["payload"].first)
  end

  def username
    payload["user"]["username"]
  end

  def action_value
    @action_value ||= JSON.parse(payload["actions"].first["value"])
  end

  def client
    @client ||= Aws::CodePipeline::Client.new
  end
end
