module EacBase
  class EventManager
    class << self
      def add_listener(entity, action, listener)
        return if listeners(entity, action).include?(listener)
        listeners(entity, action) << listener
      end

      def trigger(entity, action, data)
        event = EacBase::Event.new(entity, action, data)
        Rails.logger.debug("Event triggered: #{event}")
        listeners(entity, action).each do |l|
          Rails.logger.debug("Listener found: #{l}")
          delay.run_listener(l.constantize.new(event))
        end
      end

      private

      def run_listener(listener)
        previous_locale = I18n.locale
        begin
          Rails.logger.info("Running listener: #{listener}")
          I18n.locale = Setting.default_language
          listener.run
        rescue => ex
          Rails.logger.warn(ex)
        ensure
          I18n.locale = previous_locale
        end
      end

      def listeners(entity, action)
        @listeners ||= {}
        @listeners[entity] ||= {}
        @listeners[entity][action] ||= []
      end
    end
  end
end
