require 'amazon_pay/client_helper'

module AmazonPay
  class AmazonPayClient
    def initialize(config_args)
      @config_args = config_args.freeze
    end

    # API to process a request
    # - Makes an API Call using the specified options.
    # @param {Hash} options - The options to make the API Call
    # @param {String} options.method - The HTTP request method
    # @param {String} options.url_fragment - The URI for the API Call
    # @param {String} [options.payload=nil] - The payload for the API Call
    # @param {Hash} [options.headers=nil] - The headers for the API Call
    # @param {Hash} [options.queryParams=nil] - The headers for the API Call

    def api_call(options: {})
      prepared_options = AmazonPay::ClientHelper.prepare_options(config_args: @config_args, options: options)
      prepared_options[:headers] = AmazonPay::ClientHelper.sign_headers(config_args: @config_args, options: prepared_options)
      AmazonPay::ClientHelper.invoke_api(config_args: @config_args, api_options: prepared_options)
    end

    # Signs the request headers
    #       - Signs the request provided and returns the signed headers Hash.
    #     @param {Hash} options - The options to make the API Call
    #     @param {String} options.method - The HTTP request method
    #     @param {String} options.url_fragment - The URI for the API Call
    #     @param {String} [options.payload=nil] - The payload for the API Call
    #     @param {Hash} [options.headers=nil] - The headers for the API Call

    def get_signed_headers(options: {})
      prepared_options = AmazonPay::ClientHelper.prepare_options(@config_args, options)
      AmazonPay::ClientHelper.sign_headers(config_args: @config_args, options: prepared_options)
    end

    #  Lets the solution provider get Authorization Token for their merchants if they are granted the delegation.
    #       - Please note that your solution provider account must have a pre-existing relationship (valid and active MWS authorization token) with the merchant account in order to use this function.
    #     @param {String} mws_auth_token - The mws_auth_token
    #     @param {String} merchant_id - The merchant_id
    #     @param {Hash} [headers=nil] - The headers for the request

    def get_authorization_token(mws_auth_token: nil, merchant_id: nil, headers: nil)
      api_call(options: {
                 method: 'GET',
                 url_fragment: "authorizationTokens/#{mws_auth_token}",
                 headers: headers,
                 query_params: {
                   merchantId: merchant_id
                 }
               })
    end

    #  Generates static signature for amazon.Pay.renderButton used by checkout.js.
    #     - Returns signature as string.
    #   @param {Hash} payload - The payload for the request
    #   @returns {String} signature

    def generate_button_signature(payload: nil)
      AmazonPay::ClientHelper.sign_payload(config_args: @config_args, payload: payload)
    end

    # Lets the solution provider make the DeliveryTrackers request with their auth token.
    #     - Lets you provide shipment tracking information to Amazon Pay so that Amazon Pay will
    #       be able to notify buyers on Alexa when shipments are delivered.
    #   @see https://developer.amazon.com/docs/amazon-pay-onetime/delivery-notifications.html#api-reference
    #   @param {Hash} payload - The payload for the request
    #   @param {String} payload.amazonOrderReferenceId - The Amazon Order Reference ID or Charge
    #                   Permission Id associated with the order for which the shipments need
    #                   to be tracked
    #   @param {String} payload.trackingNumber - The tracking number for the shipment provided by
    #                   the shipping company
    #   @param {Hash} payload.carrierCode - The shipping company code used for delivering goods to the customer
    #   @param {Hash} [headers=nil] - The headers for the request

    def delivery_trackers(payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: 'deliveryTrackers',
                 payload: payload,
                 headers: headers
               })
    end
  end
end
