json.extract! company, :id, :name, :industry, :location, :website, :created_at, :updated_at
json.url company_url(company, format: :json)
