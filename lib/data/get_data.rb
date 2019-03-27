require 'yaml'

module GetData
  TEST_USERS = YAML.load_file(File.join(Dir.pwd, 'lib', 'data', 'test_users.yml'))
  TEST_ACCOUNTS = YAML.load_file(File.join(Dir.pwd, 'lib', 'data', 'test_accounts.yml'))
  TEST_CUSTOMERS = YAML.load_file(File.join(Dir.pwd, 'lib', 'data', 'test_customers.yml'))

  module_function

  def get_user(param)
    user($driver.environment, param)
  end

  def user(environment, user_type)
    user_hash = TEST_USERS.dig(environment, user_type)
    unless user_hash
      raise KeyError.new("Couldn't find [#{environment}][#{user_type}] in test_users.yml")
    end
    symbolize_keys(user_hash)
  end

  def get_account(param)
    account($driver.environment, param)
  end

  def account(environment, account_type)
    account_hash = TEST_ACCOUNTS.dig(environment, account_type)
    unless account_hash
      raise KeyError.new("Couldn't find [#{environment}][#{account_type}] in test_accounts.yml")
    end
    symbolize_keys(account_hash)
  end

  def get_customer(param)
    customer(param)
  end

  def customer(customer_type)
    customer_hash = TEST_CUSTOMERS.dig(customer_type)
    unless customer_hash
      raise KeyError.new("Couldn't find [#{customer_type}] in test_customers.yml")
    end
    symbolize_keys(customer_hash)
  end

  def symbolize_keys(hash) # change all keys in hash from strings to symbol
    hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  end
end