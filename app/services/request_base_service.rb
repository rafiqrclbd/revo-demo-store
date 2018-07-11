class RequestBaseService
  include Locale

  def initialize(user)
    @user = user
  end

  def call
    get_response
  end

  private

  attr_reader :user

  def order
    @order ||= user.orders.create!(amount: 1)
  end

  def get_response
    uri.query = params.to_query

    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = payload

    response = http.request(request)
    JSON.parse(response.body)
  end

  def password
    Rails.application.secrets.password
  end

  def store_id
    Rails.application.secrets.revo_store_id
  end

  def params
    { store_id: store_id, signature: signature }
  end

  def signature
    Digest::SHA1.hexdigest(payload + password)
  end

  def host
    Rails.application.secrets.revo_host
  end

  def http
    @http ||= begin
      http = Net::HTTP.new(uri.host, uri.port)

      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      http
    end
  end
end
