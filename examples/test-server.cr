require "http/server"
require "zlib"
require "digest/md5"

host = "127.0.0.1"
port = (ARGV[0]? || 8089).to_i

cbk = ->(context : HTTP::Server::Context) do
  context.response.headers["Server"] = "Crystal"
  context.response.headers["X-Frame-Options"] = "SAMEORIGIN"
  context.response.headers["X-Content-Type-Options"] = "nosniff"
  context.response.headers["X-XSS-Protection"] = "1; mode=block"
  context.response.headers["Content-Type"] = "text/plain"

  p context.request.path

  case context.request.path
  when "/"
    context.response.print("BenchServer v1.0")
  when "/bytes"
    context.response.print("a" * (context.request.query_params["n"]? || 100).to_i)
  when "/delay"
    n = (context.request.query_params["n"]? || 0.1).to_f
    sleep(n)
    context.response.print("sleeped for #{n}")
  else
    context.response.status_code = 404
    context.response.print("unknown path #{context.request.path}")
  end
end

spawn do
  server = HTTP::Server.new(&cbk)
  server.bind_tcp(host, port)
  puts "BenchServer Listening on http://#{host}:#{port}"
  server.listen
end

puts "listen on #{host}:#{port}"
sleep
