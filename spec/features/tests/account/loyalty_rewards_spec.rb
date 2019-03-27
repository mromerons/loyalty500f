require './spec/spec_helper'

describe 'Rewards Module' do
  # Utils
  include VerificationHelpers

  # Pages
  include LoginPage
  include AdminPage
  include LandingPage
  include RewardsPage


  let(:user) { GetData.get_user('automation_user') }
  let(:account) { GetData.get_account('automation_account') }


  before(:all) do
    @reward_name = 'Auto_reward_' + Time.now.to_i.to_s
  end

  before(:each) do
    visit '/'
    login(user[:username], user[:password])
    find_account(account[:number])
    navigate_account
    navigate_account_rewards
  end

  it 'should add a new reward' do
    add_reward @reward_name
    within '.flash_notice' do
      verify_content 'Reward was successfully added.'
    end
    # sleep 1
  end

  it 'should modify a reward' do
    modify_reward @reward_name
    within '.flash_notice' do
      verify_content 'Reward was successfully updated.'
    end
    # sleep 1
  end

  it 'should delete a reward' do
    delete_reward @reward_name
    page.current_url == Capybara.app_host + '/accounts/'.concat(@account.to_s).concat('/rewards')
    # within '.flash_notice' do
    #   verify_content 'The reward has been deleted.'
    # end
    # sleep 1
  end

  after(:each) do
    logout
  end
end
