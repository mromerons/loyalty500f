require './lib/requires'

feature 'Segments Module' do
  include VerificationHelpers
  include LoginPage
  include AdminPage
  include LandingPage
  include SegmentsPage

  before(:all) do
    @segment_name = 'Auto_segment_' + Time.now.to_i.to_s
  end

  before(:each) do
    @account = 1008
    @username = 'merklensqa@gmail.com'
    @password = 'Test1234'
    visit '/'
    login(@username, @password)
    find_account(@account)
    navigate_account
    navigate_account_segments
  end

  it 'should add a new segment' do
    add_segment @segment_name
    within '.flash_notice' do
      verify_content 'Segment was successfully created.'
    end
    sleep 1
  end

  it 'should update a segment' do
    update_segment @segment_name
    within '.flash_notice' do
      verify_content 'Segment was successfully updated.'
    end
    sleep 1
  end

  it 'should delete a segment' do
    delete_segment @segment_name
    within '.flash_notice' do
      verify_content 'Segment was successfully deleted.'
    end
    sleep 1
  end

  it 'should preview customers in segment' do
    click_preview_in_segment
  end

  after(:each) do
    logout(@username)
  end
end
