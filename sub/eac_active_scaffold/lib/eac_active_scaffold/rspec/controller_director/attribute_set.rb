# frozen_string_literal: true

module EacActiveScaffold
  module Rspec
    class ControllerDirector
      class AttributeSet
        enable_method_class
        common_constructor :director, :example, :name, :value

        def result
          text_fill
        rescue ::Capybara::ElementNotFound
          select_option
        end

        private

        # @return [Capybara::Node::Element]
        def field
          example.find_field(label)
        end

        def label
          director.attribute_label(name)
        end

        def select_option
          example.within field do
            example.find("option[value='#{value}']").select_option
          end
        end

        def text_fill
          field.fill_in with: value
        end
      end
    end
  end
end
