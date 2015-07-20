# encoding: UTF-8
class EsostiUsuario < ActiveRecord::Base
  unloadable
  validates_presence_of :matricula, :nome
  validates_uniqueness_of :matricula
  
  def to_s
    matricula + " - " + nome
  end
  
  def self.get_or_create(esosti_usuario_rotulo)
    fields = EsostiUsuario.parse_esosti_usuario_rotulo(esosti_usuario_rotulo)
    usuario = find_by_matricula(fields[:matricula])
    if (!usuario)
      usuario = EsostiUsuario.new(fields)
      usuario.matricula = fields[:matricula]
      usuario.nome = fields[:nome]
      Trf1Sjap::ModelUtils.save_or_raise(usuario)
    end
    usuario
  end

  def self.get_or_create_from_user(user)
    instance = find_by_matricula(user.login)
    if !instance
      instance = new
      instance.matricula = user.login.upcase
      instance.nome = (user.firstname + ' ' + user.lastname).upcase
      Trf1Sjap::ModelUtils.save_or_raise(instance)      
    end
    instance
  end

  def self.find_by_matricula(matricula)
    where("lower(matricula) = ?", matricula.downcase).first
  end

  def self.find_by_nome(nome)
    where("lower(nome) = ?", nome.downcase).first
  end

  def to_redmine_user
    user = User.find_by_login(matricula.downcase)
    if !user
      user = User.new(EsostiUsuario.parse_full_name(nome))
      user.login = matricula.downcase
      user.mail = user.login + '@localhost.localhost'
      Trf1Sjap::ModelUtils.save_or_raise user
    end
    user
  end

  # Extrai a matrícula e o nome de um rótulo de usuário do e-Sosti.
  # "AP20199 EDUARDO HENRIQUE BOGONI" = { :matricula => "AP20199", :nome => "EDUARDO HENRIQUE BOGONI" }
  def self.parse_esosti_usuario_rotulo(esosti_usuario_rotulo)
    parts = /\s*([0-9a-zA-Z]+)\s*\-\s*(\S+(?:\s+\S+)*)\s*/.match(esosti_usuario_rotulo)
    raise "Rótulo de usuário e-Sosti não coincide com o formato esperado: \"#{esosti_usuario_rotulo}\" (Formato esperado: <MATRÍCULA> - <NOME>)" if !parts
    {:matricula => parts[1], :nome => parts[2]}
  end

  # Converte um nome completo em primeiro nome / sobrenome
  # "EDUARDO HENRIQUE BOGONI" = { :firstname => "Eduardo", :lastname => "Henrique Bogoni"}
  def self.parse_full_name(esosti_usuario_nome)
    names = esosti_usuario_nome.scan(/\S+/)
    return {
      :firstname => capitalize_name([names[0]], 30),
      :lastname => capitalize_name(names[1..names.size], 30)
    }
  end

  private

  def self.capitalize_name(names, limit)
    result = names.map{|name| name.length <= 2 ? UnicodeUtils.downcase(name, :pt) : UnicodeUtils.titlecase(name, :pt)}
    while result.join(' ').strip.length > limit
      new_result = abreviate_name(result)
      if new_result == result
        raise "Nome não pôde ser abreviado: #{result.join(' ').strip}"
      end
      result = new_result
      x = result.join(' ').strip
    end
    result.join(' ').strip
  end

  def self.abreviate_name(parts)
    result = abreviate_middle(parts, true)
    if result == parts
      result = abreviate_middle(parts, false)
    end
    result
  end

  def self.abreviate_middle(parts, skip_first_last)
    result = []
    passed_first = false
    abreviated = false
    parts.each_with_index  do |part, i|
      if part.length > 2
        if !abreviated && ((passed_first && i != parts.length-1) || !skip_first_last)
          result << part[0] + '.'
        abreviated = true
        else
        result << part
        passed_first = true
        end
      else
      result << part
      end
    end
    result
  end

end
