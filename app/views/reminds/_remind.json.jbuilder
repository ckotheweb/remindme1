json.extract! remind, :id, :email_id, :title, :body, :schedule, :created_at, :updated_at
json.url remind_url(remind, format: :json)