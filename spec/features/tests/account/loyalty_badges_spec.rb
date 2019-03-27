require './spec/spec_helper'

describe 'Badges Module' do

  # Utils
  include VerificationHelpers
  include CustomUtils

  # Pages
  include LoginPage
  include AdminPage
  include LandingPage
  include BadgesPage


  let(:user) { GetData.get_user('automation_user') }
  let(:account) { GetData.get_account('automation_account') }


  before(:all) do
    @badge_series_name = 'Auto_badge_series_' + Time.now.to_i.to_s
    @badge_name = 'Auto_badge_' + Time.now.to_i.to_s
  end

  before(:each) do
    visit '/'
    login(user[:username], user[:password])
    find_account(account[:number])
    navigate_account
    navigate_account_badges
  end

  it 'should add a new badge series' do
    add_badge_series @badge_series_name
    within '.flash_notice' do
      verify_content 'Badge series was successfully added.'
    end
  end

  it 'should add a new badge' do
    badge_series_name = convert_to_loyalty_name_convention(@badge_series_name)
    add_badge(badge_series_name, @badge_name)
    within '.flash_notice' do
      verify_content 'Badge was successfully added.'
    end
  end

  it 'should modify a badge' do
    badge_series_name = convert_to_loyalty_name_convention(@badge_series_name)
    modify_badge(badge_series_name, @badge_name)
    within '.flash_notice' do
      verify_content 'Badge was successfully updated.'
    end
  end

  it 'should delete a badge' do
    badge_series_name = convert_to_loyalty_name_convention(@badge_series_name)
    delete_badge(badge_series_name, @badge_name)
    within '.flash_notice' do
      verify_content 'The badge has been deleted.'
    end
  end

  it 'should modify a badge series' do
    badge_series_name = convert_to_loyalty_name_convention(@badge_series_name)
    modify_badge_series badge_series_name
    within '.flash_notice' do
      verify_content 'Badge series was successfully updated.'
    end
  end

  it 'should delete a badge series' do
    badge_series_name = convert_to_loyalty_name_convention(@badge_series_name)
    delete_badge_series badge_series_name
    within '.flash_notice' do
      verify_content 'The badge series has been deleted.'
    end
  end

  after(:each) do
    logout
  end
end
