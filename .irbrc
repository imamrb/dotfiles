begin
  require "awesome_print"
  AwesomePrint.pry!
  exit
rescue LoadError => e
  warn "=> Unable to load pry"
end

IRB.conf[:USE_AUTOCOMPLETE] = false
