# Amazon Pay API SDK (Ruby)

Amazon Pay Checkout v2 Integration

Please note the Amazon Pay API SDK can only be used for API calls to the pay-api.amazon.com|eu|jp endpoint.

If you need to make an Amazon Pay API call that uses the mws.amazonservices.com|jp or mws-eu.amazonservices.com endpoint, then you will need to use the original [Amazon Pay SDK (Ruby)](https://github.com/amzn/amazon-pay-sdk-ruby).

## Requirements

- Amazon Pay account: To register for Amazon Pay, go to https://pay.amazon.com, choose your region by selecting the flag icon in the upper right corner, and then click "Register".
- Node 8.0 or higher

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'amazon_pay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install amazon_pay

## Public and Private Keys

MWS access keys, MWS secret keys, and MWS authorization tokens from previous MWS integrations cannot be used with this SDK.

You will need to generate your own public/private key pair to make API calls with this SDK.

In Windows 10 this can be done with ssh-keygen commands:

```
ssh-keygen -t rsa -b 2048 -f private.pem
ssh-keygen -f private.pem -e -m PKCS8 > public.pub
```

In Linux or macOS this can be done using openssl commands:

```
openssl genrsa -out private.pem 2048
openssl rsa -in private.pem -pubout > public.pub
```

The first command above generates a private key and the second line uses the private key to generate a public key.

To associate the key with your account, follow the instructions here to
[Get your Public Key ID](http://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-checkout/get-set-up-for-integration.html#4-get-your-public-key-id).

## Configuration

```ruby
   config = {
        'public_Key_id': 'ABC123DEF456XYZ',                                     # RSA Public Key ID (this is not the Merchant or Seller ID)
        'private_key': File.read(File.expand_path('tst/private.pem', __dir__)), # Path to RSA Private Key (or a string representation)
        'region': 'us',                                                         # Must be one of: 'us', 'eu', 'jp'
        'sandbox': true                                                         # true (Sandbox) or false (Production) boolean
    }
```

# Versioning

The pay-api.amazon.com|eu|jp endpoint uses versioning to allow future updates. The major version of this SDK will stay aligned with the API version of the endpoint.

If you have downloaded version 2.x.y of this SDK, version in below examples would be "v2".

# Convenience Functions (Overview)

Make use of the built-in convenience functions to easily make API calls. Scroll down further to see example code snippets.

When using the convenience functions, the request payload will be signed using the provided private key, and a HTTPS request is made to the correct regional endpoint.
In the event of request throttling, the HTTPS call will be attempted up to three times

## Alexa Delivery Trackers API

Please note that your merchant account must be whitelisted to use the [Delivery Trackers API](https://developer.amazon.com/docs/amazon-pay-onetime/delivery-order-notifications.html).

- **delivery_trackers**(payload: nil, headers: nil) &#8594 POST to `#{version}/delivery_trackers`

## Authorization Tokens API

Please note that your solution provider account must have a pre-existing relationship (valid and active MWS authorization token) with the merchant account in order to use this function.

- **getAuthorizationToken**(mws_auth_token: nil, merchant_id: nil, headers: nil) &#8594 GET to `#{version}/authorizationTokens#{mws_auth_token}?merchantId=#{merchant_id}`

## Amazon Checkout v2 API

[Checkout v2 Integration Guide](https://amazonpaycheckoutintegrationguide.s3.amazonaws.com/amazon-pay-api-v2/introduction.html)

The headers field is not optional for create/POST calls below because it requires, at a minimum, the x-amz-pay-idempotency-key header:

```ruby
   headers = {
        'x-amz-pay-idempotency-key': SecureRandom.uuid.to_s.gsub(/-/, '')
    }
```

### Amazon Checkout v2 Buyer object

- **getBuyer**(buyer_token: nil, headers: nil) &#8594 GET to `#{version}/buyer/{$buyerToken}`

### Checkout v2 CheckoutSession object

- **createCheckoutSession**(payload: nil, headers: nil) &#8594 POST to `#{version}/checkoutSessions`
- **getCheckoutSession**(checkout_session_id: nil, headers: nil) &#8594 GET to `#{version}/checkoutSessions/#{checkout_session_id}`
- **updateCheckoutSession**(checkout_session_id: nil, payload: nil, headers: nil) &#8594 PATCH to `#{version}/checkoutSessions#{checkout_session_id}`
- **completeCheckoutSession**(checkout_session_id: nil, payload: nil, headers: nil) &#8594 POST to `#{version}/checkoutSessions#{checkout_session_id}/complete`

### Checkout v2 ChargePermission object

- **getChargePermission**(charge_permission_id: nil, headers: nil) &#8594 GET to `#{version}/chargePermissions/#{charge_permission_id}`
- **updateChargePermission**(charge_permission_id: nil, payload: nil, headers: nil) &#8594 PATCH to `#{version}/chargePermissions#{charge_permission_id}`
- **closeChargePermission**(charge_permission_id: nil, payload: nil, headers: nil) &#8594 DELETE to `#{version}/chargePermissions#{charge_permission_id}/close`

### Checkout v2 Charge object

- **createCharge**(payload: nil, headers: nil) &#8594 POST to `#{version}/charges`
- **getCharge**(charge_id: nil, headers: nil) &#8594 GET to `#{version}/charges/#{charge_id}`
- **capture_charge**(charge_id: nil, payload: nil, headers: nil) &#8594 POST to `#{version}/charges/#{charge_id}/capture`
- **cancelCharge**(charge_id: nil, payload: nil, headers: nil) &#8594 DELETE to `#{version}/charges/#{charge_id}/cancel`

### Checkout v2 Refund object

- **createRefund**(payload: nil, headers: nil) &#8594 POST to `#{version}/refunds`
- **getRefund**(refund_id: nil, headers: nil) &#8594 GET to `#{version}/refunds/#{refund_id}`

## In-Store API

Please contact your Amazon Pay Account Manager before using the In-Store API calls in a Production environment to obtain a copy of the In-Store Integration Guide.

- **instoreMerchantScan**(payload: nil, headers: nil) &#8594 POST to `#{version}/in-store/merchant_scan`
- **in: payloadstoreCharge**(payload: nil, headers: nil) &#8594 POST to `#{version}/in-store/charge`
- **instoreRefund**(payload: nil, headers: nil) &#8594 POST to `#{version}/in-store/refund`

# Using Convenience Functions

Four quick steps are needed to make an API call:

Step 1. Construct a Client (using the previously defined Config object).

```ruby
   require 'amazon_pay'

   client = AmazonPay::AmazonPayClient.new(config)
    #-or-
   client = AmazonPay::WebStoreClient.new(config)
    #-or-
   client = AmazonPay::InStoreClient.new(config)
```

Step 2. Generate the payload.

```ruby
   payload = {
        scanData: 'UKhrmatMeKdlfY6b',
        scanReferenceId: SecureRandom.uuid.to_s.gsub(/-/, ''),
        merchantCOE: 'US',
        ledgerCurrency: 'USD',
        chargeTotal: {
            currencyCode: 'USD',
            amount: '2.00'
        },
        storeLocation: {
            countryCode: 'US'
        },
        metadata: {
            merchantNote: 'Merchant Name',
            customInformation: 'in-store Software Purchase',
            communicationContext: {
                merchantStoreName: 'Store Name',
                merchantOrderId: '789123'
            }
        }
    }
```

Step 3. Execute the call.

```ruby
    response = client.merchant_scan(payload)
```

If you are a Solution Provider and need to make an API call on behalf of a different merchant account, you will need to pass along an extra authentication token parameter into the API call.

```ruby
   test_headers = {
        'x-amz-pay-authtoken': 'other_merchant_super_secret_token'
    }
   response = client.merchant_scan(payload: payload, headers: test_headers)
```

# Convenience Functions Code Samples

## Alexa Delivery Notifications

```ruby
   require 'amazon_pay'

   config = {
        public_key_id: 'ABC123DEF456XYZ',
        private_key: File.read(File.expand_path('/test/private.pem', __dir__)),
        region: 'us',
        sandbox: true
    }

   payload = {
        amazonOrderReferenceId: 'P00-0000000-0000000',
        deliveryDetails: [{
            trackingNumber: '1Z999AA10123456789',
            carrierCode: 'UPS'
        }]
    }

   client = AmazonPay::AmazonPayClient.new(config)
   response = client.delivery_trackers(payload: payload)
```

## Checkout v2 - Create Checkout Session

```ruby
   require 'amazon_pay'

   config = {
        public_key_id: 'ABC123DEF456XYZ',
        private_key: File.read(File.expand_path('/test/private.pem', __dir__)),
        region: 'us',
        sandbox: true
    }

   payload = {
        webCheckoutDetails: {
            checkoutReviewReturnUrl: 'https://localhost/store/checkoutReview',
            checkoutResultReturnUrl: 'https://localhost/store/checkoutReturn'
        },
        storeId: 'amzn1.application-oa2-client.5cc4962582fd4025a2962fc5350582d9' # Enter Client ID
    }
   headers = {
        'x-amz-pay-idempotency-key': SecureRandom.uuid.to_s.gsub(/-/, '')
    }

   client = AmazonPay::WebStoreClient.new(config)
   response = client.createCheckoutSession(payload: nil, headers: nil)
```

## Checkout v2 - Get Checkout Session

```ruby
   require 'amazon_pay'

   config = {
        public_key_id: 'ABC123DEF456XYZ',
        private_key: File.read(File.expand_path('/test/private.pem', __dir__)),
        region: 'us',
        sandbox: true
    }

   headers = {
        'x-amz-pay-idempotency-key': SecureRandom.uuid.to_s.gsub(/-/, '')
    }

   checkout_session_id = '00000000-0000-0000-0000-000000000000'
   client = AmazonPay::WebStoreClient.new(config)
   response = client.get_checkout_session(checkout_session_id: checkout_session_id: checkout_session_id, headers: nil)
```

## Checkout v2 - Update Checkout Session

```ruby
   require 'amazon_pay'

   config = {
        public_key_id: 'ABC123DEF456XYZ',
        private_key: File.read(File.expand_path('/test/private.pem', __dir__)),
        region: 'us',
        sandbox: true
    }

   payload = {
        webCheckoutDetails: {
            checkoutResultReturnUrl: 'https://localhost/store/checkoutReturn'
        },
        paymentDetails: {
            paymentIntent: 'Confirm',
            canHandlePendingAuthorization: false,
            chargeAmount: {
                amount: 50,
                currencyCode: 'USD'
            }
        },
        merchantMetadata: {
            merchantReferenceId: SecureRandom.uuid.to_s.gsub(/-/, ''),
            merchantStoreName: 'AmazonTestStoreFront',
            noteToBuyer: 'merchantNoteForBuyer',
            customInformation: ''
        }
    }

   checkout_session_id = '00000000-0000-0000-0000-000000000000'
   client = AmazonPay::WebStoreClient.new(config)
   response = client.updateCheckoutSession(checkout_session_id: checkout_session_id, payload: payload)
```

## Checkout v2 - Capture Charge

```ruby
   require 'amazon_pay'

   config = {
        public_key_id: 'ABC123DEF456XYZ',
        private_key: File.read(File.expand_path('/test/private.pem', __dir__)),
        region: 'us',
        sandbox: true
    }

   payload = {
        captureAmount: {
            amount: '10.00',
            currencyCode: 'USD'
        },
        softDescriptor: 'AMZN'
    }
   headers = {
        'x-amz-pay-idempotency-key': SecureRandom.uuid.to_s.gsub(/-/, '')
    }

   charge_id = 'S01-0000000-0000000-C000000'
   client = AmazonPay::WebStoreClient.new(config)
   response = client.capture_charge(charge_id: nil, payload: nil, headers: nil)
```

## In Store MerchantScan

```ruby
   payload = {
        scanData: '[scanData]',
        scanReferenceId: '[scanReferenceId]',
        merchantCOE: 'US',
        ledgerCurrency: 'USD'
    }

    response = client.merchant_scan(payload: payload)
    merchant_scan_charge_permission_id = response[:charge_permission_id]
```

## Generate Button Signature

The signatures generated by this helper function are only valid for the Checkout v2 front-end buttons. Unlike API signing, no timestamps are involved, so the result of this function can be considered a static signature that can safely be placed in your website JS source files and used repeatedly (as long as your payload does not change).

Example call to generate_button_signature function:

```ruby
   require 'amazon_pay'

   config = {
        public_key_id: 'ABC123DEF456XYZ',
        private_key: File.read(File.expand_path('/test/private.pem', __dir__)),
        region: 'us',
        sandbox: true
    }

   client = AmazonPay::AmazonPayClient(config)
   payload = {
        webCheckoutDetails: {
            checkoutReviewReturnUrl: 'https://localhost/test/checkoutReview.html',
            checkoutResultReturnUrl: 'https://localhost/test/checkoutResult.html'
        },
        storeId: 'amzn1.application-oa2-client.xxxxx'
    }
   signature = client.generate_button_signature(payload: payload)
```

## Manual Signing (Advanced Use-Cases Only)

This SDK provides the ability to help you manually sign your API requests if you want to use your own code for sending the HTTPS request over the Internet.

Example call to api_call function with values:

```ruby
    /** API to process a request
     *   - Makes an API Call using the specified options.
     * @param {Object} options - The options to make the API Call
     * @param {String} options.method - The HTTP request method
     * @param {String} options.urlFragment - The URI for the API Call
     * @param {String} [options.payload=null] - The payload for the API Call
     * @param {String} [options.headers=null] - The headers for the API Call
```

Example request method:

```ruby
   options = {
        method: 'POST',
        urlFragment: '#{version}/in-store/merchant_scan',
     : payload   payload = {
            scanData: 'UKhrmatMeKdlfY6b',
            scanReferenceId: '0b8fb271-2ae2-49a5-b35d4',
            merchantCOE: 'US',
            ledgerCurrency: 'USD',
            chargeTotal: {
                currencyCode: 'USD',
                amount: '2.00'
            },
            storeLocation: {
                countryCode: 'US'
            },
            metadata: {
                merchantNote: 'Merchant Name',
                customInformation: 'in-store Software Purchase',
                communicationContext: {
                    merchantStoreName: 'Store Name',
                    merchantOrderId: '789123'
                }
            }
        }
    }

   client = AmazonPay::InStoreClient.new(config)
   signedHeders = client.api_call(options)
```

Example call to get_signed_headers function with values:
(This will only be used if you don't use api_call and want to create your own custom headers.)

```ruby
    /** Signs the request headers
     *   - Signs the request provided and returns the signed headers object.
     * @param {Object} options - The options to make the API Call
     * @param {String} options.method - The HTTP request method
     * @param {String} options.urlFragment - The URI for the API Call
     * @param {String} [options.payload=null] - The payload for the API Call
     * @param {String} [options.headers=null] - The headers for the API Call
     **/
```

Example request method:

```ruby
   options = {
        method: 'POST',
        urlFragment: '#{version}/in-store/merchant_scan',
     : payload   payload = {
            scanData: 'UKhrmatMeKdlfY6b',
            scanReferenceId: '0b8fb271-2ae2-49a5-b35d4',
            merchantCOE: 'US',
            ledgerCurrency: 'USD',
            chargeTotal: {
                currencyCode: 'USD',
                amount: '2.00'
            },
            storeLocation: {
                countryCode: 'US'
            },
            metadata: {
                merchantNote: 'Merchant Name',
                customInformation: 'in-store Software Purchase',
                communicationContext: {
                    merchantStoreName: 'Store Name',
                    merchantOrderId: '789123'
                }
            }
        },
        headers: {
            'Accept': 'application/rubyon',
            'Content-Type': 'application/rubyon'
            'X-Amz-Pay-Region': 'us'
        }
    }

   client = AmazonPay::AmazonPayClient(config)
   signedHeaders = client.get_signed_headers(options)
```
