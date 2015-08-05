class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless check_cpf(value)
      record.errors[attribute] << (options[:message] || 'CPF inválido')
    end
  end

  # https://gist.github.com/gouvermxt/1005640
  def check_cpf(cpf = nil)
    return true if cpf.nil?
    nulos = %w(12345678909 11111111111 22222222222 33333333333 44444444444 55555555555 66666666666 77777777777 88888888888 99999999999 00000000000)
    valor = cpf.scan /[0-9]/
    if valor.length == 11 && valor.length == cpf.length
      unless nulos.member?(valor.join)
        valor = valor.collect(&:to_i)
        soma = 10 * valor[0] + 9 * valor[1] + 8 * valor[2] + 7 * valor[3] + 6 * valor[4] + 5 * valor[5] + 4 * valor[6] + 3 * valor[7] + 2 * valor[8]
        soma -= (11 * (soma / 11))
        resultado1 = (soma == 0 || soma == 1) ? 0 : 11 - soma
        if resultado1 == valor[9]
          soma = valor[0] * 11 + valor[1] * 10 + valor[2] * 9 + valor[3] * 8 + valor[4] * 7 + valor[5] * 6 + valor[6] * 5 + valor[7] * 4 + valor[8] * 3 + valor[9] * 2
          soma -= (11 * (soma / 11))
          resultado2 = (soma == 0 || soma == 1) ? 0 : 11 - soma
          return true if resultado2 == valor[10] # CPF válido
        end
      end
    end
    false # CPF inválido
  end
end

# https://github.com/shamanime/pasep-pis-nit/blob/master/lib/pasep-pis-nit/pis.rb
class PasepPisNitValidator < ::ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless check_pis(value)
      record.errors[attribute] << (options[:message] || 'PIS inválido')
    end
  end

  private

  PESO = %w(3 2 9 8 7 6 5 4 3 2)

  def check_pis(pis = nil)
    return true if pis.nil?
    return false if pis.length != 11
    total = soma_digitos(pis)
    resto = total % 11
    verificador = 11 - resto
    verificador = 0 if verificador == 10 || verificador == 11
    verificador.to_s == pis[10]
  end

  def soma_digitos(pis)
    soma = 0
    (0..9).each { |i| soma += PESO[i].to_i * pis[i].to_i }
    soma
  end
end

class Funcionario < ActiveRecord::Base
  validates :nome, presence: true
  validates :cpf, uniqueness: true, allow_blank: true, cpf: true
  validates :matricula, uniqueness: { :case_sensitive => false }, allow_blank: true
  validates :pis, uniqueness: true, pasep_pis_nit: true, allow_blank: true

  def to_s
    nome
  end
end
