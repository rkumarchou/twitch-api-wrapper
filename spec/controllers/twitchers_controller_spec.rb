# frozen_string_literal: true

require 'rails_helper'

describe TwitchersController do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'results' do
    let(:query_params) { { query: 'ar' } }

    let(:channels_data) do
      data = File.read(File.join(Rails.root, 'spec', 'fixtures', 'channels.json'))
      JSON.parse(data)
    end

    let(:streams_data) do
      data = File.read(File.join(Rails.root, 'spec', 'fixtures', 'streams.json'))
      JSON.parse(data)
    end

    let(:channels_response) { Result.new(data: channels_data, errors: []) }
    let(:streams_response) { Result.new(data: streams_data, errors: []) }

    context 'channels search' do
      before do
        search_endpoint = "search/channels?#{query_params.to_query}"
        channels_object = Twitch::Request.new(search_endpoint)

        streams_endpoint = "streams?#{ { first: 20 }.to_query }"
        streams_object = Twitch::Request.new(streams_endpoint)

        expect(Twitch::Request).to receive(:new).with(streams_endpoint).and_return(streams_object)
        expect(Twitch::Request).to receive(:new).with(search_endpoint).and_return(channels_object)

        allow(channels_object).to receive(:call).and_return(channels_response)
        allow(streams_object).to receive(:call).and_return(streams_response)
      end

      it 'returns 200 status code' do
        post 'results', params: query_params, xhr: true

        expect(response).to be_successful
        expect(response).to render_template(:results)
      end

      it 'sets channels and streams' do
        post 'results', params: query_params, xhr: true

        expect(assigns[:channels]).to eq(channels_data['data'])
        expect(assigns[:streams]).to eq(streams_data['data'])
        expect(assigns[:streams].first).to have_key('in_top_20')
      end
    end

    context 'feeling lucky search' do
      before do
        search_history = create(:search_history, user: user)
        feeling_lucky_params = { after: search_history.last_pagination, first: 40 }

        search_endpoint = "search/channels?#{query_params.to_query}"
        channels_object = Twitch::Request.new(search_endpoint)

        streams_endpoint = "streams?#{ feeling_lucky_params.to_query }"
        streams_object = Twitch::Request.new(streams_endpoint)

        expect(Twitch::Request).to receive(:new).with(streams_endpoint).and_return(streams_object)
        expect(Twitch::Request).to receive(:new).with(search_endpoint).and_return(channels_object)

        allow(channels_object).to receive(:call).and_return(channels_response)
        allow(streams_object).to receive(:call).and_return(streams_response)
      end

      it 'returns 200 status code' do
        post 'results', params: query_params.merge(button: 'feeling_lucky'), xhr: true

        expect(response).to be_successful
        expect(response).to render_template(:results)
      end

      it 'sets channels and streams' do
        post 'results', params: query_params.merge(button: 'feeling_lucky'), xhr: true

        expect(assigns[:channels]).to eq(channels_data['data'])
        expect(assigns[:streams]).to eq(streams_data['data'])
        expect(assigns[:streams].first).to have_key('in_top_20')
      end
    end
  end
end
