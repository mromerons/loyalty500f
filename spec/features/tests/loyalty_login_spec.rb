require './lib/requires'
require './lib/helpers/navigation'

feature 'Login Module' do
  include VerificationHelpers
  include LoginPage
  include AdminPage
  include LandingPage
  include Navigation

  before(:each) do
    visit '/'
    @account = 1008
    @username = 'merklensqa@gmail.com'
    @password = 'Test1234'
  end

  it 'should sign in loyaltyplus' do
    login(@username, @password)
    verify_user_name
  end

  it 'should go to test automation account' do
    login(@username, @password)
    find_account(@account)
    account_name = verify_account_name.text
    account_name == 'Nearsoft Automation'
  end

  after(:each) do
    logout
  end
end