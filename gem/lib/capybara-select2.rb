require "capybara-select2/version"
require 'rspec/core'

module Capybara
  module Select2
    def select2(value, options = {})
      raise "Must pass a hash containing 'from' or 'xpath' or 'css'" unless options.is_a?(Hash) and [:from, :xpath, :css].any? { |k| options.has_key? k }

      if options.has_key? :xpath
        select2_container = first(:xpath, options[:xpath])
      elsif options.has_key? :css
        select2_container = first(:css, options[:css])
      else
        select_name = options[:from]
        select2_container = first("label", text: select_name).find(:xpath, '..').find(".select2-container")
      end

      select2_container.find(".select2-choice").click

      if options.has_key? :search
        find(:xpath, "//body").find("input.select2-input").set(value)
        page.execute_script(%|$("input.select2-input:visible").keyup();|)
        drop_container = ".select2-results"
      else
        drop_container = ".select2-drop"
      end

      [value].flatten.each do |value|
        select2_container.find(:xpath, "a[contains(concat(' ',normalize-space(@class),' '),' select2-choice ')] | ul[contains(concat(' ',normalize-space(@class),' '),' select2-choices ')]").click
        find(:xpath, "//body").find("#{drop_container} li", text: value).click
      end
    end
  end
end

RSpec.configure do |c|
  c.include Capybara::Select2
end
