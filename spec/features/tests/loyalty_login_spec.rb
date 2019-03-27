require './spec/spec_helper'

describe 'Login Module' do

  # Utils
  include Navigation

  # Pages
  include LoginPage
  include AdminPage
  include LandingPage


  let(:user) { GetData.get_user('automation_user') }
  let(:account) { GetData.get_account('automation_account') }


  before(:each) do
    visit '/'
    login(user[:username], user[:password])
  end

  it 'should sign in loyaltyplus' do
    verify_user_name(user[:first_name])
  end

  it 'should go to test automation account' do
    find_account(account[:name])
    account_name = verify_account_name.text
    account_name == account[:name]
  end

  after(:each) do
    logout
  end
end