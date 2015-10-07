module Trf1Sjap
  class ModelUtils
    def self.active_record_base_errors_to_string(errors)
      b = ''
      errors.messages.each do |field, messages|
        b += ' / ' if b != ''
        b += field.to_s + ': ' + messages.to_s
      end
      b
    end

    def self.save_or_raise(model_instance)
      unless model_instance.save
        fail 'Falha ao tentar salvar ' + model_instance.class.name + ': ' + active_record_base_errors_to_string(model_instance.errors)
      end
    end

    def self.destroy_or_raise(model_instance)
      unless model_instance.destroy
        fail 'Falha ao tentar remover' + model_instance.class.name
      end
    end
  end
end
