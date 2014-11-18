require "httparty"
require 'csv'
require 'json'

class CsvParser
  INPUT_FILE_PATH = File.join(__dir__, "full_event_attendees.csv")
  attr_reader :filepath
  def initialize(filepath = INPUT_FILE_PATH)
    @filepath = filepath
    @people = []
  end

  def call
    collect_people
    send_to_fetcher
  end

  def send_to_fetcher
    @people.each do |person|
      puts "CSV Parser will send person: #{person} to fetcher app"
      body = {'citizen' => person}.to_json
      HTTParty.post('http://localhost:9494/',
                    body: body,
                    headers: {'Content-Type' => 'application/json'})
    end
  end

  def collect_people
    CSV.foreach(filepath, headers: true) do |person|
      @people << hash_with_keepables(person)
    end
  end

  def keepables
    [" ", "first_Name", "last_Name", "Zipcode"]
  end

  def hash_with_keepables(person)
    hash = person.to_h.keep_if { |k,v| keepables.include?(k) }
    hash[:id] = hash.delete(" ")
    hash[:name] = "#{hash.delete("first_Name")} #{hash.delete("last_Name")}"
    hash[:zipcode] = hash.delete("Zipcode")
    hash.to_json
  end
end
