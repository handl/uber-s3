require 'eventmachine'
require 'em-http'
require 'em-synchrony'
require 'em-synchrony/em-http'

module UberS3::Connection
  class EmHttpFibered < Adapter

    # the two changes we make to this method are commented below
    def request(verb, url, headers={}, body=nil)
      params = {}
      params[:head] = headers
      params[:body] = body if body
      # params[:keepalive] = true if persistent # causing issues ...?

      r = EM::HttpRequest.new(url).send("a#{verb}", params)   # CHANGE: changed method call to make it asynchronous

      UberS3::Response.new({
                                    response: r,   # CHANGE: include original deferrable in return result
                                    :status => r.response_header.status,
                                    :header => r.response_header,
                                    :body   => r.response,
                                    :raw    => r
                                })
    end
    
  end
end
