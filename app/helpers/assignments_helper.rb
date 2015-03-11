module AssignmentsHelper
  def show_assignment_status assignment
    status = case assignment.status
    when JOBBER_OK; 'er blevet godkendt af jobberen'
    when JOBBER_DECLINE; 'er ikke blevet godkendt af jobberen'
    when DT_OK; 'er blevet godkendt af udvalget'
    when DT_DECLINE; 'er ikke blevet godkendt af udvalget'
    when JOBBER_OK+DT_OK; 'er blevet godkendt af både jobberen og udvalget'
    when JOBBER_OK+DT_DECLINE; 'er blevet godkendt af jobberen men ikke af udvalget'
    when JOBBER_DECLINE+DT_DECLINE; 'er hverken blevet godkendt af jobberen eller udvalget'
    else; 'afventer jobberen og udvalget'
    end
    status
  end
end
