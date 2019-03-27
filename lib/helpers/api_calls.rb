module ApiCalls

  def execute_api(url, method = 'get', payload = nil, headers = nil)
    case method
      when 'get'
        RestClient.get(url)
      when 'post'
        RestClient.post(url, payload, headers)
      else
        puts "Invalid method for API call"
    end
  end

  def purchase_via_api(customer_email)
    url = "https://" + $driver.environment + ".500friends.com/api/record.json?uuid=d01714e04c5f13&email=" +
        CGI.escape(customer_email) + "&type=purchase&value=20&event_id=" + Time.now.to_i.to_s +
        "&brand=Nearsoft&channel=qa&sub_channel=automation"
    execute_api url
  end

  def reward_redeem_via_api(customer_email, reward_id)
    url = "https://" + $driver.environment + ".500friends.com/api/reward_redeem.json?uuid=d01714e04c5f13&email=" +
        CGI.escape(customer_email) + "&reward_id=" + reward_id.to_s
    execute_api url
  end

end