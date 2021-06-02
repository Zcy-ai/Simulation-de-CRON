#!/bin/bash

function install {
#creation du fichier tacheron.allow
if [ ! -f /etc/tacheron.allow ]
then
	touch /etc/tacheron.allow
	if [ $? -eq 0 ]
	then
		echo "creation du fichier tacheron.allow avec succes"
		echo "root" > /etc/tacheron.allow
	else
		echo "Echec de creation du fichier tacheron.allow"
		exit
	fi
fi

#creation du fichier tacheron.deny
if [ ! -f /etc/tacheron.deny ]
then
	touch /etc/tacheron.deny
	if [ $? -eq 0 ]
	then
		echo "creation du fichier tacheron.deny avec succes"
	else
		echo "Echec de creation du fichier tacheron.deny"
		exit
	fi
fi

#creation du repertoire /etc/tacheron
if [ ! -d /etc/tacheron ]
then
	mkdir /etc/tacheron
	if [ $? -eq 0 ]
	then
		echo "creation du repertoire /etc/tacheron avec succes"
	else
		echo "Echec de creation du repertoire /etc/tacheron" 
		exit
	fi
fi

#creation du fichier /var/log
if [ ! -f /var/log/tacheron ]
then
	touch /var/log/tacheron
fi

#creation du fichier /etc/tacheron/tacherontab
if [ ! -f /etc/tacheron/tacherontab ]
then
        touch /etc/tacheron/tacherontab
        if [ $? -eq 0 ]
        then
                echo "creation du fichier tacherontab avec succes"
        else
                echo "Echec de creation du fichier tacherontab"
                exit
        fi
fi

#creation du repertoire tmp/tacheron
if [ ! -d /tmp/tacheron ]
then
        mkdir /tmp/tacheron
        if [ $? -eq 0 ]
        then
                echo "creation du repertoire /tmp/tacheron avec succes"
        else
                echo "Echec de creation du repertoire /tmp/tacheron"
                exit
        fi
fi

}


