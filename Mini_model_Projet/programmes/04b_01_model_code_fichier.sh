#!/usr/bin/env bash

# see egrep or others

#===============================================================================
# VOUS DEVEZ MODIFIER CE BLOC DE COMMENTAIRES.
# Ici, on décrit le comportement du programme.
# Indiquez, entre autres, comment on lance le programme et quels sont
# les paramètres.
# La forme est indicative, sentez-vous libres d'en changer !
# Notamment pour quelque chose de plus léger, il n'y a pas de norme en bash.
###################################################
# curl -ILs = -I header -L suivre redirection, -s silencieux  
# grep -e =egrep ^http (line beg with http) , obtained header by curl 
# -Eo grep etendu, o = only d | cut (sérapré par) -d(délimiteur)" "-f2 (f= field/columns, -f2 = looking for 2nd column, délimité par = | tail -n 1 (last line of file) 
# the commands above can be stored in a variable 
#pour fichier csv délimiteur , , donc 
### for context :m
#regexp (...)(mitif à chercher ?)(...)
#regexp (\w+\W)(robots?)(\w\w+)
# cat nomFicher.txt | sed 's/\(.../)robots\?(...)/____/'
#===============================================================================

fichier_urls=$1 # le fichier d'URL en entrée
fichier_tableau=$2 # le fichier HTML en sortie

if [[ $# -ne 2 ]]
then
	echo "Ce programme demande exactement deux arguments."
	exit
fi


# egrep -i "\b(l')?arm(e|es) ((nucl(é|e)air(e|es))|(atomiqu(e|es)))\b" 

mot=$(egrep "\b(street|fast) food\b") 
# street food # à modifier selon langue

echo $fichier_urls;
basename=$(basename -s .txt $fichier_urls)

echo "<html><body>" > $fichier_tableau
echo "<h2>Tableau $basename :</h2>" >> $fichier_tableau
echo "<br/>" >> $fichier_tableau
echo "<table>" >> $fichier_tableau
echo "<tr><th>ligne</th>
	<th>code</th>
	<th>encodage</th>
	<th>URL</th>
	<th>Dumps</th>
	<th>Aspirations</th>
	<th>occurences</th>
	<th>Contexte</th>
	<th>concordances</th></tr>" >> $fichier_tableau

lineno=1;
while read -r URL; do
	echo -e "\tURL : $URL";
	
	# la façon attendue, sans l'option -w de cURL
	code=$(curl -ILs $URL | grep -e "^HTTP/" | grep -Eo "[0-9]{3}" | tail -n 1)
	charset=$(curl -ILs $URL | grep -Eo "charset=(\w|-)+" | cut -d= -f2)

	# autre façon, avec l'option -w de cURL
	# code=$(curl -Ls -o /dev/null -w "%{http_code}" $URL)
	# charset=$(curl -ILs -o /dev/null -w "%{content_type}" $URL | grep -Eo "charset=(\w|-)+" | cut -d= -f2)

	echo -e "\tcode : $code";

	if [[ ! $charset ]]
	then
		echo -e "\tencodage non détecté, on prendra UTF-8 par défaut.";
		charset="UTF-8";
	else
		echo -e "\tencodage : $charset";
	fi

	if [[ $code -eq 200 ]]
	then
		dump=$(lynx -dump -nolist -assume_charset=$charset -display_charset=$charset $URL)
		if [[ $charset -ne "UTF-8" && -n "$dump" ]]
		then
			dump=$(echo $dump | iconv -f $charset -t UTF-8//IGNORE)
		fi
	else
		echo -e "\tcode différent de 200 utilisation d'un dump vide"
		dump=""
		charset=""
	fi
	
	# variable "$mot" always withing quotes 
	
	# dump 
	echo "$dump" > "../dumps-text/$basename-$lineno.txt"
	
	# number of instances of a word , insert in HTML Table 
	occurences=$(grep -E -o -i "$mot" ../dumps-text/$basename-$lineno.txt | wc -l)
	
	
	#concordances :construction concordance avec commande externe : ./ pour execution, si non confusion avec dossier 
	../programmes/concordance.sh ../dumps-text/$basename-$lineno.txt "$mot" > ../concordances/$basename-$lineno.html

	# aspiration
	charset=$(curl -Ls $URL -D - -o "../aspirations/$basename-$lineno.html" | grep -Eo "charset=(\w|-)+" | cut -d= -f2)

	
	
	# extraction des contextes
	contexte=$(grep -E -A2 -B2 "$mot" ../dumps-text/$basename-$lineno.txt > ../contextes/$basename-$lineno.txt)
	echo "$contexte"
	
	## iTrameur 
	
	
	

	echo "<tr><td>$lineno</td>
	<td>$code</td>
	<td>$charset</td>
	<td><a href=\"$URL\">$URL</a></td>
	<td><a href=\"../dumps-text/$basename-$lineno.txt\">en-$lineno</a></td>
	<td><a href=\"../aspirations/$basename-$lineno.html\">en-$lineno</a></td>
	<td>$occurences</td>
	<td><a href=\"../contextes/$basename-$lineno.txt\">en-$lineno</a></td>
	<td><a href=\"./../concordances/$basename-$lineno.html\">en-$lineno</a></td>
	</tr>" >> $fichier_tableau
	
	echo -e "\t--------------------------------"
	lineno=$((lineno+1));
	
done < $fichier_urls
echo "</table>" >> $fichier_tableau
echo "</body></html>" >> $fichier_tableau
