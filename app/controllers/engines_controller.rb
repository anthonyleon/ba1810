class EnginesController < ApplicationController
  before_action :set_engine, only: [:show, :edit, :update, :destroy]

  def index
    @engines = current_user.engines.decorate
  end

  def show
    @engine = @engine.decorate
    @document = Document.new
  end

  def new
    @engine = Engine.new
    @document = Document.new
  end

  def edit
  end

  def create
    @engine = Engine.new(engine_params)
    @engine.company = current_user
    if params.require(:engine)[:document]  
      @document = Document.new(attachment: document_params, name: document_params.original_filename)
      @document.engine = @engine
      @document.save
    end
    respond_to do |format|
      if @engine.save

        format.html { redirect_to engines_path, notice: 'Engine was successfully created.' }
        format.json { render :show, status: :created, location: @engine }
      else
        format.html { render :new }
        format.json { render json: @engine.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params.require(:engine)[:document]
      @document = Document.new(attachment: document_params, name: document_params.original_filename) if params.require(:engine)[:document]
      @document.engine = @engine 
      @document.save
    end
    respond_to do |format|
      if @engine.update(engine_params)

        format.html { redirect_to engines_path, notice: 'Engine was successfully updated.' }
        format.json { render :show, status: :ok, location: @engine }
      else
        format.html { render :edit }
        format.json { render json: @engine.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @engine.destroy
    respond_to do |format|
      format.html { redirect_to engines_url, notice: 'Engine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_engine
      @engine = Engine.find(params[:id])
    end

    def engine_params
      params.require(:engine).permit(:company_id, :engine_major_variant, :engine_minor_variant, :esn, :condition, :service_status, :current_operator, :last_operator, :location, :cycles_remaining, :available_date, :sale, :lease, :document_id)
    end

    def document_params
      params.require(:engine).require(:document)["attachment"][0] 
      # params.require(:engine).permit(documents: [:id, :name, :attachment]) [:documents]
    end
end
