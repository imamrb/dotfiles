begin
  require "pry"
  puts "Loading pry"
  Pry.start
  exit
rescue LoadError => e
  warn "=> Unable to load pry"
end
