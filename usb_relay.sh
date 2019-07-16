#! /bin/bash

dev="/dev/ttyUSB0"
up_sign=0
down_sign=0
delay=0.5

help="usag:\n\
\t-u\t power up\n\
\t-d\t power down\n\
\t-s\t device default /dev/ttyUSB0\n\
\t-t n\t delay n second,default 0.5s\n\
\t-ud\t power up then power down\n\
\t-du\t power down then power up\n
\t-dut 2\t power down and delay 2s then power up"

while getopts "uUdDhs:t:" arg;
do
	case $arg in
	u|U)
		up_sign=$OPTIND
	;;
	d|D)
		down_sign=$OPTIND
	;;
	s)
		dev=$OPTARG
	;;
	t)
		delay=$OPTARG
	;;
	h)
	echo -e $help
	exit
	;;
	esac
done

if [ ! -e $dev ] ;then
	echo "$dev not valid"
	exit 1
fi

if( [ $up_sign -ne 0 ] && [ $down_sign -ne 0 ] ) ;then
	#echo "up$up_sign/down:$down_sign delay$delay s"
	stty -F $dev 9600
	if [ $up_sign -gt $down_sign ];then
		#echo "-du power down after power up"	
		echo -e "\xA0\x01\x00\xA1" >$dev
		sleep $delay 
		echo -e "\xA0\x01\x01\xA2" >$dev
	else
		#echo "-ud power up after power down"
		echo -e "\xA0\x01\x01\xA2" >$dev
		sleep $delay 
		echo -e "\xA0\x01\x00\xA1" >$dev
	fi
else
	stty -F $dev 9600
	if [ $up_sign -ne 0 ] ;then
		echo -e "\xA0\x01\x01\xA2" >$dev
	fi
	
	if [ $down_sign -ne 0 ] ;then
		echo -e "\xA0\x01\x00\xA1" >$dev
	fi
#echo "up/down 0"
fi
