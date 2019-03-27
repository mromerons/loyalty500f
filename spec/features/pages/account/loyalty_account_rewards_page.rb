module RewardsPage
  include Capybara::DSL

  def add_reward(name)
    click_link 'Add new reward'
    fill_in 'reward_name', with: name # + '_Name'
    fill_in 'reward_display_name', with: name + '_Display_Name'
    fill_in 'reward_description', with: name + '_Description'
    find(:xpath, "//div[@id='reward_image_url']//input[@name='file']", wait: 2).set(File.absolute_path('./lib/data/reward.png'))
    sleep 5
    fill_in 'reward_points', with: '30'
    fill_in 'reward_instructions', with: name + '_Redemption_Instructions'
    status = find(:id, 'reward_status', wait: 2)
    status.click unless status.checked?
    click_link_or_button 'Save'
  end

  def modify_reward(name)
    find(:xpath, "//a/dt[contains(text(), '" + name + "')]", wait: 2).click
    fill_in 'reward_points', with: '35'
    click_link_or_button 'Save'
  end

  def delete_reward(name)
    find(:xpath, "//a/dt[contains(text(), '" + name + "')]", wait: 2).click
    click_link_or_button 'Delete Reward'
    find(:xpath, "//div[@class='delete_overlay']//a[@class='primary_button del_button' and contains(text(), 'Delete')]", wait: 2).click
  end

  def open_reward(name)
    find(:xpath, "//a/dt[contains(text(), '" + name + "')]", wait: 2).click
  end

  def select_redemption_communication(reward_email)
    find(:id, 'reward_email_id', wait: 2).click
    find(:xpath, "//select[@id='reward_email_id']/option[text()='" + reward_email + "']", wait: 2).click
  end

  def save_reward_changes
    click_link_or_button 'Save'
  end
end
