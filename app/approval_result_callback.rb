require "cgi"
require "aws-sdk-codepipeline"
require "app/sender"

def handler(event:, context:)
  event_body = URI.decode(event["body"])
  payload = JSON.parse(CGI.parse(event_body)["payload"].first)

  username = payload["user"]["username"]
  action_value = JSON.parse(payload["actions"].first["value"])

  sender = Sender.new(payload["response_url"])
  sender.send!({
    "text": "#{action_value["action"]} by #{username}"
  })

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

  {
    statusCode: 200,
    body: JSON.generate({
      text: "ok"
    })
  }
end

def client
  Aws::CodePipeline::Client.new
end
