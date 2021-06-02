#! /bin/bash
#This is the file to creat the command "tacherontab"
#To make this command valid, 
#add a line in the file .bashrc: source ~/tacherontab.sh
#And excute the command : source .bashrc 

function tacherontab {
        #To check whether the input command is right
        if [ $# -ne 3 ]
        then
                echo "The right way to use is: tacherontab -u user -l|-r|-e"
        fi
        if [ "$1" != "-u" ] && [ "$3" != "-l" -o  "$3" -o  "$3" != "-e" ] ;
        then
                echo "The right way to use is: tacherontab -u user -l|-r|-e"
        fi

        #To check whether the user exists
        check_user=$( cat /etc/tacherontab | cut -d' ' -f8 | grep "^$2$" )
        user_flag=0
        if [ "$check_user" == "" ]
        then
                echo "The user does not exist."
        else
                tmp_user=$2
                user_flag=1
        fi

        #The command : tacherontab -u user -l
        if [ "$1" == "-u" -a "$3" == "-l" -a $user_flag -eq 1 ]
        then
                cat /etc/tacheron/$tmp_user
        fi

        #The command : tacherontab -u user -r
        if [ "$1" == "-u" -a "$3" == "-r" -a $user_flag -eq 1 ]
        then
                echo "Are you sure to delete this user ? [y/n]"
                read ans
                if [ $ans == "y" -o $ans == "Y" ]
                then
                        rm -rf /etc/tacheron/$tmp_user
                        echo "Deleting user successfully."
                        temp_line_etc=$( cat /etc/tacherontab | cut -d' ' -f8 | grep "^$2$" )
                        temp_line_var=$( cat /var/log/tacheron | cut -d' ' -f8 | grep "^$2$" )
                        for i in $temp_line_etc
                        do
                                sed -i '$i d' /etc/tacherontab
                        done
                        for j in $time_line_var
                        do
                                sed -i '$j d' /var/log/tacheron
                        done
                        echo "Deleting the info of this user successfully."
                fi
        fi

        #The command : tacherontab -u user -e
        if [ "$1" == "-u" -a "$3" == "-e" -a $user_flag -eq 1 ]
        then
                vi /tmp/tacheron
                if [ -s /tmp/tacheron ]
                then
                        cat /tmp/tacheron >> /etc/tacheron/$tmp_user
                        awk -F' ' '{ print $1,$2,$3,$4,$5,$6,$7,"$tmp_user",$8 >> "/etc/tacherontab" } ' /tmp/tacheorn
                        awk -F' ' '{ print $1,$2,$3,$4,$5,$6,$7,"$tmp_user",$8 >> "/var/log/tacheron" } ' /tmp/tacheron
                        echo "New task adding succesfully."
                        cat /dev/null > /tmp/tacheron
                fi
        fi
}

                                                                                                                                    

