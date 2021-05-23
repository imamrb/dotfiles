$LOAD_PATH << "/home/imam07/.rbenv/versions/2.7.1/lib/ruby/gems/2.7.0/gems/amazing_print-1.2.2/lib/"

begin
  require "amazing_print"
  AmazingPrint.irb!
rescue LoadError => err
  puts "no awesome_print :("
end

if defined?(Rails::Console)
  puts "Log enabled"
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
