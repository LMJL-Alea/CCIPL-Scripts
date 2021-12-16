#!/bin/bash   
# le "!" dit que l'interpréteur Bash qui permet de lire ce fichier se trouve là : "/bin/bash" 

# paramètres sbatch qui n'étaient pas dans la requête sbatch
# voir : http://wiki.ccipl.univ-nantes.fr/doku.php?id=doc:main

#SBATCH --ntasks-per-node=20  
#SBATCH --exclusive   
#SBATCH --mail-user=anthony.ozier-lafontaine@ec-nantes.fr 
#SBATCH --mail-type=abort,end  
#SBATCH -o job_test-%j.out 


# chargement modules 
module purge # nettoie tous les modules chargés
module load python/3.7.4 

# je récupère les paramètres reçus par le script dans l'ordre où ils ont été indiqués dans tutoriel_CCIPL0.sh

$path $diroutput $jobname $njobs $partition $int $bool $str
path=$1
diroutput=$2
jobname=$3
njobs=$4
partituon=$5
int=$6
bool=$7
str=$8


echo cette phrase sera écrite dans le fichier de logs specifié dans tutoriel_CCIPL0.sh

if [ ! -e ${diroutput}${jobname} ]; then #verif non existence du fichier 
    echo "${jobname} submitted with"$'\n'"bool=${bool}"$'\n'"parallel : ${nj}"

    # srun lance un script qui peut utiliser plusieurs coeurs du ou des noeuds demandés (ici n=1 noeud)
    #  srun     commande lue par srun          params reçus par le .py      logs des erreurs
    #|-------|-------------------------------|-------------------------|-----------------------------------------|
    srun -n 1 python ${path}tutoriel_CCIPL.py -b $bool -s $str -i $int >test_ccipl_log_python_${jobname} 2>&1
    
    # srun lance la commande "python ${path}main.py -b $bool -s $seed >2okfda${partition}_${jn}nj${nj} 2>&1"
    # le script python prendra donc en paramètres -b pour $bool et -s pour seed 
    # tous les prints et erreurs du script python seront écrits dans le fichier 2okfda${partition}_${jobname}nj${nj}  (utile pour suivre ce qui se passe pendant le run )
fi  
