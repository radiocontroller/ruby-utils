#ip地址和十进制转换

reuiqre 'ipaddr'

IPAddr.new('1.2.3.4').to_i => 16909060
IPAddr.new(16909060, Socket::AF_INET).to_s => "1.2.3.4"
