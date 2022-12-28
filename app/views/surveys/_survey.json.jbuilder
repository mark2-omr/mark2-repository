json.extract! survey, :id, :user_id, :name, :slug, :payload, :file, :created_at, :updated_at
json.url survey_url(survey, format: :json)
