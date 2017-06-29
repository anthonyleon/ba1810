class CompanyDocsController < ApplicationController
	before_action :set_company_doc, only: [:destroy]
	

	def new
		@company_doc = CompanyDoc.new
	end

	def index
    @company_doc = CompanyDoc.new 
		@company_docs = current_company.company_docs
	end

	def create 
    @company_doc = CompanyDoc.new(company_doc_params)
    @company_doc.company = current_company
    if @company_doc.save
      AdminMailer.resale_uploaded(current_company, @company_doc)..deliver_later(wait: 1.hour) if @company_doc.resale_license
      redirect_to edit_company_path #company_docs_url
      flash.now[:notice] = "The document #{@company_doc.name} has been uploaded."
    else
      redirect_to @company_doc, notice: "The document #{@company_doc.name} failed to upload."
    end
  end

  def destroy
 		@company_doc.destroy	
  	redirect_to company_docs_url, notice:  "The document #{@company_doc.name} has been deleted."
  end
	private


	def set_company_doc
      @company_doc = CompanyDoc.find(params[:id])
    end

	def company_doc_params
		params.require(:company_doc).permit(:name, :attachment, :company_id, :resale_license)
  end
	
end

