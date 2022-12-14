

# inspiration script projet impot -Projet encadré

#!/usr/bin/bash
#Ce script va nous permettre de récupérer tous les URLs de chaque fichier pour les classer dans un tableau
#On aura un tableau par fichier d'URL
#Notre programme demande donc trois arguments : le dossier qui contient les fichiers URls, le dossier qui contient notre page HTML pour créer notre tableau, et le motif
#Le programme doit s'exécuter depuis le dossier PROJET-SUR-LE-MOT de l'environnement de travail
#Voici la commande :
# bash ./PROGRAMMES/script_v2.bash ./URLS ./TABLEAUX/ "\bпадат(ак|ка|ку|кам|ке|к(і|i)|каў|кам|камі|ках)?\b|\bналог(а|у|ом|е|и|ов|ам|ами|ах)?\b|\btax (es|p[a-z]+)?\b|\b([a-zA-Z]{4,})?[sS]teuern?([a-zA-Z]{2,})?\b|\b(impôts?)\b|\b(fisca(le?s?|ux))\b|\b(taxes?)\b"
###########################################################
#On choisit trois variables pour stocker les arguments que l'ont vient de spécifier

URLS=$1
TABLEAUX=$2
MOTIF=$3
mkdir DUMP-TEXT/DUMP-NETTOYAGE

###########################################################
#Création d'une fonction générale pour les traitements
traitement_commun () {
#-----------------------------------------
#On crée l'index à partir des fichiers .txt
egrep -i -o "\w+" ./DUMP-TEXT/"$compteur_tableau-$compteur_url".txt | sort | uniq -c | sort -nr > ./DUMP-TEXT/"index_$compteur_tableau-$compteur_url".txt
compteur_motif=$(egrep -i -o -c "$MOTIF" ./DUMP-TEXT/"$compteur_tableau-$compteur_url".txt )
#-----------------------------------------
#On va créer les bigrammes avec les prochaines commandes
sed "s/ /\n/g" ./DUMP-TEXT/"$compteur_tableau-$compteur_url".txt | egrep -o "\b.*\b" | head -n -1 > ./DUMP-TEXT/"bigramme1_$compteur_tableau-$compteur_url".txt
tail -n +2 ./DUMP-TEXT/"bigramme1_$compteur_tableau-$compteur_url".txt > ./DUMP-TEXT/"bigramme2_$compteur_tableau-$compteur_url".txt
paste ./DUMP-TEXT/"bigramme1_$compteur_tableau-$compteur_url".txt ./DUMP-TEXT/"bigramme2_$compteur_tableau-$compteur_url".txt | sort | uniq -c | sort -rn > ./DUMP-TEXT/"bigramme_entier_$compteur_tableau-$compteur_url".txt
#-----------------------------------------
#Création du contexte .txt avec egrep
egrep -i -C1 "$MOTIF" ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt > ./CONTEXTES/"$compteur_tableau-$compteur_url".txt
#-----------------------------------------
#On crée nos contexte en .html avec minigrep perl ./DUMP-TEXT/minigrepmultilingue-v2.2-regexp/minigrepmultilingue.pl "UTF-8" ./DUMP-TEXT/"$compteur_tableau-$compteur_url".txt ./DUMP-TEXT/minigrepmultilingue-v2.2-regexp/MOTIF.txt
mv resultat-extraction.html ./CONTEXTES/"$compteur_tableau-$compteur_url".html
#-----------------------------------------
#On concatène les dumps
echo -e "<dump=\""./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url""\">\n" >> DUMP-TEXT/dump_"$fichier"_concat.txt
cat ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt >> ./DUMP-TEXT/dump_"$fichier"_concat.txt
echo -e "\n</dump> §\n" >> ./DUMP-TEXT/dump_"$fichier"_concat.txt
#-----------------------------------------
#On concatène les contextes
echo -e "<contexte=\""./CONTEXTES/"$compteur_tableau-$compteur_url".txt"\">\n" >> CONTEXTES/contexte_"$fichier"_concat.txt
cat ./CONTEXTES/"$compteur_tableau-$compteur_url".txt >> ./CONTEXTES/contexte_"$fichier"_concat.txt
echo -e "\n</contexte> §\n" >> ./CONTEXTES/contexte_"$fichier"_concat.txt
}


