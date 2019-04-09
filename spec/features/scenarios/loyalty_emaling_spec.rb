require './spec/spec_helper'

describe 'Emailing' do

  # Utils
  include VerificationHelpers
  include Navigation
  include EmailUtils
  include ApiCalls

  # Pages
  include LoginPage
  include AdminPage
  include LandingPage
  include MembersPage
  include EmailsPage
  include RewardsPage


  let(:user) { GetData.get_user('automation_user') }
  let(:account) { GetData.get_account('automation_account') }
  let(:customer) { GetData.get_customer('automation_customer') }
  let(:automation_email_account) { GetData.get_account('automation_email_account') }
  let(:nearsoft_test_1) { GetData.get_customer('nearsoft_test_1') }

  describe 'Trigger Emails' do
    before(:each) do
      visit '/'
      login(user[:username], user[:password])
      find_account(account[:name])
      navigate_account
      @gmail = connect_to_email(automation_email_account[:email], automation_email_account[:secret_password])
      @unique_code = Time.now.to_i.to_s
      navigate_account_emails
      delete_automation_emails 'Trigger'
    end

    # Trigger Emails
    # Scenario 1: Should Get a Test Email feature
    it 'should get a test email feature' do
      add_trigger_email 'Auto_Trigger_Test_Email', 'purchase', @unique_code
      open_email 'Auto_Trigger_Test_Email'
      send_test_email_to automation_email_account[:email]
      within '.flash_notice' do
        verify_content 'Successfully sent test emails.'
      end
      email = search_email(@gmail, 'Purchase', @unique_code)
      logout_from_email @gmail
      delete_email
      fail 'No Email found in customer inbox' unless email
    end

    # Scenario 2: Should Get a Purchase Email
    it 'should get a purchase email' do
      add_trigger_email 'Auto_Trigger_Purchase', 'purchase', @unique_code
      navigate_members
      find_member nearsoft_test_1[:cid].to_s
      record_purchase_event
      email = search_email(@gmail, 'Purchase', @unique_code)
      logout_from_email @gmail
      navigate_account
      navigate_account_emails
      open_email 'Auto_Trigger_Purchase'
      delete_email
      fail 'No Email found in customer inbox' unless email
    end

    # Scenario 3: Should Get a Return Email
    it 'should get a return email' do
      add_trigger_email 'Auto_Trigger_Return', 'return', @unique_code
      navigate_members
      find_member nearsoft_test_1[:cid].to_s
      record_return_event
      email = search_email(@gmail, 'Return', @unique_code)
      logout_from_email @gmail
      navigate_account
      navigate_account_emails
      open_email 'Auto_Trigger_Return'
      delete_email
      fail 'No Email found in customer inbox' unless email
    end

    # Scenario 4: Should Get a Enrollment Email
    it 'should get an enrollment email' do
      add_trigger_email 'Auto_Trigger_Enrollment', 'enrollment', @unique_code
      navigate_members
      @customer_id = 'merklensqa+n' + @unique_code.to_s + '@gmail.com'
      customer[:id] = @customer_id
      add_new_member customer
      find_member customer[:id]
      email = search_email(@gmail, 'Enrollment', @unique_code, 300)
      logout_from_email @gmail
      navigate_account
      navigate_account_emails
      open_email 'Auto_Trigger_Enrollment'
      delete_email
      fail 'No Email found in customer inbox' unless email
    end

    # Scenario 5: Should Get a Tier Email
    it 'should get a tier email' do
      add_trigger_email 'Auto_Trigger_Tier', 'tier', @unique_code
      navigate_members
      @customer_id = 'merklensqa+n' + @unique_code.to_s + '@gmail.com'
      customer[:id] = @customer_id
      add_new_member customer
      find_member customer[:id]
      email = search_email(@gmail, 'Tier', @unique_code)
      logout_from_email @gmail
      navigate_account
      navigate_account_emails
      open_email 'Auto_Trigger_Tier'
      delete_email
      fail 'No Email found in customer inbox' unless email
    end

    # Scenario 6: Should Get a Downgrade Tier Email
    it 'should get a downgrade tier email' do
      navigate_members
      @customer_id = 'merklensqa+n' + @unique_code.to_s + '@gmail.com'
      customer[:id] = @customer_id
      add_new_member customer
      find_member customer[:id]
      5.times do
        record_purchase_event
      end
      2.times do
        record_generic_event 'post'
      end
      navigate_account
      navigate_account_emails
      add_trigger_email 'Auto_Trigger_Downgrade_Tier', 'downgrade_tier', @unique_code
      navigate_members
      find_member customer[:id]
      # reject_last_event_of 'post'
      reject_last_purchase_event
      email = search_email(@gmail, 'Downgrade_tier', @unique_code)
      logout_from_email @gmail
      navigate_account
      navigate_account_emails
      open_email 'Auto_Trigger_Downgrade_Tier'
      delete_email
      fail 'No Email found in customer inbox' unless email
    end

    # Scenario 7: Should Get a First Reward Email
    it 'should get a first reward email' do
      add_trigger_email 'Auto_Trigger_First_Reward', 'first_reward', @unique_code
      navigate_members
      @customer_id = 'merklensqa+n' + @unique_code.to_s + '@gmail.com'
      customer[:id] = @customer_id
      add_new_member customer
      find_member customer[:id]
      5.times do
        record_purchase_event 500
      end
      2.times do
        record_generic_event 'post'
      end
      record_custom_purchase_event 'auto_custom_purchase', 20
      sleep 2
      update_date_selection
      email = search_email(@gmail, 'First_Reward', @unique_code)
      logout_from_email @gmail
      navigate_account
      navigate_account_emails
      open_email 'Auto_Trigger_First_Reward'
      delete_email
      fail 'No Email found in customer inbox' unless email
    end

    # Scenario 8: Should Get a Reward Email
    it 'should get a reward email' do
      add_trigger_email 'Auto_Trigger_Reward', 'reward', @unique_code
      navigate_account
      navigate_account_rewards
      open_reward 'Auto_Reward_C'
      select_redemption_communication 'Auto_Trigger_Reward'
      save_reward_changes
      navigate_members
      @customer_id = 'merklensqa+n' + @unique_code.to_s + '@gmail.com'
      customer[:id] = @customer_id
      add_new_member customer
      find_member customer[:id]
      5.times do
        record_purchase_event 500
      end
      2.times do
        record_generic_event 'post'
      end
      record_custom_purchase_event 'auto_custom_purchase', 20
      sleep 2
      update_date_selection
      email = search_email(@gmail, 'Reward', @unique_code)
      logout_from_email @gmail
      navigate_account
      navigate_account_emails
      open_email 'Auto_Trigger_Reward'
      delete_email
      fail 'No Email found in customer inbox' unless email
    end

    # Scenario 9: Should Get a Badge Email
    it 'should get a badge email' do
      add_trigger_email 'Auto_Trigger_Badge', 'badge', @unique_code
      navigate_members
      @customer_id = 'merklensqa+n' + @unique_code.to_s + '@gmail.com'
      customer[:id] = @customer_id
      add_new_member customer
      find_member customer[:id]
      3.times() do
        record_purchase_event
      end
      sleep 2
      update_date_selection
      email = search_email(@gmail, 'Badge', @unique_code)
      logout_from_email @gmail
      navigate_account
      navigate_account_emails
      open_email 'Auto_Trigger_Badge'
      delete_email
      fail 'No Email found in customer inbox' unless email
    end

    after(:each) do
      logout
    end
  end

  describe 'Scheduled Emails' do
    before(:each) do
      visit '/'
      login(user[:username], user[:password])
      find_account(account[:name])
      navigate_account
      navigate_account_emails
      @unique_code = Time.now.to_i.to_s
    end

    # One-Time Email
    # Scenario 10: Should Schedule a One-Time Email
    it 'should schedule a one-time email' do
      delete_automation_emails 'Schedule_One_Time'
      add_one_time_email 'Auto_Schedule_One_Time_Email', @unique_code
      verify_email_exist 'Auto_Schedule_One_Time_Email'
    end

    # Recurring Email
    # Scenario 11: Should Schedule a Recurring Email
    it 'should schedule a recurring email' do
      delete_automation_emails 'Schedule_Recurring'
      add_recurring_email 'Auto_Schedule_Recurring_Email', @unique_code
      verify_email_exist 'Auto_Schedule_Recurring_Email'
    end

    after(:each) do
      logout
    end
  end
end
