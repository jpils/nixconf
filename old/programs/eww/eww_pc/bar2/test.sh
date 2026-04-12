#!/bin/sh

create_button() {
	arg0="$1"
	arg1="$2"
	arg2="$3"
	arg3="$4"
	arg4="$5"

	workspace="$1$2$3"

	if [ "$workspace" != "0" ] && [ -n "$arg4" ]; then
		echo "(button :onclick \"wmctrl -s $arg0\"  :class     \"$arg1$arg2$arg3\"   \"$arg4\")"
	fi
}

ws1=6
un="0"
o1="0"
f1="0"
symbol1=""

echo 	"(box	:class \"works\" :orientation \"v\"	:halign \"center\"	:valign \"start\"	 :space-evenly \"false\" :spacing \"-5\" $(create_button $ws1 $un $o1 $f1 $symbol1) $(create_button $ws2 $un $o2 $f2 $symbol2)$(create_button $ws3 $un $o3 $f3 $symbol3) $(create_button $ws4 $un $o4 $f4 $symbol4) $(create_button $ws5 $un $o5 $f5 $symbol5)"
