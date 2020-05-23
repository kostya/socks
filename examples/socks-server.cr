require "../src/socks"

p :started
s = Socks::Server.new "127.0.0.1", (ARGV[0]? || 8088).to_i
s.run
