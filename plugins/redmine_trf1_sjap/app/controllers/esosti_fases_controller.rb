class EsostiFasesController < ApplicationController
  # GET /esosti_fases
  # GET /esosti_fases.json
  def index
    @esosti_fases = EsostiFase.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @esosti_fases }
    end
  end

  # GET /esosti_fases/new
  # GET /esosti_fases/new.json
  def new
    @esosti_fase = EsostiFase.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @esosti_fase }
    end
  end

  # GET /esosti_fases/1/edit
  def edit
    @esosti_fase = EsostiFase.find(params[:id])
  end

  # POST /esosti_fases
  # POST /esosti_fases.json
  def create
    @esosti_fase = EsostiFase.new(params[:esosti_fase])

    respond_to do |format|
      if @esosti_fase.save
        format.html { redirect_to esosti_fases_path, notice: 'Esosti fase was successfully created.' }
        format.json { render json: @esosti_fase, status: :created, location: esosti_fases_path }
      else
        format.html { render action: "new" }
        format.json { render json: @esosti_fase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /esosti_fases/1
  # PUT /esosti_fases/1.json
  def update
    @esosti_fase = EsostiFase.find(params[:id])

    respond_to do |format|
      if @esosti_fase.update_attributes(params[:esosti_fase])
        format.html { redirect_to esosti_fases_path, notice: 'Esosti fase was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @esosti_fase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /esosti_fases/1
  # DELETE /esosti_fases/1.json
  def destroy
    @esosti_fase = EsostiFase.find(params[:id])
    @esosti_fase.destroy

    respond_to do |format|
      format.html { redirect_to esosti_fases_url }
      format.json { head :no_content }
    end
  end
end
