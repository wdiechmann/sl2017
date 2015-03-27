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
      Message.mail subject: 'Vi har gemt din registrering!',
        who: @jobber.email,
        what: m3_message,
        jobber: @jobber,
        job: @jobber.assignments.first,
        delivery_team: nil,
        confirm_link: '',
        messenger: current_user

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
    begin
      if @jobber.jobs.count > 0
        # match jobber with job
        @jobber.update_attributes( next_contact_at: 4.weeks.since)
        Message.mail subject: 'Tak for din bekræftelse!',
          who: @jobber.email,
          what: m4_message,
          jobber: @jobber,
          job: @jobber.jobs.first,
          confirm_link: (confirmation_jobber_url(jobber, confirmed_token: jobber.confirmed_token) rescue '- bekræftelseslink mangler -'),
          messenger: current_user

        Message.mail subject: 'Vi har et match!',
          who: @jobber.jobs.first.user.email,
          what: 'Vi har et match - jobberen hedder {{jobber_name}}. Skriv på adressen {{jobber_email}}.  \n\nStor spejder hilsen  \nJobcenteret Spejdernes Lejr 2017',
          jobber: @jobber,
          job: @jobber.jobs.first,
          confirm_link: '',#(confirmation_jobber_url(jobber, confirmed_token: jobber.confirmed_token) rescue '- bekræftelseslink mangler -'),
          messenger: current_user

      else
        unless @jobber.delivery_team.nil?
          # match jobber with delivery_team
          @jobber.update_attributes( next_contact_at: 4.weeks.since)
          Message.mail subject: 'Tak for din bekræftelse!',
            who:@jobber.email,
            what: m2_message,
            jobber: @jobber,
            job: @jobber.jobs.first,
            delivery_team: @jobber.delivery_team,
            confirm_link: (confirmation_jobber_url(jobber, confirmed_token: jobber.confirmed_token) rescue '- bekræftelseslink mangler -'),
            messenger: current_user


          # Message.mail subject: 'Vi har et match!',
          #   who: @jobber.delivery_team.user.email,
          #   what: 'Vi har et match - jobberen hedder {{jobber_name}}. Skriv på adressen {{jobber_email}}',
          #   jobber: @jobber,
          #   job: @jobber.assignments.first,
          #   confirm_link: '',#(confirmation_jobber_url(jobber, confirmed_token: jobber.confirmed_token) rescue '- bekræftelseslink mangler -'),
          #   messenger: current_user


        else
          Message.create( title: 'Ny bekræftelse!', msg_from: @jobber.email, msg_to: Rails.application.secrets.imap_reply_email, body: '_', messenger: @jobber)
        end
      end
    rescue
      Rails.logger.info "Under bekræftelsen fejlede noget?!? jobber: %s" % @jobber.to_json
    end
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
        Message.mail subject: 'Tak for din registrering!',
          who: @jobber.email,
          what: invite_message,
          jobber: @jobber,
          job: @jobber.assignments.first,
          delivery_team: @jobber.delivery_team,
          confirm_link: (confirmation_jobber_url(@jobber, confirmed_token: @jobber.confirmed_token) rescue '- bekræftelseslink mangler -'),
          current_user: current_user || User.first

        format.html { redirect_to jobbers_url, notice: 'Jobberen blev oprettet korrekt' }
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
        format.html { redirect_to @jobber, notice: 'Jobberen blev opdateret korrekt' }
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


  # jobber invited
  def invite_message
    [
      "Vi er rigtig glade for, at du har vist interesse i Spejdernes Lejr 2017. Vi har brug for rigtig mange frivillige hænder, som allerede nu har mulighed for at være med til at lægge grundstenene til Spejdernes Lejr 2017 i Sønderborg.",
      "\n\n**Husk at bekræfte din registrering**\n\n",
      "\n\nJob-sitet er en åben tilmelding - og derfor er vi nødt til at sikre os, at alle tilmeldinger er _af egen vilje_ (og ikke f.eks. en robot, der står og spytter registreringer i hovedet på os)!",
      "\n\nTryk derfor venligst [på dette link]({{confirm_link}}) - som vil lede dig tilbage til job.sl2017.dk. På forhånd tak for ulejligheden!",
      "\n\nDato: {{jobber_created_at}}  \n",
      "\n\nJobber nr.: {{jobber_id}}\n\n",
      "\n\n{{jobber_name}}  \n{{jobber_street}}  \n{{jobber_city}}",
      "\n\nemail: {{jobber_email}}  \ntlfnr.: {{jobber_phone}}\n",
      "{{job_name_select}}  ",
      "{{delivery_team_select}}  ",
      "\n\n**Hvad sker der så?**\n\n",
      "\n\nVi er i fuld gang med at behandle registreringer - og når du har bekræftet din, vil din registrering også blive behandlet, så hurtigt som vi kan!",
      "\n\n_De fedeste Spejdernes Lejr 2017 hilsener_  \n",
      "{{bruger}}, Jobcenteret SL2017"
    ].join()
  end

  # jobber questioned
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

  # jobber rerouted to delivery team
  def m2_message
    [
      "Super fedt at du gerne vil hjælpe os, med at planlægge Spejdernes Lejr 2017!",
      "\n\nUd fra dine fantastiske kompetencer, har vi videregivet dine kontaktoplysninger til {{udvalg}}. Hvis du ikke hører fra {{udvalg}}, eller hvis I ikke fandt noget du var interesseret i, så er du mere end velkommen til at kontakte os på job@sl2017.dk. Så hjælper vi dig videre til et andet spændende lejrjob!",
      "\n\n_De fedeste Spejdernes Lejr 2017 hilsener_  \n",
      "{{bruger}}, Jobcenteret SL2017"
    ].join()
  end

  # jobber parked
  def m3_message
    [
      "Det er rigtig lækkert at du allerede nu har vist interesse for Spejdernes Lejr 2017. Vi får brug for rigtig mange frivillige på lejren og vi sætter stor pris på din interesse.",
      "\n\nVi er dog ikke på nuværende tidspunkt klar til at matche denne type jobs. Men… vi gemmer dine oplysninger, og så kontakter vi dig igen ca. {{parkeret_dato}}, hvor vi forventer, at planlægningen er kommet så langt, at vi har et fantastisk jobmatch til dig. Du er i mellemtiden velkommen til at holde øje med job.sl2017.dk, hvor der løbende vil blive lagt nye jobs op -  måske kommer der noget som netop passer til dine interesser.",
      "\n\n_De fedeste Spejdernes Lejr 2017 hilsener_  \n",
      "{{bruger}}, Jobcenteret SL2017"
    ].join()
  end

  # jobber picked a job
  def m4_message
    [
      "Tak for din interesse for at være **{{jobnavn}}** på Spejdernes Lejr 2017.",
      "\n\nVi har sendt dine kontaktoplysninger videre til {{kontaktperson}}, som er kontaktperson for denne opgave. Hvis du ikke hører fra {{kontaktperson}}, eller hvis jobbet ikke passede til dig alligevel, så er du velkommen til at kontakte os på job@sl2017.dk, så hjælper vi dig med at finde et andet fantastisk lejrjob!",
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
      params.require(:jobber).permit( :delivery_team_id, :job_name, :job_id, :name, :street, :zip_city, :phone_number, :email, :confirmed_token, :confirmed_at, :jobber_assigned, :next_contact_at, :description, :jobbers_controlled)
    end

end
