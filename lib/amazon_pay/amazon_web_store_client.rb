# rubocop:disable Metrics/ClassLength

module AmazonPay
  # Class for Amazon Web Store
  class AmazonWebStoreClient < AmazonPayClient
    def initialize(config_args)
      super(config_args)
    end

    #  API to get the Buyer Hash
    #       - Get Buyer details can include buyer ID, name, email address, postal code,
    #         and country code
    #       - when used with the Amazon.Pay.renderButton 'SignIn' productType and corresponding
    #         signInScopes
    #     @param {String} buyer_token - The checkout session Id
    #     @param {Hash} [headers=nil] - The headers for the request

    def get_buyer(buyer_token: nil, headers: nil)
      api_call(options:
        {
          method: 'GET',
          url_fragment: "buyers/#{buyer_token}",
          headers: headers
        })
    end

    #  API to create a CheckoutSession Hash
    #     - Creates a new CheckoutSession Hash.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/checkout-session.html#create-checkout-session
    #   @param {Hash} payload - The payload for the request
    #   @param {Hash} headers - The headers for the request
    def create_checkout_session(payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: 'checkoutSessions',
                 payload: payload,
                 headers: headers
               })
    end

    # API to get the CheckoutSession Hash
    #     - Retrives details of a previously created CheckoutSession Hash.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/checkout-session.html#get-checkout-session
    #   @param {String} checkout_session_id - The checkout session Id
    #   @param {Hash} [headers=nil] - The headers for the request
    def get_checkout_session(checkout_session_id: nil, headers: nil)
      api_call(options: {
                 method: 'GET',
                 url_fragment: "checkoutSessions/#{checkout_session_id}",
                 headers: headers
               })
    end

    # API to update the CheckoutSession Hash
    #     - Updates a previously created CheckoutSession Hash.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/checkout-session.html#update-checkout-session
    #   @param {String} checkout_session_id - The checkout session Id
    #   @param {Hash} payload - The payload for the request
    #   @param {Hash} [headers=nil] - The headers for the request
    def update_checkout_session(checkout_session_id: nil, payload: nil, headers: nil)
      api_call(options: {
                 method: 'PATCH',
                 url_fragment: "checkoutSessions/#{checkout_session_id}",
                 payload: payload,
                 headers: headers
               })
    end

    # API to complete a Checkout Session
    #     - Confirms the completion of buyer checkout.
    #   @see //TODO Update Live URL
    #   @param {String} checkout_session_id - The checkout session Id
    #   @param {Hash} payload - The payload for the request
    #   @param {Hash} [headers=nil] - The headers for the request
    def complete_checkout_session(checkout_session_id: nil, payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: "checkoutSessions/#{checkout_session_id}/complete",
                 payload: payload,
                 headers: headers
               })
    end

    # API to get a ChargePermission Hash
    #     - Retrives details of a previously created ChargePermission Hash.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/charge-permission.html#get-charge-permission
    #   @param {String} charge_permission_id - The charge permission Id
    #   @param {Hash} [headers=nil] - The headers for the request
    def get_charge_permission(charge_permission_id: nil, headers: nil)
      api_call(options: {
                 method: 'GET',
                 url_fragment: "chargePermissions/#{charge_permission_id}",
                 headers: headers
               })
    end

    # API to update a ChargePermission Hash
    #     - Updates a previously created ChargePermission Hash.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/charge-permission.html#update-charge-permission
    #   @param {String} charge_permission_id - The charge permission Id
    #   @param {Hash} payload - The payload for the request
    #   @param {Hash} [headers=nil] - The headers for the request
    def update_charge_permission(charge_permission_id: nil, payload: nil, headers: nil)
      api_call(options: {
                 method: 'PATCH',
                 url_fragment: "chargePermissions/#{charge_permission_id}",
                 payload: payload,
                 headers: headers
               })
    end

    # API to close a ChargePermission Hash
    #     - Closes a perviously created ChargePermission Hash.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/charge-permission.html#close-charge-permission
    #   @param {String} charge_permission_id - The charge permission Id
    #   @param {Hash} payload - The payload for the request
    #   @param {Hash} [headers=nil] - The headers for the request
    def close_charge_permission(charge_permission_id: nil, payload: nil, headers: nil)
      api_call(options: {
                 method: 'DELETE',
                 url_fragment: "chargePermissions/#{charge_permission_id}/close",
                 payload: payload,
                 headers: headers
               })
    end

    # API to create a Charge Hash
    #     - Creates a new Charge Hash.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/charge.html#create-charge
    #   @param {Hash} payload - The payload for the request
    #   @param {Hash} headers - The headers for the request
    def create_charge(payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: 'charges',
                 payload: payload,
                 headers: headers
               })
    end

    # API to get the Charge Hash
    #     - Retrieves a perviously created Charge Hash.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/charge.html#get-charge
    #   @param {String} charge_id - The charge Id
    #   @param {Hash} [headers=nil] - The headers for the request
    def get_charge(charge_id: nil, headers: nil)
      api_call(options: {
                 method: 'GET',
                 url_fragment: "charges/#{charge_id}",
                 headers: headers
               })
    end

    #  API to create a captureCharge request
    #     - Captures an existing charge
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/charge.html#capture-charge
    #   @param {String} charge_id - The charge Id
    #   @param {Hash} payload - The payload for the request
    #   @param {Hash} [headers=nil] - The headers for the request

    def capture_charge(charge_id: nil, payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: "charges/#{charge_id}/capture",
                 payload: payload,
                 headers: headers
               })
    end

    #  API to create a cancelCharge request
    #     - Cancels an existing charge.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/charge.html#cancel-charge
    #   @param {String} charge_id - The charge Id
    #   @param {Hash} payload - The payload for the request
    #   @param {Hash} [headers=nil] - The headers for the request

    def cancel_charge(charge_id: nil, payload: nil, headers: nil)
      api_call(options: {
                 method: 'DELETE',
                 url_fragment: "charges/#{charge_id}/cancel",
                 payload: payload,
                 headers: headers
               })
    end

    #  API to create a Refund Hash
    #       - Generates a refund.
    #     @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/refund.html#create-refund
    #     @param {Hash} payload - The payload for the request
    #     @param {Hash} headers - The headers for the request

    def create_refund(payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: 'refunds',
                 payload: payload,
                 headers: headers
               })
    end

    #  API to get a Refund Hash
    #     - Retreives details of an existing refund.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/refund.html#get-refund
    #   @param {String} refundId - The refund Id
    #   @param {Hash} [headers=nil] - The headers for the request

    def get_refund(refund_id: nil, headers: nil)
      api_call(options: {
                 method: 'GET',
                 url_fragment: "refunds/#{refund_id}",
                 headers: headers
               })
    end
  end
end
