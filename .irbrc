begin
  require "pry"
  puts "loading pry"
  Pry.start
  exit
rescue LoadError => e
  warn "=> Unable to load pry"
end

if defined?(Rails::Console)
  puts "Log enabled"
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
