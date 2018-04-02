require "socket"

class Socks::Server
  def initialize(@listen_host : String, @listen_port : Int32, @debug : Bool = true)
    @server = TCPServer.new @listen_host, @listen_port
  end

  def stop!
    @server.close
  end

  def run
    loop do
      spawn handle(@server.accept)
    end
  end

  def auth(client)
    # Actually just skip it

    num_methods = client.read_byte
    raise Error.new("Failed to get number of methods") unless num_methods

    num_methods.times do
      method = client.read_byte
      raise Error.new("Failed to get auth method") unless method
    end

    begin
      client.write_byte(Socks::VERSION)
      client.write_byte(0_u8)
    rescue ex
      raise Socks::Error.new("Failed to write auth reply `#{ex.inspect}`")
    end

    nil
  end

  def handle(client)
    id_msg = "[SOCKS-#{client.remote_address}]"

    version = client.read_byte
    raise Error.new("Failed to get version byte") unless version
    raise Error.new("Unsupported SOCKS version #{version}") unless version == Socks::VERSION

    auth = auth(client)

    request = Request.new(client, auth)
    request.handle

    STDERR.puts("#{id_msg} OK") if @debug
  rescue ex : Socks::Error
    STDERR.puts("#{id_msg} ERR: #{ex.message}") if @debug
  ensure
    client.close
  end
end
