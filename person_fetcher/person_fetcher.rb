require 'redis-queue'
require 'json'
require 'sunlight'

class PersonFetcher
  PRINT_QUEUE = "print_queue"
  PRINT_QUEUE_PROGRESS = "print_queue_in_process"
  WAITING_QUEUE = "waiting_queue"
  WAITING_QUEUE_PROGRESS = "waiting_queue_in_process"
  attr_accessor :redis, :waiting_queue, :print_queue

  def initialize
    @redis = Redis.new
    @waiting_queue = Redis::Queue.new(WAITING_QUEUE, WAITING_QUEUE_PROGRESS, :redis => redis)
    @print_queue   = Redis::Queue.new(PRINT_QUEUE, PRINT_QUEUE_PROGRESS, :redis => redis)
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
      puts person.inspect
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
