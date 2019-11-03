require "uri"

class Sender
  attr_reader :uri

  def initialize(uri)
    @uri = URI.parse(uri)
  end

  def send!(params)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.start do
      request = Net::HTTP::Post.new(uri.path)
      request.set_form_data(payload: params.to_json)
      http.request(request)
    end
  end
end