########################################### HTML FROM HERE ON

#En-tête du fichier html
echo "<html><head> <meta charset =\"UTF-8\"/> <style>
table {
border:1px solid #000000;
border-collapse:collapse;
table-layout:fixed;
}
th {
background-color:#BDBDBD;
text-align: center;
}

td {
font-size:90%;
text-align: center;
}

table tr:nth-child(odd)
{
background-color:#F2F2F2;
}

caption
{
font-size:10px;
caption-side: bottom;
}

</style></head><body>" > $2/tableau.html
###########################################################
#On va créer un compteur pour effectuer chacune de nos actions pour chaque fichier contenu dans le dossier URLS
compteur_tableau=1
###########################################################
#pour chaque élément contenu dans le dossier URL ($1) :
for fichier in $(ls $1)
do

#On ouvre le fichier
echo $fichier

#On va créer un compteur pour les lignes de chaque fichier
compteur_url=1

#On crée les colonnes de notre tableau
echo "<table aligne=\"center\" border=\"10px\">
<caption><span style=\"background-color:#FFFF00;\">UTF-8 détecté avec CURL </span>
<span style=\"background-color:#FF00FF;\">Encodage autre détecté avec CURL</span>
<span style=\"background-color:#7fffd4;\">UTF-8 détecté avec FILE -i </span>
<span style=\"background-color:#7FFF00;\">Encodage autre détecté avec FILE -i</span>
</caption>" >>$2/tableau.html

echo "<h2><tr><th colspan=\"11\"> TABLEAU $compteur_tableau $fichier </th></tr></h2>" >>$2/tableau.html
echo "<tr><td>Numero Url</td>
<td>URL</td>
<td>Code HTTP</td>
<td>Encodage</td>
<td>Page Aspirée</td>
<td>Compte motif</td>
<td>Dump Texte</td>
<td>Index</td>
<td>Bigramme</td>
<td>Contexte (texte)</td>
<td>Contexte (html)</td></tr>" >>$2/tableau.html

#Pour chaque ligne de chaque fichier contenu dans URLS :
while read ligne
do
#On cherche à savoir si le code http est 200 (code signifiant que lea page web est valide) tout en aspirant la page web avec la fonction curl
codehttp=$(curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:95.0) Gecko/20100101 Firefox/95.0" -o ./PAGES-ASPIREES/"$compteur_tableau-$compteur_url".html
--compressed $ligne -w %{http_code})

#Si le code est 200, on va pouvoir effectuer les actions suivantes :
if [[ $codehttp == 200 ]]
then
echo "code http = 200"
#On prend l'encodage de l'URL
encodage=$(curl -L -I $ligne | egrep -i "charset" | cut -d"=" -f2 | tr [a-z] [A-Z] | tr -d "\r")
echo $encodage

#Si cet encodage est bien UTF-8 on passe aux étapes suivantes :
if [[ $encodage == "UTF-8" ]]
then
echo "encodage : UTF-8"

#On va dumper l'URL avec la fonction lynx
cat ./PAGES-ASPIREES/"$compteur_tableau-$compteur_url".html | grep -v "charset=" | lynx -dump -stdin -nolist > ./DUMP-TEXT/" $compteur_tableau-$compteur_url".txt

#On créé une version nettoyée du DUMP pour le trameur
cat ./DUMP-TEXT"/$compteur_tableau-$compteur_url".txt | (tr "[A-Z]" "[a-z]" | sed -E "s/^ *//g" | sed -E "s/^(\*|\+|o|https|video|permalink|\(button\)|\(iframe:\)) (.*| .*)//g" | sed -E "s/(\(button\)|\(iframe:\))//g" | sed -E "s/^# ?.*//g" | sed "s/’/e /g" | tr -d "?!:,;.\_\(\)\/\\<>\"\"-@" | sed "s/steuern/steuer/g" | sed "s/steuer/xsteuerx/g" | sed "s/xsteuerx/ steuer /g" | sed -E "s/\b(be|ver|t|lich|ung)\b//g" | sed "s/impôts/impôt/g" | sed -E "s/fisca((les?)|(ux))\b/fiscal/g" | sed -E "s/tax(es)?/taxe/g" | sed -E "s/\bналог(а|у|ом|е|и|ов|ам|ами|ах) ?\b/налог/g" | sed -E "s/\bпадат(ка|ку|кам|ке|к(і|i)|каў|кам|камі|ках)?\b/падатак/g" | cat -s ) > ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt
if [[ $fichier == "ANGLAIS" ]]
then
sed "s/taxe/tax/g" ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt > ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyéTAX.txt
rm ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt
mv ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyéTAX.txt ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt
fi
#On lance notre fonction qui contient nos différents traitements
traitement_commun

