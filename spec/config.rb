module Config
  def self.get_config
    {
      'public_key_id': '', # Enter your Public Key ID
      'private_key': File.read(File.expand_path('/test/private.pem', __dir__)), # Path to your private key file
      'region': 'us',
      'sandbox': true,
      'currency_code': 'USD',
      'country_code': 'US',
      'store_id': ''
    }
  end
end
