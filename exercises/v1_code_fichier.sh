#!/usr/bin/env bash

# version 07_12

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

#en tête html
echo "<html><head><meta charset=\"utf-8\"/></head><body>">$tableaux/tableau_fr.html
echo "<html><head><meta charset=\"utf-8\"/></head><body>">$tableaux/tableau_en.html
echo "<html><head><meta charset=\"utf-8\"/></head><body>">$tableaux/tableau_ch.html
echo "<table align=\"center\" border=\"1px\" bordercolor=green>">>$tableaux/tableau_fr.html
echo "<table align=\"center\" border=\"1px\" bordercolor=green>">>$tableaux/tableau_en.html
echo "<table align=\"center\" border=\"1px\" bordercolor=green>">>$tableaux/tableau_ch.html

echo "<tr><td>$lineno</td><td>$code</td><td>$charset</td><td><a href=\"$URL\">$URL</a>
</td><td>Page</td><td>DUMP</td><td>index</td><td>bigrammes</td><td>contextes</td>
<td>occurences</td></tr>">>$tableaux/tableau_en.html

if [[ $# -ne 2 ]]
then
	echo "Ce programme demande exactement deux arguments."
	exit
fi

mot="fast food" # à modifier

echo $fichier_urls;
basename=$(basename -s .txt $fichier_urls)

echo "<html><body>" > $fichier_tableau
echo "<h2>Tableau $basename :</h2>" >> $fichier_tableau
echo "<br/>" >> $fichier_tableau
echo "<table>" >> $fichier_tableau
echo "<tr><th>ligne</th><th>code</th><th>encodage</th><th>URL</th><th>occurences</th><th>Contexte</th></tr>" >> $fichier_tableau

lineno=1;
while read -r URL; do
	echo -e "\tURL : $URL";
	
	counter = 1
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
	
	# variable "$mot" always within quotes 
	
	# dump 
	echo "$dump" > "dumps-text/$basename-$lineno.txt"
	
	
	# number of instances of a word , insert in HTML Table 
	nb_occurences=$(grep -E -o -i "$mot" ./dumps-text/$basename-$lineno.txt | wc -l)
	echo "$nb_occurences"
	
	#concordances :construction concordance avec commande externe : ./ pour execution, si non confusion avec dossier 
	./concordance_gitProf.sh ./dumps-text/$basename-$lineno.txt "$mot" > ./concordances/$basename-$lineno.html

	# aspiration
	charset=$(curl -Ls $URL -D - -o "./aspirations/$basename-$lineno.html" | grep -Eo "charset=(\w|-)+" | cut -d= -f2)
	####
	
	
	# extraction des contextes
	contexte=$(grep -E -A2 -B2 "$mot" ./dumps-text/$basename-$lineno.txt > ./contextes/$basename-$lineno.txt)
	
	
	
	echo "<tr><td>$lineno</td><td>$code</td><td>$charset</td><td><a href=\"$URL\">$URL</a></td>
	<td><a href=\"./dumps-text/index-$counter-$lineno.txt\">$aspirations</a></td>
	<td>$occurences</td><td>$contexte</td></tr>" >> $fichier_tableau
	
	echo -e "\t--------------------------------"
	lineno=$((lineno+1));
	
done < $fichier_urls
echo "</table>" >> $fichier_tableau
echo "</body></html>" >> $fichier_tableau
