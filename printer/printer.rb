require "redis-queue"
require "json"
require "csv"

class Printer
  OUTPUT_PATH         = "formatted_names.csv"

  def append_record(data)
    puts "will append #{data} to the file"
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
