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
      if select2_container.has_selector?(".select2-selection")
        # select2 version 4.0
        select2_container.find(".select2-selection").click
      elsif select2_container.has_selector?(".select2-choice")
        select2_container.find(".select2-choice").click
      else
        select2_container.find(".select2-choices").click
      end

      if options.has_key? :search
        find(:xpath, "//body").find(".select2-container--open input.select2-search__field").set(value)
        page.execute_script(%|$(".select2-container--open  input.select2-search__field:visible").keyup();|)
        drop_container = ".select2-results"
      elsif find(:xpath, "//body").has_selector?(".select2-dropdown")
        # select2 version 4.0
        drop_container = ".select2-dropdown"
      else
        drop_container = ".select2-drop"
      end

      [value].flatten.each do |value|
        if find(:xpath, "//body").has_selector?("#{drop_container} li.select2-results__option")
          # select2 version 4.0
          find(:xpath, "//body").find("#{drop_container} li.select2-results__option", text: value).click
        else
          find(:xpath, "//body").find("#{drop_container} li.select2-result-selectable", text: value).click
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include Capybara::Select2
  config.include Capybara::Selectors::TagSelector
end
