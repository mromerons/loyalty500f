require './spec/spec_helper'

describe 'Scenarios' do

  # Utils
  include VerificationHelpers
  include Navigation
  include ApiCalls

  # Pages
  include LoginPage
  include AdminPage
  include LandingPage
  include PointsPage
  include MembersPage
  include OffersPage
  include SegmentsPage


  let(:user) { GetData.get_user('automation_user') }
  let(:account) { GetData.get_account('automation_account') }
  let(:customer) { GetData.get_customer('automation_customer') }
  let(:nearsoft_test1) { GetData.get_customer('nearsoft_test_1') }


  before(:each) do
    visit '/'
    login(user[:username], user[:password])
    @customer_id = 'AutoMember' + Time.now.to_i.to_s + '@gmail.com'
    customer[:id] = @customer_id
    find_account(account[:name])
  end

  # Scenario 1: A customer earn the World Badge
  it 'should earn the world badge' do
    navigate_members
    add_new_member customer
    find_member customer[:id]
    3.times() do
      record_purchase_event
    end
    sleep 2
    update_date_selection
    verify_badges_section
    verify_has_badge_world
  end

  # Scenario 2: A customer gets Double Points from a Purchase due a Promotion
  it 'should get double points from a purchase due a linked promotion' do
    navigate_members
    add_new_member customer
    find_member customer[:id]
    link_offer 'Auto_Promotion_Points_x2'
    verify_offer_is_linked
    expected_points_balance = current_points + (10 * 2)
    record_purchase_event
    current_points.equal? expected_points_balance
  end

  # Scenario 3: A customer reaches the Tier Level 2
  it 'should reach the tier level 2' do
    navigate_members
    add_new_member customer
    find_member customer[:id]
    verify_tier_section
    # puts 'Current Tier: ' + verify_tier_level
    5.times do
      record_purchase_event
    end
    2.times do
      record_generic_event 'post'
    end
    sleep 5
    update_date_selection
    # puts 'Current Tier: ' + verify_tier_level
    verify_tier_level.eql? 'Auto_Level_2'
  end

  # Scenario 4: A customer must belongs to a special Segment
  it 'should belong to a special segment' do
    navigate_account_segments
    open_segment 'Auto_Segment_Special'
    preview_customers_in_segment
    # verify_customer_belongs_to_segment @automation_customer_1
    verify_customer_belongs_to_segment nearsoft_test1[:first_name] + ' ' + nearsoft_test1[:last_name]
    close_segment_preview_frame
    cancel_segment
  end

  # Scenario 5: A customer triggers an Event based on some Promotion settings
  it 'should auto-redeem a reward c based on reward conditions' do
    # Reward conditions are:
    # Customer belongs to Level 2 Tier
    # Customer has the Auto Badge World
    # Customer has 2000 Orange points
    # Customer has the Auto Custom Purchase Event
    navigate_members
    add_new_member customer
    find_member customer[:id]
    # puts 'The current number of rewards redeemed is: ' + current_rewards_redeemed.to_s
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
    # puts 'The new number of rewards redeemed is: ' + current_rewards_redeemed.to_s
    current_rewards_redeemed == 1
  end

  # Scenario 6: A customer triggers an Event based on some Promotion settings
  it 'should trigger an event based on some promotion settings' do
    navigate_members
    add_new_member customer
    find_member customer[:id]
    link_offer 'Auto_Promotion_Trigger_Event'
    update_date_selection
    purchase_via_api customer[:id]
    sleep 5
    manage_events
    verify_content 'Members » View » Manage Events'
    verify_event_exist 'Auto_promotion_event'
  end

  after(:each) do
    logout
  end
end
