class JobbersController < ApplicationController
  before_action :set_jobber, only: [:show, :edit, :update, :destroy, :confirmation, :park]
  before_filter :authenticate_user!, except: [:create, :confirmation]
  after_action :verify_authorized


  # GET /jobbers
  # GET /jobbers.json
  def index
    unless params[:q].nil?
      jobbers = Jobber.arel_table
      query_string = "%#{params[:q]}%"
      @jobbers = Jobber.vacant.where(jobbers[:name].matches(query_string).or(jobbers[:street].matches(query_string)).or(jobbers[:zip_city].matches(query_string)).or(jobbers[:email].matches(query_string)).or(jobbers[:phone_number].matches(query_string))).order(created_at: :desc)
    else
      @jobbers = params[:job_id].blank? ? Jobber.vacant.order(created_at: :desc) : Job.find(params[:job_id]).jobbers.order(created_at: :desc)
    end
    authorize Jobber
  end

  def park
    if @jobber && current_user
      @jobber.update_attributes( next_contact_at: params[:until_at])
      # RDiscount.new( format_message_body ).to_html
      # message = Message.create( title: 'Velkommen!', msg_from: @jobber.email, msg_to: Rails.application.secrets.imap_reply_email, body: 'Du har lige registreret dig - det er super!')
      # MessageMailer.message_email(message,jobber,job, assignment).deliver_later
      respond_to do |format|
        format.html { head 200 }
      end
    end
  end


  # now the jobber has confirmed - then what?
  #
  # 1 - if the jobber has requested a specific job - send him off to the job contact
  # 2 - if the jobber has requested a delivery team - send him off to that team
  # otherwise - introduce a message on the VJC dialogue dashboard
  #
  def confirmation
    Message.create( title: 'Velkommen!', msg_from: @jobber.email, msg_to: Rails.application.secrets.imap_reply_email, body: 'Du har lige registreret dig - det er super!')
    if current_user
      @jobber.confirm!
      respond_to do |format|
        format.html { render layout: false }
      end
    else
      notice = @jobber.confirmed?(params) ?  'Din tilmelding er nu bekræftet - og vi vil kontakte dig hurtigst muligt' : 'Din tilmelding er ikke bekræftet'
      respond_to do |format|
        format.html { redirect_to root_path, notice: notice}
      end
    end
  end

  # GET /jobbers/1
  # GET /jobbers/1.json
  def show
    body = RDiscount.new( m1_message ).to_html
    message=Message.create( title: 'Velkommen!', msg_to: @jobber.email, msg_from: Rails.application.secrets.imap_reply_email, body: body)
    JobberMailer.first_email(message,m1_message).deliver
    respond_to do |format|
      format.html { render layout: false }
      format.json
    end
  end

  # GET /jobbers/new
  def new
    @jobber = Jobber.new
    authorize @jobber
  end

  # GET /jobbers/1/edit
  def edit
  end

  # POST /jobbers
  # POST /jobbers.json
  def create
    @jobber = Jobber.new(jobber_params)
    authorize @jobber
    @jobber.confirmed_token = Devise.friendly_token
    # raw, enc = Devise.token_generator.generate(self.class, :confirmation_token)
    # @raw_confirmation_token   = raw
    # self.confirmation_token   = enc
    # self.confirmation_sent_at = Time.now.utc


    respond_to do |format|
      if @jobber.save
        @jobber.assign_job (current_user||@jobber)
        JobberMailer.welcome_email(@jobber,current_user).deliver_later
        format.html { redirect_to jobbers_url, notice: 'Jobber was successfully created.' }
        format.js { head 220 }
        format.json { render :show, status: :created, location: @jobber }
      else
        format.html { render :new }
        format.js { head 404 }
        format.json { render json: @jobber.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobbers/1
  # PATCH/PUT /jobbers/1.json
  def update
    respond_to do |format|
      if @jobber.update(jobber_params)
        format.html { redirect_to @jobber, notice: 'Jobber was successfully updated.' }
        format.js   { head 220 }
        format.json { render :show, status: :ok, location: @jobber }
      else
        format.html { render :edit }
        format.js   { render layout: false }
        format.json { render json: @jobber.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobbers/1
  # DELETE /jobbers/1.json
  def destroy
    result = true if @jobber.destroy
    result ? (flash.now[:info] = "Jobberen blev slettet korrekt") : (flash.now[:error] = "Jobberen blev ikke slettet korrekt" )
    if result==true
      render layout:false, status: 200, locals: { result: true }
    else
      render layout:false, status: 301, locals: { result: true }
    end
  rescue
    (flash.now[:error] = "Der opstod en andenfejl - og Jobberen blev ikke slettet korrekt")
    render layout:false, status: 401, locals: { result: false }
  end





  def m1_message
    [
      "Vi er rigtig glade for, at du har vist interesse i Spejdernes Lejr 2017. Vi har brug for rigtig mange frivillige hænder, som allerede nu har mulighed for at være med til at lægge grundstenene til Spejdernes Lejr 2017 i Sønderborg.",
      "\n\n**Vil du planlægge nu?**\n\n",
      "\n\nHvis du allerede nu brænder for, at være med til at planlægge lejren, så er nu det rigtige tidspunkt at melde sig på. Mange hovedudvalg er lige nu ved, at finde personer til de forskellige underudvalg, og står måske lige nu og mangler netop dig!",
      "\n\nHvis du gerne vil være med til at planlægge lejren allerede nu, men der ikke er et specifikt job på netop dit ønske, så vil vi rigtig gerne høre lidt mere om dig.  Så vil vi nemlig prøve, at matche dig med et udvalg som har behov for netop dine kompetencer.",
      "\n\n**Vil du hjælpe på lejren?**\n\n",
      "\n\nVi er ikke begyndt, at slå jobs op på selve lejren endnu. Så hvis du først ønsker, at hjælpe med noget på selve lejren i Sønderborg i 2017, så gemmer vi dine oplysninger og kontakter dig når vi kommer lidt nærmere lejren. Her får vi helt sikkert behov for netop din kompetencer!",
      "\n\n_De fedeste Spejdernes Lejr 2017 hilsener_  \n",
      "{{bruger}}, Jobcenteret SL2017"
    ].join()
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jobber
      @jobber = Jobber.find(params[:id])
      authorize @jobber
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # "name"=>"navn", "street"=>"adresse", "zip_city"=>"postnr by", "phone_number"=>"12345678", "email"=>"e@a.dk
    def jobber_params
      params.require(:jobber).permit(:job_name, :job_id, :name, :street, :zip_city, :phone_number, :email, :confirmed_token, :confirmed_at, :jobber_assigned, :next_contact_at, :description, :jobbers_controlled)
    end

    #
    # - (@message.body.gsub!(/{{jobbet}}/,@job.name) unless @job.nil?) rescue nil
    # {{navn}}
    # {{bruger}}
    # {{udvalg}}
    # {{parkeret_dato}}
    # {{jobnavn}}
    # {{kontaktperson}}
    #
    #
    def format_message_body

      unless params[:message][:job_offer_id].blank?
        job = Job.find params[:message].delete(:job_offer_id) rescue nil
      end
      jobber = Jobber.find_by_email(params[:message][:msg_to].strip) rescue nil

      vars = MessageVars.new
      vars.navn = jobber.name rescue '- dit navn mangler -'
      vars.bruger = current_user.name rescue '- brugerens navn mangler -'
      vars.udvalg = job.delivery_team.title rescue '- udvalgets navn mangler -'
      vars.parkeret_dato = jobber.next_contact_at.strftime( "%d/%m/%Y") rescue '- datoen blev ikke fundet -'
      vars.jobnavn = job.name rescue '- navnet på jobbet mangler -'
      vars.kontaktperson = job.user.name rescue '- navnet på kontaktpersonen mangler -'

      body = params[:message][:body]
      ['navn', 'bruger', 'udvalg', 'parkeret_dato', 'jobnavn', 'kontaktperson'].each do |key|
        value = vars.send( key.to_s) rescue '--'
        body.gsub! /{{#{key}}}/, value
      end

      body

    end





end
