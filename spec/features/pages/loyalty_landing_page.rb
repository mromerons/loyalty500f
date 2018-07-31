module LandingPage
  include Capybara::DSL

  def logout(username)
    find(:xpath, "//a[@class='options_link' and contains(text(), '" + username.to_s + "')]").hover
    click_link 'Logout'
  end

  # Main Navigation Bar
  def navigate_dashboard
    click_link 'Dashboard'
  end

  def navigate_members
    click_link 'Members'
  end

  def navigate_account
    click_link 'Account'
  end

  def navigate_users
    click_link 'Users'
  end

  def navigate_help
    click_link 'Help'
  end

  def navigate_admin
    click_link 'Admin'
  end


  # Account Navigation Bar
  def navigate_account_profile
    click_link 'Profile'
  end

  def navigate_account_points
    click_link 'Points'
  end

  def navigate_account_rewards
    click_link 'Rewards'
  end

  def navigate_account_tiers
    click_link 'Tiers'
  end

  def navigate_account_badges
    click_link 'Badges'
  end

  def navigate_account_emails
    click_link 'Emails'
  end

  def navigate_account_offers
    click_link 'Offers'
  end

  def navigate_account_segments
    click_link 'Segments'
  end

end


