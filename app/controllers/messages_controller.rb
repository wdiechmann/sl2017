class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:create,:format]
  after_action :verify_authorized

  def format
    render inline: RDiscount.new( params[:message][:body]).to_html
    authorize Message
  end

  # GET /messages
  # GET /messages.json
  def index
    @messages = params[:all]=='true' ? Message.answered.order( created_at: :desc) : Message.unseen.order( created_at: :desc)
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
    unless params[:message][:job_offer_id].nil?
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
    msg.update_attributes( answered_at: Time.now) unless msg.nil?
    #
    # format the message
    unless original.nil?
      params[:message][:body] = (RDiscount.new(params[:message][:body]).to_html + '<br/><br/>' + msg.body).html_safe
    else
      params[:message][:body] = RDiscount.new(params[:message][:body]).to_html
    end

    params[:message][:msg_from] = Rails.application.secrets.imap_user_name
    message = Message.new(message_params)
    authorize message

    respond_to do |format|
      if message.save
        #
        # attach it all to the jobber
        jobber = Jobber.find_by_email(params[:message][:msg_to].strip)
        if jobber && job
          Assignment.create( job: job, jobber: jobber, assignee: current_user, assigned_at: Time.now)
        end
        #
        # tell the jobber all about it
        MessageMailer.message_email(message,jobber,job).deliver_later
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
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
      authorize @message
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:title, :msg_from, :msg_to, :body, :answered_at)
    end
end
