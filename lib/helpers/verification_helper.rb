# require 'rspec/expectations'

module VerificationHelpers
  #include Capybara::DSL
  #include RSpec::Matchers

  def verify_content(expected_content)
    expect(page).to have_content expected_content
  end

  def verify_no_content(expected_content)
    expect(page).not_to have_content expected_content
  end

  def verify_content_by_xpath(expected_xpath)
    expect(page).to have_xpath expected_xpath
  end

  def verify_no_content_by_xpath(expected_xpath)
    expect(page).not_to have_xpath expected_xpath
  end
end
