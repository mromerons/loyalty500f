require './lib/requires'

feature 'Points Module' do
  include VerificationHelpers
  include LoginPage
  include AdminPage
  include LandingPage
  include PointsPage

  before(:all) do
    @rule_name = 'Auto_rule_' + Time.now.to_i.to_s
  end

  before(:each) do
    @account = 1008
    @username = 'merklensqa@gmail.com'
    @password = 'Test1234'
    visit '/'
    login(@username, @password)
    find_account(@account)
    navigate_account
    navigate_account_points
  end

  it 'should add a new rule' do
    add_points_rule @rule_name
    within '.flash_notice' do
      verify_content 'Points rule was successfully created.'
    end
    sleep 1
  end

  it 'should modify a rule' do
    modify_points_rule @rule_name
    within '.flash_notice' do
      verify_content 'Points rule was successfully updated.'
    end
    sleep 1
  end

  it 'should delete a rule' do
    delete_points_rule @rule_name
    within '.flash_notice' do
      verify_content 'The point rule has been deleted.'
    end
    sleep 1
  end

  after(:each) do
    logout(@username)
  end
end
