module Trf1Sjap
  class ModelUtils
    def self.active_record_base_errors_to_string errors
      b = ''
      errors.messages.each do |field, messages|
        if b != ''
          b += ' / '
        end
        b += field.to_s + ": " + messages.to_s
      end
      return b
    end

    def self.save_or_raise(model_instance)
      if ! model_instance.save
        raise "Falha ao tentar salvar " + model_instance.class.name + ": " + active_record_base_errors_to_string(model_instance.errors)
      end
    end
  end
end