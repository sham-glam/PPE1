# 2ndInspiration



#!usr/bin/bash
#pour lancer le script :
#bash premierscript.sh <dossier URLS> <dossier TABLEAUX>

#stocker les arguments dans des variables
fichier_urls=$1 # le fichier d'URL en entrée
fichier_tableau=$2 # le fichier HTML en sortie

mot="fast food" # à modifier


#echo $dossier_url
#echo $dossier_tableau

#en tête html
#echo "<html><head><meta charset=\"utf-8\"/></head><body>">$tableaux/tableau_fr.html
echo "<html><head><meta charset=\"utf-8\"/></head><body>">$tableaux/tableau_en.html
#echo "<html><head><meta charset=\"utf-8\"/></head><body>">$tableaux/tableau_ch.html
#echo "<table align=\"center\" border=\"1px\" bordercolor=green>">>$tableaux/tableau_fr.html
echo "<table align=\"center\" border=\"1px\" bordercolor=green>">>$tableaux/tableau_en.html
#echo "<table align=\"center\" border=\"1px\" bordercolor=green>">>$tableaux/tableau_ch.html

#echo "<tr><td>$lineno</td><td>$code</td><td>$charset</td><td><a href=\"$URL\">$URL</a></td>
	#<td>$occurences</td><td>$contexte</td></tr>" >> $fichier_tableau

echo "<tr><td>$lineno</td><td>$code</td><td>$charset</td><td>URL</td>
<td>Page</td><td>DUMP</td><td>index</td><td>bigrammes</td><td>contextes</td>
<td>occurences</td></tr>">>$tableaux/tableau_en.html

#echo "<tr><td>$lineno</td><td>HTTP</td><td>Encodage</td><td>URL</td><td>Page</td><td>DUMP</td><td>index</td><td>bigrammes</td><td>contextes</td><td>occurences</td></tr>">>$dossier_tableau/tableau_fr.html
#echo "<tr><td>$lineno</td><td>HTTP</td><td>Encodage</td><td>URL</td><td>Page</td><td>DUMP</td><td>index</td><td>bigrammes</td><td>contextes</td><td>occurences</td></tr>">>$dossier_tableau/tableau_jp.html

#on crée un compteur de tableau
#countTable=0;

lineno=1;


	
###################################################################################################### 	
	
	
	


	
#lire le fichier d'urls
for fichier in $(ls $fichier_urls); do
   echo "fichier lu : $fichier"
   counterTable=$(($counterTable+1))
   compteur=0
