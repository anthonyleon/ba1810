class DocumentsController < ApplicationController
  before_action :set_inventory_part, only: [:show, :edit, :update, :create]

  def index
    @documents = Document.all
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    @document.inventory_part_id = @inventory_part.id

    if @document.save
      redirect_to @inventory_part, notice: "The document #{@document.name} has been uploaded."
    else
      redirect_to @inventory_part, notice: "The document #{@document.name} failed to uploaded."
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @inventory_part = @document.inventory_part
    @document.destroy
    redirect_to inventory_part_path(@inventory_part), notice:  "The document #{@document.name} has been deleted."
  end

  private
  def document_params
    params.require(:document).permit(:name, :attachment, :inventory_part_id)
  end

  def set_inventory_part
    @inventory_part = InventoryPart.find(params[:inventory_part_id])
  end
end
