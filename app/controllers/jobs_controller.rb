class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:create, :index]
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
    @job = Job.new
    authorize @job
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  # "job"=>{"email"=>"", "delivery_team_id"=>"22", "name"=>"walther@diechmann.net", "location"=>"ved toiletterne", "schedule"=>"hver morgen kl 6", "jobbers_min"=>"3", "jobbers_wanted"=>"6", "jobbers_max"=>"7", "priority"=>"2", "promote_job_at"=>"18 June, 2015", "description"=>"Det er vigtigt at møde præcist, have rene negle og vandkæmmet hår"}
  def create
    unless current_user
      user = (User.find_by(email: params[:job][:email]) || User.first)
      params[:job][:user_id] = user.id
    else
      params[:job][:user_id] = current_user.id
      user = current_user
    end
    @job = Job.new(job_params)
    authorize @job

    respond_to do |format|
      if params[:job][:email].blank?
        format.html { render :new, notice: 'Husk din email adresse!' }
      else
        if @job.save
          Message.mail subject: ('Tak fordi du slog jobbet %s op!' % @job.name),
            who: user.email,
            what: job_message,
            jobber: nil,
            job: @job,
            confirm_link: (confirmation_job_url(@job, confirmed_token: '1qaz2wsx3edc') rescue '- bekræftelseslink mangler -'),
            messenger: user || User.first

          format.html { redirect_to @job, notice: 'Job was successfully created.' }
          format.js { render :show, status: :created, location: @job }
          format.json { render :show, status: :created, location: @job }
        else
          format.html { render :new }
          format.js { render :new, status: :unprocessable_entity, location: @job }
          format.json { render json: @job.errors, status: :unprocessable_entity }
        end
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
      @delivery_teams = DeliveryTeam.ancestry_options(DeliveryTeam.unscoped.arrange(:order => 'title')) {|i| "#{'-' * i.depth} #{i.title}" }
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
      authorize @job
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:name, :location, :schedule, :priority, :delegated_at, :jobbers_min, :jobbers_wanted, :jobbers_max, :vacancies, :description, :promote_job_at, :delivery_team_id, :user_id, :email)
    end



    def job_message
      [
        "Tak fordi du har oprettet et job!\n\n",
        "Vi lover at vi skal gøre vort bedste for at finde de arbejdskræfter, I beder om i\n\n",
        "Hvad sker der så herefter?\n\n",
        "Vi arbejder på højtryk for at skabe en god kontakt mellem de, der har lyst at give en hånd med, og dit udvalg.",
        "Din henvendelse er noteret, og når en frivillig henviser til dit job opslag, eller udtrykker ønske om at arbejde med noget, der står omtalt i dit jobopslag,",
        "sender vi dig en email med den frivilliges kontakt oplysninger.\n\n",
        #"Bemærk - det vil lette arbejdet meget for os, hvis du vil have ulejlighed med at acceptere de emails, vi sender med kontaktoplysninger."
        #"Der vil være en knap, der vil sende dig til job.sl2017.dk (job sitet) - så vi kan holde styr på, hvilke frivillige der bliver match'et med et job."
        "Spejderhilsen  \n",
        "Jobcenteret, Spejdernes Lejr 2017\n"
      ].join()
    end

end
