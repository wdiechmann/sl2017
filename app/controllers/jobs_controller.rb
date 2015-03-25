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
        JobMailer.job_confirm(message,text_body).deliver_later
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
    result = true if @job.destroy
    result ? (flash.now[:info] = "Jobbet blev slettet korrekt") : (flash.now[:error] = "Jobbet blev ikke slettet korrekt" )
    if result==true
      render layout:false, status: 200, locals: { result: true }
    else
      render layout:false, status: 301, locals: { result: true }
    end
  rescue
    (flash.now[:error] = "Der opstod en andenfejl - og Jobbet blev ikke slettet korrekt")
    render layout:false, status: 401, locals: { result: false }
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



    def m1_message
      [
        "Tak fordi du har oprettet et job! Vi lover at vi skal gøre vort bedste for at finde de arbejdskræfter, I beder om i udvalget: <%= @job.delivery_team.name %>

        Job nr: <%= @id %>                                Dato: <%= @created_at %>

        Hvad sker der så herefter?
        --------------------------

        Vi arbejder på højtryk for at skabe en god kontakt mellem de, der har lyst at give en hånd med, og dit udvalg, og vi forventer at være klar i løbet af marts 2015.
        Din henvendelse er noteret, og når en frivillig henviser til dit job opslag, eller udtrykker ønske om at arbejde med noget, der står omtalt i dit jobopslag,
        sender vi dig en email med den frivilliges kontakt oplysninger.

        Bemærk - det vil lette arbejdet meget for os, hvis du vil have ulejlighed med at acceptere de emails, vi sender med kontaktoplysninger.
        Der vil være en knap, der vil sende dig til job.sl2017.dk (job sitet) - så vi kan holde styr på, hvilke frivillige der bliver match'et med et job.


        Spejderhilsen

        ------------------------------------------------------------
        Spejdernes Lejr 2017
"
      ].join()






end
