# #!/trinity/shared/apps/cv-standard/python/3.7.4/bin/python3.7
# # SBATCH --nodes=2 
# # SBATCH --ntasks-per-node=20 
# # SBATCH --exclusive   
# # SBATCH --mail-user=anthony.ozier-lafontaine@ec-nantes.fr 
# # SBATCH --mail-type=abort,end  
# # SBATCH -o job_python-%j.out 

import multiprocessing
from time import time

# voilà comment je récupère des fonctions que j'ai codées dans 
# les fichiers get_params.py et simulations.py, rangés 
# dans le dossier '/home/LMJL/ozier-lafontaine-a/kfdapy'
import os 
if os.getcwd() == '/home/LMJL/ozier-lafontaine-a':
    os.chdir('/home/LMJL/ozier-lafontaine-a/kfdapy')
from get_params import get_params
from simulations import parallel_single_cell_kfda_all_sample, parallel_simu, simu_kfda


if __name__ == '__main__':

    # la fonction get_params lit les paramètres rangés dans la liste de paramètres que j'avais appelée $bool 
    key = get_params()
    
    
    # une fois que j'ai récupéré tous les paramètres, le reste est un script python normal. 
    for k,v in key.items():
        print(k,v)

    nj = key['nj']
    if 'sc' in key and key['sc'] == True:
        # single_cell_kfda(key)
        parallel_single_cell_kfda_all_sample(key,nj)
        # print('en travaux')
    elif 'test' in key and key['test'] == True:
        if 'parallel' in key and key['parallel'] == True:
            start = time()
            parallel_simu(key,nj)
            print('parallel_test:',time() - start)
        else:
            start = time()
            simu_kfda(key)
            print('not_parallel_test:',time() - start)

    else: 

        # start = time()
        # simu_kfda(key)
        # print('simu_kfda:',time() - start)
        
        start = time()
        parallel_simu(key,nj)
        print('parallel_simu:',time() - start)
    
