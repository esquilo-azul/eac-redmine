module FuncionariosHelper
  def multi_funcionario_input(form, column)
    MultiFuncionarioInput.new(self, form, column).build
  end

  private

  module Single
    def single_input
      view.content_tag(:span, class: 'single_container') do
        field_name = "#{column}_single_funcionario_id"
        options = view.options_from_collection_for_select(Funcionario.order(nome: :asc).all, :id,
                                                          :nome, view.params[field_name])
        view.select_tag(field_name, options)
      end
    end
  end

  module Multi
    def multi_input
      view.content_tag(:span, class: 'multi_container') do
        b = ActiveSupport::SafeBuffer.new
        funcionarios_grouped.each do |k, v|
          b << funcionarios_group_container(k, v)
        end
        b
      end
    end

    def funcionarios_grouped
      groups = {}
      Funcionario.order(nome: :asc).all.each do |f|
        letter = f.nome.upcase[0]
        groups[letter] ||= []
        groups[letter] << f
      end
      groups
    end

    def funcionarios_group_container(letter, funcionarios)
      view.content_tag(:span, class: 'funcionarios_group_container') do
        b = view.content_tag(:span, letter, class: 'letter')
        b << view.content_tag(:span, class: 'funcionarios_container') do
          funcionarios_rows(funcionarios)
        end
      end
    end

    def funcionarios_rows(funcionarios)
      b = ActiveSupport::SafeBuffer.new
      RowsBuilder.new(4, funcionarios).rows.each do |r|
        b << view.content_tag(:span, class: 'row') do
          b1 = ActiveSupport::SafeBuffer.new
          r.each { |f| b1 << funcionario(f) }
          b1
        end
      end
      b
    end

    def funcionario(f)
      view.content_tag(:span, class: 'funcionario') do
        field_name = "#{@column}_multi_funcionario_#{f.id}"
        view.check_box_tag(field_name, '1', view.params[field_name] == '1') << f.to_s
      end
    end

    class RowsBuilder
      def initialize(row_size, funcionarios)
        @row_size = row_size
        @rows = []
        funcionarios.each { |f| add_funcionario(f) }
      end

      def add_funcionario(f)
        @rows << [] if @rows.empty? || @rows[-1].size >= @row_size
        @rows[-1] << f
      end

      attr_reader :rows
    end
  end

  class MultiFuncionarioInput
    include Single
    include Multi

    attr_reader :view, :form, :column

    def initialize(view, form, column)
      @view = view
      @form = form
      @column = column
    end

    def build
      @view.content_tag(:span, id: id, class: 'FuncionariosHelper') do
        type_select <<
          @view.tag(:br) <<
          single_input <<
          multi_input <<
          @view.content_tag(:script, @view.raw("new FuncionariosHelper('#{id}', " \
              "'#{result_input_name}')"))
      end
    end

    private

    def result_input_name
      "#{@form.object_name}[#{sanitized_method_name}][]"
    end

    def sanitized_method_name
      @column.to_s.sub(/\?$/, '')
    end

    def id
      'funcionarios_helper_multi_funcionario_input'
    end

    def type_select
      b = ActiveSupport::SafeBuffer.new
      { 'single' => 'Único', 'multi' => 'Vários' }.each do |k, v|
        b << @view.content_tag(:span) do
          @view.radio_button_tag('multi_funcionario_type', k,
                                 (@view.params['multi_funcionario_type'] || 'single') == k) << v
        end
      end
      b
    end
  end
end
