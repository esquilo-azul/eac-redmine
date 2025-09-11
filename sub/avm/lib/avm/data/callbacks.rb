# frozen_string_literal: true

require 'active_support/callbacks'

module Avm
  module Data
    module Callbacks
      common_concern do
        include ::ActiveSupport::Callbacks

        %i[dump load].each do |action|
          define_callbacks action

          %i[before after].each do |callback|
            method_name = "#{callback}_#{action}"
            singleton_class.class_eval do
              define_method method_name do |callback_method = nil, &block|
                if callback_method
                  set_callback action, callback, callback_method
                else
                  set_callback action, callback, &block
                end
                self
              end
            end

            define_method method_name do |callback_method = nil, &block|
              singleton_class.send(method_name, callback_method, &block)
              self
            end
          end
        end
      end
    end
  end
end
