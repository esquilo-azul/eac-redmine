module PontoCargaHorariasHelper
  def funcionario_options_for_select(selected)
    options_for_select([[l(:label_all), '']] + funcionarios_list, selected ? selected.id : nil)
  end

  def funcionarios_list
    Funcionario.order(nome: :asc).all.collect { |p| [p.nome, p.id] }
  end
end
