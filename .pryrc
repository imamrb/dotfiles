# Using these pry gems -- copy to your Gemfile
# group :development, :test do
#   gem 'awesome_print' # pretty print ruby objects
#   gem 'pry' # Console with powerful introspection capabilities
#   gem 'pry-byebug' # Integrates pry with byebug
#   gem 'pry-doc' # Provide MRI Core documentation
#   gem 'pry-rails' # Causes rails console to open pry. `DISABLE_PRY_RAILS=1 rails c` can still open with IRB
#   gem 'pry-rescue' # Start a pry session whenever something goes wrong.
#   gem 'pry-theme' # An easy way to customize Pry colors via theme files
# end

begin
  require 'awesome_print'
  AwesomePrint.pry!
rescue LoadError => e
  puts 'awesome_print gem not found!'
end

class Object
  def local_methods(obj = self) # list methods which aren't in superclass
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end


if defined?(Rails::Console)
  ActiveRecord::Base.logger = Logger.new(STDOUT)

  include Rails.application.routes.url_helpers # For testing routes in console
end

if Object.const_defined?('PryRails') && PryRails::Prompt.project_name == 'agent'
  def td
    Apartment::Tenant.switch! 'djungle'
  end

  def tp
    Apartment::Tenant.switch! 'public'
  end

  def tc
    Apartment::Tenant.current
  end

  td unless Tenant.count.zero?
end

# Custom prompt for Apartment MultiTenant Apps
if Pry::Prompt[:rails] && Object.const_defined?('Apartment')
  begin
    current_tenant_name = proc { Pry::Helpers::Text.magenta(Apartment::Tenant.current) }
    name = 'multi_tenant'
    desc = 'rails prompt with apartment tenant name'
    separators = %w[> *]

    Pry::Prompt.add(name, desc, separators) do |target_self, nest_level, pry, sep|
      "[#{pry.input_ring.size}] " \
      "[#{PryRails::Prompt.project_name}][#{PryRails::Prompt.formatted_env}]" \
      "[#{current_tenant_name.call}] " \
      "#{pry.config.prompt_name}(#{Pry.view_clip(target_self)})" \
      "#{":#{nest_level}" unless nest_level.zero?}#{sep} "
    end

    puts

    Pry.config.prompt = Pry::Prompt[:multi_tenant]
  rescue StandardError => e
    puts e.inspect
    Pry.config.prompt = Pry::Prompt[:rails]
  end
end

# Shortcut for calling pry_debug
if defined?(PryByebug)
  Pry.commands.alias_command 't', 'backtrace'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command 'ff', 'frame'
  Pry.commands.alias_command 'u', 'up'
  Pry.commands.alias_command 'd', 'down'
  Pry.commands.alias_command 'b', 'break'
  Pry.commands.alias_command 'w', 'whereami'
end

Pry.config.commands.alias_command 'h', 'hist -T 20', desc: 'Last 20 commands'
Pry.config.commands.alias_command 'hg', 'hist -T 20 -G', desc: 'Up to 20 commands matching expression'
Pry.config.commands.alias_command 'hG', 'hist -G', desc: 'Commands matching expression ever used'
Pry.config.commands.alias_command 'hr', 'hist -r', desc: 'hist -r <command number> to run a command'

Pry.commands.alias_command '?', 'show-source -d'

def more_help
  puts
  puts 'Helpful shortcuts:'
  puts 'hh  : hist -T 20       Last 20 commands'
  puts 'hg : hist -T 20 -G    Up to 20 commands matching expression'
  puts 'hG : hist -G          Commands matching expression ever used'
  puts 'hr : hist -r          hist -r <command number> to run a command'
  puts

  puts 'Introspection'
  puts '$    :  show whole method of current context'
  puts '$ foo:  show definition of foo'
  puts '? foo:  show docs for foo'
  puts
  puts "Be careful not to use shortcuts for temp vars, like 'u = User.first`"
  puts 'Run `help` to see all the pry commands'

  puts 'helper   : Access Rails helpers'
  puts 'app      : Access url_helpers'
  puts
  puts 'Sidekiq::Queue.new.clear              : To clear sidekiq'
  puts 'Sidekiq.redis { |r| puts r.flushall } : Another clear of sidekiq'
  puts
  puts "Run `require 'factory_bot'; FactoryBot.find_definitions` for FactoryBot"
  puts
  puts 'Debugging Shortcuts'
  puts

  return '' unless defined?(PryByebug)

  puts 'Installed debugging Shortcuts'
  puts 'w  :  whereami'
  puts 's  :  step'
  puts 'n  :  next'
  puts 'c  :  continue'
  puts 'f  :  finish'
  puts 'pp(obj)  :  pretty print object'
  puts ''
  puts 'Stack movement'
  puts 't  :  backtrace'
  puts 'ff :  frame'
  puts 'u  :  up'
  puts 'd  :  down'
  puts 'b  :  break'
  puts
  ''
end

# Utils

def world_clock
  ActiveSupport::TimeZone.all.map(&:name).map do |zone|
    zone + ' : ' + Time.now.in_time_zone(zone).strftime('%F %T %:z')
  end
end

def benchmark(repetitions = 100, &block)
  require 'benchmark'
  Benchmark.bm { |b| b.report { repetitions.times(&block) } }
end

Pry.config.prompt = Pry::NAV_PROMPT unless defined?(Pry::Prompt)

# https://github.com/pry/pry/issues/2185#issuecomment-945082143
ENV['PAGER'] = ' less --raw-control-chars -F -X'