function tacherontab_syntaxe {
	while read sec min heu jou moi sem cmd
	do
		set -f
		valid=1
		for i in {1,2,3,4,5,6}
		do
			if [ $i -eq 1 ]
			then
				val=3
				contenu=$sec
				#signifier toutes les valuers possibles du champs
				if [ $(echo $contenu | grep "^*$") ]
				then
					valid=0
				#une liste des valeurs valides, separe par virgule
				elif [ $(echo $contenu | grep "^\([0-3],\)\+[0-3]$") ]	
				then 
					valid=0
				#une intervalle
				elif [ $(echo $contenu | grep "^[0-3]-[0-3]$") ]
				then 
					valid=0
				#tous les quelques temps
				elif [ $(echo $contenu | grep "^\*/[0-3]$") ]
				then
					valid=0
				#tous les quelques temps
				elif [ $(echo $contenu | grep "^[0-3]-[0-3]\/[0-3]$") ]
				then
					valid=0
				#la valeur precise
				elif [ $(echo $contenu | grep "^[0-9]\{1,2\}$") ] && [ "$contenu" -le "$val" ]
				then 
					valid=0
				else
					return 1
				fi
			elif [ $i -eq 2 ]
			then
				val=59
				contenu=$min
				#signifier toutes les valuers possibles du champs
				if [ $(echo $contenu | grep "^*$") ]
				then
					valid=0
				 #une liste des valeurs valides, separe par virgule
				elif [ $(echo $contenu | grep "^\([0-5]\?[0-9],\)\+[0-5]\?[0-9]$")  ]	
				then
					valid=0
				#une intervalle
				elif [ $(echo $contenu | grep "^\([0-5]\?[0-9]-\)[0-5]\?[0-9]$") ]
				then
					valid=0
				#tous les quelques temps
				elif [ $(echo $contenu | grep "^\*/[0-9]\?[0-9]$") ]
				then
					valid=0
				elif [ $(echo $contenu | grep "^\([0-5]\?[0-9]-[0-5]\?[0-9]\)\/[0-5]\?[0-9]$") ]
				then
					valid=0
				#une intervalle excepte quelques temps
				elif [ $(echo $contenu | grep "^\([0-5]\?[0-9]-[0-5]\?[0-9]\)\{1\}\(~[0-5]\?[0-9]\)\+$") ]
				then
					valid=0
				#la valeur precise
				elif [ $(echo $contenu | grep "^\([0-5]\?[0-9]\)") ] && [ "$contenu" -le "$val" ] 
				then
					valid=0
				else
					return 1
				fi
			elif [ $i -eq 3 ]
			then
				val=23
				contenu=$heu
				#signifier toutes les valuers possibles du champs
				if [ $(echo $contenu | grep "^*$") ]
				then
				valid=0
				 #une liste des valeurs valides, separe par virgule
				elif [ $(echo $contenu | grep "^\([2][0-3],\|[0-1]\?[0-9],\)\+\([2][0-3]\|[0-1]\?[0-9]\)$") ]
				then
				valid=0
				#une intervalle
				elif [ $(echo $contenu | grep "^\([2][0-3]-\|[0-1]\?[0-9]-\)\([2][0-3]\|[0-1]\?[0-9]\)$") ]
				then
				valid=0
				#tous les quelques temps
				elif [ $(echo $contenu | grep "^\*/[0-9]\{1,2\}$") ]
				then
				valid=0
				#tous les quelques temps
				elif [ $(echo $contenu | grep "^\([2][0-3]-\|[0-1]\?[0-9]-\)\([2][0-3]\|[0-1]\?[0-9]\)/\([2][0-3]\|[0-1]\?[0-9]\)") ]
				then
				valid=0
				#une intervalle excepte quelques temps
				elif [ $(echo $contenu | grep "^\([2][0-3]-\|[0-1]\?[0-9]-\)\([2][0-3]\|[0-1]\?[0-9]\)\(~\([2][0-3]\|[0-1]\?[0-9]\)\)\+") ]
				then
				valid=0
				#la valeur precise
				elif [ $(echo $contenu | grep "^[0-9]\{1,2\}$") ] && [ "$contenu" -le "$val" ]	
				then
				valid=0
				else
				return 1
				fi
			elif [ $i -eq 4 ]
			then
				val=31
				contenu=$jou
				#signifier toutes les valuers possibles du champs
				if [ $(echo $contenu | grep "^*$") ]
				then
				valid=0
				 #une liste des valeurs valides, separe par virgule
				elif [ $(echo $contenu | grep "^\([3][0-1],\|[0-2]\?[0-9],\)\+\([3][0-1]\|[0-2]\?[0-9]\)$") ]
				then
				valid=0
				#une intervalle
				elif [ $(echo $contenu | grep "^\([3][0-1]-\|[0-2]\?[0-9]-\)\([3][0-1]\|[0-2]\?[0-9]\)$") ]	
				then
				valid=0
				#tous les quelques temps
				elif [ $(echo $contenu | grep "^\([3][0-1]-\|[0-2]\?[0-9]-\)\([3][0-1]\|[0-2]\?[0-9]\)/\([3][0-1]\|[0-2]\?[0-9])$") ]
				then
				valid=0
				#tous les quelques temps
				elif [ $(echo $contenu | grep "^\*/[0-9]\{1,2\}$") ]
				then
				valid=0
				#une intervalle excepte quelques temps
				elif [ $(echo $contenu | grep "^\([3][0-1]-\|[0-2]\?[0-9]-\)\([3][0-1]~\|[0-2]\?[0-9]~\)\+\([3][0-1]\|[0-2]\?[0-9]\)$") ]
				then
				valid=0
				#la valeur precise
				elif [ $(echo $contenu | grep "^[0-9]\{1,2\}$") ] && [ "$contenu" -le "$val" ]
				then
				valid=0
				else 
				return 1
				fi			
			elif [ $i -eq 5 ]
			then
				val=12
				contenu=$moi
				#signifier toutes les valuers possibles du champs
				if [ $(echo $contenu | grep "^*$") ]
				then
				valid=0
				 #une liste des valeurs valides, separe par virgule
				elif [ $(echo $contenu | grep "^\([1][0-2],\|[0]\?[0-9],\)\+\([1][0-2]\|[0]\?[0-9]\)$") ]
				then
				valid=0
				#une intervalle
				elif [ $(echo $contenu | grep "^\([1][0-2]-\|[0]\?[0-9]-\)\([1][0-2]\|[0]\?[0-9]\)$") ]
				then
				valid=0
				#tous les quelques temps
				elif [ $(echo $contenu | grep "^\([1][0-2]-\|[0]\?[0-9]-\)\([1][0-2]\|[0]\?[0-9]\)/\([1][0-2]\|[0]\?[0-9]\)$") ]
				then
				valid=0
				#tous les quelques temps
				elif [ $(echo $contenu | grep "^\*/[0-9]\{1,2\}$") ]
				then
				valid=0
				#une intervalle excepte quelques temps
				elif [ $(echo $contenu | grep "^\([1][0-2]-\|[0]\?[0-9]-\)\([1][0-2]~\|[0]\?[0-9]~\)\+\([1][0-2]\|[0]\?[0-9]\)$") ]
				then
				valid=0
				#la valeur precise
				elif [ $(echo $contenu | grep "^[0-9]\{1,2\}$") ] && [ "$contenu" -le "$val" ] 
				then
				valid=0
				else
				return 1
				fi 
			elif [ $i -eq 6 ]
			then
			val=6
			contenu=$sem
				#signifier toutes les valuers possibles du champs
				if [ $(echo $contenu | grep "^*$") ]
				then
				valid=0
				 #une liste des valeurs valides, separe par virgule
				elif [ $(echo $contenu | grep "^\([0-6],\)\+[0-6]$") ]
				then
				valid=0
				#une intervalle
				elif [ $(echo $contenu | grep "^[0-6]-[0-6]$") ]
				then
				valid=0
				#tous les quelques temps
				elif [ $(echo $contenu | grep "[0-6]-[0-6]/[0-6]") ]
				then
				valid=0
				#une intervalle excepte quelques temps
				elif [ $(echo $contenu | grep "[0-6]-\([0-6]~\)\+[0-6]") ]
				then
				valid=0
				#tous les quelques temps
				elif [ $(echo $contenu | grep "^\*/[0-6]$") ]
				then
				valid=0
				#la valeur precise
				elif [ $(echo $contenu | grep "^[0-9]\{1,2\}$") ] && [ "$contenu" -le "$val" ]
				then
				valid=0
				else
				return 1
				fi
			fi
		done								
	done < /tmp/tacheron/tacherontabtemp$(whoami)
return $valid		
}
	
