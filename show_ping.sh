#!/bin/bash

echo "SHOW PING"
ping 192.168.4.2 -c 2 > text.txt
if [ $? -eq 0 ];
then
        echo Successful;
else
        echo Failure;
fi

string=""
count=1
while read line
do
        string+=$line
	string+=" "
	count=`expr $count + 1`
done < text.txt

if [ $count -ne 6 ];
then
	packet_size=${string#*data. }
	packet_size=${packet_size%% bytes*}
	echo "Packet size : $packet_size"
fi
substring=${string#*--- }

j=1
for a in $substring
do
	if [ $j -eq 1 ];
	then
		echo "Address: $a"
	elif [ $j -eq 5 ];
	then
		echo "Packets transmitted: $a"
	elif [ $j -eq 8 ];
	then
		echo "Received : $a"
	elif [ $j -eq 10 ];
	then
		echo "Packets lose : $a"
	elif [ $j -eq 14 ];
	then
		echo "Time : $a"
	elif [ $j -eq 18 ];
	then
		str=$a
		i=1
		while [ $str ]
		do
			if [ $i -eq 1 ];
			then
				echo "Min : ${str%%/*}"
			elif [ $i -eq 2 ];
			then
				echo "Avg : ${str%%/*}"
			elif [ $i -eq 3 ];
			then
				echo "Max : ${str%%/*}"
			fi	
        		str=${str#*/}
			i=`expr $i + 1`
        		if [ ${str%%/*} = $str ];
        		then
                		echo "Mdev: $str"
                		break

        		fi
		done
	fi
	j=`expr $j + 1`

done
echo "-------------------------"
echo "SHOW TRACEROUTE"
traceroute  -n 192.168.4.2 > text1.txt

if [ $? -eq 0 ];
then
        echo Successful;
else
        echo Failure;
fi
sed -i 's/*/khoa/g' text1.txt

i=0
while read line
do
        if [ $i -eq 0 ];
        then
                j=1
                for str in $line
                do
                        if [ $j -eq 3 ];
                        then
                                echo "Address: $str"
                        elif [ $j -eq 5 ];
                        then
                                echo "Hops max: $str"
                        elif [ $j -eq 8 ];
                        then
                                echo "Byte packets: $str"
						fi
                        j=`expr $j + 1`
                done
        else
                string=${line#$i  }
                string=${string%% *}
                if [ $string = "khoa" ];
                then
                        string=${line#$i  khoa }
                        string=${string%% *}
                        if [ $string = "khoa" ];
                        then
                        		string=${line#$i  khoa khoa }
                       	 		string=${string%% *}
                        		if [ $string = "khoa" ];
                        		then
										echo "$i: * * *"
							
                        		else
                                		echo "$i: $string"
                        		fi

                        else
                                echo "$i: $string"
                        fi
                else
                        echo "$i: $string"
                fi
        fi
        i=`expr $i + 1`
done < text1.txt

