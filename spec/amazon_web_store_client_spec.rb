headers = {}
headers['x-amz-pay-idempotency-key'] = SecureRandom.uuid.to_s.gsub(/-/, '')

charge_permission_id = '' # Enter Charge Permission ID
buyer_token = '' # Enter Buyer Token
config = Config.get_config

client = AmazonPay::AmazonWebStoreClient.new(config)

checkout_session_id = ''
charge_id = ''
refund_id = ''

create_checkout_session_payload = {
  webCheckoutDetails: {
    checkoutReviewReturnUrl: 'https://localhost/maxo/checkoutReview',
    checkoutResultReturnUrl: 'https://localhost/maxo/checkoutReturn'
  },
  storeId: config[:store_id] || '' # Enter Store ID
}

update_checkout_session_payload = {
  paymentDetails: {
    paymentIntent: 'Confirm',
    chargeAmount: {
      amount: 50,
      currencyCode: config[:currency_code]
    }
  },
  merchantMetadata: {
    merchantReferenceId: SecureRandom.uuid.to_s.gsub(/-/, ''),
    merchantStoreName: 'Test Shop US',
    noteToBuyer: 'Thank you for your order!'
  }
}

complete_checkout_session_payload = {
  chargeAmount: {
    amount: 50,
    currencyCode: config[:currency_code]
  }
}

update_charge_permission_payload = {
  merchantMetadata: {
    merchantReferenceId: SecureRandom.uuid.to_s.gsub(/-/, ''),
    merchantStoreName: 'Test Shop EU',
    noteToBuyer: 'Thank you for your order!',
    customInformation: 'Custom Info'
  }
}

close_charge_permission_payload = {
  closureReason: 'All actions completed',
  cancelPendingCharges: false
}

create_charge_payload = {
  chargePermissionId: charge_permission_id,
  chargeAmount: {
    amount: '0.01',
    currencyCode: config[:currency_code]
  },
  captureNow: false,
  canHandlePendingAuthorization: false
}

capture_charge_payload = {
  captureAmount: {
    amount: '0.01',
    currencyCode: config[:currency_code]
  },
  softDescriptor: 'AMZN'
}

cancel_charge_payload = {
  cancellationReason: 'Cancelling Charge Test'
}

RSpec.describe 'WebStore Client Test Cases - Checkout Session APIs' do
  before do
    if create_checkout_session_payload[:storeId].empty?
      skip 'Please provide storeId in the payload before executing these test cases'
    end
  end

  expected_response = {
    checkoutSessionId: '',
    webCheckoutDetails: '',
    productType: '',
    paymentDetails: '',
    chargePermissionType: '',
    recurringMetadata: '',
    checkoutType: '',
    merchantMetadata: '',
    supplementaryData: '',
    buyer: '',
    billingAddress: '',
    paymentPreferences: '',
    statusDetails: '',
    shippingAddress: '',
    platformId: '',
    chargePermissionId: '',
    chargeId: '',
    constraints: '',
    creationTimestamp: '',
    expirationTimestamp: '',
    storeId: '',
    providerMetadata: '',
    releaseEnvironment: '',
    deliverySpecifications: ''
  }

  it 'Validating Get Buyer API' do
    result = client.get_buyer(buyer_token: buyer_token, headers: headers)
    expect(result[:buyerId]).to start_with('amzn1.account.')
  end

  it 'Validating Create Checkout Session API' do
    result = client.create_checkout_session(payload: create_checkout_session_payload, headers: headers)
    result = result.transform_keys(&:to_sym)
    checkout_session_id = result[:checkoutSessionId]
    expect(result.keys).to eq(expected_response.keys)
  end

  it 'Validating Get Checkout Session API' do
    result = client.get_checkout_session(checkout_session_id: checkout_session_id, headers: headers)
    result = result.transform_keys(&:to_sym)
    expect(result.keys).to eq(expected_response.keys)
  end

  it 'Validating Update Checkout Session API' do
    result = client.update_checkout_session(checkout_session_id: checkout_session_id, payload: update_checkout_session_payload, headers: headers)
    result = result.transform_keys(&:to_sym)
    expect(result.keys).to eq(expected_response.keys)
  end

  it 'Validating Complete Checkout Session API' do
    result = client.update_checkout_session(checkout_session_id: checkout_session_id, payload: complete_checkout_session_payload, headers: headers)
    result = result.transform_keys(&:to_sym)
    expect(result.keys).to eq(expected_response.keys)
  end
end

