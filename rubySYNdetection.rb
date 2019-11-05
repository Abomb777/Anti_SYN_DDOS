#!/usr/bin/ruby
# Nagios check for TCP SYN Flooding Attack
## check_syn_flood.rb -w WarningLevel -c CriticalLevel
#
# Written by Robert Birnie
# Source: http://www.uberobert.com/nagios-check-for-tcp-syn-flooding-attacks/
#
# /proc/net/tcp format:
# sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
#  0: 0100007F:46E0 00000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 36206 1 ffff810224e52140 3000 0 0 2 -1
#
#    %nethash = (
#        '01',  =>  TCP_ESTABLISHED,
#        '02',  =>  TCP_SYN_SENT,
#        '03',  =>  TCP_SYN_RECV,
#        '04',  =>  TCP_FIN_WAIT1,
#        '05',  =>  TCP_FIN_WAIT2,
#        '06',  =>  TCP_TIME_WAIT,
#        '07',  =>  TCP_CLOSE,
#        '08',  =>  TCP_CLOSE_WAIT,
#        '09',  =>  TCP_LAST_ACK,
#        '0A',  =>  TCP_LISTEN,
#        '0B',  =>  TCP_CLOSING,
#    );
The output looks like this:
################################################################################################
###  $ ruby /usr/lib64/nagios/plugins/check_syn_flood.rb -w 500 -c 1000
###  SYN Count: 239
###  $ ruby /usr/lib64/nagios/plugins/check_syn_flood.rb -w 500 -c 100
###  SYN FLOOD CRITICAL SYN Count: 182 | DST: 192.168.1.1: 37 SRC: 1.2.3.4: 6
################################################################################################
require 'optparse'
require 'scanf'

options = {}

optparse = OptionParser.new do |opts|
  opts.on('-w', '--warn warning') do |f|
    options[:warn] = f
  end
  opts.on('-c', '--critical critical') do |f|
    options[:crit] = f
  end
end

optparse.parse!

raise OptionParser::MissingArgument if options[:warn].nil?
raise OptionParser::MissingArgument if options[:crit].nil?

@src_ips = Hash.new(0)
@dst_ips = Hash.new(0)
@count = 0
exit_code = 0

File.readlines('/proc/net/tcp').each do |line|
  i = line.split(' ')
  if i[3] == '03'
    @count += 1
    @dst_ips[i[1].split(':')[0].scanf('%2x'*4)*"."] += 1
    @src_ips[i[2].split(':')[0].scanf('%2x'*4)*"."] += 1
  end
end

msg = "SYN Count: #{@count}"

if @count > options[:crit].to_i or @count > options[:warn].to_i
  top_dst_ip = @dst_ips.max_by{|k,v| v}
  top_src_ip = @src_ips.max_by{|k,v| v}
  crit = "| DST: #{top_dst_ip[0].split('.').reverse.join('.')}: #{top_dst_ip[1]} SRC: #{top_src_ip[0].split('.').reverse.join('.')}: #{top_src_ip[1]}"
  if @count.to_i > options[:crit].to_i
    exit_code = 2
    msg = "SYN FLOOD CRITICAL #{msg} #{crit}"
  elsif @count.to_i > options[:warn].to_i
    exit_code = 1
    msg = "SYN FLOOD WARN #{msg} #{crit}"
  end
end

puts msg
exit exit_code
