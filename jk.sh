########
top -n 1 -b > /root/cpu.txt
top -n 1 -b -o  %MEM > /root/mem.txt
declare -i  gen=`df -lh |grep  "/$" |awk  '{print $5}' |awk -F % '{print $1}'`
cpuC=`cat /root/cpu.txt |grep  average |awk -F : '{print $5}' |awk -F , '{print $3}'`
processor=`lscpu |grep 'CPU(s):' |awk '{print $2}'`
memused=`free -m |grep  Mem |awk '{print $3}'`
memtotal=`free -m |grep  Mem |awk '{print $2}'`
mem=`echo $memused \* $memtotal |bc `
echo "$cpuC + --$memtotal"
echo "========="
echo "========="
cpu=`echo "$cpuC \* $processor" | bc `
echo "cou：$cpu"
echo "========="
echo "cpu使用率：$cpu%"
echo "内存使用率：$mem%"
echo "磁盘使用率：$gen%"
#############i#
#echo "您才怎么找 $cpu"
echo `date +%c`>> /root/xingnengjiankong_log

if
	[ !   -e  /root/xingnengjiankong_log ];
then
 	touch  /root/xingnengjiankong_log
	echo `date +%c`>> /root/xingnengjiankong_log
fi
#####

`
if
	[ $cpu -ge 80 ];
	 then
	 echo "警告：CPU使用量过高！" >> /root/xingnengjiankong_log
	 echo "cpu使用量最高的五个进程为："  >> /root/xingnengjiankong_log
	 sed -n '7,12p' /root/cpu.txt >> /root/xingnengjiankong_log
else  
	 echo "您的CPU状况良好！" >> /root/xingnengjiankong_log
 fi
`
######

if
	[ $mem -ge 90 ];
then
	echo `date +%c`>> /root/xingnengjiankong_log
	echo "警告：内存使用量过高！" >> /root/xingnengjiankong_log
	echo "内存使用量最高的五个进程为："  >> /root/xingnengjiankong_log
	sed -n '7,12p' /root/mem.txt >> /root/xingnengjiankong_log
else  
	echo "您的内存还行！" >> /root/xingnengjiankong_log
fi
##########											
if
	[ $gen -ge 80 ];
then
	echo "警告：磁盘空间不太够了！" >> /root/xingnengjiankong_log
else
	echo "磁盘空间很大,请放心使用！" >> /root/xingnengjiankong_log
fi

	wy_MAIL=2683195565
#	`hostnamectl | awk '1d'`>/home/king/hostname
	echo $hostname
	echo "hellow"
	echo "请到ip为frozenfish的主机进行维护" >> /root/xingnengjiankong_log

###
 if					 	    
	 cat /root/xingnengjiankong_log |grep "警告" >/dev/null
	then
	echo "详情请查看附件" |mail -s "监控日志" -a /root/xingnengjiankong_log  $wy_MAIL@qq.com	
if [ $? -eq 0 ];
	then
		echo "监控日志发送成功，请到$wy_MAIL@qq.com查看"
else
	echo "监控日志发送失败"

fi
#########

rm -rf /root/xingnengjiankong_log
else
	DD=`ls -lh /root/xingnengjiankong_log |awk '{print $7}'`
	[ $DD -ge 20480 ];
	rm -rf /root/xingnengjiankong_log
fi
