module EmployeesHelper
  
  def show_last_date employee
    return '' if employee.last_seen.blank?
    employee.last_seen.strftime '%d/%m/%Y'
  end
  
  def show_last_time employee
    return '' if employee.last_seen.blank?
    employee.last_seen.strftime '%H:%M'
  end
  
end
