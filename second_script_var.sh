# usr/bin/bash

ANNEE=$1
TYPE=$2

echo "pour l'année $ANNEE" > sortie.txt 
grep "$TYPE" $ANNEE*.ann | wc -l >> sortie.txt 
