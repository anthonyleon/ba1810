class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :archive]

  def new
    @project = Project.new
  end

  def index
    @projects = Project.where(user: current_user)
  end

  def edit
  end

  def show
  end

  def create
    @project = Project.new(project_params)
    @project.company = current_user

    respond_to do |format|
      if @project.save
        if !attachment_params.empty?
          json_data = CsvImport.jsonize_csv(attachment_params[:attachment])
          PartRequirementsUploadWorker.perform_async(json_data, current_user.id, @project.id, project_params)
        end
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        flash[:error] = @project.errors.full_messages.to_sentence.gsub('.','')
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def import_part_reqs
    raise
    json_data = CsvImport.jsonize_csv(params[:file])
    InventoryUploadWorker.perform_async(json_data, (params[:inventory_company_id] || params[:company_id].to_i), params[:project_id])
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def archive
    ## TODO: Implement this.
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:reference_num, :description, :street_addy, :city, :state, :zip, :country)
    end

    def attachment_params
      params.require(:project).permit(:attachment)
    end
end
