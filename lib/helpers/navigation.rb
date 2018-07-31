module Navigation
  # navigation helpers methods

  def pause_for(seconds)
    return if seconds == 0
    puts "[PAUSE WARNING] I have to pause due slow page for #{seconds}"
    sleep(seconds)
  end

  def browser_back
    page.evaluate_script('window.history.back()')
    pause_for 2
  end

  def browser_forward
    page.evaluate_script('window.history.forward()')
  end

  def browser_refresh
    page.evaluate_script('window.location.reload()')
  end

  def click_by_alt(alt)
    find(:xpath, "//img[contains(@alt, '#{alt}')]").click
    self
  end

  def click_similar_link_by_index_partial(linkName, index)
    all(:link, linkName, exact: false)[index].click
  end

  def click_similar_link_by_index(linkName, index)
    all(:link, linkName)[index].click
  end

  def click_similar_link_by_last(linkName)
    all(:link, linkName).last
  end

  def click_similar_button_by_last(buttonId)
    all(:button, buttonId).last.click
  end

  def click_similar_button_by_index(buttonId, index)
    all(:button, buttonId)[index].click
  end

  def select_from_dropdown(option, class_name_id)
    select(option, :from => class_name_id)
  end

  def click_input_by_value(value)
    pause_for 1
    execute_script("$(\"input[value='#{value}']\").trigger(\"click\");")
  end

  def click_on_plain_text(by_tag, text)
    pause_for 3
    execute_script("$(\"#{by_tag}:contains('#{text}')\").trigger(\"click\"); ")
  end

  def click_on_plain_text_first(by_tag, text)
    execute_script("$(\"#{by_tag}:contains('#{text}'):first\").trigger(\"click\"); ")
  end

  def click_on_plain_text_by_index(by_tag, text, index)
    execute_script("$(\"#{by_tag}:contains('#{text}')\").eq(#{index}).trigger(\"click\"); ")
  end

  def click_on_element_via_free_jquery(locator)
    execute_script("#{locator}.trigger(\"click\"); ")
  end

  def checked_by_name?(name)
    find(:xpath, "//input[@name='#{name}']").checked?
  end

  def checked_by_value?(value)
    find(:xpath, "//input[@value='#{value}']").checked?
  end

  def fill_form_js_by_id(id, value)
    execute_script("$(\"##{id}\").focus().val('#{value}').keyup()")
  end

  def wait_element_run_command(web_element, command_code, seconds)
    for i in 0..seconds
      if body.include?(web_element)
        puts "Waiting #{web_element} to appear #{i} seconds"
        pause_for 1
      else
        puts "It took #{i} seconds to find #{web_element}"
        eval command_code
        break
      end
    end
  end

  def wait_element(web_element, seconds)
    for i in 0..seconds
      if body.include?(web_element)
        puts "Waiting #{web_element} to appear #{i} seconds"
        pause_for 1
      else
        puts "It took #{i} seconds to find #{web_element}"
        break
      end
    end
  end

  def wait_for_css_selector(selector, seconds)
    i = 1
    seconds.times do |secs|
      if has_css? selector
        return true
      else
        break if i >= Capybara.default_max_wait_time
        puts "Waiting #{selector} to appear #{i} seconds"
        i += 1
        pause_for 1
      end
    end
    false
  end

  def wait_for(kind, locator, seconds)
    for i in 0..seconds
      element = first(kind, locator)
      if element.nil?
        puts "Waiting #{locator} to appear #{i} seconds"
        pause_for 1
      else
        puts "It took #{i} seconds to find #{locator}"
        return true
      end
    end
    false
  end

  def wait_for_no(kind, locator, seconds)
    for i in 0..seconds
      element = first(kind, locator)
      pause_for 1
      if element.nil?
        puts "It took #{i} seconds to hide #{locator}"
        return true
      else
        puts "Waiting #{locator} to hide #{i} seconds"
      end
    end
    false
  end

  def wait_for_content(content, seconds)
    for i in 0..seconds
      if !has_content?(content, wait: seconds)
        puts "Waiting content '#{content}' to appear #{i} seconds"
        pause_for 1
      else
        puts "It took #{i} seconds to find '#{content}'"
        return true
      end
    end
    false
  end

  def drag_drop(draggable, x_offset, y_offset)
    page.driver.browser.action.drag_and_drop_by(draggable.native, x_offset, y_offset).perform
  end

  # Capybara will wait for the element to appear before trying to click. Note that match: :first is more brittle, because it will silently click on a different element if you introduce new elements which match.
  def click_first_element(element)
    # If you just want the first element
    page.find(element, match: :first).click
  end

  def scroll_bottom_page
    page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
  end

  def close_and_switch_window
    # page.driver.browser.close
    session.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
  end

  def close_and_switch_tab
    handle = page.driver.find_window(page.title)
    page.driver.browser.switch_to.window(handle)
    # close current tab
    page.driver.browser.close
    # switch to last tab
    last_handle = page.driver.browser.window_handles.last
    page.driver.browser.switch_to.window(last_handle)
  end

  def check_all_elements_in_array(array)
    array.each do |value|
      check(value)
    end
  end

  def uncheck_all_elements_in_array(array)
    array.each do |value|
      uncheck(value)
    end
  end
