class AircraftsController < ApplicationController
  before_action :set_aircraft, only: [:show, :edit, :update, :destroy]
  include ApplicationHelper

  def index
    @aircrafts = current_user.aircrafts.decorate
  end

  def show
    @aircraft = @aircraft.decorate
    @document = Document.new
  end

  def new
    @aircraft = Aircraft.new
  end

  def edit
  end

  def create
    @aircraft = Aircraft.new(set_empty_params_to_na(aircraft_params))
    @aircraft.company = current_user
    if params.require(:aircraft)[:document]  
      @document = Document.new(attachment: document_params, name: document_params.original_filename)
      @document.aircraft = @aircraft
      @document.save
    end
    respond_to do |format|
      if @aircraft.save
        format.html { redirect_to aircrafts_path, notice: 'Aircraft was successfully created.' }
        format.json { render :show, status: :created, location: @aircraft }
      else
        format.html { render :new }
        format.json { render json: @aircraft.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params.require(:aircraft)[:document]
      @document = Document.new(attachment: document_params, name: document_params.original_filename) if params.require(:aircraft)[:document]
      @document.aircraft = @aircraft 
      @document.save
    end
    respond_to do |format|
      if @aircraft.update(aircraft_params)
        format.html { redirect_to aircrafts_path, notice: 'Aircraft was successfully updated.' }
        format.json { render :show, status: :ok, location: @aircraft }
      else
        format.html { render :edit }
        format.json { render json: @aircraft.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @aircraft.destroy
    respond_to do |format|
      format.html { redirect_to aircrafts_url, notice: 'Aircraft was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_aircraft
      @aircraft = Aircraft.find(params[:id])
    end

    def document_params
      params.require(:aircraft).require(:document)["attachment"][0]  
    end

    def aircraft_params
      params.require(:aircraft).permit(:company_id, :aircraft_type, :msn, :tail_number, :yob, :mtow, :engine_major_variant, :engine_minor_variant, :apu_model, :cabin_config, :current_operator, :last_operator, :location, :maintenance_status, :available_date, :sale, :lease, :service_status, :document_id)
    end
end
