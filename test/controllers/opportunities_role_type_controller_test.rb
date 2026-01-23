require "test_helper"

class OpportunitiesRoleTypeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company = companies(:one)
    @opportunity = opportunities(:one)
  end

  test "should create software engineer opportunity with role metadata" do
    assert_difference("Opportunity.count") do
      post opportunities_url, params: {
        opportunity: {
          company_id: @company.id,
          position_title: "Senior Software Engineer",
          application_date: Date.today,
          role_type: "software_engineer",
          status: "submitted",
          role_metadata: {}
        }
      }
    end

    assert_redirected_to opportunity_url(Opportunity.last)
    assert_equal "software_engineer", Opportunity.last.role_type
  end

  test "should create sales engineer opportunity with metadata" do
    assert_difference("Opportunity.count") do
      post opportunities_url, params: {
        opportunity: {
          company_id: @company.id,
          position_title: "Sales Engineer",
          application_date: Date.today,
          role_type: "sales_engineer",
          status: "submitted",
          role_metadata: {
            sales_motion: "enterprise",
            acv_range: "$100k-$500k",
            customer_persona: [ "operators", "it_security" ],
            pressure_sources: {
              quota_pressure: "1",
              travel_percent: "30"
            }
          }
        }
      }
    end

    opportunity = Opportunity.last
    assert_redirected_to opportunity_url(opportunity)
    assert_equal "sales_engineer", opportunity.role_type
    assert_equal "enterprise", opportunity.metadata[:sales_motion]
    assert_equal "$100k-$500k", opportunity.metadata[:acv_range]
    assert_equal [ "operators", "it_security" ], opportunity.metadata[:customer_persona]
  end

  test "should create solutions engineer opportunity" do
    assert_difference("Opportunity.count") do
      post opportunities_url, params: {
        opportunity: {
          company_id: @company.id,
          position_title: "Solutions Engineer",
          application_date: Date.today,
          role_type: "solutions_engineer",
          status: "submitted",
          role_metadata: {
            solution_scope: "implementation",
            technical_complexity: "high",
            customer_facing_percent: "60"
          }
        }
      }
    end

    opportunity = Opportunity.last
    assert_equal "solutions_engineer", opportunity.role_type
    assert_equal "implementation", opportunity.metadata[:solution_scope]
  end

  test "should create product manager opportunity" do
    assert_difference("Opportunity.count") do
      post opportunities_url, params: {
        opportunity: {
          company_id: @company.id,
          position_title: "Product Manager",
          application_date: Date.today,
          role_type: "product_manager",
          status: "submitted",
          role_metadata: {
            product_stage: "growth",
            pm_type: "technical",
            stakeholder_complexity: "high"
          }
        }
      }
    end

    opportunity = Opportunity.last
    assert_equal "product_manager", opportunity.role_type
    assert_equal "growth", opportunity.metadata[:product_stage]
  end

  test "should update opportunity role_type" do
    patch opportunity_url(@opportunity), params: {
      opportunity: {
        role_type: "sales_engineer",
        role_metadata: {
          sales_motion: "mid_market"
        }
      }
    }

    @opportunity.reload
    assert_equal "sales_engineer", @opportunity.role_type
    assert_equal "mid_market", @opportunity.metadata[:sales_motion]
  end

  test "should filter opportunities by role_type" do
    # Create different role types
    Opportunity.create!(
      company: @company,
      position_title: "SE",
      application_date: Date.today,
      role_type: "sales_engineer"
    )
    Opportunity.create!(
      company: @company,
      position_title: "PM",
      application_date: Date.today,
      role_type: "product_manager"
    )

    get opportunities_url
    assert_response :success
  end
end
