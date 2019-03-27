module EmailUtils
  include Gmail

  def send_test_email(gmail)
    email = gmail.compose do
      to 'merklensqa@gmail.com'
      subject 'Test email!'
      body 'Test email sent from Automation Project'
    end
    email.deliver!
  end

  def connect_to_email(username, secret_password)
    Gmail.connect(username, secret_password)
  end

  def retrieve_email(gmail, trigger, code)
    gmail.inbox.find(from: "merklensqa@gmail.com", subject: trigger + ' ' + code)
  end

  def search_email(gmail, trigger, code, search_retry = 120, body = '')
    print '  --> Waiting until ' + trigger.gsub('_', ' ').split.map(&:capitalize).join(' ') + ' email arrives into customer inbox'
    while retrieve_email(gmail, trigger, code).any? == false and search_retry > 0 do
      print "."
      sleep 1
      search_retry -= 1
    end
    if retrieve_email(gmail, trigger, code).any?
      print '. Found!'
      email = retrieve_email(gmail, trigger, code).first
      mark_as_read email
    end
    puts ''
    retrieve_email(gmail, trigger, code).any?
  end

  def delete_all_emails(gmail)
    gmail.inbox.find(:unread).each(&:read!)
    gmail.inbox.find(:read).each(&:delete!)
  end

  def logout_from_email(gmail)
    gmail.logout
  end

  def mark_as_read(email_element)
    email_element.read!
  end

  def mark_all_emails_as_read(gmail)
    gmail.inbox.find(:unread).each(&:read!)
  end
end



# email.each do |key|
#   puts key
# end

# email.each do |key, value|
#   puts key.to_s + ' : ' + value
# end

# Email structure sample
# #<struct Net::IMAP::Envelope
#     date="Thu, 14 Mar 2019 15:36:41 +0000 (UTC)",
#     subject="Purchase",
#     from=[#<struct Net::IMAP::Address
#         name="Nearsoft Automation",
#         route=nil,
#         mailbox="merklensqa",
#         host="gmail.com">],
#     sender=[#<struct Net::IMAP::Address
#         name="Nearsoft Automation",
#         route=nil,
#         mailbox="merklensqa",
#         host="gmail.com">],
#     reply_to=[#<struct Net::IMAP::Address
#         name="Nearsoft Automation",
#         route=nil,
#         mailbox="merklensqa",
#         host="gmail.com">],
#     to=[#<struct Net::IMAP::Address
#         name=nil,
#         route=nil,
#         mailbox="merklensqa+n1",
#         host="gmail.com">],
#     cc=nil,
#     bcc=nil,
#     in_reply_to=nil,
#     message_id="<5c8a750925783_55e1e930a417746@ip-172-33-6-150.mail>">