function judge {
	min=$1
	minNow=$2
	#tous les temps peuvent executer
	if [ "$min" == "*" ]
	then
		return 0
	#dans le cas de la valeur precise
	elif [[ "$min" == "$minNow" ]]
	then 
		return 0
	#suites des temps,il faut un entre eux est correspondant
	elif [ $(echo $min | grep ",") ]
	then
		#recherche le temps correspondant
		 cici=$(echo $min | awk -F',' -v time=$minNow '{for(i=1;i<NF;i++)if(time==$i){print "0";break}}')	
		if [ "$cici" = "0" ]
               	then
			return 0
                else
                        return 1
                fi
	#le cas d'une intervalle
	elif [ $(echo $min | grep "^[0-9]\+-[0-9]\+$") ]
	then
		#determiner si le temps est dans le domaine de l'intervalle
		cici=$(echo $min | awk -F'-' -v time=$minNow '{pre=$1;sec=$2;if(time<=sec&&time>=pre){print "0"}}')
		 if [ "$cici" = "0" ]
                then
                        return 0
                else
                        return 1
                fi
	#le cas d'une intervalle excepte quelque temps
	elif [ $(echo $min | grep "~") ]
	then
		pre=$(echo "$min" | cut -d'~' -f1)
		pr=$(echo "$pre" | cut -d'-' -f1)
		se=$(echo "$pre" | cut -d'-' -f2)
		#le premier regle ,c'est dans le cadre de l'intervalle
		if [[ "$pr" -le "$minNow" ]] && [[ "$se" -ge "$minNow" ]]
		then
			coco=$(echo "$min" | cut -d'-' -f2)
			#recherche si le temps est le temps d'exception
			cici=$(echo $coco | awk -F'~' -v a=$minNow '{for(i=2;i<=NF;i++)if(a==$i){print "0";break}}')
			if [ "$cici" = "0" ]
               		then
                       		 return 1
               		else
                           	 return 0
               		fi
		else
			return 1
		fi
	#tous les quelques temps
	elif [ $(echo $min | grep "/") ]
	then
		pre=$(echo "$min" | cut -d'/' -f1)
		sec=$(echo "$min" | cut -d'/' -f2)
		#le cas de *
		if [ "$pre" = "*" ]
		then
			mod=$(expr "$minNow" % "$sec")
			if [ $mod -eq 0 ]
			then
				return 0
			else
				return 1
			fi
		#le cas d'une intervalle
		elif [ $(echo $pre | grep "^[0-9]\+-[0-9]\+$") ]
		then
			pr=$(echo $pre | cut -d'-' -f1)
			se=$(echo $pre | cut -d'-' -f2)
			if [[ "$pr" -le "$minNow" ]] && [[ "$se" -ge "$minNow" ]]
			then
				mod=$(expr "$minNow" % "$sec")
				if [ $mod -eq 0 ]
        	                then
                	                return 0
                       		else
                               	 	return 1
                        	fi
			else
				return 1
			fi
		else
			return 1
		fi
	else
		return 1
	fi
}

