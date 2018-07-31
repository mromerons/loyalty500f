module LoginPage
  include Capybara::DSL

  def login(username, password)
    # input_username = 'user_session_email'
    # input_password_blur = "//input[@id='password_blur']"
    # input_password = 'user_session_password'
    # btn_sign_in = 'sign_in'

    # binding.pry
    # input_username = find(:id, 'user_session_email', wait: 2)
    # input_password_blur = find(:xpath, "//input[@id='password_blur']", wait: 2)
    # input_password = find(:id, 'user_session_password', wait: 2)
    # btn_sign_in = find(:id, 'sign_in', wait: 2)
    #
    # fill_in input_username, with: username.to_s
    # #find(:xpath, input_password_blur).click
    # input_password_blur.click
    # fill_in input_password, with: password.to_s
    # #click_link_or_button btn_sign_in
    # btn_sign_in.click

    fill_in 'user_session_email', with: username.to_s
    find(:xpath, "//input[@id='password_blur']").click
    fill_in 'user_session_password', with: password.to_s
    click_link_or_button 'sign_in'
  end

end

