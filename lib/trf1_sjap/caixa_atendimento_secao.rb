# encoding: UTF-8

require 'nokogiri'

module Trf1Sjap

  class CaixaAtendimentoSecao
    def initialize(pageContent)
      @doc = Nokogiri::HTML(pageContent)
    end

    def solicitacoes
      data = []
      columns = solicitacoes_columns()
      for line in solicitacoes_lines()
        line_cells  = line.xpath('td')
        data.append({
          :id => line.at_xpath('@value').text.strip.to_i,
          :numero => column_cell_text(line_cells[columns[:numero]]),
          :solicitante => column_cell_text(line_cells[columns[:solicitante]]),
          :servico_atual => column_cell_text(line_cells[columns[:servico_atual]]),
          :atendente => __parseAtendente(column_cell_text(line_cells[columns[:atendente]]))
        })
      end
      return data
    end

    def __parseAtendente(text)
      text = text.strip
      if text == '-'
        return ''
      else
      return text
      end
    end

    def novaSolicitacao?
      for s in solicitacoes
        if s[:atendente] == ''
        return true
        end
      end
      return false
    end
    
    private
    
    def solicitacoes_table
      return @doc.at_xpath("id('container_pagination')/table")
    end
    
    def solicitacoes_lines
      return solicitacoes_table().xpath('tbody/tr')
    end
    
    def solicitacoes_columns
      result = {}
      i = 0
      for cell in solicitacoes_table().xpath('thead/tr/th')
        column = column_by_label(column_cell_text(cell))
        if column != nil
          result[column] = i
        end
        i += 1
      end      
      for column in solicitacao_columns_text().keys()
        if ! result.key?(column)
          raise 'Coluna não encontrada: ' + column.to_s + " / Result: " + result.to_s
        end
      end
      return result
    end
    
    def column_by_label(label)
      solicitacao_columns_text().each do |column, text| 
        return column if label.downcase.include?(text)
      end
      return nil
    end
    
    def solicitacao_columns_text
      return {
        :numero => 'solicitação', 
        :solicitante => 'solicitante', 
        :servico_atual => 'serviço',
        :atendente => 'atendente'
      }
    end
    
    def column_cell_text(cell)
      link_text = cell.at_xpath('a/text()')
      if link_text != nil && link_text.to_s.strip.length > 0
        return link_text.to_s.strip
      end
      return cell.text.to_s.strip
    end

  end

end