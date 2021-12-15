
# paramètres pour la requete sbatch
partition="SMP-short" # voir https://doc.ccipl.univ-nantes.fr/CCIPL-PUBLIC/stable/technique/technique.html#_partitionnement
t="06:00:00" # temps maximal que devrait durer le run

# divers paramètres 
diroutput=/scratch/LMJL/ozier-lafontaine-a/outputs # dossier dans lequel on enregistre les resultats
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



path=/home/LMJL/ozier-lafontaine-a/
pathsc=/home/LMJL/ozier-lafontaine-a/human_cell_atlas_loom/
diroutput=/scratch/LMJL/ozier-lafontaine-a/outputs
mkdir -p ${diroutput}




# si tu veux tester le code sur ta machine avant de l'envoyer ça peut servir 
echo $PWD
local=false
if  [ $PWD = "/home/LMJL/ozier-lafontaine-a" ]; then
    echo CCIPL
    local=false
elif [ $PWD = "/home/anthony/These/Implementations/kfdapy" ]; then
    echo Local
    local=true
fi

# liste des paramètres booléens utilisés par mon code python rangés en "parametre1:valeur1+parametre2:valeur2" 
# Dans mon code python une fonction sait lire cette liste de paramètres 
bool=bootstrap:${bootstrap}+sc:${sc}+local:${local}
seeds=$(seq 0 100 1000) # de 0 a 1000 avec un pas de 100 (=[0,100,200,300,400,500,600,700,800,900,1000])
nj="20" # nombre de jobs en parallèle 

if [ "$local" = "true" ]; then
    path=/home/anthony/These/Implementations/kfdapy/ # dossier contenant les fonctions à charger 
    pathsc=/home/anthony/These/Implementations/data/2020_10_human_cell_atlas_loom/ # dossier contenant les données à charger 
    diroutput=/home/anthony/These/Implementations/data/simu_local_01_2021/ # dossier où ecrire les fichier en sortie 
    mkdir -p ${diroutput} # crée le dossier diroutput
else
    path=/home/LMJL/ozier-lafontaine-a/kfdapy/
    pathsc=/home/LMJL/ozier-lafontaine-a/human_cell_atlas_loom/
    diroutput=/scratch/LMJL/ozier-lafontaine-a/outputs
    mkdir -p ${diroutput}
fi

for seed in $seeds
do
    jobname=seed${seed}
    
   if [ "$local" = "true" ]; then
        # en local je lance juste le code python avec le paramètre bool nommé (par moi) -b
        python ${path}main.py -b $bool
    else
        # je vérifie que le fichier que je compte écrire n'est pas déjà écrit afin d'éviter de faire tourner deux fois le même code pour la même seed 
        if [ ! -e ${diroutput}${jobname} ]; then 
            # sur le CCIPL je soumets un fichier .sh au gestionnaire slurm avec la commande sbatch
            echo ${jobname} submitted
            sbatch --job-name=${jobname}_${partition}_nj${nj} --time=$t -p $partition ${path}tutoriel_CCIPL1.sh $path $diroutput $jobname $bool $nj $partition $seed >log_${jobname}seed${seed} 2>&1
            # les parametres que je spécifie à sbatch sont : --job-name, --time, -p
            # le script .sh a lire par la commande sbatch est  ${path}1_simu.sh
            # les paramètres que recevra le script .sh sont $path $diroutput $jobname $bool $nj $partition ( ça me permet de garder en mémoire toutes les infos utiles pour la reproductibilité)
            # tous les prints et erreurs du script tutoriel_CCIPL1.sh seront écrits dans le fichier log_${jobname}seed${seed} (utile pour suivre ce qui se passe pendant le run )
        fi
    fi
done
