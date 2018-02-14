#!/bin/bash

function round_date(){
    # args: 1-> date; 2-> optional round unit

    # default 15 Minute Round
    local unit_s=$(( ${2:-15} * 60 ))
    local halfu_s=$(( $unit_s / 2 ))
    local sections=$(( 3600 / $unit_s ))
    local Y m d H M
    eval $(date +Y=%Y\;m=%m\;d=%d\;H=%H\;M=%M -d "$1")
    local total_s=$(( $H * 3600 + $M * 60 ))
    [ "$(( $total_s % $unit_s ))" -eq 0 ] && date -d "$1" && return
    # local section=$(echo "($total_s / $unit_s ) % $sections " | bc)
    local section=$(python2 -c \
        "print '%d' % round(($total_s / float(${unit_s})) % $sections)")
    # section=$(LC_ALL=C printf '%.*f\n' 0 $section ) # Round to the nearest unit
    local round_time_s=$(( ($unit_s * $section ) + $H * 3600 ))
    H=$(( $round_time_s / 3600 ))
    M=$(( ($round_time_s - $H * 3600) / 60 ))

    date -d "$Y-$m-$d $H:$M"
}

d=${1:-'18-02-14 15:57:30'}
u=${2:-5}
echo "Entered: $d $u"
ret="$(round_date "$d" $u)"
echo "Returned: $ret"
