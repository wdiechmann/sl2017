module JobsHelper
  def display_job_jobbers job
    jobbers = []
    job.current_jobbers.each do |jobber|
      jobbers << link_to( jobber.name, jobber_url(jobber))
    end
    jobbers
  end

  def badge job
    link_to 'jobbers', job_jobbers_url(job)
  end
end
