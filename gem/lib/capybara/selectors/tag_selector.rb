module Capybara
  module Selectors
    module TagSelector
      def select2_tag(value, options = {})
        find_select2_input(options).set(value)
        find('.select2-drop li', text: value).click
      end

      def select2_deselect_tag(value, options = {})
        find_select2_input(options).parent
          .find('.select2-choices div', text: value)
          .find(:xpath, 'following-sibling::a').click
      end

      private

      def find_select2_input(options)
        if options[:from]
          find(:fillable_field, options[:from])
        else
          find('input.select2-input')
        end
      end
    end
  end
end
