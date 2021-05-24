begin
  require "amazing_print"
  AmazingPrint.irb!
rescue LoadError => err
  puts "amazing print not installed"
  puts "run gem install amazing_print"
end
