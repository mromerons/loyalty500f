module AdminPage
  include Capybara::DSL

  def find_account(account_name)
    navigate_admin
    find(:xpath, "//section[@id='primary']/div/h1[normalize-space()='Accounts']", wait: 2)
    click_link account_name
  end
end