RSpec.describe '' do
  before do
    skip 'Please provide charge_permission_id before executing these test cases' if charge_permission_id.empty?
  end

  describe 'WebStore Client Test Cases - Charge Permission APIs' do
    expected_response = {
      chargePermissionId: '',
      chargePermissionReferenceId: '',
      platformId: '',
      buyer: '',
      shippingAddress: '',
      billingAddress: '',
      paymentPreferences: '',
      statusDetails: '',
      creationTimestamp: '',
      expirationTimestamp: '',
      merchantMetadata: '',
      releaseEnvironment: '',
      limits: '',
      presentmentCurrency: ''
    }

    it 'Validating Get Charge Permission API' do
      result = client.get_charge_permission(charge_permission_id: charge_permission_id, headers: headers)
      result = result.transform_keys(&:to_sym)
      expect(result.keys).to eq(expected_response.keys)
    end

    it 'Validating Update Charge Permission API' do
      result = client.update_charge_permission(charge_permission_id: charge_permission_id, payload: update_charge_permission_payload, headers: headers)
      result = result.transform_keys(&:to_sym)
      expect(result.keys).to eq(expected_response.keys)
    end

    it 'Validating Close Charge Permission API' do
      result = client.close_charge_permission(charge_permission_id: charge_permission_id, payload: close_charge_permission_payload, headers: headers)
      result = result.transform_keys(&:to_sym)
      expect(result.keys).to eq(expected_response.keys)
    end
  end
end

RSpec.describe 'WebStore Client Test Cases - Charge APIs' do
  before do
    skip 'Please provide charge_permission_id before executing these test cases' if charge_permission_id.empty?
  end
  expected_response = {
    chargeId: '',
    chargeAmount: '',
    chargePermissionId: '',
    captureAmount: '',
    refundedAmount: '',
    softDescriptor: '',
    providerMetadata: '',
    statusDetails: '',
    creationTimestamp: '',
    expirationTimestamp: '',
    releaseEnvironment: ''
  }
  it 'Validating Create Charge API' do
    result = client.create_charge(payload: create_charge_payload, headers: headers)
    charge_id = result[:chargeId]
    result = result.transform_keys(&:to_sym)
    expect(result.keys).to eq(expected_response.keys)
  end

  it 'Validating Get Charge API' do
    result = client.get_charge(charge_id: charge_id, headers: headers)
    result = result.transform_keys(&:to_sym)
    expect(result.keys).to eq(expected_response.keys)
  end

  it 'Validating Capture Charge API' do
    charge_headers = {}
    charge_headers['x-amz-pay-idempotency-key'] = SecureRandom.uuid.to_s.gsub(/-/, '')
    result = client.capture_charge(charge_id: charge_id, payload: capture_charge_payload, headers: charge_headers)
    result = result.transform_keys(&:to_sym)
    expect(result.keys).to eq(expected_response.keys)
  end

  # Cannot Run both Capture charge and Cancel charge at same time, Run either Capture Capture or Cancel Charge
  xit 'Validating Cancel Charge API' do
    result = client.cancel_charge(charge_id: charge_id, payload: cancel_charge_payload, headers: headers)
    result = result.transform_keys(&:to_sym)
    expect(result.keys).to eq(expected_response.keys)
  end
end

RSpec.describe 'WebStore Client Test Cases - Refund APIs' do
  before do
    skip 'Please Enter charge_permission_id and execute test cases' if charge_permission_id.empty?
  end

  headers = {}
  headers['x-amz-pay-idempotency-key'] = SecureRandom.uuid.to_s.gsub(/-/, '')

  expected_response = {
    refundId: '',
    chargeId: '',
    creationTimestamp: '',
    refundAmount: '',
    statusDetails: '',
    softDescriptor: '',
    releaseEnvironment: ''
  }

  it 'Validating Create Refund API' do
    refund_paylod = {
      chargeId: charge_id,
      refundAmount: {
        amount: '0.01',
        currencyCode: config[:currency_code]
      },
      softDescriptor: 'SOFT_DESCRIPTOR'
    }
    result = client.create_refund(payload: refund_paylod, headers: headers)
    refund_id = result[:refundId]
    result = result.transform_keys(&:to_sym)
    expect(result.keys).to eq(expected_response.keys)
  end

  it 'Validating Get Refund API' do
    result = client.get_refund(refund_id: refund_id, headers: headers)
    result = result.transform_keys(&:to_sym)
    expect(result.keys).to eq(expected_response.keys)
  end
end
