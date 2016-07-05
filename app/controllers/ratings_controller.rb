class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]
  before_action :set_company, only: [:index, :create]

  def index
    @ratings = Rating.where(company_id: company_id)
  end

  def new
    @rating = Rating.new
  end



  def create
    @rating = Rating.new(rating_params)
    @rating.company_id = @company.id

    respond_to do |format|
      if @rating.save
        format.html { redirect_to :back, notice: 'Rating was successfully created.' }
        format.json { render :show, status: :created, location: @rating }
      else
        format.html { render :new }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @rating.update(rating_params)
        format.html { redirect_to @rating, notice: 'Rating was successfully updated.' }
        format.json { render :show, status: :ok, location: @rating }
      else
        format.html { render :edit }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to ratings_url, notice: 'Rating was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_rating
      @rating = Rating.find(params[:id])
    end

    def set_company
      @company = Company.find(params[:company_id])
    end

    def rating_params
      params.require(:rating).permit(:packaging, :timeliness, :documentation, :bid_aero, :dependability, :company_id)
    end
end
