module CustomUtils
  # utils methods

  def convert_to_loyalty_name_convention(name)
    name.tr('_', ' ').split.map(&:capitalize).join(' ')
  end

  def drag_time_slider_to_right(elem, times = 1)
    times.times do
      page.driver.browser.action.drag_and_drop_by(elem.native, 7, 0).perform
    end
  end

  def drag_time_slider_to_left(elem, times = 1)
    page.driver.browser.action.drag_and_drop_by(elem.native, -7, 0).perform
  end

  def time_to_next_half_hour(time)
    array = time.to_a
    half = ((array[1] % 60) / 30.0).ceil
    array[1] = (half * 30) % 60
    Time.local(*array) + (half == 2 ? 3600 : 0)
  end
end


