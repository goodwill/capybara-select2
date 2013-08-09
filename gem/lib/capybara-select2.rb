require "capybara-select2/version"
require 'rspec/core'

module Capybara
  module Select2
    def select2(value, options = {})
      select2_container = find_select2(options)

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

    def find_select2(options)
      raise "Must pass a hash containing 'from/label' or 'xpath'" unless options.is_a?(Hash) and [:from, :label, :xpath].any? { |k| options.has_key? k }

      if options.has_key? :xpath
        first(:xpath, options[:xpath])
      else
        select_name = options[:from] || options[:label]
        label = find('label', text: select_name)
        focusser = find(:xpath, "//*[@id = #{label[:for].inspect}]")
        focusser.find(:xpath,
          "./ancestor::div[contains(concat(' ', normalize-space(@class), ' '), ' select2-container ')]")
      end
    end

    def open_select2(options)
      find_select2(options).find('.select2-choice, .select2-choices').click
    end

    def close_select2
      find('.select2-drop-mask').click
    end
  end
end

RSpec.configure do |c|
  c.include Capybara::Select2
end
