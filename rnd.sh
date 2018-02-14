#!/bin/bash

function round_date(){
    # args: 1-> date; 2-> optional round unit

    # default 15 Minute Round
    local unit_s=$(( ${2:-15} * 60 ))
    # local sections=$(( 3600 / $unit_s ))
    # [ $sections -lt 1 ] && sections=1
    local Y m d H M S
    eval $(date +Y=%Y\;m=%m\;d=%d\;H=%H\;M=%M\;S=%S -d "$1")
    local total_s=$(( $H * 3600 + $M * 60 + $S ))
    [ "$(( $total_s % $unit_s ))" -eq 0 ] && date -d "$1" && return
    # local section=$(echo "($total_s / $unit_s ) % $sections " | bc)
    # local section=$(python2 -c \
    #     "print '%d' % round(($total_s / float(${unit_s})) % $sections)")
    local section=$(python2 -c \
        "print '%d' % round($total_s / float(${unit_s}) )")
    # section=$(LC_ALL=C printf '%.*f\n' 0 $section ) # Round to the nearest unit
    # local round_time_s=$(( ($unit_s * $section ) + $H * 3600 ))
    local round_time_s=$(( $unit_s * $section ))
    H=$(( $round_time_s / 3600 ))
    M=$(( ($round_time_s - $H * 3600) / 60 ))
    echo "remaning secs S: $(( $round_time_s - ( $H * 3600 ) - ( $M * 60 ) ))" >&2

    local nd=$(( $H / 24 ))
    echo 'next day: '"$nd" >&2
    [ $nd -ge 1 ] && let 'H%=24' || unset nd
    echo "$nd" >&2

    # date -d "$Y-$m-$d $H:$M ${nd+$(printf 'next day $.0s' $(seq 1 $nd))}"
    echo "$Y-$m-$d $H:$M ${nd=$(printf 'next day %.0s' $(seq 1 $nd))}"
}

d=${1:-'18-02-14 23:15:50'}
u=${2:-30}
echo "Entered: date: $d ; Round by $u"
ret="$(round_date "$d" $u)"
echo "Returned: $ret"
