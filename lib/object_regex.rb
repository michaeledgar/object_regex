if RUBY_VERSION < "1.9"
  raise 'object_regex is only compatible with Ruby 1.9 or greater.'
end
require 'object_regex/implementation'