require "capybara-select2/version"
require 'rspec/core'

module Capybara
  module Select2
    def select2(value, options = {})
      raise "Must pass a hash containing 'from'" if not options.is_a?(Hash) or not options.has_key?(:from)
      select_name = options[:from]

      select2_container=first("label", text: select_name).find(:xpath, '..').find(".select2-container")

      [value].flatten.each do |value|
        select2_container.find(:xpath, "a[contains(concat(' ',normalize-space(@class),' '),' select2-choice ')] | ul[contains(concat(' ',normalize-space(@class),' '),' select2-choices ')]").click
        find(:xpath, "//body").find(".select2-drop li", text: value).click
      end
    end
  end
end

RSpec.configure do |c|
  c.include Capybara::Select2
end
