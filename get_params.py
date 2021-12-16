#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import getopt
import sys

""" This module generates a key from bash parameters """

def get_params():
    optlist,_ = getopt.getopt(sys.argv[1:], 'i:s:b:')
    key = {}
    for i in optlist:
        print(i)
        if i[0] == '-s':
            for a in i[1].split(sep='+'):
                k,v = a.split(sep=':')
                key[k] = v
        elif i[0] == '-b':
            for a in i[1].split(sep='+'):
                k,v = a.split(sep=':')
                key[k] = True if v == "true" else False
        elif i[0] == '-i':
            for a in i[1].split(sep='+'):
                k,v = a.split(sep=':')
                key[k] = int(v)
        else:
            print('error:',i[0],i[1])
        
    return key


if __name__ == "__main__":
    # -s nychoice:kmeans_joint+diroutput:/home/output+jn:lerunxxx+cell_type:T_T+patient:1_2
    # -b nystrom:true+sc:false
    # -i data_nobs:100+data_seed:200+nC:300+nj:400
            
    key = get_params()
    print(key)