end

def select_from_custom_dropdown(id, item)
  field = "//div[@id='#{id}']"
  i = 0
  while first(:xpath, field + '//input').nil? && i<5
    find(:xpath, field+"//a").click
    i+=1
    pause_for 1
  end
  find(:xpath, field + '//input').set item
  find(:xpath, field + "//em[contains(text(), '#{item}')]").click
end

def select_from_custom_dropdown_without_search(id, item)
  field = "//div[@id='#{id}']"
  find(:xpath, field).click
  pause_for 1
  find(:xpath, field + "//li[contains(text(), '#{item}')]").click
end

def switch_to_window(handle)
  raise Capybara::NotSupportedByDriverError, 'Capybara::Driver::Base#switch_to_window'
end

def windows
  driver.window_handles.map do |handle|
    Window.new(self, handle)
  end
end

def point_to_first_window
  pause_for 2
  switch_to_window(windows.first)
  pause_for 2
  #age.driver.browser.window_handles.first
  #Capybara.current_session.driver.browser.switch_to.default_content
end

def point_to_last_window
  pause_for 2
  switch_to_window(windows.last)
  pause_for 2
  #page.driver.browser.window_handles.last
  #page.driver.browser.switch_to().window(page.driver.browser.window_handles.last)
end

def scroll_to_bottom
  execute_script 'window.scrollBy(0,10000)'
end

def switch_to_iframe(id)
  Capybara.current_session.driver.browser.switch_to.frame(id)
end

def in_browser(name, opts={})
  opts[:keep_browser_open] = true        unless opts.has_key? :keep_browser_open

  if (new_host = get_host_from_driver(name))
    old_host = Capybara.app_host
    Capybara.app_host = new_host
  end
  old_session = Capybara.session_name
  Capybara.session_name = name

  begin
    yield
  ensure
    Capybara.current_session.driver.quit    if opts[:keep_browser_open] == false
    Capybara.session_name = old_session
    Capybara.app_host = old_host if new_host
  end
end

def in_csa_portal(opts={})#(username, password) <- implement it if needed
  # quick wrapper to avoid include visit, browser_max and
  # common and repeated lines
  aggregate_failures do
    in_browser(:csa, opts) do
      visit '/'                   #
      browser_maximize            #
      login_into_csa_application  #
      yield   if block_given?
    end
  end
end

def in_provider_portal(username, password, opts={})
  # quick wrapper to avoid include visit, browser_max and
  # common and repeated lines
  opts[:nuke_system_alerts] = true        unless opts.has_key? :nuke_system_alerts

  aggregate_failures do
    in_browser(:provider_portal, opts) do
      visit '/'
      browser_maximize
      FrontEndMainPageObject.new
          .sign_in(username, password, opts[:nuke_system_alerts])
      yield   if block_given?
    end
  end
end

def in_patient_portal(username, password, opts={})
  # quick wrapper to avoid include visit, browser_max and
  # common and repeated lines
  opts[:nuke_system_alerts] = true        unless opts.has_key? :nuke_system_alerts

  aggregate_failures do
    in_browser(:patient_portal, opts) do
      visit '/'
      browser_maximize
      FrontEndMainPageObject.new
          .sign_in(username, password, opts[:nuke_system_alerts])
      yield   if block_given?
    end
  end
end

def get_host_from_driver(name)
  begin
    $driver.webhost_for(environment: $driver.environment, app: name)
  rescue StandardError => e
    nil
  end
end

def reset_capybara_sessions
  Capybara.reset_sessions!
  Capybara.current_session.driver.quit
end

def refresh_browser
  visit(current_path)
end

def get_row_having_text(text='', css_selector='.table-bordered.table')
  # returns a row object of the first row having
  # the specified text
  rows = find(css_selector).all('tr').map{ |tr|  tr.text }
  row_text = rows.select{|row| row.include? text}.first
  row_idx = rows.index(row_text)
  find(css_selector).all('tr')[row_idx]   unless row_idx.nil?
end

def get_row_having_text_at_specific_column(text='', column_id=-1, css_selector='.table-bordered.table')
  # returns a row object of the first row having
  # with a specific text in a specific column position
  columns = find(css_selector).all('tr').map{ |tr| tr.text.split[column_id.to_i].downcase }
  row_idx = columns.index(text.downcase)
  find(css_selector).all('tr')[row_idx]   unless row_idx.nil?
end

def get_first_row(css_selector='.table-bordered.table')
  find(css_selector).all('tr')[1]
end

def js_click(elem)
  # clicks an element (Capybara's node) by using javascript  instead of
  # actions of capybara like "click", "send_keys :return", etc
  # usage:
  # js_click(find(:id, 'submit'))
  page.driver.browser.execute_script('arguments[0].click()', elem.native)
end

def js_set_attribute(elem, attr, value)
  page.driver.browser.execute_script("arguments[0].setAttribute('#{attr}', '#{value}')", elem.native)
end