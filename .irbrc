begin
  require "awesome_print"
  AwesomePrint.pry!
  exit
rescue LoadError => e
  warn "=> Unable to load pry"
end

class Object
  def local_methods(obj = self) # list methods which aren't in superclass
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end

IRB.conf[:USE_AUTOCOMPLETE] = false
