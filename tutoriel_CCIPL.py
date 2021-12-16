# #!/trinity/shared/apps/cv-standard/python/3.7.4/bin/python3.7
# # SBATCH --nodes=2 
# # SBATCH --exclusive   
# # SBATCH --mail-user=anthony.ozier-lafontaine@ec-nantes.fr 
# # SBATCH --mail-type=abort,end  
# # SBATCH -o job_python-%j.out 

from time import time
from joblib import parallel_backend
from joblib import Parallel, delayed
from joblib.externals.loky import set_loky_pickler

# on peut récuperer des fonctions codées dans un autre fichier si on est dans le bon dossier 
import os 
os.chdir('/home/LMJL/ozier-lafontaine-a/CCIPL-SCRIPTS/')
from get_params import get_params


if __name__ == '__main__':

    print('cette phrase sera écrite dans le fichier de logs specifié dans tutoriel_CCIPL1.sh')
    print("pour effacer tous les fichiers logs d'un coup: rm *test_ccipl_log_python*")


    key = get_params()
    n_jobs = key['n_jobs']

    def a_paralleliser(key,seed):
        seed = key['seed'] # récupère la seed
        str1,str2 = key['string1'],key['string2'] # récupère d'autres paramètres 
        print(f"seed{seed}   {str1} {str2}")
        return(seed)


    with parallel_backend('loky'):
        a = Parallel(n_jobs=n_jobs)(delayed(a_paralleliser)(key,seed_i) for seed_i  in range(key['seed'],key['seed']+11) )


    # a contient la liste des seed utilisées si on avait généré des données, on pourrait les écrire dans key['diroutput']
