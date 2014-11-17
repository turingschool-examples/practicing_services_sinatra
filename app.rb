class IdeaBoxApp < Sinatra::Base
  get '/' do
    CsvParser.call
  end
end
