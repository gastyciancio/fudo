require 'zlib'

class Request
  private

  def respond_with_json(data, status = 200)
    body = [JSON.dump(data)]
    headers = { 'Content-Type' => 'application/json' }

    if gzip_enabled?
      body = gzip(body.first)
      headers['Content-Encoding'] = 'gzip'
    end

    [status, headers, body]
  end

  def gzip_enabled?
    @req.env['HTTP_ACCEPT_ENCODING']&.include?('application/gzip')
  end

  def gzip(content)
    io = StringIO.new
    writer = Zlib::GzipWriter.new(io)
    writer.write(content)
    writer.close
    [io.string]
  end

  def unauthorized
    [401, { 'Content-Type' => 'application/json' }, [JSON.dump({ error: 'Unauthorized' })]]
  end
end
