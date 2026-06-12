require "rails_helper"

RSpec.describe "CommunityPulseVotes", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:cache_store) { ActiveSupport::Cache::MemoryStore.new }

  before do
    allow(Rails).to receive(:cache).and_return(cache_store)
  end

  around do |example|
    Rails.cache.clear
    example.run
    Rails.cache.clear
  end

  describe "POST /community_pulse_votes" do
    it "creates a vote and redirects for html requests" do
      expect do
        post community_pulse_votes_path,
             params: { community_pulse_vote: { topic: "getting_interviews" } }
      end.to change(CommunityPulseVote, :count).by(1)

      expect(response).to redirect_to(dashboard_path(anchor: "community-pulse"))
      expect(response.headers["Set-Cookie"]).to include("community_pulse_daily_votes")
    end

    it "allows additional votes up to the daily limit" do
      post community_pulse_votes_path,
           params: { community_pulse_vote: { topic: "getting_interviews" } }

      expect do
        post community_pulse_votes_path,
             params: { community_pulse_vote: { topic: "passing_screens" } }
      end.to change(CommunityPulseVote, :count).by(1)

      expect(response).to redirect_to(dashboard_path(anchor: "community-pulse"))
    end

    it "blocks the sixth vote in the same day for the same connection" do
      5.times do |index|
        post community_pulse_votes_path,
             params: { community_pulse_vote: { topic: "getting_interviews" } },
             headers: { "HTTP_USER_AGENT" => "DailyLimitSpec/1", "REMOTE_ADDR" => "203.0.113.10" }

        expect(response).to redirect_to(dashboard_path(anchor: "community-pulse"))
      end

      travel_to(Time.current + 11.minutes) do
        expect do
          post community_pulse_votes_path,
               params: { community_pulse_vote: { topic: "passing_screens" } },
               headers: { "HTTP_USER_AGENT" => "DailyLimitSpec/1", "REMOTE_ADDR" => "203.0.113.10" }
        end.not_to change(CommunityPulseVote, :count)
      end

      expect(response).to redirect_to(dashboard_path(anchor: "community-pulse"))
      expect(flash[:alert]).to eq("You have reached today's vote limit. Please come back tomorrow.")
    end

    it "rate limits burst submissions from the same connection" do
      5.times do |index|
        post community_pulse_votes_path,
             params: { community_pulse_vote: { topic: "getting_interviews" } },
             as: :turbo_stream,
             headers: { "HTTP_USER_AGENT" => "SpecBot/#{index}", "REMOTE_ADDR" => "203.0.113.10" }
      end

      expect do
        post community_pulse_votes_path,
             params: { community_pulse_vote: { topic: "passing_screens" } },
             as: :turbo_stream,
             headers: { "HTTP_USER_AGENT" => "SpecBot/6", "REMOTE_ADDR" => "203.0.113.10" }
      end.not_to change(CommunityPulseVote, :count)

      expect(response).to have_http_status(:too_many_requests)
      expect(response.body).to include("Too many votes from this connection")
    end
  end
end
