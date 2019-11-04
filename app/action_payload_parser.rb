# Parse slack action payload

class ActionPayloadParser
  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  def username
    payload["user"]["username"]
  end

  def action_summary
    payload["actions"].first
  end

  def action_value
    JSON.parse(action_summary["value"])
  end

  def action_ts
    Time.at(action_summary["action_ts"].to_f)
  end

  def action
    action_value["action"]
  end
end
