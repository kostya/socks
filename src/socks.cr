require "./socks/*"
require "socket"

module Socks
  VERSION = 5_u8

  class Error < Exception; end
end
