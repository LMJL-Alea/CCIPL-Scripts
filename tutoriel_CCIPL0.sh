
# paramètres pour la requete sbatch
partition="SMP-short" # voir https://doc.ccipl.univ-nantes.fr/CCIPL-PUBLIC/stable/technique/technique.html#_partitionnement
t="06:00:00" # temps maximal que devrait durer le run

# divers paramètres 
path=/home/LMJL/ozier-lafontaine-a/ # dossier où sont les scripts 
diroutput=/scratch/LMJL/ozier-lafontaine-a/outputs # dossier dans lequel on enregistre les resultats
mkdir -p ${diroutput} # créer le dossier des outputs

int1=10
int2=43
n_jobs="10" # nombre de job paralleles sur un noeud 
# Quand un job nécessite beaucoup de paramètres, une solution consiste à rassembler les paramètres par types
# pour ça, on peut utiliser le format nom1:valeur1+nom2:valeur2...
bool=booleen1:true+booleen2:false
str=string1:hello+string2:world+diroutput:${diroutput}
int=int1:${int1}+int2:${int2}+n_jobs:${n_jobs}




# Dans cet exemple, on souhaite répéter la même simulation pour 100 seed differentes. 
# On va utiliser un noeud par lot de 10 seeds.
# Dans chaque noeud, on réparti les 10 calculs sur 10 coeurs

seeds=$(seq 0 10 100) # une liste de 0 à 100 avec un pas de 10 



for seed in $seeds
do
    # pour chaque valeur de seed, une requête sbatch demande l'accès à un noeud sur lequel 10 jobs vont tourner en parallèle. 
    jobname=seed${seed}_${partition}_nj${nj} # idealement le jobname contient toutes les infos nécessaires pour refaire tourner exactement le même job si besoin (reproductibilité)
    int=${int}+seed:${seed} # ajoute seed à int 
        if [ ! -e ${diroutput}${jobname} ]; then # vérification que le fichier à créer n'existe pas déjà 

            #              params de la commande sbatch           script lu par le noeud           paramètres du script lu par le noeud                 fichier de logs (print et erreurs)
            #     |--------------------------------------------|--------------------------|-----------------------------------------------------------|-------------------------------| 
            sbatch --job-name=${jobname} --time=$t -p $partition ${path}tutoriel_CCIPL1.sh $path $diroutput $jobname $njobs $partition $int $bool $str >log_${jobname}seed${seed} 2>&1
            echo le job correspondant a seed ${seed} est soumis 
            
        fi
    fi
done





# # si tu veux tester le code sur ta machine avant de l'envoyer ça peut servir 
# echo $PWD
# local=false
# if  [ $PWD = "/home/LMJL/ozier-lafontaine-a" ]; then
#     echo CCIPL
#     local=false
# elif [ $PWD = "/home/anthony/These/Implementations/kfdapy" ]; then
#     echo Local
#     local=true
# fi


# if [ "$local" = "true" ]; then
#     path=/home/anthony/These/Implementations/kfdapy/ # dossier contenant les fonctions à charger 
#     pathsc=/home/anthony/These/Implementations/data/2020_10_human_cell_atlas_loom/ # dossier contenant les données à charger 
#     diroutput=/home/anthony/These/Implementations/data/simu_local_01_2021/ # dossier où ecrire les fichier en sortie 
#     mkdir -p ${diroutput} # crée le dossier diroutput
# else
#     path=/home/LMJL/ozier-lafontaine-a/kfdapy/
#     pathsc=/home/LMJL/ozier-lafontaine-a/human_cell_atlas_loom/
#     diroutput=/scratch/LMJL/ozier-lafontaine-a/outputs
#     mkdir -p ${diroutput}
# fi
