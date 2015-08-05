class CefIdSolicitacao < ActiveRecord::Base
  belongs_to :funcionario
  validates :funcionario, presence: true

  def self.import_from_hash(funcionario, consulta_hash)
    fields = import_from_hash_fields(consulta_hash)
    instance = where(fields).first
    unless instance
      instance = new(fields)
      instance.funcionario = funcionario
      Trf1Sjap::ModelUtils.save_or_raise(instance)
    end
  end

  def self.import_from_hash_fields(hash)
    result = {}
    hash.each do |k, v|
      if k == :data
        result[k] = Date.strptime(v, '%d/%m/%Y')
      else
        result[k] = v
      end
    end
    result
  end
end
