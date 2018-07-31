module BadgesPage
  include Capybara::DSL

  def add_badge_series(name)
    click_link 'Add new badge series'
    fill_in 'badge_group_name', with: name
    fill_in 'badge_group_description', with: name + '_Description'
    find(:xpath, "//div[@id='badge_group_icon_url']//input[@name='file']", wait: 2).set(File.absolute_path('./lib/data/badges/badgeseries.png'))
    sleep 5
    status = find(:id, 'badge_group_status', wait: 2)
    status.click unless status.checked?
    click_link_or_button 'Save'
  end

  def modify_badge_series(name)
    find(:xpath, "//tr[@class='item']//a//dt[contains(text(), '" + name + "')]", wait: 2).click
    # fill_in 'tier_points', with: '15'
    click_link_or_button 'Save'
  end

  def delete_badge_series(name)
    find(:xpath, "//tr[@class='item']//a//dt[contains(text(), '" + name + "')]", wait: 2).click
    click_link_or_button 'Delete badge series'
    find(:xpath, "//div[@class='delete_overlay']//a[@class='primary_button del_button' and contains(text(), 'Delete')]", wait: 2).click
  end

  def add_badge(badge_series_name, badge_name)
    find(:xpath, "//tr[@class='item']//a//dt[contains(text(), '" + badge_series_name + "')]", wait: 2).click
    click_link 'Add badge'
    fill_in 'badge_name', with: badge_name
    fill_in 'badge_display_name', with: badge_name + '_Display_Name'
    fill_in 'badge_description', with: badge_name + '_Description'
    # Add New Image
    find(:xpath, "//button[@id='multiple-media-add-button']", wait: 2).click
    find(:xpath, "//div[@id='medium-upload-wrapper']//input[@name='file']", wait: 2).set(File.absolute_path('./lib/data/badges/volcano.png'))
    sleep 3
    fill_in '_ignore[key]', with: 'Badge_Key'
    fill_in '_ignore[display_name]', with: 'Badge_Display_Name'
    click_link_or_button 'media-modal-save'
    fill_in 'badge_badge_rules_attributes_0_value', with: '3'
    find(:id, 'badge_badge_rules_attributes_0_event_type', wait: 2).click
    find(:xpath, "//select[@id='badge_badge_rules_attributes_0_event_type']/option[@value='Post']", wait: 2).click
    find(:id, 'badge_badge_rules_attributes_0_action_type', wait: 2).click
    find(:xpath, "//select[@id='badge_badge_rules_attributes_0_action_type']/option[@value='Events']", wait: 2).click
    fill_in 'badge_points', with: '10'
    fill_in 'badge_instructions', with: 'Badge instructions'
    status = find(:id, 'badge_status', wait: 2)
    status.click unless status.checked?
    find(:xpath, "//a[contains(text(), 'Save')]", wait: 2).click
  end

  def modify_badge(badge_series_name, badge_name)
    find(:xpath, "//tr[@class='item']//a//dt[contains(text(), '" + badge_series_name + "')]", wait: 2).click
    find(:xpath, "//tr[@class='item_table_row_badge']//a//dt[contains(text(), '" + badge_name + "')]", wait: 2).click
    fill_in 'badge_badge_rules_attributes_0_value', with: '4'
    find(:xpath, "//a[contains(text(), 'Save')]", wait: 2).click
  end

  def delete_badge(badge_series_name, badge_name)
    find(:xpath, "//tr[@class='item']//a//dt[contains(text(), '" + badge_series_name + "')]", wait: 2).click
    find(:xpath, "//tr[@class='item_table_row_badge']//a//dt[contains(text(), '" + badge_name + "')]", wait: 2).click
    click_link_or_button 'Delete badge'
    find(:xpath, "//div[@class='delete_overlay']//a[@class='primary_button del_button' and contains(text(), 'Delete')]", wait: 2).click
  end
end
