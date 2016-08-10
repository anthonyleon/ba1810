class CompanyDocsController < ApplicationController
	before_action :set_company_doc, only: [:destroy]
	

	def new
		@company_doc = CompanyDoc.new
	end

	def index
    @company_doc = CompanyDoc.new 
		@company_docs = current_user.company_docs
	end

	def create 
    @company_doc = CompanyDoc.new(company_doc_params)
    @company_doc.company = current_user
    if @company_doc.save
      redirect_to company_docs_url
      flash.now[:notice] = "The document #{@company_doc.name} has been uploaded."
    else
      redirect_to @company_doc, notice: "The document #{@company_doc.name} failed to uploaded."
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

