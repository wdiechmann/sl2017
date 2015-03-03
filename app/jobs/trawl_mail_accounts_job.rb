class TrawlMailAccountsJob < ActiveJob::Base
  queue_as :default

  SERVER='pbox.dk'
  USER='sl2017@alco.dk'
  PASSWORD='sl2017!job'
  ROUNDTRIP=3.minutes

  def perform(*args)
    mbox = Postman::Imap.new server:SERVER, user:USER, password:PASSWORD
    mbox.each_message do |msg|
      Message.create  title: msg.subject,
        name: '',
        street: '',
        zip_city: '',
        email: '',
        msg_from: msg.from.join(","),
        msg_to: msg.to.join(","),
        body: msg.body
    end
    TrawlMailAccountsJob.set(wait: ROUNDTRIP).perform_later
  end
end
