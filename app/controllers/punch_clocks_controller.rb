class PunchClocksController < ApplicationController
  before_action :set_punch_clock, only: [:show, :edit, :update, :destroy]

  # GET /punch_clocks
  # GET /punch_clocks.json
  def index
    @punch_clocks = current_user.account.punch_clocks
  end

  # GET /punch_clocks/1
  # GET /punch_clocks/1.json
  def show
  end

  # GET /punch_clocks/new
  def new
    @punch_clock = PunchClock.new
  end

  # GET /punch_clocks/1/edit
  def edit
  end

  # POST /punch_clocks
  # POST /punch_clocks.json
  def create
    @punch_clock = PunchClock.new(punch_clock_params)

    respond_to do |format|
      if @punch_clock.save
        format.html { redirect_to @punch_clock, notice: t('punch_clocks.created_ok')}
        format.json { render :show, status: :created, location: @punch_clock }
      else
        format.html { render :new }
        format.json { render json: @punch_clock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /punch_clocks/1
  # PATCH/PUT /punch_clocks/1.json
  def update
    respond_to do |format|
      if @punch_clock.update(punch_clock_params)
        format.html { redirect_to @punch_clock, notice: t('punch_clocks.updated_ok') }
        format.js   { head :no_content }
        format.json { render :show, status: :ok, location: @punch_clock }
      else
        format.html { render :edit }
        format.json { render json: @punch_clock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /punch_clocks/1
  # DELETE /punch_clocks/1.json
  def destroy
    @punch_clock.destroy
    respond_to do |format|
      format.html { redirect_to punch_clocks_url, notice: t('punch_clocks.deleted_ok') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_punch_clock
      @punch_clock = PunchClock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def punch_clock_params
      return PunchClock.find(params[:id]).attributes if params[:punch_clock].nil? and cookies.permanent.signed[:punch_clock]=params[:id]
      params[:punch_clock][:account_id]=current_user.account.id
      params.require(:punch_clock).permit(:account_id, :name)
    end
end
