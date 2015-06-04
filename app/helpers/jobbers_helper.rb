module JobbersHelper
  def parent?
    !parent.nil?
  end

  def parent
    Job.find(params[:job_id])
  rescue
    nil
  end
end
