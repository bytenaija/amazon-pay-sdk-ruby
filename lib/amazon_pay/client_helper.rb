# rubocop:disable Metrics/MethodLength,  Metrics/ClassLength, Metrics/AbcSize

require 'openssl'
require 'base64'
require 'json'
require 'time'
require 'date'
require 'net/http'
require 'amazon_pay/constants'

module AmazonPay
  class ClientHelper
    def self.fetch_timestamp
      Time.now.utc.iso8601
    end

    def self.fetch_api_endpoint_base_url(config_args: {})
      if config_args[:overrideServiceUrl]&.length&.positive?
        config_args[:overrideServiceUrl]
      else
        region = config_args[:region].downcase.to_sym
        region_map = AmazonPay::CONSTANTS[:REGION_MAP][region].to_sym

        AmazonPay::CONSTANTS[:API_ENDPOINTS][region_map]
      end
    end

    def self.invoke_api(config_args: {}, api_options: {})
      options = {
        method: api_options[:method],
        json: false,
        headers: api_options[:headers],
        url: "https://#{fetch_api_endpoint_base_url(config_args: config_args)}/#{api_options[:url_fragment]}"\
        "#{fetch_query_string(request_params: api_options[:query_params])}",
        body: api_options[:payload]
      }

      retry_logic(options: options, count: 1)
    end

    def self.fetch_query_string(request_params: nil)
      return "?#{fetch_parameters_as_string(request_params: request_params)}" if request_params

      ''
    end

    def self.fetch_parameters_as_string(request_params: nil)
      return '' if request_params.nil?

      query_params = []
      request_params.map do |key, value|
        query_params << "#{key}=#{CGI.escape(value)}"
      end
      query_params.join('&')
    end

    def self.prepare_options(config_args: {}, options: {})
      options[:headers] ||= {}

      # if user doesn't pass in a string, assume it's a JS object and convert it to a JSON string
      unless options[:payload].is_a?(String) || options[:payload].nil?
        options[:payload] = JSON.generate(options[:payload])
      end

      options[:url_fragment] = if config_args[:sandbox] == true || config_args[:sandbox] == 'true'
                                 "sandbox/#{AmazonPay::CONSTANTS[:API_VERSION]}/#{options[:url_fragment]}"
                               else
                                 "live/#{AmazonPay::CONSTANTS[:API_VERSION]}/#{options[:url_fragment]}"
                               end

      options
    end

    def self.sign(private_key: nil, data: nil)
      sign_hash = OpenSSL::Digest.new('SHA256')
      priv = OpenSSL::PKey::RSA.new(private_key)
      signature = priv.sign_pss(sign_hash, data, salt_length: 20, mgf1_hash: 'SHA256')
      Base64.strict_encode64(signature)
    end

    def self.retry_logic(options: {}, count: 0)
      response = send_request(options: options, count: count)
      return response if count > AmazonPay::CONSTANTS[:RETRIES]

      return response unless response.nil?

      count += 1
      retry_logic(options: options, count: count)
    end

    def self.send_request(options: {}, count: 0)
      delay_time = count == 1 ? 0 : (2**(count - 1)).seconds
      sleep(delay_time)
      begin
        uri = URI(options[:url])

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        case options[:method].to_sym
        when :GET
          response = http.get(uri, options[:headers])
        when :DELETE
          response = http.delete(uri.request_uri, options[:headers])
        when :POST
          request = Net::HTTP::Post.new(uri.path, options[:headers])
          request.body = options[:body]
          response = http.request(request)
        when :PATCH
          request = Net::HTTP::Patch.new(uri.path, options[:headers])
          request.body = options[:body]
          response = http.request(request)
        end
        JSON.parse(response.body)
      rescue StandardError
        nil
      end
    end

    # Expected options:
    #        options[:method]
    #        options[:url_fragment]
    #        options[:payload]
    #        options[:headers]

    def self.sign_headers(config_args: {}, options: {})
      headers = options[:headers] || {}
      headers['x-amz-pay-region'] = 'us'
      headers['x-amz-pay-host'] = fetch_api_endpoint_base_url(config_args: config_args)
      headers['x-amz-pay-date'] = fetch_timestamp
      headers['content-type'] = 'application/json'
      headers['accept'] = 'application/json'
      headers[
        'user-agent'
      ] = "amazon-pay-api-sdk-ruby/#{AmazonPay::CONSTANTS[:SDK_VERSION]} (Ruby/#{RUBY_VERSION}; #{RUBY_PLATFORM})"

      lower_case_sorted_header_keys = headers.keys.sort.map(&:downcase)
      signed_headers = lower_case_sorted_header_keys.join(';')

      payload = options[:payload]

      if payload.nil? || options[:url_fragment].include?('/account-management/'\
        "#{AmazonPay::CONSTANTS[:API_VERSION]}/accounts")
        payload = '' # do not sign payload for payment critical data APIs
      end

      canonical_request =
        options[:method] + "\n" +
        options[:url_fragment] + "\n" +
        fetch_parameters_as_string(request_params: options[:query_params]) +
        "\n"

      lower_case_sorted_header_keys.each do |item|
        str = item.downcase + ':' + headers[item] + "\n"

        canonical_request += str
      end

      canonical_request += "\n" + signed_headers + "\n" +
                           OpenSSL::Digest::SHA256.hexdigest(payload)

      string_to_sign =
        AmazonPay::CONSTANTS[:AMAZON_SIGNATURE_ALGORITHM] +
        "\n" +
        OpenSSL::Digest::SHA256.hexdigest(canonical_request)

      signature = sign(private_key: config_args[:private_key], data: string_to_sign)

      headers['authorization'] = "#{AmazonPay::CONSTANTS[:AMAZON_SIGNATURE_ALGORITHM]} "\
      "PublicKeyId=#{config_args[:public_key_id]}, SignedHeaders=#{signed_headers}, Signature=#{signature}"

      headers
    end

    def self.sign_payload(config_args: nil, payload: nil)
      # if user doesn't pass in a string, assume it's a JS object and convert it to a JSON string
      payload = JSON.generate(payload) unless payload.is_a?(String)
      string_to_sign = AmazonPay::CONSTANTS[:AMAZON_SIGNATURE_ALGORITHM] + "\n" +
                       OpenSSL::Digest::SHA256.hexdigest(payload)
      sign(private_key: config_args[:private_key], data: string_to_sign)
    end
  end
end
