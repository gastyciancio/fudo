require 'dotenv/load'
require 'securerandom'
require_relative './request'

class Authenticate < Request
  def initialize(req, auth_tokens)
    @req = req
    @auth_tokens = auth_tokens
  end

  def call
    credentials = JSON.parse(@req.body.read)
    if credentials['user'] == ENV['API_USERNAME'] && credentials['password'] == ENV['API_PASSWORD']
      token = SecureRandom.hex
      @auth_tokens[token] = token
      respond_with_json({ token: token })
    else
      unauthorized
    end
  end
end
