class TwitchersController < ApplicationController
  before_action :authenticate_user!
  after_action :log_to_paper_trail

  def search
    query_params = { query: search_params[:query] }
    endpoint = "search/channels?#{query_params.to_query}"

    response = Twitch::Request.new(endpoint).call

    if response.success?
      @channels = response.data 
      check_for_top_postions
    end
  end

  private

  def search_params
    params.permit(:query)
  end

  def check_for_top_postions
    response = Twitch::Request.new.call

    return unless response.success?

    streams = response.data
    user_logins = streams.map { |s| s['user_login'] }

    @channels.map! do |channel|
      channel['in_top_20'] = user_logins.include?(channel['broadcaster_login'])
      channel
    end
  end

  def log_to_paper_trail
    PaperTrail::Version.create(
      item_type: "User",
      item_id: current_user.id,
      event: "search",
      object: { query: params[:query] }.to_yaml,
      whodunnit: current_user.id
    )
  end
end
