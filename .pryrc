begin
  require "awesome_print"
  AwesomePrint.pry!
rescue LoadError => err
  puts "awesome print not installed"
  puts "run gem install awesome_print"
end


if Pry::Prompt[:rails]
  puts "Good Day!\n"
  Pry.config.prompt = Pry::Prompt[:rails]
end

now = proc { Time.new.strftime('%T%Z') }

if defined?(Rails::Console)
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

if Pry::Prompt[:rails] && PryRails::Prompt.project_name == "agent"
  def switch_djungle
    Apartment::Tenant.switch! 'djungle'
  end

  def switch_public
    Apartment::Tenant.switch! 'public'
  end

  tenant_name = proc { Pry::Helpers::Text.magenta(Apartment::Tenant.current) }

  begin
    switch_djungle

    prompt_procs = proc { }
    Pry::Prompt.add 'agent', 'agent prompt', %w(> *) do |target_self, nest_level, pry, sep|
      "[#{pry.input_ring.size}] " \
      "[#{PryRails::Prompt.project_name}][#{PryRails::Prompt.formatted_env}]" \
      "[#{tenant_name.call}] " \
      "#{pry.config.prompt_name}(#{Pry.view_clip(target_self)})" \
      "#{":#{nest_level}" unless nest_level.zero?}#{sep} "
    end

    Pry.config.prompt = Pry::Prompt[:agent]
  rescue => e
    puts e.inspect
    Pry.config.prompt = Pry::Prompt[:rails]
  end
end

def load_routes
  include Rails.application.routes.url_helpers
end
