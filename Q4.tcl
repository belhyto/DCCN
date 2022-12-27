puts "Enter an array: "
gets stdin inputString
foreach char [split $inputString ","] {
if {$char >= "A" && $char <= "Z"} {
puts \n$char\tUpper
} elseif {$char >= "a" && $char <= "z"} {
puts \n$char\tlower
} elseif {$char >= "0" && $char <= "9"} {
puts \n$char\tdigit
} else {
puts \n$char\tSpecialCharacter
}
}
