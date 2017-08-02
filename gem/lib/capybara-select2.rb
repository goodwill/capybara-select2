# frozen_string_literal: true

require 'capybara-select2/version'
require 'capybara/selectors/tag_selector'
require 'rspec/core'
require 'capybara-select2/query'

module Capybara
  module Select2
    def select2(value, options = {})
      Capybara::Select2::Query.new(page, value, options).call
    end
  end
end

RSpec.configure do |config|
  config.include Capybara::Select2
  config.include Capybara::Selectors::TagSelector
end
