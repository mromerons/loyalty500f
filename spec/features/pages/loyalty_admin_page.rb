module AdminPage
  include Capybara::DSL

  def find_account(account_name)
    navigate_admin
    click_link account_name
  end
end
