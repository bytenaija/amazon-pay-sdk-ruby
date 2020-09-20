generate_button_signature_payload_object = {
  storeId: 'amzn1.application-oa2-client.a950c92bb0cc4ae08ef395668b702bb9',
  webCheckoutDetails: {
    checkoutReviewReturnUrl: 'https://localhost/test/CheckoutReview',
    checkoutResultReturnUrl: 'https://localhost/test/CheckoutResult'
  }
}
generate_button_signature_payload_string = '{"storeId":"amzn1.application-oa2-client.a950c92bb0cc4ae08ef395668b702bb9","webCheckoutDetails":{"checkoutReviewReturnUrl":"https://localhost/test/CheckoutReview","checkoutResultReturnUrl":"https://localhost/test/CheckoutResult"}}'
generate_button_signature_payload_escaped_string = '{"storeId":"amzn1.application-oa2-client.a950c92bb0cc4ae08ef395668b702bb9","webCheckoutDetails":{"checkoutReviewReturnUrl":"https://localhost/test/CheckoutReview","checkoutResultReturnUrl":"https://localhost/test/CheckoutResult"}}'.dump
expected_string_to_sign = "AMZN-PAY-RSASSA-PSS\n83323e36a31358c997bc9f688d271e78b6df3a495fc3d9fc0506608ae96709e3"
mws_auth_token = '' # Provide public key here to run the tests
merchant_id = '' # Provide merchantId

def verify(signature, data)
  sign_hash = OpenSSL::Digest.new('SHA256')
  priv_key = OpenSSL::PKey::RSA.new(Config.get_config[:private_key])
  pub_key = priv_key.public_key
  signature = Base64.strict_decode64(signature)
  pub_key.verify_pss(sign_hash, signature, data, salt_length: 20, mgf1_hash: 'SHA256')
end

RSpec.describe 'AmazonPay Client Test Cases - Generate Button Signature' do
  before do
    if Config.get_config[:private_key].empty?
      skip 'Enter your  public_key in the config.rb file before running these tests'
    end
  end
  it 'Validating Generate Button Signature Method' do
    client = AmazonPay::AmazonPayClient.new(Config.get_config)

    signature_one = client.generate_button_signature(payload: generate_button_signature_payload_object)
    signature_two = client.generate_button_signature(payload: generate_button_signature_payload_string)
    signature_three = client.generate_button_signature(payload: generate_button_signature_payload_escaped_string)

    expect(verify(signature_one, expected_string_to_sign)).to eq(true)
    expect(verify(signature_two, expected_string_to_sign)).to eq(true)
    expect(verify(signature_three, "AMZN-PAY-RSASSA-PSS\n6e01340a2e88e8cde557ab5855c1ac11c4a6ec12004acfaf9d12403e871ea042")).to eq(true)
  end
end

RSpec.describe 'AmazonPay Client Test Cases - Get Authorization Token' do
  before do
    if mws_auth_token.empty? || merchant_id.empty?
      skip 'Please provide your mws_auth_token and merchant_id before executing these test cases'
    end
  end

  it 'Validating Get Authorization Token API' do
    config = Config.get_config
    config[:sandbox] = false
    client = AmazonPay::AmazonPayClient.new(config)

    result = client.get_authorization_token(mws_auth_token: mws_auth_token, merchant_id: merchant_id)
    puts result
    expect(result[:authorizationToken]).to be_truthy
  end
end
