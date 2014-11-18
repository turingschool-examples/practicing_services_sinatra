require 'redis-queue'
require 'json'
require 'sunlight'
require 'httparty'

class PersonFetcher
  def process_record(record)
    puts "fetcher will process record: #{record}"
    person = JSON.parse(record)
    person.merge!(senator: fetch_senator(person['zipcode']))
    puts person.inspect
    send_to_printer(person)
  end

  def send_to_printer(person)
    body = {'citizen' => person}.to_json
    HTTParty.post('http://localhost:9393/', body: body, headers: {'Content-Type' => 'application/json'})
  end

  def fetch_senator(zipcode)
    senator = Sunlight::Legislator.all_in_zipcode(zipcode).first
    "#{senator.firstname} #{senator.lastname}"
  end
end
