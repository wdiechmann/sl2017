class Message < ActiveRecord::Base
	has_paper_trail

	belongs_to :messenger, polymorphic: true

	validates :title,  presence: true
	# validates :msg_to, presence: true
	validates :body,  presence: true

	scope :unseen, ->() { where(["answered_at is null and msg_from is not null and msg_from <> '%s'", Rails.application.secrets.imap_user_name])}
	scope :answered, ->() { where(['answered_at is not null and msg_from is not null'])}


	def self.mail options={}
		text_body = Message.format_message_body options
		who = options.delete(:who)
		subject = options.delete(:subject)
		html_body = RDiscount.new( text_body.split(' ||| ')[0] ).to_html + text_body.split(' ||| ')[1].to_s
		message=Message.create( title: subject, msg_to: who, msg_from: Rails.application.secrets.imap_reply_email, body: html_body, messenger: options[:messenger])
		MessageMailer.message_email(message,text_body).deliver#_later
		self
	rescue
		false
	end

  class MessageVars
    attr_accessor :navn,
			:bruger,
			:udvalg,
			:parkeret_dato,
			:jobnavn,
			:kontaktperson,
			:confirm_link,
			:jobber_created_at,
			:jobber_phone,
			:jobber_email,
			:jobber_city,
			:jobber_street,
			:jobber_id,
			:jobber_name,
			:job_name_select,
			:delivery_team_select
  end
  #
  # - (@message.body.gsub!(/{{jobbet}}/,@job.name) unless @job.nil?) rescue nil
  # {{navn}}
  # {{bruger}}
  # {{udvalg}}
  # {{parkeret_dato}}
  # {{jobnavn}}
  # {{kontaktperson}}
  # {{confirm_link}}
	# {{jobber_name}}
	# {{jobber_street}}
	# {{jobber_city}}
	# {{jobber_email}}
	# {{jobber_phone}}
	# {{jobber_id}}
	# {{jobber_created_at}}
	# {{job_name_select}}
	# {{delivery_team_select}}
  #
  def self.format_message_body options
		job = options.delete(:job)
		jobber = options.delete(:jobber)
		current_user = options[:messenger]
		delivery_team = options.delete(:delivery_team)
    vars = MessageVars.new
    vars.navn = jobber.name rescue '- dit navn mangler -'
    vars.bruger = current_user.name rescue '- os i - '
    vars.udvalg = ((job.nil? || job.delivery_team.nil?) ? delivery_team.title : job.delivery_team.title) rescue '- udvalgets navn mangler -'
    vars.parkeret_dato = jobber.next_contact_at.strftime( "%d/%m/%Y") rescue '- datoen blev ikke fundet -'
    vars.jobnavn = job.name rescue '- navnet på jobbet mangler -'
    vars.kontaktperson = job.user.name rescue '- navnet på kontaktpersonen mangler -'
    vars.confirm_link = options.delete(:confirm_link)
		vars.jobber_name = jobber.name rescue ''
		vars.jobber_street = jobber.street rescue ''
		vars.jobber_city = jobber.zip_city rescue ''
		vars.jobber_email = jobber.email rescue ''
		vars.jobber_phone = jobber.phone rescue ''
		vars.jobber_id = jobber.id rescue ''
		vars.jobber_created_at = jobber.created_at.localtime.strftime("%d/%m/%Y %H:%M") rescue ''
		vars.job_name_select = (jobber.assignments.count < 1 ? '' : "\nVi har noteret os at du gerne vil kontaktes omkring jobbet %s \n" % jobber.jobs.first.name) rescue ''
		vars.delivery_team_select = (delivery_team.nil? ? '' : "\nVi har noteret os at du gerne hjælpe til i udvalget %s  \n" % delivery_team.title) rescue ''

    bodies = options.delete(:what).split(' ||| ')
    [ 'navn', 'bruger', 'udvalg',
			'parkeret_dato', 'jobnavn',
			'kontaktperson', 'confirm_link', 'jobber_created_at',
			'jobber_phone', 'jobber_email', 'jobber_city',
			'jobber_street', 'jobber_id', 'jobber_name','job_name_select', 'delivery_team_select'].each do |key|
      value = vars.send( key.to_s) rescue '--'
      bodies[0].gsub! /{{#{key}}}/, value.to_s
    end

    bodies.join(' ||| ')

  end

end
