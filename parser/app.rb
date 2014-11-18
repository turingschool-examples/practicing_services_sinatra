require "pry"
class IdeaBoxApp < Sinatra::Base
  get '/' do
    CsvParser.new.call
  end

  post '/' do
    filepath = params[:filedata][:tempfile]
    CsvParser.new(filepath).call
  end

  get '/formatted' do
    path = File.join(__dir__, "..", "printer", "formatted_names.csv")
    content = CSV.read(path)
    content.to_json
  end
end
