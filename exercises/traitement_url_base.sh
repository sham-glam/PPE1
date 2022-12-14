#!/usr/bin/env bash

#===============================================================================
# refer to shell.pdf  du cours , pg 41 , in PPE exercises
#VOUS DEVEZ MODIFIER CE BLOC DE COMMENTAIRES.
# Ici, on décrit le comportement du programme.
# Indiquez, entre autres, comment on lance le programme et quels sont
# les paramètres.
# La forme est indicative, sentez-vous libres d'en changer !
# Notamment pour quelque chose de plus léger, il n'y a pas de norme en bash.
#===============================================================================

fichier_urls=$1 # le fichier d'URL en entrée, depuis le terminal ? 
fichier_tableau=$2 # le fichier HTML en sortie

# parameters exist, else exit!

if [ $# -ne 1 ]
	then
	echo "ce programme demande au moins 1 argument "
	exit
fi


if [[ ! -s $1 ]]   
	then
	echo "fichier url vide, fin du programme..."
	exit 

:'
elif [ -f $2 ] 
	then
		echo "fichier HTML existe déjà, veuillez le modifier avant de relancer le script"
		exit 
	fi
'		
fi 
 
# !!!!!!

# !!!!!!
 
# modifier la ligne suivante pour créer effectivement du HTML
#echo "Je dois devenir du code HTML à partir de la question 3" > $fichier_tableau
#use curl -I or curl -S 

lineno=1
unvalid=0

while read -r line ;
do	
	if curl --output /dev/null --silent --head --fail "$line"
		then
		echo $lineno ":" $line
		#header= curl -I "$line"
	else 
		echo "unvalid url number $lineno"
		
	fi
	lineno=$((lineno +1))
	unvalid=$((unvalid +1))
	
done < $fichier_urls

:'
		if [[ $line =~ ^https:// ]]
			then
				echo " ressemble à une URL valide " 
				#$line >> tableau1.html
				#echo "$line $lineno: $line" 
				lineno=$((lineno+1))
				echo $lineno
		
		fi
done < $fichier_urls

#1)line 2)line_number, 3)link -> create html table 

# I have the number of lines lineno


'
