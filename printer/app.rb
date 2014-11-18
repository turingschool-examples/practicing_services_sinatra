class PrinterApp < Sinatra::Base
  get "/" do
    "hello world"
  end

  post "/" do
    record = JSON.parse(request.body.read)["citizen"]
    Printer.new.append_record(record)
    record.to_json
  end
end
