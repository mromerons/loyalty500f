module RewardsPage
  include Capybara::DSL

  def add_reward(name)
    click_link 'Add new reward'
    fill_in 'reward_name', with: name # + '_Name'
    fill_in 'reward_display_name', with: name + '_Display_Name'
    fill_in 'reward_description', with: name + '_Description'
    # upload an image here
    find(:xpath, "//div[@id='reward_image_url']//input[@name='file']", wait: 2).set(File.absolute_path('./lib/data/reward.png'))
    sleep 5
    fill_in 'reward_points', with: '30'
    fill_in 'reward_instructions', with: name + '_Redemption_Instructions'
    # find(:id, 'reward_status', wait: 2).click
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
end
