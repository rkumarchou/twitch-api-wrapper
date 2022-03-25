class HelloWorldController < ApplicationController
  def index
    response = Twitch::Request.new.call

    @top_streams = response.data if response.success?
  end
end
