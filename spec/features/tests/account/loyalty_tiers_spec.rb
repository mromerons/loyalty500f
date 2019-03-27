require './spec/spec_helper'

describe 'Tiers Module' do

  # Utils
  include VerificationHelpers

  # Pages
  include LoginPage
  include AdminPage
  include LandingPage
  include TiersPage


  let(:user) { GetData.get_user('automation_user') }
  let(:account) { GetData.get_account('automation_account') }


  before(:all) do
    @tier_name = 'Auto_tier_' + Time.now.to_i.to_s
  end

  before(:each) do
    visit '/'
    login(user[:username], user[:password])
    find_account(account[:number])
    navigate_account
    navigate_account_tiers
  end

  it 'should add a new tier' do
    add_tier @tier_name
    within '.flash_notice' do
      verify_content 'Tier was successfully created.'
    end
  end

  it 'should modify a tier' do
    modify_tier @tier_name
    within '.flash_notice' do
      verify_content 'Tier was successfully updated.'
    end
  end

  it 'should delete a tier' do
    delete_tier @tier_name
    within '.flash_notice' do
      verify_content 'Tier was successfully deleted.'
    end
  end

  after(:each) do
    logout
  end
end
