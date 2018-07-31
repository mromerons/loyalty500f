module TiersPage
  include Capybara::DSL

  def add_tier(name)
    click_link 'Add new tier'
    fill_in 'tier_name', with: name # + '_Name'
    fill_in 'tier_description', with: name + '_Description'
    fill_in 'tier_display_detail', with: name + '_Display_Detail'
    find(:xpath, "//div[@id='tier_tier_url']//input[@name='file']", wait: 2).set(File.absolute_path('./lib/data/tiers/mercury.png'))
    sleep 5
    fill_in 'tier_tier_rules_attributes_0_value', with: '3'
    find(:id, 'tier_tier_rules_attributes_0_event_type', wait: 2).click
    find(:xpath, "//select[@id='tier_tier_rules_attributes_0_event_type']/option[@value='Post']", wait: 2).click
    fill_in 'tier_points', with: 10
    status = find(:id, 'tier_status', wait: 2)
    status.click unless status.checked?
    click_link_or_button 'Save'
  end

  def modify_tier(name)
    find(:xpath, "//tr[@class='item']//a//dt[contains(text(), '" + name + "')]", wait: 2).click
    fill_in 'tier_points', with: '15'
    click_link_or_button 'Save'
  end

  def delete_tier(name)
    find(:xpath, "//tr[@class='item']//a//dt[contains(text(), '" + name + "')]", wait: 2).click
    click_link_or_button 'Delete tier'
    find(:xpath, "//div[@class='delete_overlay']//a[@class='primary_button del_button' and contains(text(), 'Delete')]", wait: 2).click
  end
end
