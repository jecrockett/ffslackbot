$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dotenv'
Dotenv.load

require 'milfbot'
require 'web'

Thread.abort_on_exception = true

Thread.new do
  begin
    Milfbot::App.instance.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run Milfbot::Web
