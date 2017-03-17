#/bin/bash
#killitif function given
function killitif {
    docker ps -a  > /tmp/yy_xx$$
    if grep --quiet web1 /tmp/yy_xx$$ #these are all of the commands for web1
     then
     echo "killing older web1 and switching to web2" #first you have to kill it
     docker rm -f `docker ps -a | grep web1  | sed -e 's: .*$::'` #changed to grep web1 specifically not $1 this kills it (web1)
     docker run --name web2 --net ecs189_default -dP $1 #this runs $1 as web2 and lets you join it
     sleep 10 && docker exec ecs189_proxy_1 /bin/bash /bin/swap2.sh #exactly from dorun.sh just added swap2.sh at the end instead of init.sh because swap2.sh swaps from web1 to web2
     echo "redirecting to the service" 
     echo "...nginx restarted, should be ready to go!" 
	else # for web2 to web1 switch
	 echo "killing older web2 and switching to web1"
	 docker rm -f `docker ps -a | grep web2  | sed -e 's: .*$::'` #changed to grep web2 specifically not $1 this kills it (web2)
	 docker run --name web1 --net ecs189_default -dP $1 # this runs $1 as web1 and lets you join it
	 sleep 10 && docker exec ecs189_proxy_1 /bin/bash /bin/swap1.sh # exactly from dorun.sh just added swap1.sh at end instead of init.sh because swap1.swaps from web2 to web 1
	 echo "redirecting to the service"
         echo "...nginx restarted, should be ready to go!"
     	
    fi
}
killitif $1

#test incase there is no docker image

