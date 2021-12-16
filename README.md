# CCIPL-Scripts

Le (Centre de Calcul Intensif des Pays de la Loire)[https://ccipl.univ-nantes.fr/] (CCIPL) est un centre de calcul parallèle pour le calcul scientifique. Le package CCIPL-Scripts est destiné à faciliter son utilisation aux chercheurs du (Laboratoire de Mathématiques Jean Leray)[https://www.math.sciences.univ-nantes.fr/fr] (LMJL). Le package a été pensé pour le Machine Learning et l'analyse de données. Pour des tutoriels et une description plus générale du CCIPL, voir (le wiki du CCIPL)[http://wiki.ccipl.univ-nantes.fr/].



Quand on parle de paralléliser nos calculs, cela peut vouloir dire différentes choses. 
La parallélisation la plus simple consiste à faire tourner le même script indépendamment sur plusieurs noeuds du CCIPL avec des paramètres différents sur chaque noeud. 
Le second niveau de parallélisation consiste à répartir les calculs d'un script sur les différents coeurs du noeud sur lequel on l'a lancé.  
Le troisième niveau de parallélisation consiste à faire tourner en parallèle plusieurs calculs sur un même coeur, ce niveau de parallélisation n'est possible que sur des (Graphics Processing Unit) GPU. 

