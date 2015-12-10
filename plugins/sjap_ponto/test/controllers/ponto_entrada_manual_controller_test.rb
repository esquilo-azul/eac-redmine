require 'test_helper'

class PontoEntradaManualControllerTest < ActionController::TestCase
  ActiveRecord::FixtureSet.create_fixtures(File.expand_path('plugins/redmine_trf1_sjap/test/fixtures', Rails.root), :funcionarios)

  def setup
    @request.session[:user_id] = User.where(status: 1, admin: true).first.id
  end

  def test_new
    get :new
    assert_response :success
    assert_not_nil assigns(:ponto_entrada_manual)
  end

  def test_create
    assert_difference 'PontoEntrada.count' do
      post :create, ponto_entrada_manual: { :motivo => 'Esquecimento', funcionario_id: Funcionario.first.id,
                                            'ano' => '2015', 'mes' => '12', 'dia' => '14',
                                            'hora' => '12', 'minuto' => '30'
      }
    end
    assert_redirected_to new_ponto_entrada_manual_path
    assert_not_nil assigns(:ponto_entrada_manual)
    assert_equal Time.utc(2015, 12, 14, 15, 30, 0), assigns(:ponto_entrada_manual).ponto_entrada.data_hora
  end
end
