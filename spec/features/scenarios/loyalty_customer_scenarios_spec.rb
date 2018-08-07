require './lib/requires'

feature 'Customer' do
  include VerificationHelpers
  include Navigation
  include LoginPage
  include AdminPage
  include LandingPage
  include PointsPage
  include MembersPage

  before(:all) do
    @member_id = 'AutoMember' + Time.now.to_i.to_s
  end

  before(:each) do
    @account = 1008
    @username = 'merklensqa@gmail.com'
    @password = 'Test1234'
    # @automation_member_1 = 'merklensqa+n1@gmail.com'

    visit '/'
    login(@username, @password)
    find_account(@account)
  end

  # Scenario 1: A customer earn the World Badge
  it 'should earns the world badge' do
    # Customer should perform 3 purchases
    navigate_members
    add_new_member @member_id
    find_member @member_id
    record_purchase_event
    record_purchase_event
    record_purchase_event
    sleep 2
    update_date_selection
    verify_badges_section
    verify_has_badge_world
    sleep 2
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
    sleep 2
  end

  # Scenario 3: A customer reaches the Tier Level 2
  it 'should reach the tier level 2' do
    # pending 'Scenario is in progress...'
    #
  end

  # Scenario 4: A customer Redeem the Reward A
  # Scenario 5: A customer belongs to a special segment

  after(:each) do
    logout(@username)
  end
end