#lire chaque ligne du dossier
   if [[ $fichier == *"fast-food"* ]]
       then
           while read line; do
               compteur=$(($compteur+1))
               codeHTTP=$(curl -L -w '%{http_code}\n' -o ./aspirations/$counterTable-$compteur.html $line)

                if [[ $codeHTTP == 200 ]]
                   then
                       #on nettoie la variable (il faut aussi tout mettre en maj) avec tr [[:lower:]] [[:upper:]]
                       #Ajout d'un egrep dans encodageutf8    pour sortir un encodage positif si UTF8 apparait au moins une fois
                       encodageutf8=$(curl -L -I $line | egrep charset | cut -d"=" -f2 | tr -d '\r' | tr -d '\n'| tr [[:lower:]] [[:upper:]] | egrep -o "UTF-8"| uniq)
                       echo "encodage utf8 = $encodageutf8"
                       #on verifie l'encodage
                       if [[ $encodageutf8 == "UTF-8" ]]
                           then
                               texte=$(lynx --assume_charset "UTF-8" --dump "./aspirations/$counterTable-$compteur.html")
                               echo "$texte"> ./dumps-text/$counterTable-$compteur.txt
                               
                               #index # cptTalbleau = lineno
                               index=$(echo "$texte" |grep -o -P '\w+' | sort | uniq -c | sort -n | sort -r)
                               echo "$index" > ./dumps-text/index-$counterTable-$compteur.txt
                               echo "$texte" | grep -o -P '\w+' | head -n -1 > ./dumps-text/bigramme1-$counterTable-$compteur.txt
                               echo "$texte" | grep -o -P '\w+' | tail -n +2 > ./dumps-text/bigramme2-$counterTable-$compteur.txt
                               # bigramme
                               bigramme=$(paste ./dumps-text/bigramme1-$counterTable-$compteur.txt ./dumps-text/bigramme2-$counterTable-$compteur.txt | sort | uniq -c | sort -r)
                               echo "$bigramme" > ./dumps-text/bigramme-$counterTable-$compteur.txt
                               echo "$texte" | grep -E -o '(\w+[^[:alpha:]]+){,5}(A|a)lcools?([^[:alpha:]]+\w+){,5}' > ./contextes/contexte-$counterTable-$compteur.txt
                               occurences=$(echo "$texte" | grep -o -E "\b(A|a)lcools?\b" | grep -c -E "\b(A|a)lcools?\b")
                               echo "$occurences"
                               echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>$encodageutf8</td><td><a href=\"$line\">$line</a>
                               </td><td><a href=\"../aspirations/$counterTable-$compteur.html\">$counterTable-$compteur</a></td>
                               <td><a href=\"../dumps-text/$counterTable-$compteur.txt\">$counterTable-$compteur</a></td>
                               <td><a href=\"../dumps-text/index-$counterTable-$compteur.txt\">index-$counterTable-$compteur</a></td>
                               <td><a href=\"../dumps-text/bigramme-$counterTable-$compteur.txt\">bigramme-$counterTable-$compteur</a></td>
                               <td><a href=\"../contextes/contexte-$counterTable-$compteur.txt\">contexte-$counterTable-$compteur</a></td>
                               <td>$occurences</td></tr>" >> $tableaux/tableau_fr.html
                               # bigramme
                               bigramme=$(paste ./dumps-text/bigramme1-$cptTableau-$compteur.txt ./DUMP-TEXT/bigramme2-$cptTableau-$compteur.txt | sort | uniq -c | sort -r)
                               echo "$bigramme" > ./dumps-text/bigramme-$counterTable-$compteur.txt
                               echo "$texte" | grep -E -o '(\w+[^[:alpha:]]+){,5}(A|a)lcools?([^[:alpha:]]+\w+){,5}' > ./contextes/contexte-$counterTable-$compteur.txt
                               occurences=$(echo "$texte" | grep -o -E "\b(A|a)lcools?\b" | grep -c -E "\b(A|a)lcools?\b")
                               echo "$occurences"
                               echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>$encodageutf8</td><td><a href=\"$line\">$line</a></td>
                               <td><a href=\"../aspirations/$cptTableau-$compteur.html\">$counterTable-$compteur</a></td>
                               <td><a href=\"../dumps-text/$counterTable-$compteur.txt\">$counterTable-$compteur</a></td>
                               <td><a href=\"../dumps-text/index-$counterTable-$compteur.txt\">index-$counterTable-$compteur</a></td>
                               <td><a href=\"../dumps-text/bigramme-$counterTable-$compteur.txt\">bigramme-$counterTable-$compteur</a></td>
                               <td><a href=\"../contextes/contexte-$counterTable-$compteur.txt\">contexte-$counterTable-$compteur</a></td>
                               <td>$occurences</td></tr>" >> $dossier_tableau/tableau_fr.html
                               else
                               #dans le cas où l'encodage n'est pas UTF-8
                               encodage=$(curl -L -I $line | egrep charset | cut -d"=" -f2 | tr -d '\r' | tr -d '\n'| tr [[:lower:]] [[:upper:]]);
                               echo "raté $encodage" > ./DUMP-TEXT/$cptTableau-$compteur.txt
                               echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>$encodage</td><td><a href=\"$line\">$line</a></td><td><a href=\"../aspirations/$counterTable-$compteur.html\">$counterTable-$compteur</a>
                               </td><td><a href=\"../dumps-test/$counterTable-$compteur.txt\">$counterTable-$compteur</a></td><td><a href=\"../dumps-text/index-$counterTable-$compteur.txt\">index-$counterTable-$compteur</a></td>
                               <td>-</td><td>-</td><td>-</td></tr>" >> $tableaux/tableau_fr.html
                           fi
                   #On essaye d'attraper une url


                   else
                       echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>-</td><td><a href=\"$line\">$line</a></td><td>-</td>
                       <td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>">>$tableaux/tableau_fr.html
                   fi
               echo "$texte" >> ./aspirations/corpus_fr.txt       
                
       #Redirection de flux entrant
           done < $URLS/$fichier
           echo "</table>">>$dossier_tableau/tableau_fr.html
           echo "</body></html>">>$dossier_tableau/tableau_fr.html
   elif [[ $fichier == *"alcohol"* ]]
       then
           while read line; do
               compteur=$(($compteur+1))
               codeHTTP=$(curl -L -w '%{http_code}\n' -o ./PAGES-ASPIREES/$cptTableau-$compteur.html $line)

                if [[ $codeHTTP == 200 ]]
                   then
                       #on nettoie la variable (il faut aussi tout mettre en maj) avec tr [[:lower:]] [[:upper:]]
                       #Ajout d'un egrep dans encodageutf8    pour sortir un encodage positif si UTF8 apparait au moins une fois
                       encodageutf8=$(curl -L -I $line | egrep charset | cut -d"=" -f2 | tr -d '\r' | tr -d '\n'| tr [[:lower:]] [[:upper:]] | egrep -o "UTF-8"| uniq)
                       echo "encodage utf8 = $encodageutf8"
                       #on verifie l'encodage
                       if [[ $encodageutf8 == "UTF-8" ]]
                           then
                               texte=$(lynx --assume_charset "UTF-8" --dump "./PAGES-ASPIREES/$cptTableau-$compteur.html")
                               echo "$texte"> ./DUMP-TEXT/$cptTableau-$compteur.txt
                               index=$(echo "$texte" |grep -o -P '\w+' | sort | uniq -c | sort -n | sort -r)
                               echo "$index" > ./DUMP-TEXT/index-$cptTableau-$compteur.txt
                               echo "$texte" | grep -o -P '\w+' | head -n -1 > ./DUMP-TEXT/bigramme1-$cptTableau-$compteur.txt
                               echo "$texte" | grep -o -P '\w+' | tail -n +2 > ./DUMP-TEXT/bigramme2-$cptTableau-$compteur.txt
                               bigramme=$(paste ./DUMP-TEXT/bigramme1-$cptTableau-$compteur.txt ./DUMP-TEXT/bigramme2-$cptTableau-$compteur.txt | sort | uniq -c | sort -r)
                               echo "$bigramme" > ./DUMP-TEXT/bigramme-$cptTableau-$compteur.txt
                               echo "$texte" | grep -E -o '(\w+[^[:alpha:]]+){,5}(A|a)lcohol?([^[:alpha:]]+\w+){,5}' > ./CONTEXTES/contexte-$cptTableau-$compteur.txt
                               occurences=$(echo "$texte" | grep -o -E "\b(A|a)lcohol\b" | grep -c -E "\b(A|a)lcohol\b")
                               echo "$occurences"
                               echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>$encodageutf8</td><td><a href=\"$line\">$line</a></td><td><a href=\"../PAGES-ASPIREES/$cptTableau-$compteur.html\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/index-$cptTableau-$compteur.txt\">index-$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/bigramme-$cptTableau-$compteur.txt\">bigramme-$cptTableau-$compteur</a></td><td><a href=\"../CONTEXTES/contexte-$cptTableau-$compteur.txt\">contexte-$cptTableau-$compteur</a></td><td>$occurences</td></tr>" >> $dossier_tableau/tableau_en.html
                               else
                               #dans le cas où l'encodage n'est pas UTF-8
                               encodage=$(curl -L -I $line | egrep charset | cut -d"=" -f2 | tr -d '\r' | tr -d '\n'| tr [[:lower:]] [[:upper:]]);
                               echo "raté $encodage" > ./DUMP-TEXT/$cptTableau-$compteur.txt
                               echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>$encodage</td><td><a href=\"$line\">$line</a></td><td><a href=\"../PAGES-ASPIREES/$cptTableau-$compteur.html\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/index-$cptTableau-$compteur.txt\">index-$cptTableau-$compteur</a></td><td>-</td><td>-</td><td>-</td></tr>" >> $dossier_tableau/tableau_en.html
                           fi
                   #On essaye d'attraper une url


                   else
                       echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>-</td><td><a href=\"$line\">$line</a></td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>">>$dossier_tableau/tableau_en.html
                   fi
               echo "$texte" >> ./PAGES-ASPIREES/corpus_en.txt    
       #Redirection de flux entrant
           done < $dossier_url/$fichier
           echo "</table>">>$dossier_tableau/tableau_en.html
           echo "</body></html>">>$dossier_tableau/tableau_en.html
   elif [[ $fichier == *"osake"* ]]
       then
           while read line; do
               compteur=$(($compteur+1))
               codeHTTP=$(curl -L -w '%{http_code}\n' -o ./PAGES-ASPIREES/$cptTableau-$compteur.html $line)

                if [[ $codeHTTP == 200 ]]
                   then
                       #on nettoie la variable (il faut aussi tout mettre en maj) avec tr [[:lower:]] [[:upper:]]
                       #Ajout d'un egrep dans encodageutf8    pour sortir un encodage positif si UTF8 apparait au moins une fois
                       encodageutf8=$(curl -L -I $line | egrep charset | cut -d"=" -f2 | tr -d '\r' | tr -d '\n'| tr [[:lower:]] [[:upper:]] | egrep -o "UTF-8"| uniq)
                       echo "encodage utf8 = $encodageutf8"
                       #on verifie l'encodage
                       if [[ $encodageutf8 == "UTF-8" ]]
                           then
                               texte=$(lynx --assume_charset "UTF-8" --dump "./PAGES-ASPIREES/$cptTableau-$compteur.html")
                               echo "$texte"> ./DUMP-TEXT/$cptTableau-$compteur.txt

                                #Il faut segmenter le japonais afin de le traiter par la suite
                               #Ici, on le fait passer par un petit script python qui va le segmenter, mais aussi le nettoyer 
                               texte=$(python3 ./PROGRAMMES/japanese_segmenter.py "$texte")

                                index=$(echo "$texte" |grep -o -P '\w+' | sort | uniq -c | sort -n | sort -r)
                               echo "$index" > ./DUMP-TEXT/index-$cptTableau-$compteur.txt
                               echo "$texte" | grep -o -P '\w+' | head -n -1 > ./DUMP-TEXT/bigramme1-$cptTableau-$compteur.txt
                               echo "$texte" | grep -o -P '\w+' | tail -n +2 > ./DUMP-TEXT/bigramme2-$cptTableau-$compteur.txt


                               bigramme=$(paste ./DUMP-TEXT/bigramme1-$cptTableau-$compteur.txt ./DUMP-TEXT/bigramme2-$cptTableau-$compteur.txt | sort | uniq -c | sort -r)
                               echo "$bigramme" > ./DUMP-TEXT/bigramme-$cptTableau-$compteur.txt
                               echo "$texte" | grep -E -o '(\w+[^[:alpha:]]+){,5}お?\b酒\b([^[:alpha:]]+\w+){,5}' > ./CONTEXTES/contexte-$cptTableau-$compteur.txt
                               occurences=$(echo "$texte" | grep -o -E "お?\b酒\b" | grep -c -E "\b(A|a)lcools?\b")
                               echo "$occurences"
                               echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>$encodageutf8</td><td><a href=\"$line\">$line</a></td><td><a href=\"../PAGES-ASPIREES/$cptTableau-$compteur.html\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/index-$cptTableau-$compteur.txt\">index-$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/bigramme-$cptTableau-$compteur.txt\">bigramme-$cptTableau-$compteur</a></td><td><a href=\"../CONTEXTES/contexte-$cptTableau-$compteur.txt\">contexte-$cptTableau-$compteur</a></td><td>$occurences</td></tr>" >> $dossier_tableau/tableau_jp.html
                               else
                               #dans le cas où l'encodage n'est pas UTF-8
                               encodage=$(curl -L -I $line | egrep charset | cut -d"=" -f2 | tr -d '\r' | tr -d '\n'| tr [[:lower:]] [[:upper:]]);
                               echo "raté $encodage" > ./DUMP-TEXT/$cptTableau-$compteur.txt
                               echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>$encodage</td><td><a href=\"$line\">$line</a></td><td><a href=\"../PAGES-ASPIREES/$cptTableau-$compteur.html\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/index-$cptTableau-$compteur.txt\">index-$cptTableau-$compteur</a></td><td>-</td><td>-</td><td>-</td></tr>" >> $dossier_tableau/tableau_jp.html
                           fi
                   #On essaye d'attraper une url


                   else
                       echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>-</td><td><a href=\"$line\">$line</a></td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>">>$dossier_tableau/tableau_jp.html
                   fi
               echo "$texte" >> ./aspirations/corpus_ch.txt
       #Redirection de flux entrant
           done < $URLS/$fichier
           echo "</table>">>$tableaux/tableau_ch.html
           echo "</body></html>">>$tableaux/tableau_ch.html
       fi
done
#nettoyage des dumps par langue
clean_en=$(cat ./aspirations/corpus_en.txt | sed 's/[^a-zA-Z0-9 ]//g')
clean_fr=$(cat ./aspirations/corpus_fr.txt | sed 's/[^a-zA-Z0-9 ]//g')
clean_ch=$(cat ./aspirations/corpus_ch.txt | sed 's/[^a-zA-Z0-9 ]//g')
echo "<langue=\"français\">">corpus.txt
echo "$clean_fr">>corpus.txt
echo "<\/langue>">>corpus.txt
echo "<langue=\"anglais\">">>corpus.txt
echo "$clean_en">>corpus.txt
echo "</langue>">>corpus.txt
echo "<langue=\"chinois\">">>corpus.txt
echo "$clean_jp">>corpus.txt
echo "</langue>">>corpus.txt
echo '$clean_jp'>clean_corpus_jp.txt
echo '$clean_en'>clean_corpus_en.txt
echo '$clean_ch'>clean_corpus_fr.txt

