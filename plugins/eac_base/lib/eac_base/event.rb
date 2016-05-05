module EacBase
  class Event
    attr_reader :entity, :action, :data

    def initialize(entity, action, data)
      @entity = entity
      @action = action
      @data = data
    end

    def to_s
      "#{entity}::#{action}|#{data.class}(#{data.id})"
    end
  end
end
