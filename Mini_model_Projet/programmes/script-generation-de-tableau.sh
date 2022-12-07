#!/usr/bin/env bash

#===============================================================================
# VOUS DEVEZ MODIFIER CE BLOC DE COMMENTAIRES.
# Ici, on décrit le comportement du programme.
# Indiquez, entre autres, comment on lance le programme et quels sont
# les paramètres.
# La forme est indicative, sentez-vous libres d'en changer !
# Notamment pour quelque chose de plus léger, il n'y a pas de norme en bash.
#===============================================================================

fichier_urls=$1 # le fichier d'URL en entrée contenant les URLS
#fichier_tableau=$2 # le fichier HTML en sortie qui génére un tableau

# modifier la ligne suivante pour créer effectivement du HTML

echo "<html><header><meta charset=\"urf-8\"/><title>TABlEAU DES URLS</title><body><table border=\"10px\">" > tableau.html

i=0 #cela permet d'ajouter la numérotation au début

while read line #condition while = read line
	do	
	echo "<tr><td>$((i=i+1))<td>$line</td></td></tr>" >> tableau.html
	done < $fichier_urls

echo "</table></body></html>" >> premier-tableau.html
