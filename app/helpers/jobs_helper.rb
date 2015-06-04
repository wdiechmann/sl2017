module JobsHelper
  def display_job_jobbers job
    jobbers = []
    job.current_jobbers.each do |jobber|
      jobbers << link_to( jobber.name, jobber_url(jobber))
    end
    jobbers
  end

  # <span class="badge">14</span>
  def badge job
    txt = "<span class='badge sl2017color darken-2'>%i / %i</span>" % [ job.current_jobbers.count, job.jobbers_wanted]
    link_to txt.html_safe, job_jobbers_url(job)
  end

  def aged_class cls
    return "danger list-group-item-danger" if cls.created_at < 4.weeks.ago
  end
end