#Si le compteur_motif est à 0, c'est peut-être du à un mauvais dump, donc on essaie autre chose :
if [[ $compteur_motif == 0 ]]
then
cat ./PAGES-ASPIREES/"$compteur_tableau-$compteur_url".html | grep -v "charset=utf-8" | lynx -dump -stdin -nolist > ./DUMP-TEXT/"$compteur_tableau-$compteur_url".txt
traitement_commun
fi
#On renseigne ensuite toutes les informations dans notre tableau
echo "<tr><td>$compteur_url</td>
<td><a href=\"$ligne\">$ligne</a></td>
<td><span style=\"background-color:#40c0ff;\">$codehttp</span></td>
<td><span style=\"background-color:#FFFF00;\">$encodage</span></td>
<td><a href=\" ../PAGES-ASPIREES/$compteur_tableau-$compteur_url.html\">$compteur_tableau-$compteur_url</a></td>
<td>$compteur_motif</td>
<td><a href=\"../DUMP-TEXT/$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href =\"../DUMP-TEXT/index_$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href = \"../DUMP-TEXT/bigramme_entier_$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href = \"../CONTEXTES/$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href = \"../CONTEXTES/$compteur_tableau-$compteur_url.html\">$compteur_tableau-$compteur_url</a></td></tr>">>$2/tableau.html
#Si l'encodage n'est pas utf-8, on va avoir deux possibiltié : soit c'est un autre encodage, soit l'encodage est vide
else
echo "encodage non utf-8"
#Si l'encodage n'est pas vide (ni utf-8), alors on a un texte encodé dans un autre encodage.
if [[ $encodage != "" ]]
then
echo "encodage non vide"

#On dump notre url avec la fonction lynx pour avoir des fichiers .txt, je les mets dans le fichier DUMP-TEXT
lynx -dump -nolist -display_charset="$encodage" -assume_charset="$encodage" ./PAGES-ASPIREES/"$compteur_tableau-$compteur_url".html > ./DUMP-TEXT"/$compteur_tableau-$compteur_url_autre".txt

#On convertit à partir du fichier .txt en UTF-8
iconv -c -f "$encodage" -t "UTF-8" ./DUMP-TEXT/"$compteur_tableau-$compteur_url_autre".txt > ./DUMP-TEXT/"$compteur_tableau-$compteur_url".txt
#On créé une version nettoyée du dump pour le trameur
cat ./DUMP-TEXT"/$compteur_tableau-$compteur_url".txt | (tr "[A-Z]" "[a-z]" | sed -E "s/^ *//g" | sed -E "s/^(\*|\+|o|https|video|permalink |\(button\)|\(iframe:\))(.*| .*)//g" | sed -E "s/(\(button\)|\(iframe:\))//g" | sed -E "s/^# ?.*//g" | sed "s/’/e /g" | tr -d "?!:,;.\_\(\)\/\\<>\"\"-@" | sed "s/steuern/steuer/g" | sed "s/steuer/xsteuerx/g" | sed "s/xsteuerx/ steuer /g" | sed -E "s/\b(be|ver|t|lich|ung)\b//g" | sed "s/impôts/impôt/g" | sed -E "s/fisca((les?) |(ux))\b/fiscal/g" | sed -E "s/tax(es)?/taxe/g" | sed -E "s/\bналог(а|у|ом|е|и|ов|ам|ами|ах)?\b/налог/g" | sed -E "s/\bпадат(ка|ку|кам|ке|к(і|i)|каў|кам|камі|ках)?\b/падатак/g" | cat -s ) > ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt
if [[ $fichier == "ANGLAIS" ]]
then
sed "s/taxe/tax/g" ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt > ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyéTAX.txt
rm ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt
mv ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyéTAX.txt ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt
fi
#On lance notre fonction
traitement_commun

