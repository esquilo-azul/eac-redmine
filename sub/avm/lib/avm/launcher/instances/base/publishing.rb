# frozen_string_literal: true

module Avm
  module Launcher
    module Instances
      module Base
        module Publishing
          def publish?(stereotype)
            publish_by_stereotype?(stereotype) && publish_by_application?(stereotype) &&
              publish_by_context?(stereotype)
          end

          # @return [Boolean]
          def publish_by_application?(stereotype)
            application.stereotype_publishable?(stereotype)
          end

          # @return [Boolean]
          def publish_by_context?(stereotype)
            filter = ::Avm::Launcher::Context.current.publish_options[:stereotype]
            filter.blank? || filter == stereotype.name.demodulize
          end

          # @return [Boolean]
          def publish_by_stereotype?(stereotype)
            stereotype.publish_class.present?
          end

          # @return [Boolean]
          delegate :publishable?, to: :application

          def publish_check
            stereotypes.each do |s|
              next unless publish?(s)

              puts "#{name.to_s.cyan}|#{s.label}|" \
                   "#{s.publish_class.new(self).check}"
            end
          end

          def publish_run
            stereotypes.each do |s|
              next unless publish?(s)

              infov(name, "publishing #{s.label}")
              s.publish_class.new(self).run
            end
          end
        end
      end
    end
  end
end
