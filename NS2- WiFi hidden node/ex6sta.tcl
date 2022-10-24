#=================================================
#                     Options
#=================================================

set opt(x)		100   
set opt(y)		100   
set opt(nn)		6
set opt(stop)		150
set opt(tr)		out.tr

#=================================================
#                      MAC
#=================================================

Mac/802_11 set dataRate_        2.0e6
Mac/802_11 set RTSThreshold_    3000

#=================================================
#                     Nodes
#=================================================

set ns_ [new Simulator]
set tracefd  [open $opt(tr) w]
$ns_ trace-all $tracefd

set topo   [new Topography]
$topo load_flatgrid $opt(x) $opt(y)
create-god  $opt(nn) 

$ns_ node-config -adhocRouting 	DumbAgent \
                 -llType 	LL \
                 -macType 	Mac/802_11 \
                 -ifqType 	Queue/DropTail/PriQueue \
                 -ifqLen 	50 \
                 -antType 	Antenna/OmniAntenna \
		 -propType 	Propagation/FreeSpace \
                 -phyType 	Phy/WirelessPhy \
                 -channelType 	Channel/WirelessChannel \
                 -topoInstance 	$topo \
                 -agentTrace 	ON \
                 -routerTrace 	OFF \
                 -macTrace 	OFF \
		 -movementTrace OFF

for {set i 1} {$i <= $opt(nn)} {incr i} {
    set WT($i) [ $ns_ node $i ]
}

proc coord_proc {a} {
    return [expr 10 * $a ]
}


for {set i 1} {$i <= $opt(nn)} {incr i} {
   $WT($i) set X_ [coord_proc $i]
   $WT($i) set Y_ [coord_proc $i]
   $WT($i) set Z_ 0.0
}

#=================================================
#                     Agents
#=================================================

for {set i 1} {$i < $opt(nn)} {incr i 2} {
   set udp($i) [new Agent/UDP]
   $ns_ attach-agent $WT($i) $udp($i)

   set sink($i) [new Agent/Null]
   $ns_ attach-agent $WT([expr $i +1]) $sink($i)
   $ns_ connect $udp($i) $sink($i)

   set cbr($i) [new Application/Traffic/CBR]
   $cbr($i) set packetSize_ 1000
   $cbr($i) set interval_ 0.005
   $cbr($i) attach-agent $udp($i)

   $ns_ at [expr 20.0 * $i]  "$cbr($i) start"
   $ns_ at $opt(stop) "$cbr($i) stop"
}

#=================================================
#                     End
#=================================================


for {set i } {$i <= $opt(nn) } {incr i} {
      $ns_ at $opt(stop).0000010 "$WT($i) reset";
}

$ns_ at $opt(stop).1 "finish"
$ns_ at $opt(stop).2 "$ns_ halt"

proc finish {} {

for {set i 2} {$i <=6  } {incr i 2} {
    exec rm -f out$i.xgr
    exec awk -f fil$i.awk out.tr > out$i.xgr
}
    exec xgraph out2.xgr out4.xgr out6.xgr &
    puts "Finishing ns.."
    exit 0
}

puts "Starting Simulation..."
$ns_ run
