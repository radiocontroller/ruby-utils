module Alipay
  class CouponCampaign
    include Singleton

    REQUEST_GATEWAY = "https://openapi.alipay.com/gateway.do"

    def self.execute(method, biz_content)
      instance = self.instance
      instance.init_params(method, biz_content)
      instance.execute
    end

    def url
      REQUEST_GATEWAY
    end

    def init_params(method, biz_content)
      @params = {
        "app_id" => 'Your app id',
        "method" => method,
        "format" => "JSON",
        "charset" => "utf-8",
        "sign_type" => "RSA2",
        "timestamp" => Time.now.strftime("%F %T"),
        "version" => "1.0",
        "biz_content" => biz_content.to_json
      }
    end

    def url_with_params
      encoded_params = params_with_sign.map{ |k, v| [k, URI.encode_www_form_component(v)].join("=") }.join("&")
      [url, encoded_params].join("?")
    end

    def params_with_sign
      @params.merge({sign: sign})
    end

    def rsa
      OpenSSL::PKey::RSA.new(Base64.decode64 'Your private key')
    end

    def sign
      Base64.strict_encode64(rsa.sign('sha256', params_to_string))
    end

    def params_to_string
      @params.sort.map { |item| item.join('=') }.join('&')
    end

    def execute
      JSON.parse(RestClient.post(url_with_params, {}))
    end

  end
end

