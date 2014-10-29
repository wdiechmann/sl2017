class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy, :last_seen]
  # before_filter :authenticate_user!
  # after_action :verify_authorized


  # GET /employees/1/last_seen
  def last_seen
    entrance = Entrance.create( employee: @employee, clocked_at: DateTime.parse(params[:at]))
    @employee.update_attributes( last_seen: entrance.clocked_at)
    head(:ok) and return if entrance
    head(404)
  end

  # GET /employees
  # GET /employees.json
  def index
    if params[:format]=='js'
      if cookies.permanent.signed[:punch_clock].nil? || PunchClock.where(id: cookies.permanent.signed[:punch_clock]).empty?
        @employees = []
      else
        @employees = PunchClock.find(cookies.permanent.signed[:punch_clock]).employees
      end
    else
      @employees = params[:punch_clock_id].nil? ? current_user.account.employees : PunchClock.find(params[:punch_clock_id]).employees
    end

    respond_to do |format|
      format.html # {}
      format.js
    end
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.js   { head :no_content }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params[:employee][:account_id]=current_user.account.id
      params.require(:employee).permit(:name, :punch_clock_id,:account_id)
    end
end
