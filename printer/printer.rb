require "redis-queue"
require "json"
require "csv"

class Printer
  QUEUE_NAME          = "print_queue"
  PROCESS_QUEUE_NAME  = "printer_in_progress"
  OUTPUT_PATH         = "formated_names.csv"
  EXPECTED_KEYS       = ["RegDate","first_Name","last_Name","Email_Address","HomePhone","Street","City","State","Zipcode"]

  def call
    queue.process do |message|
      append_record(JSON.parse(message))
    end
  end

  def redis
    @redis ||= Redis.new
  end

  def queue
    @queue ||= Redis::Queue.new(QUEUE_NAME, PROCESS_QUEUE_NAME, :redis => redis)
  end

  def append_record(data)
    begin
      CSV.open(OUTPUT_PATH, "ab") do |csv|
        csv << data.values
      end
    rescue
      false
    end
    true
  end
end
