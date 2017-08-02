# frozen_string_literal: true

module Capybara
  module Select2
    class Query
      CONTROL_SELECTOR =
        '.select2-selection,.select2-choice,.select2-choices'
      OPEN_CONTAINER_SELECTOR =
        '.select2-container--open .select2-dropdown'
      SEARCH_FIELD_SELECTOR = 'input.select2-search__field'
      OPTION_SELECTOR =
        'li.select2-results__option,li.select2-results__option--highlighted'

      attr_reader :page, :value, :options

      def initialize(page, value, options = {})
        @page = page
        @value = value
        check_options!(options)
        @options = options
      end

      def call
        open_select2(find_container)
        page.within page.find(:xpath, '//body') do
          page.within page.find(OPEN_CONTAINER_SELECTOR) do
            populate_search(value) if options.key? :search
            select_options(value)
          end
        end
      end

      private

      def select_options(values)
        [values].flatten.each do |value|
          select_option(value)
        end
      end

      def select_option(value)
        wait_for_option_with_text(value)
        page.find(OPTION_SELECTOR, text: value).click
      end

      def check_options!(options)
        return if allowed_options?(options)
        raise "Must pass a hash containing 'from' or 'xpath' or 'css'"
      end

      def open_select2(container)
        container.find(CONTROL_SELECTOR).click
      end

      def allowed_options?(options = {})
        return false unless options.is_a?(Hash)
        %i[from xpath css].any? { |option| options.key? option }
      end

      def find_container
        if options.key? :xpath
          page.find(:xpath, options[:xpath])
        elsif options.key? :css
          page.find(:css, options[:css])
        else
          select_name = options[:from]
          page.find('label', text: select_name)
              .find(:xpath, '..')
              .find('.select2-container')
        end
      end

      def populate_search(value)
        page.find(SEARCH_FIELD_SELECTOR).set(value)
        page.execute_script(
          %($("#{OPEN_CONTAINER_SELECTOR} #{SEARCH_FIELD_SELECTOR}:visible").keyup();)
        )
      end

      def wait_for_option_with_text(value)
        Timeout.timeout(2) do
          sleep(0.1) until page.has_selector?(OPTION_SELECTOR, text: value)
        end
      rescue Timeout::Error
        page.find(OPTION_SELECTOR, text: value).click
      end
    end
  end
end
