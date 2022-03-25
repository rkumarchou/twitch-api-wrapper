module Twitch
  class Request < Base

    attr_reader :endpoint

    def initialize(endpoint = 'games/top')
      @endpoint = endpoint
      super()
    end

    private

    def perform
      response = Client.new.call(endpoint).get

      if response.code == 200
        @data = JSON.parse(response.body)["data"]
      else
        @errors << 'Something went wrong.'
      end
    rescue RestClient::Exceptions::Timeout
      @errors << 'Connection timed out.'
    rescue RestClient::Exception
      @errors << 'Something went wrong.'
    end
  end
end
