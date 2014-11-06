class JobbersController < ApplicationController
  before_action :set_jobber, only: [:show, :edit, :update, :destroy, :confirmation]

  # GET /jobbers
  # GET /jobbers.json
  def index
    @jobbers = Jobber.all
  end
  
  def confirmation
    notice = @jobber.confirmed?(params) ?  'Din tilmelding er nu bekræftet - og vi vil kontakte dig hurtigst muligt' : 'Din tilmelding er ikke bekræftet'
    respond_to do |format|
      format.html { redirect_to root_path, notice: notice}
    end
  end

  # GET /jobbers/1
  # GET /jobbers/1.json
  def show
  end

  # GET /jobbers/new
  def new
    @jobber = Jobber.new
  end

  # GET /jobbers/1/edit
  def edit
  end

  # POST /jobbers
  # POST /jobbers.json
  def create
    @jobber = Jobber.new(jobber_params)
    @jobber.confirmed_token = Devise.friendly_token
    # raw, enc = Devise.token_generator.generate(self.class, :confirmation_token)
    # @raw_confirmation_token   = raw
    # self.confirmation_token   = enc
    # self.confirmation_sent_at = Time.now.utc


    respond_to do |format|
      if @jobber.save
        JobberMailer.welcome_email(@jobber,current_user).deliver
        format.html { redirect_to @jobber, notice: 'Jobber was successfully created.' }
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
        format.json { render :show, status: :ok, location: @jobber }
      else
        format.html { render :edit }
        format.json { render json: @jobber.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobbers/1
  # DELETE /jobbers/1.json
  def destroy
    @jobber.destroy
    respond_to do |format|
      format.html { redirect_to jobbers_url, notice: 'Jobber was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jobber
      @jobber = Jobber.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # "name"=>"navn", "street"=>"adresse", "zip_city"=>"postnr by", "phone_number"=>"12345678", "email"=>"e@a.dk
    def jobber_params
      params.require(:jobber).permit(:name, :street, :zip_city, :phone_number, :email, :confirmed_token, :confirmed_at)
    end
end
