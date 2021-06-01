#!/bin/bash 
#SBATCH --ntasks-per-node=20 
#SBATCH --exclusive   
#SBATCH --mail-user=anthony.ozier-lafontaine@ec-nantes.fr 
#SBATCH --mail-type=abort,end  
#SBATCH -o job_kfda-%j.out 

# les commendes au dessus sont lues par SLURM pour savoir par exemple que l'interpréteur Bash qui permet de lire ce fichier se trouve là : "/bin/bash"
# les infos sur ces commandes sont sur le wiki du CCIPL : http://wiki.ccipl.univ-nantes.fr/doku.php?id=doc:main

# je charge les modules dont j'ai besoin ( je crois qu'on peut les transmettre depuis le script tutoriel_CCIPL0.sh mais je n'ai pas regardé comment faire si jamais un jour tu trouves :) 
module purge
module load python/3.7.4 
module load cuda/9.2.148
module load gcc/10.1
module load cmake/3.10.2


# je récupère les paramètres reçus par le script dans l'ordre où ils ont été indiqués dans tutoriel_CCIPL0.sh
path=$1
diroutput=$2
jobname=$3
bool=$4
nj=$5
partition=$6
seed=$7


echo ${path}

# deuxième vérification que le fichier n'est pas déjà écrit (dans mon cas cette seconde vérif était utile)
if [ ! -e ${diroutput}${jobname} ]; then 
    echo "${jobname} submitted with"$'\n'"bool=${bool}"$'\n'"parallel : ${nj}"
    # la commande srun permet de lancer mon script python dont certaines parties peuvent être parallelisées sur plusieurs coeurs du noeud
    srun -n 1 python ${path}tutoriel_CCIPL.py -b $bool -s $seed >2okfda${partition}_${jobname}nj${nj} 2>&1
    # srun reçoit le param -n qui correspond au nombre de noeuds à attribuer au script python 
    # ici, -n = 1 car de toutes façons la partition sur laquelle je job a été soumis est "SMP-short" qui n'attribue qu'un noeud au run 
    
    # srun lance la commande "python ${path}main.py -b $bool -s $seed >2okfda${partition}_${jn}nj${nj} 2>&1"
    # le script python prendra donc en paramètres -b pour $bool et -s pour seed 
    # tous les prints et erreurs du script python seront écrits dans le fichier 2okfda${partition}_${jobname}nj${nj}  (utile pour suivre ce qui se passe pendant le run )
fi  
