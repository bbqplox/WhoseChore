json.array!(@chores) do |chore|
  json.extract! chore, :id, :Name, :Description, :Date
  json.url chore_url(chore, format: :json)
end
