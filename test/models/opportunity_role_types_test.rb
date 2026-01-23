require "test_helper"

class OpportunityRoleTypesTest < ActiveSupport::TestCase
  setup do
    @company = companies(:one)
  end

  test "should have default role_type of software_engineer" do
    opp = Opportunity.new(
      company: @company,
      position_title: "Backend Engineer",
      application_date: Date.today
    )
    opp.save!
    assert_equal "software_engineer", opp.role_type
  end

  test "should validate role_type presence" do
    opp = Opportunity.new(
      company: @company,
      position_title: "Backend Engineer",
      role_type: nil
    )
    assert_not opp.valid?
    assert_includes opp.errors[:role_type], "can't be blank"
  end

  test "should validate role_type inclusion" do
    opp = Opportunity.new(
      company: @company,
      position_title: "Backend Engineer",
      role_type: "invalid_role"
    )
    assert_not opp.valid?
    assert_includes opp.errors[:role_type], "is not included in the list"
  end

  test "should allow valid role_types" do
    Opportunity::ROLE_TYPES.keys.each do |role_type|
      opp = Opportunity.new(
        company: @company,
        position_title: "Test Position",
        application_date: Date.today,
        role_type: role_type
      )
      assert opp.valid?, "#{role_type} should be valid"
    end
  end

  test "software_engineer? should return true for software engineers" do
    opp = Opportunity.new(role_type: "software_engineer")
    assert opp.software_engineer?
    refute opp.sales_engineer?
    refute opp.solutions_engineer?
    refute opp.product_manager?
  end

  test "sales_engineer? should return true for sales engineers" do
    opp = Opportunity.new(role_type: "sales_engineer")
    assert opp.sales_engineer?
    refute opp.software_engineer?
    refute opp.solutions_engineer?
    refute opp.product_manager?
  end

  test "should store and retrieve role_metadata" do
    opp = Opportunity.create!(
      company: @company,
      position_title: "Sales Engineer",
      application_date: Date.today,
      role_type: "sales_engineer",
      role_metadata: {
        sales_motion: "enterprise",
        acv_range: "$50k-$500k",
        customer_persona: [ "operators", "it_security" ]
      }
    )

    opp.reload
    assert_equal "enterprise", opp.metadata[:sales_motion]
    assert_equal "$50k-$500k", opp.metadata[:acv_range]
    assert_equal [ "operators", "it_security" ], opp.metadata[:customer_persona]
  end

  test "should handle nested pressure_sources metadata" do
    opp = Opportunity.create!(
      company: @company,
      position_title: "Sales Engineer",
      application_date: Date.today,
      role_type: "sales_engineer",
      role_metadata: {
        pressure_sources: {
          quota_pressure: true,
          travel_percent: 25,
          overtime_expected: true
        }
      }
    )

    opp.reload
    assert_equal true, opp.metadata.dig(:pressure_sources, :quota_pressure)
    assert_equal 25, opp.metadata.dig(:pressure_sources, :travel_percent)
  end

  test "metadata should provide indifferent access" do
    opp = Opportunity.create!(
      company: @company,
      position_title: "Sales Engineer",
      application_date: Date.today,
      role_type: "sales_engineer",
      role_metadata: { "sales_motion" => "enterprise" }
    )

    assert_equal "enterprise", opp.metadata[:sales_motion]
    assert_equal "enterprise", opp.metadata["sales_motion"]
  end

  test "role_type_label should return human readable label" do
    opp = Opportunity.new(role_type: "sales_engineer")
    assert_equal "Sales Engineer", opp.role_type_label

    opp.role_type = "software_engineer"
    assert_equal "Software Engineer", opp.role_type_label
  end
end
