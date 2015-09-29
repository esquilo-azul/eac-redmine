class CefIdSolicitacao < ActiveRecord::Base
  SITUACAO_GRAVADO = 'Certificado gravado com sucesso'

  belongs_to :funcionario
  validates :funcionario, presence: true

  def self.import_from_consulta(funcionario, consulta_hashs)
    ActiveRecord::Base.transaction do
      consulta_hashs.each { |h| import_from_hash(funcionario, h) }
      funcionario.cef_id_solicitacoes_ultima_consulta = DateTime.now
      Trf1Sjap::ModelUtils.save_or_raise(funcionario)
    end
  end

  def self.find_all_by_funcionario_and_situacao(funcionario, situacao)
    where(funcionario: funcionario, situacao: situacao).order(data: :asc).all
  end

  private

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
