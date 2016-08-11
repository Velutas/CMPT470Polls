json.array!(@answers) do |answer|
  json.extract! answer, :id, :ans, :poll_id
  json.url answer_url(answer, format: :json)
end
