class InventoryPartsController < ApplicationController
  before_action :set_inventory_part, only: [:show, :edit, :update, :destroy]


  def index
    @inventory_parts = current_user.inventory_parts
  end

  def show
    unless params[:bid_id].nil?
      @bid = Bid.find(params[:bid_id])
    end

    @document = Document.new
  end

  def new
    @inventory_part = InventoryPart.new
  end

  def edit
  end

  def create
    @inventory_part = InventoryPart.new(inventory_part_params)
    @part_match = Part.find_by(part_num: @inventory_part.part_num)

    respond_to do |format|
      if @part_match
        build_inv_part(@part_match, @inventory_part)

        @inventory_part.part = @part_match
        @inventory_part.company = current_user
        unless @inventory_part.save
          format.html { render :new }
        end
        format.html { redirect_to @inventory_part, notice: 'Inventory part was successfully created.' }
        format.json { render :show, status: :created, location: @inventory_part }
      else
        format.html { redirect_to new_inventory_part_path, alert: 'Part Number was not valid.' }
      end
    end
  end


  # import spreadsheet of parts inventory
  def import
    @imported_parts = InventoryPart.import(params[:file])
    @imported_parts.company_id = current_user.id
    redirect_to company_inventory_parts_path, notice: "Products imported."
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

  private
    
    def set_inventory_part
      @inventory_part = InventoryPart.find(params[:id])
    end
    
    def import_inventory
      params.require(:contact_import).permit(:file)
    end

    def build_inv_part part_match, inventory_part
      inventory_part.description = part_match.description
      inventory_part.manufacturer = part_match.manufacturer
    end

    def inventory_part_params
      params.require(:inventory_part).permit(:part_num, :description, :manufacturer, :company_id, :part_id, :serial_num, :document_id, :condition)
    end
end
