module MembersPage
  include Capybara::DSL

  def add_new_member(member)
    find(:xpath, "//a[@href=contains (text(), 'new') and text()='Add new member']", wait: 2).click
    fill_in 'customer_email', with: member.to_s + '@gmail.com'
    fill_in 'customer_customer_detail_attributes_first_name', with: 'Automation'
    fill_in 'customer_customer_detail_attributes_last_name', with: 'Member'
    find(:id, 'customer_customer_detail_attributes_birthdate_2i', wait: 2).click
    find(:xpath, "//select[@id='customer_customer_detail_attributes_birthdate_2i']/option[3]", wait: 2).click
    find(:id, 'customer_customer_detail_attributes_birthdate_3i', wait: 2).click
    find(:xpath, "//select[@id='customer_customer_detail_attributes_birthdate_3i']/option[23]", wait: 2).click
    find(:id, 'customer_customer_detail_attributes_birthdate_1i', wait: 2).click
    find(:xpath, "//select[@id='customer_customer_detail_attributes_birthdate_1i']/option[83]", wait: 2).click
    fill_in 'customer_customer_detail_attributes_address_line_1', with: 'TestAddressLine1'
    fill_in 'customer_customer_detail_attributes_address_line_2', with: 'TestAddressLine2'
    find(:id, 'customer_customer_detail_attributes_country', wait: 2).click
    find(:xpath, "//select[@id='customer_customer_detail_attributes_country']/option[@value='US']", wait: 2).click
    fill_in 'customer_customer_detail_attributes_city', with: 'Phoenix'
    find(:id, 'customer_customer_detail_attributes_state', wait: 2).click
    find(:xpath, "//select[@id='customer_customer_detail_attributes_state']/option[@value='AZ']", wait: 2).click
    fill_in 'customer_customer_detail_attributes_postal_code', with: 85002
    fill_in 'customer_customer_detail_attributes_home_phone', with: '+001 777 888-1111'
    fill_in 'customer_customer_detail_attributes_work_phone', with: '+001 777 888-2222'
    fill_in 'customer_customer_detail_attributes_mobile_phone', with: '+001 777 888-3333'
    find(:id, 'customer_locale', wait: 2).click
    find(:xpath, "//select[@id='customer_locale']/option[@value='en-US']", wait: 2).click
    click_link_or_button 'Save'
  end

  def find_member(member)
    fill_in 'search_string', with: member
    sleep 2
    find(:xpath, "//a[@class='tertiary_button' and normalize-space()='Search']", wait: 2).click
    find(:xpath, "//a/dl/dd[contains(text(), '" + member.downcase + "')]", wait: 5).click
  end

  def update_date_selection
    find(:id, 'update_date_selection', wait: 2).click
  end

  def edit_member_profile
    find(:xpath, "//div[@class='edit_button']/a[contains(@href, '/edit') and text()= 'Edit']", wait: 2).click
    fill_in 'customer_customer_detail_attributes_postal_code', with: 85003
    click_link_or_button 'Save'
  end

  def open_manage_events
    find(:xpath, "//a[contains(@href, '/event_list') and text()= 'Manage events']", wait: 2).click
  end

  def pause_member
    find(:xpath, "//aside/a[contains(@href, '/pause') and contains(text(), 'Pause this member')]", wait: 2).click
  end

  def manage_events
    click_link_or_button 'Manage events'
  end

  def record_purchase_event
    click_link_or_button 'Record Events'
    find(:id, 'event_type', wait: 2).click
    find(:xpath, "//select[@id='event_type']//option[@value='purchase']", wait: 2).click
    fill_in 'event_value', with: 10
    click_link_or_button 'Save'
  end

  def record_generic_event(event_type)
    click_link_or_button 'Record Events'
    find(:id, 'event_type', wait: 2).click
    find(:xpath, "//select[@id='event_type']//option[@value='" + event_type + "']", wait: 2).click
    click_link_or_button 'Save'
  end

  def record_custom_purchase_event(custom_purchase, value)
    click_link_or_button 'Record Events'
    find(:id, 'event_type', wait: 2).click
    find(:xpath, "//select[@id='event_type']//option[@value='" + custom_purchase.downcase + "']", wait: 2).click
    fill_in 'event_value', with: value
    click_link_or_button 'Save'
  end

  def reject_event
    click_link_or_button 'Manage events'
    find(:xpath, "//table[@id='approved']//tr[@class='event_row row_type_purchase'][1]", wait: 2).click
    click_link_or_button 'Reject Points'
  end

  def verify_badges_section
    verify_content_by_xpath "//div[@class='badges_wrap']"
  end

  def verify_has_badge_world
    verify_content_by_xpath "//div[@class='badge_title' and text()='Auto_Badge_World']"
  end

  def verify_tier_section
    verify_content_by_xpath "//div[@class='achievements_wrap tier clear']"
  end

  def verify_tier_level
    update_date_selection
    current_tier = find(:xpath, "//div[@class='achievements_wrap tier clear']//li[@class='achievements']//div[@class='achievement_description'][normalize-space()]", wait: 2).text
    current_tier.split(/\s/, 2).first
  end

  def link_offer(offer)
    find(:id, 'customer_customer_offers', wait: 2).click
    find(:xpath, "//select[@id='customer_customer_offers']/option[text()='" + offer + "']").click
    find(:xpath, "//a[@class='add_member_linked_offer small_button' and text()='Add']").click
  end

  def unlink_offer(offer)
    if find(:xpath, "//ul[@class='member_offers_block']//div[@class='achievement_name' and normalize-space('" + offer + "')]", wait: 2)
      find(:xpath, "//ul[@class='member_offers_block']//div[@class='achievement_buttons']/a[text()='Delete']", wait: 2).click
    end
  end

  def verify_offer_is_linked
    verify_content_by_xpath "//ul[@class='member_offers_block']//div[@class='achievement_name' and normalize-space('Auto_Promotion_Points_x2')]"
  end

  def verify_offer_is_not_linked
    verify_no_content_by_xpath "//ul[@class='member_offers_block']//div[@class='achievement_name' and normalize-space('Auto_Promotion_Points_x2')]"
  end

  def current_points
    find(:xpath, "//*[@id='primary']//div[@class='info_column with_right_border'][1]//dd[1]", wait: 2).text.to_i
  end

  def members_found_after_search
    find(:xpath, "//h2[@class='pagination_counter']", wait: 5)
  end

  def current_rewards_redeemed
    find(:xpath, "//*[@id='primary']//div[@class='info_column with_right_border'][2]/dl/dd[2]", wait: 2).text.to_i
  end

  def verify_elegible_rewards_section
    verify_content_by_xpath "//div[@class='rewards_wrap eligible_rewards']"
  end

  def verify_upcoming_rewards_section
    verify_content_by_xpath "//div[@class='rewards_wrap upcoming_rewards']"
  end

  def purchase_via_api(member_id)
    url = "https://loyalty-stage.500friends.com/api/record.json?uuid=d01714e04c5f13&email=automember" + member_id + "%40gmail.com&type=purchase&value=20&event_id=" + member_id + "&brand=Nearsoft&channel=qa&sub_channel=automation"
    RestClient.get(url)
  end

  def verify_event_exist(event_name)
    verify_content_by_xpath "//table[@id='approved']/tbody/tr[contains(@class, '" + event_name.downcase + "')]//dt[contains(text(), '" + event_name + "')]"
  end
end