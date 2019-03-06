require './lib/requires'

feature 'Badges Module' do
  include VerificationHelpers
  include CustomUtils
  include LoginPage
  include AdminPage
  include LandingPage
  include BadgesPage

  before(:all) do
    @badge_series_name = 'Auto_badge_series_' + Time.now.to_i.to_s
    @badge_name = 'Auto_badge_' + Time.now.to_i.to_s
  end

  before(:each) do
    @account = 1008
    @username = 'merklensqa@gmail.com'
    @password = 'Test1234'
    visit '/'
    login(@username, @password)
    find_account(@account)
    navigate_account
    navigate_account_badges
  end

  it 'should add a new badge series' do
    add_badge_series @badge_series_name
    within '.flash_notice' do
      verify_content 'Badge series was successfully added.'
    end
    sleep 1
  end

  it 'should add a new badge' do
    badge_series_name = convert_to_loyalty_name_convention(@badge_series_name)
    add_badge(badge_series_name, @badge_name)
    within '.flash_notice' do
      verify_content 'Badge was successfully added.'
    end
    sleep 1
  end

  it 'should modify a badge' do
    badge_series_name = convert_to_loyalty_name_convention(@badge_series_name)
    modify_badge(badge_series_name, @badge_name)
    within '.flash_notice' do
      verify_content 'Badge was successfully updated.'
    end
    sleep 1
  end

  it 'should delete a badge' do
    badge_series_name = convert_to_loyalty_name_convention(@badge_series_name)
    delete_badge(badge_series_name, @badge_name)
    within '.flash_notice' do
      verify_content 'The badge has been deleted.'
    end
    sleep 1
  end

  it 'should modify a badge series' do
    badge_series_name = convert_to_loyalty_name_convention(@badge_series_name)
    modify_badge_series badge_series_name
    within '.flash_notice' do
      verify_content 'Badge series was successfully updated.'
    end
    sleep 1
  end

  it 'should delete a badge series' do
    badge_series_name = convert_to_loyalty_name_convention(@badge_series_name)
    delete_badge_series badge_series_name
    within '.flash_notice' do
      verify_content 'The badge series has been deleted.'
    end
    sleep 1
  end

  after(:each) do
    logout
  end
end
