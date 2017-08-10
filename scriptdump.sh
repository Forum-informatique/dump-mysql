#!/bin/bash
set -euo pipefail
rougefonce='\e[0;31m'
vertfonce='\e[0;32m'
neutre='\e[0;m'
bleufonce='\e[0;34m'
read -p 'Veuillez entrer votre user mysql:' rep
user=$rep
read -p 'Veuillez entrer le mot de passe de votre user mysql:' -s repp
passe=$repp
if [ ! -z "$user" ] && [ ! -z "$passe" ]
then
echo -e "\n"
sleep 2
mysql -u $user -p$passe -e "SHOW DATABASES;"


echo -e "\n"
echo -e "${bleufonce}Choix disponible:\n${neutre}"
echo -e "1- Effectuer le dump de toutes les bases de donnees\n"
echo -e "2- Effectuer le dump d'une (ou plusieurs) base(s) de donnees\n"
echo -e "3- effectuer le dump d'une (ou plusieurs) table(s)\n"

read -p 'Veuillez entrer votre choix (1/2/3)?:' choix
choix=$choix
echo -e "\n"
case "$choix" in
"") echo -e "${rougefonce}aucun choix valide, script termine${neutre}"
    exit;;
1)  read -p "Voulez vous deposer le dump sous quel repertoire?:"  repdump
repertoire=$repdump
mysqldump -u $user -p$passe  --all-databases --events --ignore-table=mysql.event > $repertoire/mysql-dump-all-base.sql
sleep 2
echo -e "${vertfonce}dump effectue${neutre}";;
2) read -p "Veuillez entrer la base (ou les bases separees par des espaces):" bases
bases=$bases;
   read -p "Voulez vous deposer le(s) dump sous quel repertoire?:"  repdump
repertoire=$repdump
mysqldump -u $user -p$passe  --all-databases --events --ignore-table=mysql.event > $repertoire/mysql-dump-all-base.sql
sleep 2
echo -e "${vertfonce}dump effectue${neutre}";;
2) read -p "Veuillez entrer la base (ou les bases separees par des espaces):" bases
bases=$bases;
   read -p "Voulez vous deposer le(s) dump sous quel repertoire?:"  repdump
repertoire=$repdump
for dumpbase in ${bases[@]}
do
    mysqldump -u root -p$passe $dumpbase > $repertoire/$dumpbase.sql
done
sleep 2
echo -e "${vertfonce}dump effectue${neutre}";;
3)read -p "Veuillez entrer la base de donnees:" bases
base=$bases;
mysql -u $user -p$passe -e "use $base;show tables;"
read -p "Veuillez entrer la table (ou les tables separees par des espaces):" tables
read -p "Voulez vous deposer le dump sous quel repertoire?:"  repdump
repertoire=$repdump
for dumptable in ${tables[@]}
do
    mysqldump -u root -p$passe $base $dumptable > $repertoire/$dumptable.sql
done
sleep 2
echo -e "${vertfonce}dump effectue${neutre}";;
esac
else
echo -e "\n"
echo -e "${rougefonce}Paramteres vides, script terminee${neutre}"
fi
