require 'thread'
require 'securerandom'

class AsyncWorker
  def initialize(products)
    @products = products
    @queue = Queue.new
    @thread = Thread.new { process_queue }
  end

  def enqueue(product_data)
    @queue << product_data
  end

  private

  def process_queue
    loop do
      product_data = @queue.pop
      sleep 5
      product_data['id'] = SecureRandom.uuid
      @products << product_data
    end
  end
end
