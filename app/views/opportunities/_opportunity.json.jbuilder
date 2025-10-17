json.extract! opportunity, :id, :company_id, :position_title, :application_date, :status, :notes, :created_at, :updated_at
json.url opportunity_url(opportunity, format: :json)
