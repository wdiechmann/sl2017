class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: :create
  before_filter :collection_for_parent_select, :except => [:index, :show]
  after_action :verify_authorized

  # GET /jobs
  # GET /jobs.json
  def index
    unless params[:q].nil?
      jobs = Job.arel_table
      query_string = "%#{params[:q]}%"
      @jobs = Job.all.where(jobs[:name].matches(query_string).or(jobs[:schedule].matches(query_string)).or(jobs[:location].matches(query_string)).or(jobs[:description].matches(query_string))).order(created_at: :asc)
    else
      @jobs = Job.all.order(created_at: :asc)
    end
    authorize Job
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @delivery_teams = ancestry_options(DeliveryTeam.unscoped.arrange(:order => 'title')) {|i| "#{'-' * i.depth} #{i.title}" }
    @job = Job.new
    authorize @job
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  def create
    params[:job][:user_id] = current_user.id
    @job = Job.new(job_params)
    authorize @job

    respond_to do |format|
      if @job.save
        JobMailer.job_confirm(@job,current_user).deliver_later
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private


    def collection_for_parent_select
      @delivery_teams = ancestry_options(DeliveryTeam.unscoped.arrange(:order => 'title')) {|i| "#{'-' * i.depth} #{i.title}" }
    end


    def ancestry_options(items)
      result = []
      items.map do |item, sub_items|
        result << [yield(item), item.id]
        #this is a recursive call:
        result += ancestry_options(sub_items) {|i| "#{'-' * i.depth} #{i.title}" }
      end
      result
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
      authorize @job
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:name, :location, :schedule, :priority, :delegated_at, :jobbers_min, :jobbers_wanted, :jobbers_max, :vacancies, :description, :promote_job_at, :delivery_team_id, :user_id)
    end
end
