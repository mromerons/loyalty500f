require './lib/requires'

feature 'Offers Module' do
  include VerificationHelpers
  include LoginPage
  include AdminPage
  include LandingPage
  include OffersPage

  before(:all) do
    @deal_name = 'Auto_deal_' + Time.now.to_i.to_s
    @promotion_name = 'Auto_promotion_' + Time.now.to_i.to_s
  end

  before(:each) do
    @account = 1008
    @username = 'merklensqa@gmail.com'
    @password = 'Test1234'
    visit '/'
    login(@username, @password)
    find_account(@account)
    navigate_account
    navigate_account_offers
  end

  it 'should add a new deal' do
    add_deal @deal_name
    within '.flash_notice' do
      verify_content 'Deal created successfully.'
    end
    sleep 1
  end

  it 'should update a deal' do
    update_deal @deal_name
    within '.flash_notice' do
      verify_content 'Deal updated successfully.'
    end
    sleep 1
  end

  it 'should delete a deal' do
    delete_deal @deal_name
    within '.flash_notice' do
      verify_content 'The deal has been deleted.'
    end
    sleep 1
  end

  it 'should add a new promotion' do
    add_promotion @promotion_name
    within '.flash_notice' do
      verify_content 'Points promotion was successfully created.'
    end
    sleep 1
  end

  it 'should update a promotion' do
    update_promotion @promotion_name
    within '.flash_notice' do
      verify_content 'Points promotion was successfully updated.'
    end
    sleep 1
  end

  it 'should archive a promotion' do
    archive_promotion @promotion_name
    within '.flash_notice' do
      verify_content 'The point promotion has been archived.'
    end
    sleep 1
  end

  after(:each) do
    logout(@username)
  end
end
