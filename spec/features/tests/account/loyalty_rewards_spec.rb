require './lib/requires'

feature 'Rewards Module' do
  include VerificationHelpers
  include LoginPage
  include AdminPage
  include LandingPage
  include RewardsPage

  before(:all) do
    @reward_name = 'Auto_reward_' + Time.now.to_i.to_s
  end

  before(:each) do
    @account = 1008
    @username = 'merklensqa@gmail.com'
    @password = 'Test1234'
    visit '/'
    login(@username, @password)
    find_account(@account)
    navigate_account
    navigate_account_rewards
  end

  it 'should add a new reward' do
    add_reward @reward_name
    within '.flash_notice' do
      verify_content 'Reward was successfully added.'
    end
    sleep 1
  end

  it 'should modify a reward' do
    modify_reward @reward_name
    within '.flash_notice' do
      verify_content 'Reward was successfully updated.'
    end
    sleep 1
  end

  it 'should delete a reward' do
    delete_reward @reward_name
    page.current_url == Capybara.app_host + '/accounts/'.concat(@account.to_s).concat('/rewards')
    # within '.flash_notice' do
    #   verify_content 'The point rule has been deleted.'
    # end
    sleep 1
  end

  after(:each) do
    logout(@username)
  end
end
