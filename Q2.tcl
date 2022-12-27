{#}{Write a TCL scripts and create a following network topology. This network consists 
of 4 nodes (n0, n1, n2, n3) as shown in above figure. The duplex links between n0 
and n2, and n1 and n2 have 1 Mbps of bandwidth and 5 ms of delay. The duplex 
link between n2 and n3 has 1 Mbps of bandwidth and 10 ms of delay. Each node 
uses a DropTail queue, of which the maximum size is 20. A "tcp" agent is attached 
to n0, and a connection is established to a tcp "sink" agent attached to n3. As 
default, the maximum size of a packet that a "tcp" agent can generate is 1KByte. A
tcp "sink" agent generates and sends ACK packets to the sender (tcp agent) and 
frees the received packets. A "udp" agent that is attached to n1 is connected to a 
"null" agent attached to n3. A "null" agent just frees the packets received. A "ftp" 
and a "cbr" traffic generator are attached to "tcp" and "udp" agents respectively, 
and the "cbr" is configured to generate 2 KByte packets at the rate of 2 Mbps. The 
"cbr" is set to start at 0.1 sec and stop at 4.5 sec, and "ftp" is set to start at 1.0 sec 
and stop at 4.0 sec
}


set ns [new Simulator] 

$ns color 1 Blue 
$ns color 2 Red 

set nf [open out.nam w] 
$ns namtrace-all $nf 

proc finish {} { 
  global ns nf 
  $ns flush-trace 
  close $nf 
  exec nam out.nam & 
  exit 0 
} 

set n0 [$ns node] 
set n1 [$ns node] 
set n2 [$ns node] 
set n3 [$ns node] 

$ns duplex-link $n0 $n2 1Mb 5ms DropTail 
$ns duplex-link $n1 $n2 1Mb 5ms DropTail 
$ns duplex-link $n2 $n3 1Mb 10ms DropTail 

#Set Queue Size of link (n2-n3) to 10 
$ns queue-limit $n2 $n3 20 

$ns duplex-link-op $n0 $n2 orient right-down 
$ns duplex-link-op $n1 $n2 orient right-up 
$ns duplex-link-op $n2 $n3 orient right 

$ns duplex-link-op $n2 $n3 queuePos 0.5 

set tcp [new Agent/TCP] 
$tcp set class_ 2 
$ns attach-agent $n0 $tcp 
set sink [new Agent/TCPSink] 
$ns attach-agent $n3 $sink 
$ns connect $tcp $sink 
$tcp set fid_ 1 

set ftp [new Application/FTP] 
$ftp attach-agent $tcp 
$ftp set type_ FTP 

set udp [new Agent/UDP] 
$ns attach-agent $n1 $udp 
set null [new Agent/Null] 
$ns attach-agent $n3 $null 
$ns connect $udp $null 
$udp set fid_ 2 

set cbr [new Application/Traffic/CBR] 
$cbr attach-agent $udp 
$cbr set type_ CBR 
$cbr set packet_size_ 2000 
$cbr set rate_ 2mb 
$cbr set random_ false 

$ns at 0.1 "$cbr start" 
$ns at 1.0 "$ftp start" 
$ns at 4.0 "$ftp stop" 
$ns at 4.5 "$cbr stop" 

$ns at 4.5 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n3 $sink" 

$ns at 5.0 "finish" 

puts "CBR packet size = [$cbr set packet_size_]" 
puts "CBR interval = [$cbr set interval_]" 

$ns run
