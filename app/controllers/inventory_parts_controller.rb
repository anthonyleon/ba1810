class InventoryPartsController < ApplicationController
  before_action :set_inventory_part, only: [:show, :edit, :update, :destroy]


  def index
    respond_to do |format|
      format.html
      format.json { render json: InventoryPartsDatatable.new(view_context, current_user) }
    end
  end

  def super_index
    respond_to do |format|
      format.html
      format.json { render json: AllInventoryDatatable.new(view_context) }
    end
  end

  def show
    @inventory_part = @inventory_part.decorate
    @bid = Bid.find(params[:bid_id]) unless params[:bid_id].nil?
    @document = Document.new
  end

  def new
    @inventory_part = InventoryPart.new
  end

  def edit
  end

  def create
    @inventory_part = InventoryPart.new(inventory_part_params)

    # part_match = AvRefApi.part_num_check(@inventory_part.part_num)
    part_match = Part.find_by(part_num: @inventory_part.part_num.upcase)
    respond_to do |format|
      if part_match
        @inventory_part.add_part_details(part_match, current_user)
        unless @inventory_part.save
          format.html { render :new }
        end
        format.html { redirect_to @inventory_part, notice: 'Inventory part was successfully created.' }
        format.json { render :show, status: :created, location: @inventory_part }
      else
        flash[:error] = "Part number is not valid"
        format.html { redirect_to new_inventory_part_path, alert: 'Part Number was not valid.' }
      end
    end
  end

  # import spreadsheet of parts inventory
  def import
    @import = CsvImport.csv_import(params[:file].path, Company.find(params[:inventory_company_id]))
    # if @import.size == 2
    #   flash[:error] = "Invalid part number #{@import[1]} in your uploaded file."
    #   redirect_to new_inventory_part_path(current_user)
    # elsif @import.empty?
    #   redirect_to inventory_parts_path(current_user), notice: "Parts Imported."
    # elsif @import.size == 1
    #   redirect_to inventory_parts_path(current_user), notice: "Import complete. #{@import[0]} duplicates were found."
    # end
    
    redirect_to admin_inventory_upload_path
  end

  def update
    respond_to do |format|
      if @inventory_part.update(inventory_part_params)
        format.html { redirect_to @inventory_part, notice: 'Inventory part was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory_part }
      else
        format.html { render :edit }
        format.json { render json: @inventory_part.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @inventory_part.destroy
    respond_to do |format|
      format.html { redirect_to inventory_parts_path, notice: 'Inventory part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_all
    current_user.inventory_parts.destroy_all
    flash[:error] = "You have removed all Inventory Parts"
    redirect_to inventory_parts_path
  end

  private

    def set_inventory_part
      @inventory_part = InventoryPart.find(params[:id])
    end

    def import_inventory
      params.require(:contact_import).permit(:file, :company_id, :inventory_company_id)
    end

    def inventory_part_params
      params.require(:inventory_part).permit(:part_num, :description, :manufacturer, :company_id, :part_id, :serial_num, :document_id, :condition)
    end
end
