require './spec/spec_helper'

describe 'Members Module' do

  # Utils
  include VerificationHelpers

  # Pages
  include LoginPage
  include AdminPage
  include LandingPage
  include MembersPage


  let(:user) { GetData.get_user('automation_user') }
  let(:account) { GetData.get_account('automation_account') }
  let(:customer) { GetData.get_customer('automation_customer') }


  before(:all) do
    @customer_id = 'AutoMember' + Time.now.to_i.to_s + '@gmail.com'
  end

  before(:each) do
    visit '/'
    login(user[:username], user[:password])
    customer[:id] = @customer_id
    find_account(account[:name])
    navigate_members
  end

  it 'should add an account member' do
    add_new_member customer
    within '.flash_notice' do
      verify_content 'Member was successfully added.'
    end
  end

  it 'should find an account member' do
    find_member customer[:id]
    verify_content 'Members » View' and verify_content customer[:first_name] + ' ' + customer[:last_name]
  end

  it 'should edit member profile' do
    find_member customer[:id]
    edit_member_profile
    within '.flash_notice' do
      verify_content 'Member data successfully updated.'
    end
  end

  it 'should view member events' do
    find_member customer[:id]
    open_manage_events
    verify_content 'Members » View » Manage Events'
  end

  it 'should not find a member' do
    find_account(account[:number])
    navigate_members
    fill_in 'search_string', with: 'xxxxxxxxxxxxxxxxxxx123456789'
    members_found_after_search.has_text? 'No entries found'
  end

  it 'should record a purchase' do
    find_member customer[:id]
    record_purchase_event
    within '.flash_notice' do
      verify_content 'Points given to the customer.'
    end
  end

  it 'should record a custom purchase' do
    find_member customer[:id]
    record_custom_purchase_event 'auto_custom_purchase', 10
    within '.flash_notice' do
      verify_content 'Points given to the customer.'
    end
  end

  it 'should record a generic event' do
    find_member customer[:id]
    record_generic_event 'post'
    within '.flash_notice' do
      verify_content 'Event created.'
    end
  end

  it 'should reject a event' do
    find_member customer[:id]
    reject_last_purchase_event
    within '.flash_notice' do
      verify_content 'This event has been Rejected.'
    end
  end

  # it 'should link a offer' do  ## This is an scenario
  #   find_account(account[:number])
  #   navigate_members
  #   find_member customer[:id]
  #   link_offer 'Auto_Promotion_Points_x2'
  #   verify_offer_is_linked
  # end

  # it 'should unlink a offer' do  ## This is an scenario
  #   find_account(account[:number])
  #   navigate_members
  #   find_member customer[:id]
  #   unlink_offer 'Auto_Promotion_Points_x2'
  #   verify_offer_is_not_linked
  # end

  it 'should display the current points balance' do
    find_member customer[:id]
    # puts 'The current point balance from customer is:' + current_points.to_s
    current_points >= 0
  end

  it 'should pause a member' do
    find_member customer[:id]
    pause_member
    within '.flash_notice' do
      verify_content 'Successfully paused member.'
    end
  end

  # PENDING TEST ACTIVATE MEMBER
  # PENDING TEST DELETE MEMBER

  after(:each) do
    logout
  end
end

