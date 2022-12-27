#Q6-------------

#tclsh <filename>.tcl

puts "Enter a number"
gets stdin b
set sum 0
set i 0
while {$i<=$b} {
 set sum [expr $sum+$i]
 incr i
}
puts "The sum of first $b natural numbers is $sum"
