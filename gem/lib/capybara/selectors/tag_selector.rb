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

        select_tag_option(value, options[:first])
      end

      private

        def select_tag_option(value, first)
          clicked = wait_for_tag_option_with_text(value, first)
          unless clicked
            if first
              find(:xpath, "//body").first(select2_tag_option_selector, text: value).click
            else
              find(:xpath, "//body").find(select2_tag_option_selector, text: value).click
            end
          end
        end

        def select2_tag_option_selector
          "#{@drop_container} li.select2-results__option"
        end

        def wait_for_tag_option_with_text(value, first)
          clicked = false
          begin
            Timeout.timeout(2) do
              sleep(0.1) unless page.has_selector?(select2_tag_option_selector, text: value)
            end
          rescue TimeoutError
            if first
              find(:xpath, "//body").first(select2_tag_option_selector, text: value).click
            else
              find(:xpath, "//body").find(select2_tag_option_selector, text: value).click
            end
            clicked = true
          end
          clicked
        end
    end
  end
end
