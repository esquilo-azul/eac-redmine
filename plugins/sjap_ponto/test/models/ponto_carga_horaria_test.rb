require 'test_helper'

class PontoCargaHorariaTest < ActiveSupport::TestCase
  fixtures :users

  test 'data_final_greater_than_data_inicial' do
    p = PontoCargaHoraria.new(descricao: 'Teste', autor: users(:users_001), minutos_continuo: 420,
                              minutos_descontinuo: 480, data_inicial: DateTime.new(2015, 11, 5), data_final: nil)
    assert p.valid?, p.errors.messages

    p.data_final = DateTime.new(2015, 11, 5)
    assert p.valid?, p.errors.messages

    p.data_final = DateTime.new(2015, 11, 6)
    assert p.valid?, p.errors.messages

    p.data_final = DateTime.new(2015, 11, 4)
    assert_not p.valid?, p.errors.messages
  end

  test 'find_by_funcionario_and_data' do
    f = create_funcionario
    ch1 = create_carga_horaria(f, '2015-04-13', nil, 'Horario 1')
    ch2 = create_carga_horaria(f, '2015-06-13', nil, 'Horario 2')
    ch3 = create_carga_horaria(f, '2015-05-20', '2015-05-20', 'Feriado')
    ch4 = create_carga_horaria(f, '2015-06-13', nil, 'Cancelado')
    cancela_carga_horaria(ch4)

    assert_equal nil, PontoCargaHoraria.find_by_funcionario_and_data(f, '2015-04-12')
    assert_equal ch1, PontoCargaHoraria.find_by_funcionario_and_data(f, '2015-04-13')
    assert_equal ch1, PontoCargaHoraria.find_by_funcionario_and_data(f, '2015-05-19')
    assert_equal ch3, PontoCargaHoraria.find_by_funcionario_and_data(f, '2015-05-20')
    assert_equal ch1, PontoCargaHoraria.find_by_funcionario_and_data(f, '2015-05-21')
    assert_equal ch1, PontoCargaHoraria.find_by_funcionario_and_data(f, '2015-06-12')
    assert_equal ch2, PontoCargaHoraria.find_by_funcionario_and_data(f, '2015-06-13')
    assert_equal ch2, PontoCargaHoraria.find_by_funcionario_and_data(f, '2015-08-13')
  end

  private

  def create_funcionario
    f = Funcionario.new
    f.nome = 'João'
    f.matricula = 'AP10001'
    f.cpf = '77446953560'
    assert_equal true, f.save, f.errors.messages
    f
  end

  def create_carga_horaria(funcionario, data_inicial, data_final, descricao)
    ch = PontoCargaHoraria.new(
      autor: User.first,
      data_inicial: data_inicial,
      data_final: data_final,
      descricao: descricao,
      minutos_continuo: 420,
      minutos_descontinuo: 480,
      funcionarios_attributes: { '0' => { funcionario: funcionario, '_destroy' => 'false' } }
    )
    assert_equal true, ch.save, ch.errors.messages
    ch
  end

  def cancela_carga_horaria(carga_horaria)
    c = PontoCargaHorariaCancelamento.new(autor: User.first, ponto_carga_horaria: carga_horaria, motivo: 'true')
    assert c.save, c.errors.messages
  end
end
