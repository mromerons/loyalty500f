require './lib/requires'

feature 'Login Module' do
  include VerificationHelpers
  include LoginPage
  include AdminPage
  include LandingPage

  before(:each) do
    visit '/'
    @account = 1008
    @username = 'merklensqa@gmail.com'
    @password = 'Test1234'
  end

  it 'should sign in loyaltyplus' do
    login(@username, @password)
    within '.primary_wrap' do
      has_text? '500friends'
    end
    sleep 1
  end

  it 'should go to test automation account' do
    login(@username, @password)
    find_account(@account)
    # binding.pry
    account_name = find(:xpath, "//section[@id='primary']/div/h1", wait: 2)
    account_name.text eq 'Nearsoft Automation'
    sleep 1
  end

  after(:each) do
    logout(@username)
  end
end