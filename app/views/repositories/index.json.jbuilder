json.array!(@repositories) do |repository|
  json.extract! repository, :id, :url, :path, :owner, :email, :last_checked
  json.url repository_url(repository, format: :json)
end
