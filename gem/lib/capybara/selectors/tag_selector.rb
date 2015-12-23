module Capybara
  module Selectors
    module TagSelector
      def select2_tag(value, options = {})
        select2_container = if options.has_key? :css
          find(:css, options[:css])
        else
          select_name = options[:from]
          find('label', text: select_name).find(:xpath, '..').find('.select2-container')
        end

        select2_container.find('.select2-selection').click
        find(:xpath, "//body").find(".select2-search input.select2-search__field").set( value )

        @drop_container = ".select2-dropdown"

        select_option(value)
      end

      private

        def select_option(value)
          clicked = wait_for_option_with_text(value)
          unless clicked
            find(:xpath, "//body").find(select2_option_selector, text: value).click
          end
        end

        def select2_option_selector
          "#{@drop_container} li.select2-results__option"
        end

        def wait_for_option_with_text(value)
          clicked = false
          begin
            Timeout.timeout(2) do
              sleep(0.1) unless page.has_selector?(select2_option_selector, text: value)
            end
          rescue TimeoutError
            find(:xpath, "//body").find(select2_option_selector, text: value).click
            clicked = true
          end
          clicked
        end
    end
  end
end
