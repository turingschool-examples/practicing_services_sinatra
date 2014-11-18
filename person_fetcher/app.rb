class FetcherApp < Sinatra::Base
  SUNLIGHT_KEY = "f36d4c02185c42be86bcb6ab7c9c2091"
  Sunlight::Base.api_key = SUNLIGHT_KEY

  get "/" do
    10.times { puts "hi" }
    "hello world"
  end

  post "/" do
    record = JSON.parse(request.body.read)["citizen"]
    PersonFetcher.new.process_record(record)
    record.to_json
  end
end
