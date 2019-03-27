module LoginPage
  include Capybara::DSL

  def login(username, password)
    fill_in 'user_session_email', with: username.to_s
    find(:xpath, "//input[@id='password_blur']").click
    fill_in 'user_session_password', with: password.to_s
    click_link_or_button 'sign_in'
  end

  def verify_user_name(first_name)
    find(:xpath, "//a[@class='options_link' and text()='" + first_name + "']", wait: 2)
  end

  def verify_account_name
    find(:xpath, "//div[@id='header']/ul/li/a[@class='account_name_tab']", wait: 2)
  end

  def verify_login_form
    find(:id, 'new_user_session', wait: 2)
  end
end

