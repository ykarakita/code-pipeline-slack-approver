require "cgi"
require "app/sender"

def handler(event:, context:)
  event_body = URI.decode(event["body"])
  payload = JSON.parse(CGI.parse(event_body)["payload"].first)

  username = payload["user"]["username"]
  action = payload["actions"].first["value"] # approved | rejected

  sender = Sender.new(payload["response_url"])
  response_body = {
    "text": "#{action.capitalize!} by #{username}"
  }
  sender.send!(response_body)

  {
    statusCode: 200,
    body: JSON.generate({
      text: "ok"
    })
  }
end
