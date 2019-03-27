require './spec/spec_helper'

describe 'Segments Module' do

  # Utils
  include VerificationHelpers

  # Pages
  include Navigation
  include LoginPage
  include AdminPage
  include LandingPage
  include SegmentsPage


  let(:user) { GetData.get_user('automation_user') }
  let(:account) { GetData.get_account('automation_account') }


  before(:all) do
    @segment_name = 'Auto_segment_' + Time.now.to_i.to_s
  end

  before(:each) do
    visit '/'
    login(user[:username], user[:password])
    find_account(account[:number])
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

  it 'should open preview of segment' do
    open_segment @segment_name
    preview_customers_in_segment
    close_segment_preview_frame
    cancel_segment
  end

  it 'should delete a segment' do
    delete_segment @segment_name
    within '.flash_notice' do
      verify_content 'Segment was successfully deleted.'
    end
  end

  after(:each) do
    logout
  end
end
