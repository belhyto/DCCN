{#}{
Write a TCL Program to find the greatest of three numbers.
}

set a 23
set b 12
set c 64

if {$b > $c} {
    puts [expr $b]
} elseif {$a > $c} {
    puts [expr $a]
} else {
    puts [expr $c]
} 
