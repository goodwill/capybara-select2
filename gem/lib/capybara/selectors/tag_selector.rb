module Capybara
  module Selectors
    module TagSelector
      def select2_tag(value, options = {})
        if options[:from]
          find(:fillable_field, options[:from]).set(value)
        else
          find('input.select2-input').set(value)
        end

        find('.select2-drop li', text: value).click
      end
    end
  end
end
