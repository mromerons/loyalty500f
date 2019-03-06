require './lib/requires'

feature 'Tiers Module' do
  include VerificationHelpers
  include LoginPage
  include AdminPage
  include LandingPage
  include TiersPage

  before(:all) do
    @tier_name = 'Auto_tier_' + Time.now.to_i.to_s
  end

  before(:each) do
    @account = 1008
    @username = 'merklensqa@gmail.com'
    @password = 'Test1234'
    visit '/'
    login(@username, @password)
    find_account(@account)
    navigate_account
    navigate_account_tiers
  end

  it 'should add a new tier' do
    add_tier @tier_name
    within '.flash_notice' do
      verify_content 'Tier was successfully created.'
    end
    sleep 1
  end

  it 'should modify a tier' do
    modify_tier @tier_name
    within '.flash_notice' do
      verify_content 'Tier was successfully updated.'
    end
    sleep 1
  end

  it 'should delete a tier' do
    delete_tier @tier_name
    within '.flash_notice' do
      verify_content 'Tier was successfully deleted.'
    end
    sleep 1
  end

  after(:each) do
    logout
  end
end
