require './lib/requires'

feature 'Members Module' do
  include VerificationHelpers
  include LoginPage
  include AdminPage
  include LandingPage
  include MembersPage

  before(:all) do
    @member_id = 'AutoMember' + Time.now.to_i.to_s
  end

  before(:each) do
    @account = 1008
    @username = 'merklensqa@gmail.com'
    @password = 'Test1234'
    visit '/'
    login(@username, @password)
    find_account(@account)
    navigate_members
  end

  it 'should add an account member' do
    add_new_member @member_id
    within '.flash_notice' do
      verify_content 'Member was successfully added.'
    end
    sleep 1
  end

  it 'should find an account member' do
    find_member @member_id
    verify_content 'Members » View' and verify_content 'Automation Member'
    sleep 1
  end

  it 'should edit member profile' do
    # @member_id = 'automember1528942706'
    find_member @member_id
    edit_member_profile
    within '.flash_notice' do
      verify_content 'Member data successfully updated.'
    end
    sleep 1
  end

  it 'should view member events' do
    # @member_id = 'automember1528942706'
    find_member @member_id
    open_manage_events
    verify_content 'Members » View » Manage Events'
    sleep 1
  end

  it 'should not find a member' do
    fill_in 'search_string', with: 'xxxxxxxxxxxxxxxxxxx123456789'
    find(:xpath, "//h2[@class='pagination_counter']", wait: 5).has_text? 'No entries found'
    sleep 1
  end

  it 'should record a purchase' do
    find_member @member_id
    record_purchase_event
    within '.flash_notice' do
      verify_content 'Points given to the customer.'
    end
    sleep 1
  end

  it 'should record a custom purchase' do
    find_member @member_id
    record_custom_purchase_event 'auto_custom_purchase'
    within '.flash_notice' do
      verify_content 'Points given to the customer.'
    end
    sleep 1
  end

  it 'should record a generic event' do
    find_member @member_id
    record_generic_event 'post'
    within '.flash_notice' do
      verify_content 'Event created.'
    end
    sleep 1
  end

  it 'should reject a event' do
    find_member @member_id
    reject_event
    within '.flash_notice' do
      verify_content 'This event has been Rejected.'
    end
    sleep 1
  end

  it 'should link a offer' do
    find_member @member_id
    # find_member 'automember1532730078'
    link_offer 'Auto_Promotion_Points_x2'
    verify_offer_is_linked
    sleep 1
  end

  it 'should unlink a offer' do
    find_member @member_id
    # find_member 'automember1532730078'
    unlink_offer 'Auto_Promotion_Points_x2'
    verify_offer_is_not_linked
    sleep 1
  end

  # it 'should verify current point balance' do
    #
  # end

  it 'should pause a member' do
    # @member_id = 'automember1528942706'
    find_member @member_id
    pause_member
    within '.flash_notice' do
      verify_content 'Successfully paused member.'
    end
    sleep 1
  end

  after(:each) do
    logout(@username)
  end
end
