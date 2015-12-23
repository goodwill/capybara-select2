module Capybara
  module Selectors
    module TagSelector
      def select2_tag(value, options = {})
        select2_container = if options.has_key? :css
          find(:css, options[:css])
        else
          select_name = options[:from]
          find("label", text: select_name).find(:xpath, '..').find(".select2-container")
        end
        
        find('.select2-drop li', text: value).click
      end
    end
  end
end
