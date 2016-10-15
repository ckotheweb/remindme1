json.extract! email, :id, :email, :profile_id, :created_at, :updated_at
json.url email_url(email, format: :json)