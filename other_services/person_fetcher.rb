require 'redis-queue'
require 'json'
require 'sunlight'

class PersonFetcher
  attr_accessor :redis, :waiting_queue, :print_queue

  def initialize
    @redis = Redis.new
    @waiting_queue = Redis::Queue.new("waiting_queue", "in_process", :redis => redis)
    @print_queue   = Redis::Queue.new("print_queue", "in_process", :redis => redis)
    Sunlight::Base.api_key = "f36d4c02185c42be86bcb6ab7c9c2091"
  end

  def self.call
    fetcher = self.new
    fetcher.process_waiting_queue
  end

  def process_waiting_queue
    waiting_queue.process do |message|
      puts message
      person = JSON.parse(message)
      person.merge!(senator: fetch_senator(person['zipcode']))
      add_to_print_queue(person)
    end
  end

  def add_to_print_queue(person)
    print_queue << person.to_json
  end

  def fetch_senator(zipcode)
    senator = Sunlight::Legislator.all_in_zipcode(zipcode).first
    "#{senator.firstname} #{senator.lastname}"
  end
end


