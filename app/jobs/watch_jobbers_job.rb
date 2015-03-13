# encoding: UTF-8
require 'net/imap'
#
# the trawler will collect all emails (via IMAP)
# store them in the messages table
# and move them from INBOX to ARCHIVE in the mailbox
#
class WatchJobbersJob < ActiveJob::Base
  queue_as :default

  ROUNDTRIP=1.day

  def perform(*args)
    WatchJobbersJob.set(wait: ROUNDTRIP).perform_later
  end

end
