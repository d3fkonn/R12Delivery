class EmployeesController < ApplicationController
  before_action only: [:show, :edit, :update, :destroy]

  def index
    @employees = Employee.all  
  end

  def create
    @employee = Employee.new(employee_params)

    if @employee.save
        redirect_to employees_path, notice: "Employee was successfully created."
    else
        render :new
    end
  end

  def new
    @employee = Employee.new
  end

  private

  def employee_params
    params.require(:employee).permit(:phone, :email, :user_id, :address_id)
  end
end
