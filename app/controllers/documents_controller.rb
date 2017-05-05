class DocumentsController < ApplicationController
  before_action :set_inventory_part, :set_engine, :set_aircraft, :set_bid,  only: [:edit, :update, :create]

  def index
    #our documents
    redirect_to dashboard_path unless current_user.email != "support@bid.aero" || current_user.email != "general@gaylord.io"
    # binding.pry
    @documents = Document.where(engine_id: nil, aircraft_id: nil, company_doc_id: nil)
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    @document.inventory_part = @inventory_part
    @document.engine = @engine
    @document.aircraft = @aircraft
    @document.company_doc = @company_doc
    @document.bid = @bid

    attachments = params[:document][:attachment]
    not_saved = []
    if attachments
      if attachments.count > 1
        attachments.each do |doc| 
          @document = Document.check_object(@bid, @inventory_part, @engine, @aircraft, @company_doc, doc)
          not_saved << doc.original_filename unless @document.save
        end
      else
        @document = Document.check_object(@bid, @inventory_part, @engine, @aircraft, @company_doc, attachments[0])
      end
    end

    if @document.save
      redirect_to @inventory_part || @engine || @aircraft || @company_doc ||  auction_bid_path(@bid.auction, @bid)
      flash.now[:notice] = "The document #{@document.name} has been uploaded."
    else
      redirect_to @inventory_part || @engine || @aircraft || @company_doc || auction_bid_path(@bid.auction, @bid)
      flash[:error] = "The document #{@document.name} failed to upload."
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @inventory_part = @document.inventory_part
    @engine = @document.engine 
    @aircraft = @document.aircraft
    @company_doc = @document.company_doc
    @document.destroy
    redirect_to @inventory_part || @engine || @aircraft || documents_path, notice:  "The document #{@document.name} has been deleted."
  end

  private
  def document_params
    params.require(:document).permit(:name, :attachment, :inventory_part_id, :engine_id, :aircraft_id, :company_doc_id, :bid_id)
  end

  def set_inventory_part
    @inventory_part = InventoryPart.find(params[:inventory_part_id]) unless params[:inventory_part_id] == nil
  end


  def set_engine
    @engine = Engine.find(params[:engine_id]) unless params[:engine_id] == nil
  end

  def set_aircraft 
    @aircraft = Aircraft.find(params[:aircraft_id]) unless params[:aircraft_id] == nil
  end

  def set_company_doc
    @company_doc = CompanyDoc.find(params[:company_doc_id]) unless params [company_doc_id] == nil
  end

  def set_bid
    @bid = Bid.find(params[:bid_id]) unless params[:bid_id] == nil
  end


end
