# 2ndInspiration

#!usr/bin/bash
#pour lancer le script :
#bash premierscript.sh <dossier URLS> <dossier TABLEAUX>

#stocker les arguments dans des variables
dossier_url=$1
dossier_tableau=$2

echo $dossier_url
echo $dossier_tableau

#en tête html
echo "<html><head><meta charset=\"utf-8\"/></head><body>">$dossier_tableau/tableau_fr.html
echo "<html><head><meta charset=\"utf-8\"/></head><body>">$dossier_tableau/tableau_en.html
echo "<html><head><meta charset=\"utf-8\"/></head><body>">$dossier_tableau/tableau_jp.html
echo "<table align=\"center\" border=\"1px\" bordercolor=green>">>$dossier_tableau/tableau_fr.html
echo "<table align=\"center\" border=\"1px\" bordercolor=green>">>$dossier_tableau/tableau_en.html
echo "<table align=\"center\" border=\"1px\" bordercolor=green>">>$dossier_tableau/tableau_jp.html
echo "<tr><td>ID</td><td>HTTP</td><td>Encodage</td><td>URL</td><td>Page</td><td>DUMP</td><td>index</td><td>bigrammes</td><td>contextes</td><td>occurences</td></tr>">>$dossier_tableau/tableau_en.html
echo "<tr><td>ID</td><td>HTTP</td><td>Encodage</td><td>URL</td><td>Page</td><td>DUMP</td><td>index</td><td>bigrammes</td><td>contextes</td><td>occurences</td></tr>">>$dossier_tableau/tableau_fr.html
echo "<tr><td>ID</td><td>HTTP</td><td>Encodage</td><td>URL</td><td>Page</td><td>DUMP</td><td>index</td><td>bigrammes</td><td>contextes</td><td>occurences</td></tr>">>$dossier_tableau/tableau_jp.html
#on crée un compteur de tableau
cptTableau=0;

#lire le fichier d'urls
for fichier in $(ls $dossier_url); do
   echo "fichier lu : $fichier"
   cptTableau=$(($cptTableau+1))
   compteur=0
#lire chaque ligne du dossier
   if [[ $fichier == *"alcool"* ]]
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
                               echo "$texte" | grep -E -o '(\w+[^[:alpha:]]+){,5}(A|a)lcools?([^[:alpha:]]+\w+){,5}' > ./CONTEXTES/contexte-$cptTableau-$compteur.txt
                               occurences=$(echo "$texte" | grep -o -E "\b(A|a)lcools?\b" | grep -c -E "\b(A|a)lcools?\b")
                               echo "$occurences"
                               echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>$encodageutf8</td><td><a href=\"$line\">$line</a></td><td><a href=\"../PAGES-ASPIREES/$cptTableau-$compteur.html\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/index-$cptTableau-$compteur.txt\">index-$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/bigramme-$cptTableau-$compteur.txt\">bigramme-$cptTableau-$compteur</a></td><td><a href=\"../CONTEXTES/contexte-$cptTableau-$compteur.txt\">contexte-$cptTableau-$compteur</a></td><td>$occurences</td></tr>" >> $dossier_tableau/tableau_fr.html
                               else
                               #dans le cas où l'encodage n'est pas UTF-8
                               encodage=$(curl -L -I $line | egrep charset | cut -d"=" -f2 | tr -d '\r' | tr -d '\n'| tr [[:lower:]] [[:upper:]]);
                               echo "raté $encodage" > ./DUMP-TEXT/$cptTableau-$compteur.txt
                               echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>$encodage</td><td><a href=\"$line\">$line</a></td><td><a href=\"../PAGES-ASPIREES/$cptTableau-$compteur.html\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/index-$cptTableau-$compteur.txt\">index-$cptTableau-$compteur</a></td><td>-</td><td>-</td><td>-</td></tr>" >> $dossier_tableau/tableau_fr.html
                           fi
                   #On essaye d'attraper une url


                   else
                       echo "<tr><td>$compteur</td><td>$codeHTTP</td><td>-</td><td><a href=\"$line\">$line</a></td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>">>$dossier_tableau/tableau_fr.html
                   fi
               echo "$texte" >> ./PAGES-ASPIREES/corpus_fr.txt        
       #Redirection de flux entrant
           done < $dossier_url/$fichier
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
               echo "$texte" >> ./PAGES-ASPIREES/corpus_jp.txt
       #Redirection de flux entrant
           done < $dossier_url/$fichier
           echo "</table>">>$dossier_tableau/tableau_jp.html
           echo "</body></html>">>$dossier_tableau/tableau_jp.html
       fi
done
#nettoyage des dumps par langue
clean_en=$(cat ./PAGES-ASPIREES/corpus_en.txt | sed 's/[^a-zA-Z0-9 ]//g')
clean_fr=$(cat ./PAGES-ASPIREES/corpus_fr.txt | sed 's/[^a-zA-Z0-9 ]//g')
clean_jp=$(cat ./PAGES-ASPIREES/corpus_jp.txt | sed 's/[^a-zA-Z0-9 ]//g')
echo "<langue=\"français\">">corpus.txt
echo "$clean_fr">>corpus.txt
echo "<\/langue>">>corpus.txt
echo "<langue=\"anglais\">">>corpus.txt
echo "$clean_en">>corpus.txt
echo "</langue>">>corpus.txt
echo "<langue=\"japonais\">">>corpus.txt
echo "$clean_jp">>corpus.txt
echo "</langue>">>corpus.txt
echo '$clean_jp'>clean_corpus_jp.txt
echo '$clean_en'>clean_corpus_en.txt
echo '$clean_fr'>clean_corpus_fr.txt


