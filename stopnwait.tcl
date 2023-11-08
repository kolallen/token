set ns [new Simulator]
#Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red
#Open the Trace files
set file1 [open out.tr w]
$ns trace-all $file1
#Open the NAM trace file
set file2 [open out.nam w]
$ns namtrace-all $file2
#Define a 'finish' procedure
proc finish {} {
global ns file1 file2
$ns flush-trace
close $file1
close $file2
exec nam out.nam &
exit 0
}
set n0 [$ns node]
set n1 [$ns node]

$ns at 0.0 "$n0 label Sender"
$ns at 0.0 "$n1 label Receiver"

$ns duplex-link $n0 $n1 2Mb 100ms DropTail
$ns duplex-link-op $n0 $n1 orient right

$ns queue-limit $n0 $n1 100
 
 set tcp [new Agent/TCP]
 $tcp set window_ 1
 $tcp set maxcwnd_ 1
 $ns attach-agent $n0 $tcp
 set sink [new Agent/TCPSink]
 $ns attach-agent $n1 $sink
 $ns connect $tcp $sink
 
 set ftp [new Application/FTP]
 $ftp attach-agent $tcp
$ns add-agent-trace $tcp tcp
$ns monitor-agent-trace $tcp
$ns at 1.12 "finish"
 
$tcp tracevar cwnd_
$ns at 0.1 "$ftp start"
$ns at 3.0 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n1 $sink"
$ns at 3.5 "finish"
$ns at 0.0 "$ns trace-annotate \"Stop and Wait with normal operation\""
$ns at 0.05 "$ns trace-annotate \"FTP starts at 0.1\""
$ns at 0.11 "$ns trace-annotate \"Send Packet_0\""
$ns at 0.2 "$ns trace-annotate \"Receive Ack_0\""
$ns at 0.35 "$ns trace-annotate \"Send Packet_1\""
$ns at 0.45 "$ns trace-annotate \"Receive Ack_1\""
$ns at 0.54 "$ns trace-annotate \"Send Packet_2\""
$ns at 0.67 "$ns trace-annotate \"Receive Ack_2  \""
$ns at 0.76 "$ns trace-annotate \"Send Packet_3\""
$ns at 0.81 "$ns trace-annotate \"Receive Ack_3\""
$ns at 0.91 "$ns trace-annotate \"Send Packet_4\""
$ns at 1.04 "$ns trace-annotate \"Receive Ack_4\""
$ns at 1.116 "$ns trace-annotate \"FTP stops\""
$ns run
