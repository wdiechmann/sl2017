class DeliveryTeamsController < ApplicationController
  before_action :set_delivery_team, only: [:show, :edit, :update, :destroy]

  respond_to :html, :js, :json

  def index
    unless params[:q].nil?
      dts = DeliveryTeam.arel_table
      query_string = "%#{params[:q]}%"
      @delivery_teams = DeliveryTeam.all.where(dts[:title].matches(query_string).or(dts[:description].matches(query_string))).order(:title)
    else
      @delivery_teams = DeliveryTeam.all.order(:title)
    end

    @delivery_teams = DeliveryTeam.sort_by_ancestry( @delivery_teams )

    authorize DeliveryTeam

    respond_with(@delivery_teams)
  end

  def show
    respond_with(@delivery_team)
  end

  def new
    @delivery_team = DeliveryTeam.new(parent_id: params[:parent_id])
    respond_with(@delivery_team)
  end

  def edit
  end

  def create
    @delivery_team = DeliveryTeam.new(delivery_team_params)
    @delivery_team.save
    respond_with(@delivery_team)
  end

  def update
    @delivery_team.update(delivery_team_params)
    respond_with(@delivery_team)
  end

  def destroy
    result = true if @delivery_team.destroy
    result ? (flash.now[:info] = "Udvalget blev slettet korrekt") : (flash.now[:error] = "Udvalget blev ikke slettet korrekt" )
    if result==true
      render layout:false, status: 200, locals: { result: true }
    else
      render layout:false, status: 301, locals: { result: true }
    end
  rescue
    (flash.now[:error] = "Der opstod en andenfejl - og udvalget blev ikke slettet korrekt")
    render layout:false, status: 401, locals: { result: false }
  end

  private
    def set_delivery_team
      @delivery_team = DeliveryTeam.find(params[:id])
    end

    def delivery_team_params
      params.require(:delivery_team).permit(:title, :ancestry, :description, :parent_id, :responsible_jobbers)
    end
end
