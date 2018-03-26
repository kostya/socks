require "../src/socks"

p :started
s = Socks::Server.new "127.0.0.1", 8888
s.run
