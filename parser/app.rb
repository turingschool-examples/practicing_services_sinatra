class IdeaBoxApp < Sinatra::Base
  get '/' do
    #accept file upload
    CsvParser.call
  end

  get '/formatted' do
    path = File.join(__dir__, "..", "formatted_names.csv")
    content = CSV.read(path)
    content.to_json
  end
end
