require "test_helper"

class SalesEngineerConcernTest < ActiveSupport::TestCase
  setup do
    @company = companies(:one)
    @opportunity = Opportunity.create!(
      company: @company,
      position_title: "Sales Engineer",
      application_date: Date.today,
      role_type: "sales_engineer",
      role_metadata: {
        sales_motion: "enterprise",
        deal_type: "both",
        acv_range: "$50k-$500k",
        customer_persona: [ "operators", "it_security" ],
        pressure_sources: {
          quota_pressure: true,
          travel_percent: 25,
          overtime_expected: true
        }
      }
    )
  end

  test "sales_motion_summary should format sales motion data" do
    summary = @opportunity.sales_motion_summary
    assert_includes summary, "Enterprise"
    assert_includes summary, "Both"
    assert_includes summary, "$50k-$500k"
  end

  test "customer_persona_summary should format customer personas" do
    summary = @opportunity.customer_persona_summary
    assert_includes summary, "Operators"
    assert_includes summary, "It Security"
  end

  test "pressure_summary should format pressure sources" do
    summary = @opportunity.pressure_summary
    assert_includes summary, "Quota pressure"
    assert_includes summary, "25% travel"
    assert_includes summary, "Overtime expected"
  end

  test "sales_motion_summary should handle missing data" do
    opp = Opportunity.new(role_type: "sales_engineer", role_metadata: {})
    assert_equal "Not specified", opp.sales_motion_summary
  end

  test "customer_persona_summary should handle missing data" do
    opp = Opportunity.new(role_type: "sales_engineer", role_metadata: {})
    assert_equal "Not specified", opp.customer_persona_summary
  end

  test "pressure_summary should handle missing data" do
    opp = Opportunity.new(role_type: "sales_engineer", role_metadata: {})
    assert_equal "Not specified", opp.pressure_summary
  end

  test "pressure_summary should show low pressure when no pressure sources" do
    opp = Opportunity.new(
      role_type: "sales_engineer",
      role_metadata: { pressure_sources: {} }
    )
    assert_equal "Low pressure", opp.pressure_summary
  end
end
