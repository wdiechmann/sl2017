# encoding: UTF-8
require 'net/imap'
#
# the trawler will collect all emails (via IMAP)
# store them in the messages table
# and move them from INBOX to ARCHIVE in the mailbox
#
# when working with Exchange Servers:
# http://www.semicomplete.com/blog/geekery/ruby-net-imap-and-exchange.html
#
# Learned the 'PLAIN' expected format from imapsync.
class PlainAuthenticator
  def process(data)
    # Net::IMAP takes care of base64 encoding the result of this...
    return "#{@user}\0#{@user}\0#{@password}"
  end

  def initialize(user, password)
    @user = user
    @password = password
  end
end

Net::IMAP::add_authenticator('PLAIN', PlainAuthenticator)


# Copied/modified from net/imap.rb, don't modify that file, put this
# in your own code to override the continue_req method
module Net
  class IMAP
    class ResponseParser
      def continue_req
        match(T_PLUS)
        #match(T_SPACE)   # Comment this line out to not expect a space.
        return ContinuationRequest.new(resp_text, @str)
      end
    end
  end
end




class TrawlMailAccountsJob < ActiveJob::Base
  queue_as :default

  ROUNDTRIP=3.minutes

  def cached_addresses
    @addresses = {}
    Jobber.pluck(:id,:name,:email).map {|j| j[3]='Jobber';@addresses["#{j[2] rescue ''}"] = j  }
    User.pluck(:id,:name,:email).map {|j| j[3]='User';@addresses["#{j[2] rescue ''}"] = j  }
    @addresses
  end

  def from_addressee email
    @addresses[email]
  rescue
    nil
  end


  def perform(*args)

    if Rails.application.secrets.imap_mail_server=='pbox.dk'
      imap = Net::IMAP.new(Rails.application.secrets.imap_mail_server)
      imap.authenticate('LOGIN', Rails.application.secrets.imap_user_name, Rails.application.secrets.imap_user_password)
    else
      imap = Net::IMAP.new(Rails.application.secrets.imap_mail_server, "imaps", usessl=true)  # Exchange requires this
      imap.authenticate('PLAIN', Rails.application.secrets.imap_user_name, Rails.application.secrets.imap_user_password)
    end

    imap.select(Rails.application.secrets.imap_source_mailbox)

    cached_addresses

    imap.search(["ALL"]).each do |message_id|
      msg = imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
      mail = Mail.read_from_string(msg)
      next if mail.multipart? && mail.html_part.nil? && mail.text_part.nil?
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
      body = email.multipart? ? (email.html_part.body || email.text_part.body) : email.body
      # body.raw_source.gsub!( /\=0A\=/,'')
      body.raw_source.gsub!(/http\:\/\/mandrillapp.com\/track\/open.php/, '')
      messenger = from_addressee email.from[0]
      entity = messenger[3].constantize.find(messenger[0]) rescue nil
      Message.create(  title: email.subject, msg_from: email.from.join(","), msg_to: email.to.join(","), body: body, messenger: entity )
    rescue
      Message.mail subject: 'missed a message',
        job: nil,
        jobber: nil,
        what: 'a message saying: "%s" from %s was missed' % [ email.subject, email.from.join(',') ],
        who: 'walther@alco.dk',
        messenger: User.first

    end
  end
end
