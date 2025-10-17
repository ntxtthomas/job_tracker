json.extract! contact, :id, :name, :title, :email, :phone, :company_id, :created_at, :updated_at
json.url contact_url(contact, format: :json)
