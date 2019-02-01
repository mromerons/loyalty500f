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
    find(:xpath, "//body[@class='dashboard overview']//a[text()='Nearsoft']", wait: 2)
    sleep 1
  end

  it 'should go to test automation account' do
    login(@username, @password)
    find_account(@account)
    account_name = find(:xpath, "//div[@id='header']/ul/li/a[@class='account_name_tab']", wait: 2)
    account_name.text eq 'Nearsoft Automation'
    sleep 1
  end

  after(:each) do
    logout(@username)
  end
end