require './spec/spec_helper'

describe 'Emails Module' do
  include VerificationHelpers
  include EmailUtils
  include LoginPage
  include AdminPage
  include LandingPage
  include EmailsPage

  let(:user) { GetData.get_user('automation_user') }
  let(:account) { GetData.get_account('automation_account') }
  let(:automation_email_account) { GetData.get_account('automation_email_account') }

  before(:all) do
    @email_name = 'Auto_email_' + Time.now.to_i.to_s
  end

  before(:each) do
    visit '/'
    login(user[:username], user[:password])
    find_account(account[:number])
    navigate_account
    navigate_account_emails
    @gmail = Gmail.connect(automation_email_account[:email], automation_email_account[:secret_password])
  end

  it 'should connect to gmail' do
    # gmail = Gmail.connect('merkleuser1@gmail.com', 'mwbjjblblsiorxlc')
    gmail = Gmail.connect('merklensqa@gmail.com', 'ecppoxbhvciohhng')
    # play with your gmail...
    # puts 'Gmail messages: ' + gmail.inbox.count(:unread).to_s
    # clear_all_unread_emails gmail
    # puts 'Gmail messages after clear: ' + gmail.inbox.count(:unread).to_s
    # delete_all_automation_emails gmail
    # send_test_email gmail
    delete_all_emails gmail
    gmail.logout
  end

  it 'should add a new email' do
    add_trigger_email @email_name, 'purchase'
    verify_email_exist @email_name
  end

  it 'should disable an email' do
    open_email @email_name
    pause_email
    verify_email_exist(@email_name, true)
  end

  it 'should enable an email' do
    open_email @email_name, true
    activate_email
  end

  it 'should modify the email subject' do
    modify_email_subject @email_name, 'Purchase Updated'
    verify_email_subject 'Purchase Updated'
  end

  it 'should delete an email' do
    verify_email_exist @email_name
    open_email @email_name
    delete_email
    verify_email_not_exist @email_name
  end

  after(:each) do
    @gmail.logout
    logout
  end
end
