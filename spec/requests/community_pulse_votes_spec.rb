require "rails_helper"

RSpec.describe "CommunityPulseVotes", type: :request do
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
  end
end
