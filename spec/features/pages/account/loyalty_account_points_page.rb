module PointsPage
  include Capybara::DSL

  def add_points_rule(name)
    click_link 'Add new rule'
    fill_in 'point_rule_event_type', with: name + '_Type'
    fill_in 'point_rule_description', with: name + '_Definition'
    fill_in 'point_rule_display_detail', with: name + '_Detail'
    find(:id, 'fixed', wait: 2).click
    fill_in 'point_rule_value_fixed', with: '3'
    find(:id, 'point_rule_manual_event_recording', wait: 2).click
    # find(:id, 'point_rule_active', wait: 2).click
    status = find(:id, 'point_rule_active', wait: 2)
    status.click unless status.checked?
    click_link_or_button 'Save'
  end

  def modify_points_rule(name)
    find(:xpath, "//a/dt[contains(text(), '" + name + "')]", wait: 2).click
    find(:id, 'fixed', wait: 2).click
    fill_in 'point_rule_value_fixed', with: '5'
    click_link_or_button 'Save'
  end

  def delete_points_rule(name)
    find(:xpath, "//a/dt[contains(text(), '" + name + "')]", wait: 2).click
    click_link_or_button 'Delete this rule'
    find(:xpath, "//a[@class='primary_button del_button' and contains(text(), 'Delete')]", wait: 2).click
  end
end

