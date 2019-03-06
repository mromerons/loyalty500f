require './lib/requires'

feature 'Segments Module' do
  include VerificationHelpers
  include Navigation
  include LoginPage
  include AdminPage
  include LandingPage
  include SegmentsPage

  before(:all) do
    @segment_name = 'Auto_segment_' + Time.now.to_i.to_s
    @automation_customer_1 = 'Nearsoft Test1'
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
  end

  it 'should update a segment' do
    update_segment @segment_name
    within '.flash_notice' do
      verify_content 'Segment was successfully updated.'
    end
  end

  it 'should delete a segment' do
    delete_segment @segment_name
    within '.flash_notice' do
      verify_content 'Segment was successfully deleted.'
    end
  end

  it 'should preview customers in a segment' do
    open_segment 'Auto_Segment_Special'
    preview_customers_in_segment
    verify_customer_belongs_to_segment @automation_customer_1
    close_segment_preview_frame
    cancel_segment
  end

  after(:each) do
    logout
  end
end
