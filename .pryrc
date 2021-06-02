$LOAD_PATH << "$HOME/.rbenv/versions/2.7.2/lib/ruby/gems/2.7.0/gems/amazing_print-1.3.0/lib/"

begin
  require "amazing_print"
  puts "Amazing print enabled"
  AmazingPrint.pry!
rescue LoadError => err
  puts "amazing print not installed"
  puts "run gem install amazing_print"
end

if defined?(Rails::Console)
  puts "Log enabled"
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
