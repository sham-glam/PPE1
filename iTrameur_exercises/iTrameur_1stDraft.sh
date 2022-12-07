#!/usr/bin/env bash

# attention , doit être lancé depuis la racine du projet.
#Cela lui permet de récupérer les fichiers dans les bons dossiers.
#
#se lancera donc comme ça : 
#$ ./programmes/corrections_itrameur.sh
#

if [[ $# -ne 2 ]]
then
	echo "Deux arguments attendus: <dossier><langue>"
	exit
fi

# basename correspond à la langue étudié

folder=$1 # dumps-text OU contextes
basename=$2 # en, fr, ru, pl, it ... etc. 

echo "<lang=\"basename\">"

for  filepath in $(ls $folder/$basename-*.txt)
do 
	echo "<page=\"pagename\">" > "itrameur/$folder-$basename.txt"
	echo "<text>"
	
	#on récupère les dumps/contextes
	# et on écrit à l'intérieur de la balise text
	content=$( cat $filepath)
	
	# ordre important : & en premier
	#sinon : < => &lt; => &amp; lt; 
	content=$(echo "$content"| sed 's/&amp;/g')
	content=$(echo "$content" | sed 's/</&lt;g')
	content=$(echo "$content"| sed 's/</&gt;g')
			
	# on récupère les dumps/contextes 
	#et on écrit à l'intérieur de la balise text
	
	echo "</text>"
	ehco "</page>§"
done

ehco "</lang>"
