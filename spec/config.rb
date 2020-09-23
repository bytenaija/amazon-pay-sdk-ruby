module Config
  def self.get_config
    {
      'public_key_id': '', # Enter your Public Key ID
      'private_key': File.read(File.expand_path('tst/private.pem', __dir__)), # Path to your private key file or replace with your private key string
      'region': 'us',
      'sandbox': true,
      'currency_code': 'USD',
      'country_code': 'US',
      'store_id': ''
    }
  end
end
