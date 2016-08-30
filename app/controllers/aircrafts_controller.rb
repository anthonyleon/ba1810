class AircraftsController < ApplicationController
  before_action :set_aircraft, only: [:show, :edit, :update, :destroy]

  def index
    @aircrafts = Aircraft.all
  end

  def show
    @document = Document.new
  end

  def new
    @aircraft = Aircraft.new
  end

  def edit
  end

  def create
    @aircraft = Aircraft.new(aircraft_params)
    @aircraft.company = current_user

    respond_to do |format|
      if @aircraft.save
        format.html { redirect_to @aircraft, notice: 'Aircraft was successfully created.' }
        format.json { render :show, status: :created, location: @aircraft }
      else
        format.html { render :new }
        format.json { render json: @aircraft.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @aircraft.update(aircraft_params)
        format.html { redirect_to @aircraft, notice: 'Aircraft was successfully updated.' }
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

    def aircraft_params
      params.require(:aircraft).permit(:company_id, :aircraft_type, :msn, :tail_number, :yob, :mtow, :engine_major_variant, :engine_minor_variant, :apu_model, :cabin_config, :in_service, :off_service, :current_operator, :last_operator, :location, :maintenance_status, :available_date, :sale, :lease, :service_status, :document_id)
    end
end
