require './spec/spec_helper'

describe 'Points Module' do

  # Utils
  include VerificationHelpers

  # Pages
  include LoginPage
  include AdminPage
  include LandingPage
  include PointsPage


  let(:user) { GetData.get_user('automation_user') }
  let(:account) { GetData.get_account('automation_account') }


  before(:all) do
    @rule_name = 'Auto_rule_' + Time.now.to_i.to_s
  end

  before(:each) do
    visit '/'
    login(user[:username], user[:password])
    find_account(account[:number])
    navigate_account
    navigate_account_points
  end

  it 'should add a new rule' do
    add_points_rule @rule_name
    within '.flash_notice' do
      verify_content 'Points rule was successfully created.'
    end
  end

  it 'should modify a rule' do
    modify_points_rule @rule_name
    within '.flash_notice' do
      verify_content 'Points rule was successfully updated.'
    end
  end

  it 'should delete a rule' do
    delete_points_rule @rule_name
    within '.flash_notice' do
      verify_content 'The point rule has been deleted.'
    end
  end

  after(:each) do
    logout
  end
end
