require "cgi"
require "aws-sdk-codepipeline"
require "app/sender"

def handler(event:, context:)
  event_body = URI.decode(event["body"])
  payload = JSON.parse(CGI.parse(event_body)["payload"].first)

  response_to_user(payload)
  pipeline_put_approval_result(payload)

  { statusCode: 200 }
end

def client
  Aws::CodePipeline::Client.new
end

def response_to_user(payload)
  action_value = action_value(payload)
  username = username(payload)

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

def pipeline_put_approval_result(payload)
  action_value = action_value(payload)
  username = username(payload)

  client.put_approval_result({
    pipeline_name: action_value["pipeline_name"],
    stage_name: action_value["stage_name"],
    action_name: action_value["action_name"],
    result: {
      summary: "#{action_value["action"]} by #{username}",
      status: action_value["action"]
    },
    token: action_value["token"]
  })
end

def action_value(payload)
  JSON.parse(payload["actions"].first["value"])
end

def username(payload)
  payload["user"]["username"]
end
