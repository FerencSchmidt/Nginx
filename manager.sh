#! /bin/bash
    status="0"
    while [ "$status" -eq 0 ]  
    do
        choice=$(whiptail --title "Container manager" --menu "Choose" 16 78 5 \
        "Apache" "" \
        "Nginx" "" \
	"Exit" "" 3>&2 2>&1 1>&3) 

        option=$(echo $choice)
        case "${option}" in
            Apache)

		if (whiptail --title "Create new apache2 worker" --yes-button "New Apache" --no-button "Delete containers" --yesno "If you want to create a new apache2 container, you are in luck!" 10 78) then

		        CNAME=$(whiptail --title "Create new apache2 container" --inputbox "Enter the name of the container" 10 60 NAME goes here 3>&1 1>&2 2>&3)
		        exitstatus=$?
		        if [ $exitstatus = 0 ]; then
                		echo "Creating new container:" $CNAME
		                PORT=$(docker ps --format "{{.Ports}}" | grep -o -P '(?<=\:).*(?=\-)' | awk '{if(max<$1){max=$1;line=$1}}END{print line}')
		                NOFAPACHE=$(docker ps | awk 'END {print NR-2} ')
		                if [ "$NOFAPACHE" -ge "10" ]; then
		                        echo "You cannot start more apache2 containers (max 10)"
		                else
		                        let "PORT++"
		                        cp /vagrant/app/Apache/index.html /vagrant/app/Apache/indextemp.html
		                        sed -i "/Apache2 Ubuntu Default Page/a 192.168.0.6:$PORT" /vagrant/app/Apache/indextemp.html
		                        docker run -tipd  $PORT:80 --name $CNAME apache
		                        cat /vagrant/app/Apache/indextemp.html | docker exec -i $CNAME sh -c 'cat > /var/www/html/index.html'
		                        rm  /vagrant/app/Apache/indextemp.html
		                        echo $CNAME "ip: " && docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CNAME

                		        grep -q "192.168.0.6:$PORT" /vagrant/app/nginx/nginx.conf
		                        if [ "$?" -eq "0" ]; then
                		                echo 'This IP is already in the config file'
		                        else
		                                if [ -f /vagrant/app/nginx/nginx.conf ]; then
		                                        echo "Editing existing config file"
		                                else
		                                        cp /vagrant/app/nginx/nginx.conf /vagrant/app/nginx/nginxtemp.conf
		                                        echo "Creating temporary conf file"
		                                fi
		                                sed -i "/upstream lbalance {/a server 192.168.0.6:$PORT;" /vagrant/app/nginx/nginxtemp.conf
		                                echo "Stopping nginx server and applying new config"
		                                docker stop nginx && docker rm nginx
		                                docker run -tipd 80:80 -v /vagrant/app/nginx/nginxtemp.conf:/usr/local/nginx/conf/nginx.conf --name nginx nginx
		                        fi
		                fi
		        else
                		echo "You chose Cancel."
		        fi
		else

			res=$(docker ps --format "{{.Names}}: {{.Image}}" | grep apache | awk '{print $1}' |sed 's/://'| sort -g |  sed '/$/a Off')
			choice=$(whiptail --noitem --title "Container manager" --checklist "Choose containers to remove." 20 78 10 $res 3>&1 1>&2 2>&3)
			chosen=$(echo $choice | sed 's/"//g' | sed 's/ /\n/g')
			for i in ${chosen}; do
				docker stop $i && docker rm $i
			done
		fi
            ;;
            Nginx)
                whiptail --title "Container manager" --msgbox "You chose Nginx" 8 78

		status2="0"
		while [ "$status2" -eq 0 ]  
		do
        		choice=$(whiptail --title "Testing" --menu "Make a choice" 16 78 5 \
	        	"1" "Start Nginx server." \
        		"2" "Restart Nginx server." \
			"3" "Stop Nginx server." 3>&2 2>&1 1>&3) 
	        	option=$(echo $choice)
        		case "${option}" in
            			1)
				        docker run -tipd 80:80 --name nginx nginx
                			whiptail --title "Container manager" --msgbox "Starting Nginx server with name: nginx" 8 78
	            		;;
        	    		2)
					docker stop nginx
					docker start nginx
                			whiptail --title "Container manager" --msgbox "Restarting Nginx server" 8 78
				;;
				3)
					docker stop nginx && docker rm nginx
					whiptail --title "Container manager" --msgbox "RIP Nginx" 8 78
            			;;
	            		*)
				 	whiptail --title "Testing" --msgbox "Redirecting to the main menu" 8 78
                			status2=1
    		        	;;
	        	esac
    		done

            ;;
            *) whiptail --title "Container manager" --msgbox "Such exit , so bye" 8 78
                status=1
                exit
            ;;
        esac
        exitstatus1=$status1
	
    done

