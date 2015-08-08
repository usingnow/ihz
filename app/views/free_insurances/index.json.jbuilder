json.array!(@free_insurances) do |free_insurance|
  json.extract! free_insurance, :id, :user, :mobile, :birthday, :processed, :accepted
  json.url free_insurance_url(free_insurance, format: :json)
end
