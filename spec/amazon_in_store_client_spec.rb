# rubocop:disable Metrics/BlockLength

config = Config.get_config

client = AmazonPay::AmazonInStoreClient.new(config)
charge_permission_id = '' # Enter Charge Permission ID
charge_id = ''

merchant_scan_payload = {
  scanData: 'UKhrmatMeKdlfY6b',
  scanReferenceId: SecureRandom.uuid.to_s.gsub(/-/, ''),
  merchantCOE: config[:country_code],
  ledgerCurrency: config[:currency_code],
  storeLocation: {
    countryCode: config[:country_code]
  },
  metadata: {
    merchantNote: 'Software Purchase',
    customInformation: 'in-store Software Purchase',
    communicationContext: {
      merchantStoreName: 'TESTSTORE',
      merchantOrderId: '789123'
    }
  }
}

merchant_scan_expected_response = {
  chargePermissionId: ''
}

charge_expected_response = {
  chargeId: '',
  chargeStatus: {
    state: 'Completed'
  }
}

refund_expected_response = {
  refundId: '',
  refundStatus: {
    state: 'Pending'
  }
}

RSpec.describe 'InStore Client Test Cases' do
  it 'Validating Merchant Scan API' do
    headers = {}
    headers['x-amz-pay-idempotency-key'] = SecureRandom.uuid.to_s.gsub(/-/, '')
    result = client.merchant_scan(payload: merchant_scan_payload, headers: headers)
    charge_permission_id = result[:chargePermissionId]
    result = result.transform_keys(&:to_sym)
    expect(result.keys).to eq(merchant_scan_expected_response.keys)
  end

  it 'Validating Charge API' do
    headers = {}
    headers['x-amz-pay-idempotency-key'] = SecureRandom.uuid.to_s.gsub(/-/, '')
    charge_payload = {
      chargePermissionId: charge_permission_id,
      chargeReferenceId: SecureRandom.uuid.to_s.gsub(/-/, ''),
      chargeTotal: {
        currencyCode: config[:currency_code],
        amount: 2
      },
      softDescriptor: 'amzn-store'
    }
    result = client.charge(payload: charge_payload)
    charge_id = result[:chargeId]
    result = result.transform_keys(&:to_sym)
    expect(result.keys).to eq(charge_expected_response.keys)
  end

  it 'Validating Refund API' do
    headers = {}
    headers['x-amz-pay-idempotency-key'] = SecureRandom.uuid.to_s.gsub(/-/, '')
    refund_payload = {
      chargeId: charge_id,
      refundReferenceId: SecureRandom.uuid.to_s.gsub(/-/, ''),
      refundTotal: {
        currencyCode: config[:currency_code],
        amount: 2
      },
      softDescriptor: 'amzn-store'
    }
    result = client.refund(payload: refund_payload)

    result = result.transform_keys(&:to_sym)
    expect(result.keys).to eq(refund_expected_response.keys)
  end
end
