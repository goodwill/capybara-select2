require "capybara-select2/version"
require 'rspec/core'

module Capybara
  module Select2
    def select2(value, options={})
      raise "Must pass a hash containing 'from'" if not options.is_a?(Hash) or not options.has_key?(:from)
      select_name = options[:from]

      select2_container=find("label:contains(\"#{select_name}\")").find(:xpath, '..').find(".select2-container")

      select2_container.find(".select2-choice").click

      find(".select2-drop li:contains(\"#{value}\")").click

    end
  end
end

RSpec.configure do |c|
  c.include Capybara::Select2
end
