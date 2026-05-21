require "rails_helper"

RSpec.describe "CommunityPulseVotes", type: :request do
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

      expect(response).to redirect_to(new_user_session_path(anchor: "community-pulse"))
      expect(response.headers["Set-Cookie"]).to include("community_pulse_voted_at")
    end

    it "does not create a second vote from the same client on the same day" do
      post community_pulse_votes_path,
           params: { community_pulse_vote: { topic: "getting_interviews" } }

      expect do
        post community_pulse_votes_path,
             params: { community_pulse_vote: { topic: "passing_screens" } }
      end.not_to change(CommunityPulseVote, :count)

      expect(response).to redirect_to(new_user_session_path(anchor: "community-pulse"))
    end

    it "rate limits burst submissions from the same connection" do
      5.times do |index|
        post community_pulse_votes_path,
             params: { community_pulse_vote: { topic: "getting_interviews" } },
             as: :turbo_stream,
             headers: { "HTTP_USER_AGENT" => "SpecBot/#{index}", "REMOTE_ADDR" => "203.0.113.10" }

        cookies.delete(:community_pulse_voted_at)
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
