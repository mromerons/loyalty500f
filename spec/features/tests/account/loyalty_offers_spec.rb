require './spec/spec_helper'

describe 'Offers Module' do
  # Utils
  include VerificationHelpers

  # Pages
  include LoginPage
  include AdminPage
  include LandingPage
  include OffersPage


  let(:user) { GetData.get_user('automation_user') }
  let(:account) { GetData.get_account('automation_account') }


  before(:all) do
    @deal_name = 'Auto_deal_' + Time.now.to_i.to_s
    @promotion_name = 'Auto_promotion_' + Time.now.to_i.to_s
  end

  before(:each) do
    visit '/'
    login(user[:username], user[:password])
    find_account(account[:number])
    navigate_account
    navigate_account_offers
  end

  it 'should add a new deal' do
    add_deal @deal_name
    within '.flash_notice' do
      verify_content 'Deal created successfully.'
    end
  end

  it 'should update a deal' do
    update_deal @deal_name
    within '.flash_notice' do
      verify_content 'Deal updated successfully.'
    end
  end

  it 'should delete a deal' do
    delete_deal @deal_name
    within '.flash_notice' do
      verify_content 'The deal has been deleted.'
    end
  end

  it 'should add a new promotion' do
    add_promotion @promotion_name
    within '.flash_notice' do
      verify_content 'Points promotion was successfully created.'
    end
  end

  it 'should update a promotion' do
    update_promotion @promotion_name
    within '.flash_notice' do
      verify_content 'Points promotion was successfully updated.'
    end
  end

  it 'should archive a promotion' do
    archive_promotion @promotion_name
    within '.flash_notice' do
      verify_content 'The point promotion has been archived.'
    end
  end

  after(:each) do
    logout
  end
end
