# encoding: UTF-8
require 'net/imap'
#
# the trawler will collect all emails (via IMAP)
# store them in the messages table
# and move them from INBOX to ARCHIVE in the mailbox
#
class TrawlMailAccountsJob < ActiveJob::Base
  queue_as :default

  ROUNDTRIP=3.minutes

  def perform(*args)

    imap = Net::IMAP.new(Rails.application.secrets.imap_mail_server)
    imap.authenticate('LOGIN', Rails.application.secrets.imap_user_name, Rails.application.secrets.imap_user_password)
    imap.select(Rails.application.secrets.imap_source_mailbox)

    imap.search(["ALL"]).each do |message_id|
      msg = imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
      mail = Mail.read_from_string(msg)
      next if mail.html_part.nil? || mail.text_part.nil?
      parse mail
      imap.copy(message_id, Rails.application.secrets.imap_archive_mailbox)
      imap.store(message_id, "+FLAGS", [:Deleted])
    end

    imap.expunge
    imap.logout
    imap.disconnect

    TrawlMailAccountsJob.set(wait: ROUNDTRIP).perform_later
  end

  def parse email
    begin
      body = email.html_part.body || email.text_part.body
      body = body.force_encoding("UTF-8")
      Message.create(  title: email.subject,
        msg_from: email.from.join(","),
        msg_to: email.to.join(","),
        body: body.to_s)
    rescue
      logger.info 'missed a message %s' % email.subject
    end
  end
end
