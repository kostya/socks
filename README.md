# Socks

Socks5 server in Crystal. Simple implementation without auth, bind, associate and ipv6.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  socks:
    github: kostya/socks
```

## Usage

```crystal
require "socks"
Socks::Server.new("127.0.0.1", 8888).run
```

Run test http-server:

	crystal examples/socks-server.cr -- 9000
    crystal examples/test-server.cr -- 9001

Run queries:

    curl --socks5 127.0.0.1:9000 127.0.0.1:9001/bytes?n=100
