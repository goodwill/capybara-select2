require "capybara-select2/version"
require 'capybara/selectors/tag_selector'
require 'rspec/core'

module Capybara
  module Select2
    def select2(value, options = {})
      raise "Must pass a hash containing 'from' or 'xpath' or 'css'" unless options.is_a?(Hash) and [:from, :xpath, :css].any? { |k| options.has_key? k }

      if options.has_key? :xpath
        select2_container = find(:xpath, options[:xpath])
      elsif options.has_key? :css
        select2_container = find(:css, options[:css])
      else
        select_name = options[:from]
        select2_container = find("label", text: select_name).find(:xpath, '..').find(".select2-container")
      end

      # Open select2 field

      opener = '.select2-selection,' + # select2 version 4.0
               '.select2-choice,'    + # single select box
               '.select2-search-field' # multiple
      select2_container.find(opener).click

      if options.has_key? :search
        search_field = '.select2-search input.select2-search__field,' + # select2 version 4.0
                       '.select2-with-searchbox input.select2-input,' +
                       '.select2-search-field input.select2-input' # input field for version 3.5.*

        find(:xpath, "//body").find(search_field).set(value)
        page.execute_script("$('#{search_field}').keyup();")
      end

      option = '.select2-results li.select2-results__option,' + # select2 version 4.0
               '.select2-results li.select2-result-selectable' + # single and multiple select boxes

      [value].flatten.each do |value|
          find(:xpath, "//body").find(option, text: value).click
      end
    end
  end
end

RSpec.configure do |config|
  config.include Capybara::Select2
  config.include Capybara::Selectors::TagSelector
end
