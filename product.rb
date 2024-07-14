require_relative './request'

class Product < Request
  def initialize(req, auth_tokens, products, worker)
    @req = req
    @auth_tokens = auth_tokens
    @products = products
    @worker = worker
  end

  def call
    return unauthorized unless authenticated?

    case @req.request_method
    when 'POST'
      create_product
    when 'GET'
      respond_with_json(@products)
    else
      error_response(status: 405, data: JSON.dump({ error: 'Method Not Allowed' }))
    end
  end

  private

  def create_product
    product_data = JSON.parse(@req.body.read)
    name = product_data['name']
    return error_response(status: 400, data: JSON.dump({ error: 'Name is required' })) if name.nil? || name.empty?

    @worker.enqueue({ name: name })

    respond_with_json({ message: 'Product creation scheduled' }, 202)
  end

  def authenticated?
    token = @req.get_header('HTTP_AUTHORIZATION')
    @auth_tokens.key?(token)
  end

  def error_response(status:, data:)
    [status, { 'Content-Type' => 'application/json' }, [data]]
  end
end
