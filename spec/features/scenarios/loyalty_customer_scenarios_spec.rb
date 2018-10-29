require './lib/requires'

feature 'Customer' do
  include VerificationHelpers
  include Navigation
  include LoginPage
  include AdminPage
  include LandingPage
  include PointsPage
  include MembersPage
  include OffersPage
  include SegmentsPage

  # before(:all) do
  #   @member_id = 'AutoMember' + Time.now.to_i.to_s
  # end

  before(:each) do
    @account = 1008
    @username = 'merklensqa@gmail.com'
    @password = 'Test1234'
    @member_id = 'AutoMember' + Time.now.to_i.to_s
    # @automation_member_1 = 'merklensqa+n1@gmail.com'
    @automation_customer_1 = 'Nearsoft Test1'

    visit '/'
    login(@username, @password)
    find_account(@account)
  end

  # Scenario 1: A customer earn the World Badge
  it 'should earns the world badge' do
    navigate_members
    add_new_member @member_id
    find_member @member_id
    3.times() do
      record_purchase_event
    end
    sleep 2
    update_date_selection
    verify_badges_section
    verify_has_badge_world
    # sleep 2
  end

  # Scenario 2: A customer gets Double Points from a Purchase due a Promotion
  it 'should get double points from a purchase due a linked promotion' do
    navigate_members
    add_new_member @member_id
    find_member @member_id
    link_offer 'Auto_Promotion_Points_x2'
    verify_offer_is_linked
    expected_points_balance = current_points + (10 * 2)
    record_purchase_event
    current_points.equal? expected_points_balance
    # sleep 2
  end

  # Scenario 3: A customer reaches the Tier Level 2
  it 'should reach the tier level 2' do
    navigate_members
    add_new_member @member_id
    find_member @member_id
    verify_tier_section
    # puts 'Current Tier: ' + verify_tier_level
    10.times do
      record_purchase_event
    end
    2.times do
      record_generic_event 'post'
    end
    sleep 5
    update_date_selection
    # puts 'Current Tier: ' + verify_tier_level
    verify_tier_level.eql? 'Auto_Level_2'
    # sleep 2
  end

  # Scenario 4: A customer must belongs to a special Segment
  it 'should belongs to a special segment' do
    navigate_account_segments
    open_segment 'Auto_Segment_Special'
    preview_customers_in_segment
    verify_customer_belongs_to_segment @automation_customer_1
    close_segment_preview
    # sleep 2
  end

  # Scenario 5: A customer triggers an Event based on some Promotion settings
  it 'should auto-redeem a reward c based on reward conditions' do
    # Reward conditions are:
    # Customer belongs to Level 2 Tier
    # Customer has the Auto Badge World
    # Customer has 2000 Orange points
    # Customer has the Auto Custom Purchase Event
    navigate_members
    add_new_member @member_id
    find_member @member_id
    puts 'The current number of rewards redeemed is: ' + current_rewards_redeemed.to_s
    # Reach Level 2 Tier
    10.times do
      record_purchase_event
    end
    2.times do
      record_generic_event 'post'
    end
    # Earn World badge
    3.times do
      record_purchase_event
    end
    # Get the Custom Purchase Event and the 2000 orange points (700 * 3)
    record_custom_purchase_event 'Auto_custom_purchase', 700
    sleep 4
    update_date_selection
    puts 'The new number of rewards redeemed is: ' + current_rewards_redeemed.to_s
    current_rewards_redeemed.equal? 1
    # sleep 2
  end

  # Scenario 6: A customer triggers an Event based on some Promotion settings
  it 'should trigger an event based on some promotion settings' do
    navigate_members
    add_new_member @member_id
    find_member @member_id
    link_offer 'Auto_Promotion_Trigger_Event'
    update_date_selection
    purchase_via_api(@member_id.sub('AutoMember', ''))
    manage_events
    verify_content 'Members » View » Manage Events'
    verify_event_exist 'Auto_promotion_event'
  end

  after(:each) do
    logout(@username)
  end
end
