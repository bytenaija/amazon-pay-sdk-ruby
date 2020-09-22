# rubocop:disable Metrics/ClassLength

module AmazonPay
  # Class for Amazon Web Store
  class AmazonWebStoreClient < AmazonPayClient
    def initialize(config_args)
      super(config_args)
    end

    #  API to get the Buyer object
    #       - Get Buyer details can include buyer ID, name, email address, postal code,
    #         and country code
    #       - when used with the Amazon.Pay.renderButton 'SignIn' productType and corresponding
    #         signInScopes
    #     @param {String} buyer_token - The checkout session Id
    #     @param {Object} [headers=nil] - The headers for the request

    def get_buyer(buyer_token: nil, headers: nil)
      api_call(options:
        {
          method: 'GET',
          url_fragment: "buyers/#{buyer_token}",
          headers: headers
        })
    end

    #  API to create a CheckoutSession object
    #     - Creates a new CheckoutSession object.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/checkout-session.html#create-checkout-session
    #   @param {Object} payload - The payload for the request
    #   @param {Object} headers - The headers for the request
    def create_checkout_session(payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: 'checkoutSessions',
                 payload: payload,
                 headers: headers
               })
    end

    # API to get the CheckoutSession object
    #     - Retrives details of a previously created CheckoutSession object.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/checkout-session.html#get-checkout-session
    #   @param {String} checkout_session_id - The checkout session Id
    #   @param {Object} [headers=nil] - The headers for the request
    def get_checkout_session(checkout_session_id: nil, headers: nil)
      api_call(options: {
                 method: 'GET',
                 url_fragment: "checkoutSessions/#{checkout_session_id}",
                 headers: headers
               })
    end

    # API to update the CheckoutSession object
    #     - Updates a previously created CheckoutSession object.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/checkout-session.html#update-checkout-session
    #   @param {String} checkout_session_id - The checkout session Id
    #   @param {Object} payload - The payload for the request
    #   @param {Object} [headers=nil] - The headers for the request
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
    #   @param {Object} payload - The payload for the request
    #   @param {Object} [headers=nil] - The headers for the request
    def complete_checkout_session(checkout_session_id: nil, payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: "checkoutSessions/#{checkout_session_id}/complete",
                 payload: payload,
                 headers: headers
               })
    end

    # API to get a ChargePermission object
    #     - Retrives details of a previously created ChargePermission object.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/charge-permission.html#get-charge-permission
    #   @param {String} charge_permission_id - The charge permission Id
    #   @param {Object} [headers=nil] - The headers for the request
    def get_charge_permission(charge_permission_id: nil, headers: nil)
      api_call(options: {
                 method: 'GET',
                 url_fragment: "chargePermissions/#{charge_permission_id}",
                 headers: headers
               })
    end

    # API to update a ChargePermission object
    #     - Updates a previously created ChargePermission object.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/charge-permission.html#update-charge-permission
    #   @param {String} charge_permission_id - The charge permission Id
    #   @param {Object} payload - The payload for the request
    #   @param {Object} [headers=nil] - The headers for the request
    def update_charge_permission(charge_permission_id: nil, payload: nil, headers: nil)
      api_call(options: {
                 method: 'PATCH',
                 url_fragment: "chargePermissions/#{charge_permission_id}",
                 payload: payload,
                 headers: headers
               })
    end

    # API to close a ChargePermission object
    #     - Closes a perviously created ChargePermission object.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/charge-permission.html#close-charge-permission
    #   @param {String} charge_permission_id - The charge permission Id
    #   @param {Object} payload - The payload for the request
    #   @param {Object} [headers=nil] - The headers for the request
    def close_charge_permission(charge_permission_id: nil, payload: nil, headers: nil)
      api_call(options: {
                 method: 'DELETE',
                 url_fragment: "chargePermissions/#{charge_permission_id}/close",
                 payload: payload,
                 headers: headers
               })
    end

    # API to create a Charge object
    #     - Creates a new Charge object.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/charge.html#create-charge
    #   @param {Object} payload - The payload for the request
    #   @param {Object} headers - The headers for the request
    def create_charge(payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: 'charges',
                 payload: payload,
                 headers: headers
               })
    end

    # API to get the Charge object
    #     - Retrieves a perviously created Charge object.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/charge.html#get-charge
    #   @param {String} charge_id - The charge Id
    #   @param {Object} [headers=nil] - The headers for the request
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
    #   @param {Object} payload - The payload for the request
    #   @param {Object} [headers=nil] - The headers for the request

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
    #   @param {Object} payload - The payload for the request
    #   @param {Object} [headers=nil] - The headers for the request

    def cancel_charge(charge_id: nil, payload: nil, headers: nil)
      api_call(options: {
                 method: 'DELETE',
                 url_fragment: "charges/#{charge_id}/cancel",
                 payload: payload,
                 headers: headers
               })
    end

    #  API to create a Refund object
    #       - Generates a refund.
    #     @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/refund.html#create-refund
    #     @param {Object} payload - The payload for the request
    #     @param {Object} headers - The headers for the request

    def create_refund(payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: 'refunds',
                 payload: payload,
                 headers: headers
               })
    end

    #  API to get a Refund object
    #     - Retreives details of an existing refund.
    #   @see https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/refund.html#get-refund
    #   @param {String} refundId - The refund Id
    #   @param {Object} [headers=nil] - The headers for the request

    def get_refund(refund_id: nil, headers: nil)
      api_call(options: {
                 method: 'GET',
                 url_fragment: "refunds/#{refund_id}",
                 headers: headers
               })
    end
  end
end