#determine si l'utilisateur courant est dans le liste de tacheron.allow
function si_allow {
utilisateur=$(whoami)
if [ $(cat /etc/tacheron.allow | grep "$utilisateur") ]
then
	return 0
else
	return 1
fi
}

#la fonction pour executer,comme le main()
function execution {
utilisateur=$(whoami)
si_allow
if [ $? -eq  0 ]
then
	while read ligne
	do
	set -f
		if [[ -n $ligne ]]
		then
		#on redirige le ligne vers /tmp/tacheron/tacherontemp$utilisateur
		echo $ligne > /tmp/tacheron/tacherontabtemp$utilisateur
		tacherontab_syntaxe
			if [[ $? -eq 0 ]]
			then
				while read sec min heu jou moi sem cmd
				do
				seconde=$sec
				minute=$min
				heure=$heu 
				jour=$jou
				mois=$moi
				semaine=$sem
				commande=$cmd
				#mettre le temps en mode chiffre
				nowSec=$(date +"%S")
				if [ "$nowSec" -eq 0 ]
				then
					nowSec=0	
				elif [ "$nowSec" -eq 15 ]
				then
					nowSec=1 
				elif [ "$nowSec" -eq 30 ]
				then
					nowSec=2
				elif [ "$nowSec" -eq 45	]
				then
					nowSec=3
				else
					nowSec=""
				fi
				now_Min=$(date +"%M")
				nowHeu=$(date +"%H")
				nowJou=$(date +"%d")
				nowMoi=$(date +"%m")
				nowSem=$(date +"%w")
				judge "$seconde" "$nowSec"
				cici1=$?
				judge "$minute" "$now_Min"
				cici2=$?
				judge "$heure" "$nowHeu"
				cici3=$?
				judge "$jour" "$nowJou"
				cici4=$?
				judge "$mois" "$nowMoi"
				cici5=$?
				judge "$semaine" "$nowSem"
				cici6=$?
				cici=`expr $cici1 + $cici2 + $cici3 + $cici4 + $cici5 + $cici6`
					if [ "$cici" -eq 0 ]
					then
						sudo -u $utilisateur $cmd
						if [ $? -eq 0 ]
						then
							echo "bravo! $utilisateur a reussi la commande $cmd"
							echo "command $cmd est execute par $utilisateur en "`date` > /var/log/tacheron
					 	else
							echo "$cmd n'a pas execute par $utilisateur" > /var/log/tacheron
						fi
					fi		
				done < /tmp/tacheron/tacherontabtemp$utilisateur
			else 
				echo "le syntax de tacheron n'est pas valide"
			fi
		fi
	done < /etc/tacheron/tacherontab$utilisateur
else
	echo "vous n'avez pas de droit de utiliser le command tacheron"
fi
}

install
execution
