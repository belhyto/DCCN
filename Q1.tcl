#Create new simulator object
set ns [new Simulator] 

#Open nam tracefile
set namfile [open Question1.nam w] 
$ns namtrace-all $namfile 

#Open trace file
set tracefile [open Question1.tr w] 
$ns trace-all $tracefile 

#Create nodes
set n1 [$ns node] 
set n2 [$ns node] 
set n3 [$ns node] 
set n4 [$ns node]

#Creating links between the nodes 
$ns duplex-link $n1 $n2 1Mb 10ms DropTail 
$ns duplex-link $n2 $n3 1Mb 10ms DropTail 
$ns duplex-link $n2 $n4 1Mb 10ms DropTail 

#Creating proper orientation of the nodes
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient up-right
$ns duplex-link-op $n2 $n4 orient down-right

set tcp [new Agent/TCP] 
$ns attach-agent $n1 $tcp 
set sink [new Agent/TCPSink] 
$ns attach-agent $n2 $sink 
$ns connect $tcp $sink 
set ftp [new Application/FTP] 
$ftp attach-agent $tcp 
set udp [new Agent/UDP] 
$ns attach-agent $n1 $udp 
set null [new Agent/Null] 
$ns attach-agent $n2 $null 
$ns connect $udp $null 
$udp set class_ 1 
$ns color 1 Blue 
$tcp set class_ 2 
$ns color 2 Red 
set cbr [new Application/Traffic/CBR] 
$cbr set packetsize_ 200 
$cbr set interval_ 3 
$cbr attach-agent $udp 
$ns at 0.3 "$cbr start" 
$ns at 0.3 "$ftp start" 
$ns at 4.0 "$cbr stop" 
$ns at 4.0 "$ftp stop" 

#Finish procedure
proc finish {} { 
global ns namfile tracefile 
$ns flush-trace 
close $namfile 
close $tracefile 
exec nam Question1.nam & 
exit 0 
} 

#Calling finish operation after 10 seconds
$ns at 10.0 "finish" 

#Running simulation
$ns run
