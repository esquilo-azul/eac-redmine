# encoding: UTF-8

require File.expand_path('../../../../../test_helper', __FILE__)

module Trf1Sjap
  module Models
    class EsostiUsuarioTest < ActiveSupport::TestCase

      fixtures :users        

      def test_get_or_create_from_user
        (2..4).each {|id| EsostiUsuario.get_or_create_from_user(User.find(id))}
        assert_equal 2, EsostiUsuario.get_or_create('jsmith - Qualquer nome 1').to_redmine_user.id
        assert_equal 3, EsostiUsuario.get_or_create('dlopper - Qualquer nome 2').to_redmine_user.id
        assert_equal 4, EsostiUsuario.get_or_create('rhill - Qualquer nome 3').to_redmine_user.id    
      end
    end
  end
end