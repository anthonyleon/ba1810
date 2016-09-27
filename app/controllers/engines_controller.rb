class EnginesController < ApplicationController
  before_action :set_engine, only: [:show, :edit, :update, :destroy]

  def index
    @engines = Engine.all.decorate
  end

  def show
    @engine = @engine.decorate
    @document = Document.new
  end

  def new
    @engine = Engine.new
  end

  def edit
  end

  def create
    @engine = Engine.new(engine_params)
    @engine.company = current_user

    respond_to do |format|
      if @engine.save
        format.html { redirect_to @engine, notice: 'Engine was successfully created.' }
        format.json { render :show, status: :created, location: @engine }
      else
        format.html { render :new }
        format.json { render json: @engine.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @engine.update(engine_params)
        format.html { redirect_to @engine, notice: 'Engine was successfully updated.' }
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
      params.require(:engine).permit(:company_id, :engine_major_variant, :engine_minor_variant, :esn, :condition, :current_status, :in_service, :off_service, :current_operator, :last_operator, :location, :cycles_remaining, :available_date, :sale, :lease, :document_id)
    end
end
