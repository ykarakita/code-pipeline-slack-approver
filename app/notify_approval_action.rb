require "json"
require "app/sender"

def handler(event:, context:)
  params = {
    blocks: [
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: "title"
        }
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
            value: "approved"
          },
          {
            type: "button",
            text: {
              type: "plain_text",
              text: "Reject",
              emoji: true
            },
            style: "danger",
            value: "rejected"
          }
        ]
      }
    ]
  }

  sender = Sender.new(ENV["SlackUrl"])
  sender.send!(params)
end