#On affiche nos informations dans notre tableau
echo "<tr><td>$compteur_url</td><td> <br>
<a href=\"$ligne\">$ligne</a></td>
<td><span style=\"background-color:#40c0ff;\">$codehttp</span></td>
<td><span style=\"background-color:#FF00FF;\">$encodage</span></td>
<td><a href=\" ../PAGES-ASPIREES/$compteur_tableau-$compteur_url.html\">$compteur_tableau-$compteur_url</a></td>
<td>$compteur_motif</td>
<td><a href=\"../DUMP-TEXT/$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href =\"../DUMP-TEXT/index_$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href = \"../DUMP-TEXT/bigramme_entier_$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href = \"../CONTEXTES/$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href = \"../CONTEXTES/$compteur_tableau-$compteur_url.html\">$compteur_tableau-$compteur_url</a></td></tr>" >>$2/tableau.html
#Si on n'a pas d'encodage (encodage est vide avec curl)
else
echo "encodage vide"
#On récupère l'encodage avec la fonction file -i sur le fichier .html
encodage2=$(perl ./PROGRAMMES/detect-encoding.pl ./PAGES-ASPIREES/ "$compteur_tableau-$compteur_url".html )
echo $encodage2

#On va avoir deux nouveaux deux possibiltiés : l'encodage est utf-8 ou non.
#si l'encodage est utf-8 :
if [[ $encodage2 == "UTF-8" ]]
then
echo "encodage 2 utf-8"
echo "NOT UTF-8"
#On dump nos url
lynx -dump -nolist ./PAGES-ASPIREES/"$compteur_tableau-$compteur_url".html > ./DUMP-TEXT"/$compteur_tableau-$compteur_url".txt
# On créé une version propre du dump pour le trameur
cat ./DUMP-TEXT"/$compteur_tableau-$compteur_url".txt | (tr "[A-Z]" "[a-z]" | sed -E "s/^ *//g" | sed -E "s/^(\*|\+|o|https|video|permalink|\(button\)|\(iframe:\)) (.*| .*)//g" | sed -E "s/(\(button\)|\(iframe:\))//g" | sed -E "s/^# ?.*//g" | sed "s/’/e /g" | tr -d "?!:,;.\_\(\)\/\\<>\"\"-@" | sed "s/steuern/steuer/g" | sed "s/steuer/xsteuerx/g" | sed "s/xsteuerx/ steuer /g" | sed -E "s/\b(be|ver|t|lich|ung)\b//g" | sed "s/impôts/impôt/g" | sed -E "s/fisca((les?)|(ux))\b/fiscal/g" | sed -E "s/tax(es)?/taxe/g" | sed -E "s/\bналог(а|у|ом|е|и|ов|ам|ами|ах)?\b/налог/g" | sed -E "s/\bпадат(ка|ку|кам|ке|к(і|i)|каў|кам|камі|ках)?\b/падатак/g" | cat -s ) > ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt
if [[ $fichier == "ANGLAIS" ]]
then
sed "s/taxe/tax/g" ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt > ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyéTAX.txt
rm ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt
mv ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyéTAX.txt ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt
fi
#On lance notre fonction
traitement_commun

#On ajoute les information dans le tableau
echo "<tr><td>$compteur_url</td>
<td><a href=\"$ligne\">$ligne</a></td>
<td><span style=\"background-color:#40c0ff;\">$codehttp</span></td>
<td><span style=\"background-color:#7fffd4;\">UTF-8</span></td>
<td><a href=\" ../PAGES-ASPIREES/$compteur_tableau-$compteur_url.html\">$compteur_tableau-$compteur_url</a></td>
<td>$compteur_motif</td>
<td><a href=\"../DUMP-TEXT/$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href =\"../DUMP-TEXT/index_$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href = \"../DUMP-TEXT/bigramme_entier_$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href = \"../CONTEXTES/$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href = \"../CONTEXTES/$compteur_tableau-$compteur_url.html\">$compteur_tableau-$compteur_url</a></td></tr>" >> $2/tableau.html

