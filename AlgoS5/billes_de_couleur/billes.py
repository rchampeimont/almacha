#!/usr/bin/python
# -*- coding: utf-8 -*-
# L'auteur, Raphael Champeimont, met ce programme dans le domaine public.
# $Id: billes.py 359 2008-09-18 16:08:36Z almacha $

import time

tableau_fusion_couleurs = (
# couleur de droite
#   (0,1,2)    
    (0,2,1), # 0
    (0,1,0), # 1 couleur de gauche
    (0,0,2), # 2
    )



# Retourne la couleur de la bille apres fusion
# des billes de couleurs c1 et c2, repectivement
# a droite et a gauche
def fusion_couleurs(c1, c2):
    return tableau_fusion_couleurs[c1][c2]
 


# Prends une ligne de billes l (longueur >= 2),
# une fonction f et un numero de bille b
# (dans [0,longueur(l)-2]). La fonction fussionne
# la bille b avec le bille se trouvant a droite de b.
# Elle retourne la nouvelle ligne de billes.
# Si f n'est pas specifee, la fonction fusion_couleurs
# est utilisee.
def calculer_nouvelle_ligne(l, b, f = fusion_couleurs):
    if len(l) <= 1:
	raise ValueError, "ligne de longueur %d, ce qui est <= 1" % len(l)
    if b < 0 or b > len(l)-2:
	raise ValueError, "numero de bille invalide : %d" % b
    return l[0:b] + (f(l[b], l[b+1]),) + l[b+2:]



def test1():
    l = (0,1,2,0,0,0,0)
    print l
    while len(l) > 1:
	l = calculer_nouvelle_ligne(l, 0)
	print l



# Cette fonction cherche a savoir s'il existe une suite
# de fusions permettant d'obtenir a partir de la ligne l,
# une bille de la couleur c a la fin.
# Elle retourne une suite de billes a fusionner,
# c'est a dire qu'elle se contente de trouver une solution
# et non toutes les solutions. La fonction retourne une
# liste vide si il n'y a pas de solution.
def methode_bete(l, c):
    if len(l) < 2:
	raise ValueError, "la liste doit avoir au moins 2 billes"

    if len(l) == 2:
	# Cas de base : il n'y a que 2 billes.
	# Il y a donc une solution si et seulement
	# si la bille resultant de cette fusion est
	# de la bonne couleur.
	nouvelle_ligne = calculer_nouvelle_ligne(l, 0)
	if nouvelle_ligne[0] == c:
	    return (0,) # Solution : fusionner la premiere bille
	                # (seule choix possible en fait)
	else:
	    return ()   # Bille de la mauvaise couleur : pas de solution.


    else:
	# On essaye chaque fusion possible.
	for b in range(0,len(l)-1):
	    nouvelle_ligne = calculer_nouvelle_ligne(l, b)
	    # Avec cette fusion, on cherche s'il y a une solution
	    # pour cette nouvelle liste de billes.
	    solution_avec_cette_ligne = methode_bete(nouvelle_ligne, c)
	    if solution_avec_cette_ligne:
		return (b,) + solution_avec_cette_ligne
	return () # Pas de solution.



def test2():
    t0 = time.time()
    sol = methode_bete((0,1,2,0,1), 0)
    t1 = time.time()
    delta_t = t1 - t0
    print "Le calcul a pris %s secondes." % delta_t
    print "Solution :"
    print sol




test2()
