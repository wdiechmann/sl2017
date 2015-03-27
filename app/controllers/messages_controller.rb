class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:create,:format]
  after_action :verify_authorized

  def format
    options = { subject: params[:message][:title],
      who: params[:message][:msg_to],
      what: params[:message][:body],
      jobber: (Jobber.find_by_email(params[:message][:msg_to].strip) rescue nil),
      job: (Job.find( params[:message].delete(:job_offer_id)) rescue nil),
      delivery_team: (DeliveryTeam.find( params[:message].delete(:delivery_team_offer_id)) rescue nil),
      confirm_link: ' ',
      messenger: current_user
    }
    render inline: RDiscount.new( Message.format_message_body options ).to_html
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
    # did we suggest a delivery team
    unless params[:message][:delivery_team_offer_id].blank?
      params[:message].delete(:delivery_team_offer)
      delivery_team = DeliveryTeam.find( params[:message].delete(:delivery_team_offer_id) )
    end

    jobber = Jobber.find_by_email(params[:message][:msg_to].strip)
    #
    # attach it all to the jobber
    assignment = nil
    if jobber
      assignment = Assignment.create( job: job, jobber: jobber, assignee: current_user, assigned_at: Time.now) if job
      jobber.update_attributes( delivery_team: delivery_team) if delivery_team
    end

    #
    # keep the original in the reply?
    original = params[:message].delete(:original)
    original_id=params[:message].delete(:original_id)

    #
    # mark the original as answered
    msg = Message.find(original_id) rescue nil
    msg.update_attributes( answered_at: Time.now) unless msg.nil?

    body = msg.body rescue ""

    authorize Message.new

    message = Message.mail subject: params[:message][:title],
      who: params[:message][:msg_to],
      what: params[:message][:body],
      # what: "%s ||| %s" % [ params[:message][:body],body ],
      jobber:jobber,
      job: job,
      delivery_team: delivery_team,
      confirm_link: ' ',
      messenger: current_user

    respond_to do |format|
      if message
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

end
