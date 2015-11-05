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
end
