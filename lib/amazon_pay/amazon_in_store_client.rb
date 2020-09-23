module AmazonPay
  # Class for Amazon Web Store
  class AmazonInStoreClient < AmazonPayClient
    def initialize(config_args)
      super(config_args)
    end

    #  API to initiate a purchase with a merchant
    #   - Initiates a purchase with a merchant.
    # @see //TODO Update Live URL
    # @param {Hash} payload - The payload for the request
    # @param {Hash} [headers=nil] - The headers for the request
    #
    def merchant_scan(payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: 'in-store/merchantScan',
                 payload: payload,
                 headers: headers
               })
    end

    # API to create Charge to the buyer
    #   - Creates a charge to the buyer with the requested amount.
    # @see //TODO Update Live URL
    # @param {Hash} payload - The payload for the request
    # @param {Hash} [headers=nil] - The headers for the request
    #
    def charge(payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: 'in-store/charge',
                 payload: payload,
                 headers: headers
               })
    end

    #  API to create a Refund to the buyer
    #   - Refunds an amount that was previously charged to the buyer.
    # @see //TODO Update Live URL
    # @param {Hash} payload - The payload for the request
    # @param {Hash} [headers=nil] - The headers for the request
    #
    def refund(payload: nil, headers: nil)
      api_call(options: {
                 method: 'POST',
                 url_fragment: 'in-store/refund',
                 payload: payload,
                 headers: headers
               })
    end
  end
end
