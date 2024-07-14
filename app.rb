require 'rack'
require 'json'
require_relative './async_worker'
require_relative './authenticate'
require_relative './product'

class App
  def initialize
    @products = []
    @auth_tokens = {}
    @worker = AsyncWorker.new(@products)
  end

  def call(env)
    req = Rack::Request.new(env)
    case req.path_info
    when '/'
      case req.request_method
      when 'GET'
        response(data: File.read('openapi.yaml'))
      else
        response(status: 405, data: JSON.dump({ error: 'Method Not Allowed' }), content_type: 'application/json')
      end
    when '/author'
      case req.request_method
      when 'GET'
        response(data: File.read('AUTHORS'), cache_control: 'public, max-age=86400', content_type: 'application/json')
      else
        response(status: 405, data: JSON.dump({ error: 'Method Not Allowed' }), content_type: 'application/json')
      end
    when '/authenticate'
      Authenticate.new(req, @auth_tokens).call
    when '/products'
      Product.new(req, @auth_tokens, @products, @worker).call
    else
      response(data: JSON.dump({ error: 'Not Found' }), status: 404)
    end
  end

  private

  def response(data:, status: 200, content_type: 'application/yaml', cache_control: 'no-cache')
    headers = { 'Content-Type' => content_type, 'Cache-Control' => cache_control }

    [status, headers, [data]]
  end
end
