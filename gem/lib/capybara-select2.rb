require "capybara-select2/version"
require 'rspec/core'

module Capybara
  module Select2
    def select2(value, options = {})
      raise "Must pass a hash containing 'from' or 'xpath'" unless options.is_a?(Hash) and [:from, :xpath].any? { |k| options.has_key? k }

      if options.has_key? :xpath
        select2_container = first(:xpath, options[:xpath])
      else
        select_name = options[:from]
        label = find('label', text: select_name)
        focusser = find(:xpath, "//*[@id = #{label[:for].inspect}]")
        select2_container = focusser.find(:xpath,
          "./ancestor::div[contains(concat(' ', normalize-space(@class), ' '), ' select2-container ')]")
      end

      single = select2_container.first('.select2-choice')
      multiple = select2_container.first('.select2-choices')

      single.click if single

      if options.has_key? :search
        find(:xpath, "//body").find("input.select2-input").set(value)
        page.execute_script(%|$("input.select2-input:visible").keyup();|)
        drop_container = ".select2-results"
      else
        drop_container = ".select2-drop"
      end

      [value].flatten.each_with_index do |value, index|
        multiple.click if multiple# unless index == 0
        find(:xpath, "//body").find("#{drop_container} li", text: value).click
      end
    end
  end
end

RSpec.configure do |c|
  c.include Capybara::Select2
end
