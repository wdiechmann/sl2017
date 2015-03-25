class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:create,:format]
  after_action :verify_authorized

  def format

    render inline: RDiscount.new( format_message_body ).to_html
    authorize Message
  end

  # GET /messages
  # GET /messages.json
  def index
    #
    # A big hack - but we have to make sure that there is a job that will process mails
    #
    if Delayed::Job.all.where( 'handler like "%Trawl%"').count < 1
      TrawlMailAccountsJob.new.perform
    end
    if Delayed::Job.all.where( 'handler like "%Watch%"').count < 1
      WatchJobbersJob.new.perform
    end
    #
    messages = Message.arel_table
    jobbers = Jobber.arel_table
    jobber_exp = messages.join(jobbers).on(messages[:msg_from].eq(jobbers[:email]).or(messages[:msg_to].eq(jobbers[:email])))
    unless params[:q].blank?
      query_string = "%#{params[:q]}%"
      @messages = Message.joins(jobber_exp.join_sources).where(messages[:title].matches(query_string).or(messages[:msg_from].matches(query_string)).or(messages[:msg_to].matches(query_string)).or(messages[:body].matches(query_string)).or(jobbers[:name].matches(query_string))).uniq.order(created_at: :desc)
    else
      @messages = params[:all]=='true' ? Message.answered.joins(jobber_exp.join_sources).uniq.order( created_at: :desc) : Message.unseen.joins(jobber_exp.join_sources).uniq.order( created_at: :desc)
    end




    authorize Message
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
    authorize @message
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    #
    # did we suggest a job?
    unless params[:message][:job_offer_id].blank?
      params[:message].delete(:job_offer)
      job = Job.find params[:message].delete(:job_offer_id)
    end
    #
    # keep the original in the reply?
    original = params[:message].delete(:original)
    original_id=params[:message].delete(:original_id)

    #
    # mark the original as answered
    msg = Message.find(original_id) rescue nil

    body = msg.body rescue ""
    #
    # format the message
    #
    text_body = format_message_body
    params[:message][:body] = (RDiscount.new( text_body ).to_html + '<br/><br/>' + body).html_safe
    msg.update_attributes( answered_at: Time.now, body: body) unless msg.nil?

    params[:message][:msg_from] = Rails.application.secrets.imap_user_name
    #
    # attach the message to the current_user
    message = Message.new(message_params)
    message.messenger = current_user
    authorize message

    respond_to do |format|
      if message.save
        #
        # attach it all to the jobber
        jobber = Jobber.find_by_email(params[:message][:msg_to].strip)
        assignment = nil
        if jobber && job
          assignment = Assignment.create( job: job, jobber: jobber, assignee: current_user, assigned_at: Time.now)
        end
        #
        # tell the jobber all about it
        MessageMailer.message_email(message,text_body).deliver_later
        format.html { redirect_to root_path, notice: 'Message was successfully created, and sent.' }
        format.js { head 220 }
        format.json { render :show, status: :created, location: message }
      else
        format.html { render :new }
        format.js { render json: message.errors, status: :unprocessable_entity }
        format.json { render json: message.errors, status: :unprocessable_entity }
      end
    end
  end
  #
  # def create
  #   @message = Message.new(message_params)
  #
  #   respond_to do |format|
  #     if @message.save
  #       format.html { redirect_to @message, notice: 'Message was successfully created.' }
  #       format.json { render :show, status: :created, location: @message }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @message.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy

    result = true if @message.destroy
    result ? (flash.now[:info] = "Dialogen blev slettet korrekt!") : (flash.now[:error] = "Dialogen blev ikke slettet korrekt!" )
    if result==true
      render layout:false, status: 200, locals: { result: true }
    else
      render layout:false, status: 301, locals: { result: true }
    end
  rescue
    (flash.now[:error] = "Der opstod en fejl - og dialogen blev ikke slettet!")
    render layout:false, status: 401, locals: { result: false }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
      authorize @message
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:title, :msg_from, :msg_to, :body, :answered_at, :messenger_id, :messenger_type)
    end

    class MessageVars
      attr_accessor :navn, :bruger, :udvalg, :parkeret_dato, :jobnavn, :kontaktperson
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
