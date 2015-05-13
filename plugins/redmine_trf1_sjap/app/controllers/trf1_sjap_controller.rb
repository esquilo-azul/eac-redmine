class Trf1SjapController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id, :authorize

  helper :sort
  include SortHelper  
  
  def index
      @variavel = 123
  end

end
