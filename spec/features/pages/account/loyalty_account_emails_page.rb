module EmailsPage
  include Capybara::DSL

  def add_trigger_email(name, trigger, code = nil)
    click_link 'Create new template'
    fill_in 'email_name', with: name
    find(:id, 'select_email_type', wait: 2).click
    find(:xpath, "//select[@id='select_email_type']/option[@value='TransactionalEmail']", wait: 2).click
    find(:id, 'trigger_options', wait: 2).click
    find(:xpath, "//select[@id='trigger_options']/option[@value='" + trigger + "']", wait: 2).click
    fill_in 'email_email_template_attributes_friendly_from', with: 'Automation Account'
    fill_in 'email_email_template_attributes_email_from', with: 'merklensqa@gmail.com'
    fill_in 'email_email_template_attributes_subject', with: trigger.capitalize + (code.nil? ? '' : ' ' + code.to_s)
    fill_in 'email_email_template_attributes_body', with: 'Auto-generated Email. Event type: ' + trigger.capitalize + (code.nil? ? '' : '. Code: ' + code.to_s)
    fill_in 'email_email_template_attributes_body_text', with: 'Auto-generated email. Event type: ' + trigger.capitalize + (code.nil? ? '' : '. Code: ' + code.to_s)
    status = find(:id, 'email_active', wait: 2)
    status.click unless status.checked?
    find(:xpath, "//div/ul/li/a[@class='primary_button save_button' and text()='Save']", wait: 2).click
  end

  def modify_email_subject(name, subject)
    open_email name
    fill_in 'transactional_email_email_template_attributes_subject', with: subject
    click_link_or_button 'Save'
  end

  def delete_email
    click_link_or_button 'Delete email template'
    find(:xpath, "//div[@class='delete_overlay']//a[@class='primary_button del_button' and contains(text(), 'Delete')]", wait: 2).click
  end

  def open_email(name, email_paused = false)
    paused = email_paused ? 'paused_list ' : ''
    find(:xpath, "//ul[@class='email_list " + paused + "vertical']/li/a/dl/dt[normalize-space()='" + name + "']", wait: 2).click
  end

  def verify_email_exist(name, email_paused = false)
    paused = email_paused ? 'paused_list ' : ''
    has_xpath?("//ul[@class='email_list " + paused + "vertical']/li/a/dl/dt[normalize-space()='" + name + "']", wait: 2)
  end

  def verify_email_not_exist(name)
    has_no_xpath?("//ul[@class='email_list vertical']/li/a/dl/dt[normalize-space()='" + name + "']", wait: 2)
  end

  def verify_email_subject(subject)
    has_xpath?("//ul[@class='email_list vertical']/li/a/dl/dd[@class='subject' and normalize-space()='Subject: " + subject + "']", wait: 2)
  end

  def activate_email
    status = find(:id, 'transactional_email_active', wait: 2)
    status.click unless status.checked?
    find(:xpath, "//div/ul/li/a[@class='primary_button save_button' and text()='Save']", wait: 2).click
  end

  def pause_email
    status = find(:id, 'transactional_email_active', wait: 2)
    status.click if status.checked?
    find(:xpath, "//div/ul/li/a[@class='primary_button save_button' and text()='Save']", wait: 2).click
  end

  def send_test_email_to email_address
    click_link_or_button 'Send test email'
    fill_in 'to_emails', with: email_address
    click_link_or_button 'Send Test Email'
  end

  def delete_all_automation_emails
    delete_all_active_automation_emails
    delete_all_paused_automation_emails
  end

  def delete_all_active_automation_emails
    active_emails = find_all(:xpath, "//ul[@class='email_list vertical']/li/a/dl/dt[contains(normalize-space(), 'Auto_')]", wait: 2).count
    while active_emails > 0
      find_all(:xpath, "//ul[@class='email_list vertical']/li/a/dl/dt[contains(normalize-space(), 'Auto_')]", wait: 2).first.click
      delete_email
      active_emails-=1
    end
  end

  def delete_all_paused_automation_emails
    paused_emails = find_all(:xpath, "//ul[@class='email_list paused_list vertical']/li/a/dl/dt[contains(normalize-space(), 'Auto_')]", wait: 2).count
    while paused_emails > 0
      find_all(:xpath, "//ul[@class='email_list paused_list vertical']/li/a/dl/dt[contains(normalize-space(), 'Auto_')]", wait: 2).first.click
      delete_email
      paused_emails-=1
    end
  end
end
