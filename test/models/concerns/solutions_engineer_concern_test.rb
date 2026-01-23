require "test_helper"

class SolutionsEngineerConcernTest < ActiveSupport::TestCase
  setup do
    @company = companies(:one)
    @opportunity = Opportunity.create!(
      company: @company,
      position_title: "Solutions Engineer",
      application_date: Date.today,
      role_type: "solutions_engineer",
      role_metadata: {
        solution_scope: "implementation",
        technical_complexity: "high",
        customer_facing_percent: 60
      }
    )
  end

  test "solution_scope_summary should format solution scope data" do
    summary = @opportunity.solution_scope_summary
    assert_includes summary, "Implementation"
    assert_includes summary, "High"
  end

  test "solution_scope_summary should handle missing data" do
    opp = Opportunity.new(role_type: "solutions_engineer", role_metadata: {})
    assert_equal "Not specified", opp.solution_scope_summary
  end
end
