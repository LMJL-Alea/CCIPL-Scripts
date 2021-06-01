
module purge # nettoie tous les modules chargés

# charge les modules necessaire pour fair tourner mon code 
module load python/3.7.4 
module load cuda/9.2.148
module load gcc/10.1
module load cmake/3.10.2


echo c est parti
partition="SMP-short" # SMP-short GPU-short GPU-med Devel
t="06:00:00" # temps maximal que devrait durer le run

# parametres booleens
bootstrap=false
sc=true

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
