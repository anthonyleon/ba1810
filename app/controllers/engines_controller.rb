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
    @document = Document.new(document_params)
    @document.engine = @engine
    respond_to do |format|
      if @engine.save
        @document.save
        format.html { redirect_to engines_path, notice: 'Engine was successfully created.' }
        format.json { render :show, status: :created, location: @engine }
      else
        format.html { render :new }
        format.json { render json: @engine.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @document = Document.new(document_params)
    respond_to do |format|
      if @engine.update(engine_params)
        @document.engine = @engine
        @document.save
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
      params.require(:engine).permit(documents_attributes: [:name, :attachment])[:documents_attributes]["0"]
      # params.require(:engine).permit(documents: [:id, :name, :attachment]) [:documents]
    end
end
