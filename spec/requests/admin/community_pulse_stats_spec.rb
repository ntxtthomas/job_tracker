require "rails_helper"

RSpec.describe "Admin::CommunityPulseStats", type: :request do
  let(:admin_user) { create(:user) }
  let(:demo_user) { create(:user, :demo) }

  describe "GET /admin/community-pulse" do
    it "redirects unauthenticated users to sign in" do
      get admin_community_pulse_stats_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "blocks demo users" do
      sign_in demo_user

      get admin_community_pulse_stats_path

      expect(response).to redirect_to(dashboard_path)
      follow_redirect!
      expect(response.body).to include("Admin access only.")
    end

    it "shows daily vote counts by topic for admin users" do
      sign_in admin_user

      CommunityPulseVote.create!(topic: "getting_interviews", fingerprint: "fp-1", created_at: Time.current)
      CommunityPulseVote.create!(topic: "getting_interviews", fingerprint: "fp-2", created_at: Time.current)
      CommunityPulseVote.create!(topic: "storytelling", fingerprint: "fp-3", created_at: Time.current)

      get admin_community_pulse_stats_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Community Pulse Admin")
      expect(response.body).to include("Getting interviews")
      expect(response.body).to include("Storytelling")
      expect(response.body).to include("Today Total")
      expect(response.body).to include("3")
    end
  end
end
