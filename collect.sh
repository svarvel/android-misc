#!/bin/bash
if [ $# -ne 3 ] 
then 
	echo "====================================================="
	echo "USAGE: $0 devic-id software-log duration"
	echo "====================================================="
	exit -1 
fi 
device_id=$1
software_log=$2
duration=$3 
t_start=`date +%s`
t_current=`date +%s`
let "t_passed = t_current - t_start"
dev_model=`adb -s $device_id shell getprop ro.product.model | sed s/" "//g`
android_vrs=`adb -s $device_id shell getprop ro.build.version.release`
echo -e "Phone:$dev_model\tAndroid:$android_vrs" > $software_log
while [ $t_passed -lt $duration ] 
do
	adb -s $device_id shell cat sys/class/power_supply/*/uevent | grep "CURRENT_NOW\|VOLTAGE_NOW" | head -n 2 | awk -v t=$t_passed 'BEGIN{ans=t} {split($1, A, "="); ans=ans"\t"A[2]; }END{print ans}' >> $software_log
	t_current=`date +%s`
	let "t_passed = t_current - t_start"
done
