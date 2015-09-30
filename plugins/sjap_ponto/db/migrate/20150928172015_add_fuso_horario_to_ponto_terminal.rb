class AddFusoHorarioToPontoTerminal < ActiveRecord::Migration
  def change
    add_column :ponto_terminals, :fuso_horario, :string
  end
end
