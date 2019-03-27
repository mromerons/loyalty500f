module MembersPage
  include Capybara::DSL

  def add_new_member(customer)
    find(:xpath, "//a[@href=contains (text(), 'new') and text()='Add new member']", wait: 2).click
    fill_in 'customer_email', with: customer[:id]
    fill_in 'customer_customer_detail_attributes_first_name', with: customer[:first_name]
    fill_in 'customer_customer_detail_attributes_last_name', with: customer[:last_name]
    find(:id, 'customer_customer_detail_attributes_birthdate_2i', wait: 2).click
    find(:xpath, "//select[@id='customer_customer_detail_attributes_birthdate_2i']/option[@value='" + (customer[:date_of_birth]['month']).to_s + "']", wait: 2).click
    find(:id, 'customer_customer_detail_attributes_birthdate_3i', wait: 2).click
    find(:xpath, "//select[@id='customer_customer_detail_attributes_birthdate_3i']/option[@value='" + (customer[:date_of_birth]['day']).to_s + "']", wait: 2).click
    find(:id, 'customer_customer_detail_attributes_birthdate_1i', wait: 2).click
    find(:xpath, "//select[@id='customer_customer_detail_attributes_birthdate_1i']/option[@value='" + (customer[:date_of_birth]['year']).to_s + "']", wait: 2).click
    fill_in 'customer_customer_detail_attributes_address_line_1', with: customer[:address_line_1]
    fill_in 'customer_customer_detail_attributes_address_line_2', with: customer[:address_line_2]
    find(:id, 'customer_customer_detail_attributes_country', wait: 2).click
    find(:xpath, "//select[@id='customer_customer_detail_attributes_country']/option[@value='" + customer[:country] + "']", wait: 2).click
    fill_in 'customer_customer_detail_attributes_city', with: customer[:city]
    find(:id, 'customer_customer_detail_attributes_state', wait: 2).click
    find(:xpath, "//select[@id='customer_customer_detail_attributes_state']/option[@value='" + customer[:state] + "']", wait: 2).click
    fill_in 'customer_customer_detail_attributes_postal_code', with: customer[:postal_code]
    fill_in 'customer_customer_detail_attributes_home_phone', with: customer[:home_phone]
    fill_in 'customer_customer_detail_attributes_work_phone', with: customer[:work_phone]
    fill_in 'customer_customer_detail_attributes_mobile_phone', with: customer[:mobile_phone]
    find(:id, 'customer_locale', wait: 2).click
    find(:xpath, "//select[@id='customer_locale']/option[@value='" + customer[:locale] + "']", wait: 2).click
    click_link_or_button 'Save'
  end

  def find_member(customer_id)
    fill_in 'search_string', with: customer_id
    search_retry_number = 10
    while has_xpath?("//a/dl/dd[contains(text(), '" + customer_id.downcase + "')]", wait: 1) == false and search_retry_number > 0 do
      find(:xpath, "//a[@class='tertiary_button' and normalize-space()='Search']", wait: 1).click
      search_retry_number -= 1
    end
    find(:xpath, "//a/dl/dd[contains(text(), '" + customer_id.downcase + "')]", wait: 2).click
  end

  def update_date_selection
    find(:id, 'update_date_selection', wait: 2).click
  end

  def edit_member_profile
    find(:xpath, "//div[@class='edit_button']/a[contains(@href, '/edit') and text()= 'Edit']", wait: 2).click
    fill_in 'customer_customer_detail_attributes_postal_code', with: 99999
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

  def record_purchase_event(value = 10)
    click_link_or_button 'Record Events'
    find(:id, 'event_type', wait: 2).click
    find(:xpath, "//select[@id='event_type']//option[@value='purchase']", wait: 2).click
    fill_in 'event_value', with: value
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

  def reject_last_purchase_event
    click_link_or_button 'Manage events'
    find(:xpath, "//table[@id='approved']//tr[@class='event_row row_type_purchase'][1]", wait: 2).click
    click_link_or_button 'Reject Points'
  end

  def reject_last_event_of(event)
    click_link_or_button 'Manage events'
    find(:xpath, "//table[@id='approved']//tr[@class='event_row row_type_" + event + "'][1]", wait: 2).click
    click_link_or_button 'Reject Points'
  end

  def record_return_event
    click_link_or_button 'Record Events'
    find(:id, 'event_type', wait: 2).click
    find(:xpath, "//select[@id='event_type']//option[@value='return']", wait: 2).click
    fill_in 'event_value', with: 10
    click_link_or_button 'Save'
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

  def verify_event_exist(event_name)
    verify_content_by_xpath "//table[@id='approved']/tbody/tr[contains(@class, '" + event_name.downcase + "')]//dt[contains(text(), '" + event_name + "')]"
  end
end