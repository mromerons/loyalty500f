module SegmentsPage
  include Capybara::DSL

  def add_segment(name)
    click_link 'Add new segment'
    fill_in 'segment_name', with: name
    fill_in 'segment_description', with: name + '_Description'
    find(:id, 'segment_all_condition', wait: 2).click
    find(:xpath, "//select[@id='segment_all_condition']/option[1]", wait: 2).click
    find(:id, 'segment_segment_rules_attributes_0_variable', wait: 2).click
    find(:xpath, "//select[@id='segment_segment_rules_attributes_0_variable']//option[@value='customer.tier']", wait: 2).click
    find(:id, 'segment_segment_rules_attributes_0_operator', wait: 2).click
    find(:xpath, "//select[@id='segment_segment_rules_attributes_0_operator']//option[@value='eq']", wait: 2).click
    fill_in 'segment_segment_rules_attributes_0_value', with: 'AutoTestTier'
    # find(:id, 'segment_status', wait: 2).click
    status = find(:id, 'segment_status', wait: 2)
    status.click unless status.checked?
    click_link_or_button 'Save'
  end

  def update_segment(name)
    find(:xpath, "//a[@class='item' and contains(@href, '/edit')]//dt[normalize-space(text()) = '" + name + "']", wait: 2).click
    fill_in 'segment_description', with: name + '_Description_Updated'
    click_link_or_button 'Save'
  end

  def delete_segment(name)
    find(:xpath, "//a[@class='item' and contains(@href, '/edit')]//dt[normalize-space(text()) = '" + name + "']", wait: 2).click
    click_link_or_button 'Delete segment'
    find(:xpath, "//div[@class='delete_overlay']//a[@class='primary_button del_button' and contains(text(), 'Delete')]", wait: 2).click
  end

  def preview_customers_in_segment
    find(:xpath, "//a[@class='secondary_button preview_page']", wait: 2).click
    within_frame find(:id, 'preview', wait: 2) do
      has_text? 'Preview of Segment'
    end
  end

  def open_segment(name)
    find(:xpath, "//a[@class='item' and contains(@href, '/edit')]//dt[normalize-space(text()) = '" + name + "']", wait: 2).click
  end

  def close_segment_preview
    within_frame find(:id, 'preview', wait: 2) do
      click_link_or_button 'Close'
    end
  end

  def verify_customer_belongs_to_segment(customer)
    customer_found =
      within_frame find(:id, 'preview', wait: 2) do
        find(:xpath, "//div[@id='data_area']/table/tbody/tr/th", wait: 2).text
      end
    customer_found.eql? customer
  end
end