#Si l'encodage de file-i n'est pas vide, et n'est pas utf-8
else
if [[ $encodage2 != "" ]]
then
echo "ENCODING: YES"
#On dump nos url
lynx -dump -nolist -display_charset="$encodage2" -assume_charset="$encodage2" ./PAGES-ASPIREES/"$compteur_tableau-$compteur_url".html > ./DUMP-TEXT"/$compteur_tableau-$compteur_url_autre".txt
#On convertit notre fichier.txt en utf-8
iconv -c -f "$encodage2" -t "UTF-8" ./DUMP-TEXT/"$compteur_tableau-$compteur_url_autre".txt > ./DUMP-TEXT/"$compteur_tableau-$compteur_url".txt

#On créé une version propre du dump pour le trameur
cat ./DUMP-TEXT"/$compteur_tableau-$compteur_url".txt | (tr "[A-Z]" "[a-z]" | sed -E "s/^ *//g" | sed -E "s/^(\*|\+|o|https|video|permalink|\(button\)|\(iframe:\)) (.*| .*)//g" | sed -E "s/(\(button\)|\(iframe:\))//g" | sed -E "s/^# ?.*//g" | sed "s/’/e /g" | tr -d "?!:,;.\_\(\)\/\\<>\"\"-@" | sed "s/steuern/steuer/g" | sed "s/steuer/xsteuerx/g" | sed "s/xsteuerx/ steuer /g" | sed -E "s/\b(be|ver|t|lich|ung)\b//g" | sed "s/impôts/impôt/g" | sed -E "s/fisca((les?)|(ux))\b/fiscal/g" | sed -E "s/tax(es)?/taxe/g" | sed -E "s/\bналог(а|у|ом|е|и|ов|ам|ами|ах)?\b/налог/g" | sed -E "s/\bпадат(ка|ку|кам|ке|к(і|i)|каў|кам|камі|ках)?\b/падатак/g" | cat -s ) > ./DUMP-TEXT/DUMP-NETTOYAGE/"$compteur_tableau-$compteur_url"_nettoyé.txt

#On lance notre fonction
traitement_commun
#On rentre les informations dans notre tableau
echo "<tr><td>$compteur_url</td><td>
<a href=\"$ligne\">$ligne</a></td>
<td><span style=\"background-color:#40c0ff;\">$codehttp</span></td>
<td><span style=\"background-color:#7FFF00;\">$encodage2</span></td>
<td><a href=\" ../PAGES-ASPIREES/$compteur_tableau-$compteur_url.html\">$compteur_tableau-$compteur_url</a></td>
<td>$compteur_motif</td>
<td><a href=\"../DUMP-TEXT/$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href =\"../DUMP-TEXT/index_$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href = \"../DUMP-TEXT/bigramme_entier_$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href = \"../CONTEXTES/$compteur_tableau-$compteur_url.txt\">$compteur_tableau-$compteur_url</a></td>
<td><a href = \"../CONTEXTES/$compteur_tableau-$compteur_url.html\">$compteur_tableau-$compteur_url</a></td></tr>">>$2/tableau.html
fi
fi
fi
fi
#Si le code http n'est pas 200 on affiche dans le tableau qu'on ne peut pas faire de traitement supplémentaire.
else
echo "<tr><td>$compteur_url</td>
<td><a href=\"$ligne\">$ligne</a></td>
<td><span style=\"background-color:#8B0000;\" >$codehttp</span></td>
<td>??</td>
<td>??</td>
<td>??</td>
<td>??</td>
<td>??</td>
<td>??</td>
<td>??</td>
<td>??</td></tr>" >>$2/tableau.html
fi
#On ajoute +1 au compteur du fichier URL pour passer à la ligne suivante
compteur_url=$(($compteur_url+1))
#Fin lecture du fichier
done < $1/$fichier

#On ferme notre tableau
echo "</table>" >>$2/tableau.html

#On ajoute +1 au compteur du tableau pour passer au fichier suivant du dossier URL
compteur_tableau=$(($compteur_tableau+1))

#Fin de notre boucle
done

#On ferme notre fichier html
echo "</body>/html>" >>$2/tableau.html
