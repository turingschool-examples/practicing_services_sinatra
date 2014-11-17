require 'csv'
require 'json'

class CsvParser
  def initialize
    @people = []
  end

  def self.call
    parser = self.new
    parser.collect_people
    parser.send_to_queue
  end

  def send_to_queue
    redis = Redis.new
    queue = Redis::Queue.new("waiting_queue", "in_process", :redis => redis)
    @people.each { |person| queue.push(person) }
  end

  def collect_people
    CSV.foreach("files/full_event_attendees.csv", headers: true) do |person|
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
