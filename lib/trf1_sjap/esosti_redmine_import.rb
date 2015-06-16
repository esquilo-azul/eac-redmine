# encoding: UTF-8

module Trf1Sjap
  
  class EsostiRedmineImport
    # Replica no redmine os e-Sostis encontrados na caixa de atendimentos da seção do e-Sosti no e-Admin.
    def self.import_caixa_secao_atendimento(trf1_sjap_project, solicitacoes)
      replicate = CaixaSecaoAtendimentoReplicate.new(trf1_sjap_project, solicitacoes)
      replicate.result
    end

    # Replica no redmine os updates da página de detalhes de solicitação e-Sosti do e-Admin.
    def self.import_solicitacao_detalhes(esosti_solicitacao, updates)
      replicate = SolicitacaoDetalhesReplicate.new(esosti_solicitacao, updates)
      replicate.result
    end

    # Transforma um update e-Sosti (Já na base de dados do Redmine) em um Issue
    # ou Comment no Redmine.
    def self.update_to_redmine(esosti_update)
      export = UpdateToRedmine.new(esosti_update)
      export.result
    end

    # Exporta para o Redmine a mudança de atendente de uma solicitação e-Sosti.
    def self.import_atendente_mudanca(esosti_solicitacao)
      export = AtendenteToRedmine.new(esosti_solicitacao)
      export.result
    end

    private

    def self.get_admin_user()
      User.find(Setting.plugin_redmine_trf1_sjap['admin_user_id'])
    end
  end
end