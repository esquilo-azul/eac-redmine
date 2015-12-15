require 'test_helper'

class PontoTerminalTest < ActiveSupport::TestCase
  test 'fuso horario' do
    pt = PontoTerminal.new(descricao: 'Terminal 1', tipo: 'SUPERFACIL', endereco: 'localhost',
                           usuario: 'usuario', senha: 'senha', fuso_horario: '-03:30')
    assert pt.save!
    assert -3.5, pt.fuso_horario_offset
    assert Time.utc(2015, 12, 15, 16, 50, 0), pt.build_time(2015, 12, 15, 13, 20, 0)
  end
end
