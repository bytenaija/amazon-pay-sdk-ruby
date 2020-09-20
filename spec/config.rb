module Config
  def self.get_config
    {
      'public_key_id': 'AEO4YB57QJUNBB5GHTCIK5E2', # Enter your Public Key ID
      'private_key': File.read(File.expand_path('amzn.pem', __dir__)), # Path to your private key file
      'region': 'us',
      'sandbox': true,
      'currency_code': 'USD',
      'country_code': 'US',
      'store_id': 'amzn1.application-oa2-client.a950c92bb0cc4ae08ef395668b702bb9'
    }
  end
end
