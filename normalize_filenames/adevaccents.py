#!/usr/bin/python
# -*- coding: utf-8 -*-

# Par Raphael Champeimont, dans le domaine public.
# Ce module fournit des fonctions pour générer des noms de fichiers
# contenant des noms de personnes, en enlevant les caractères accentués,
# les '-' et autres caractères spéciaux, de façon à pouvoir générer
# des noms de fichier comme FA2008-NOM-PRENOM-MATRICULE-CSS1[-CSS2].odt
# où "NOM" et "PRENOM" sont le nom et le prenom sans accents,
# en majuscules et sans '-' (pour pouvoir découper en utilisant les '-').

# on va utiliser des regex
import re

# table de templacement des caractères accentués
# (1 caractère unicode à chaque fois)
# par leurs équivalents sans accents
# (une chaine ASCII de éventuellement plusieurs caractères)
_remplacement_des_accents = {
    u'à':'a',
    u'À':'A',
    u'â':'a',
    u'Â':'A',

    u'é':'e',
    u'É':'E',
    u'è':'e',
    u'È':'E',
    u'ê':'e',
    u'Ê':'E',
    u'ë':'e',
    u'Ë':'E',

    u'î':'i',
    u'Î':'I',
    u'ì':'i',
    u'Ì':'I',

    u'ô':'o',
    u'Ô':'O',
    u'ò':'o',
    u'Ò':'O',

    u'ù':'u',
    u'Ù':'U',
    u'û':'u',
    u'Û':'U',

    u'ÿ':'y',
    u'Ÿ':'Y',

    u'œ':'oe',
    u'Œ':'OE',

    u'æ':'ae',
    u'Æ':'AE',

    u'ç':'c',
    u'Ç':'C',

    u'ß':'ss',
}

# un "mauvais caractere" est un caractere qui n'est
# ni une lettre majuscule non accentuée (A-Z)
# ni un chiffre (0-9)
# ni un underscore (_)
_mauvais_caracteres_trop_stricte = re.compile(r'[^A-Z0-9_]')

# matche tout caractère non-ASCII ou ASCII mais non imprimable
# ou interdit dans un nom de fichier
# sous Windows (\/:*?"<>|) ou UNIX (/)
_mauvais_caracteres_pour_nom_de_fichier = \
      re.compile(r'[^' + re.escape(""" !#$%&'()+,-.0123456789;=@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{}~""") + ']')



def sans_accents_unicode(s):
    r"""Enlève les accents de la chaine unicode s."""
    r = ''
    for c in s:
        r += _remplacement_des_accents.get(c, c)
    return r
        


def nom_pour_nom_de_fichier_unicode(s):
    r"""Enlève les accents de la chaine s, la met en majuscules,
    remplace les caractères non alphanumériques par des underscores,
    pour que au final la chaine retournée ne contienne que des lettres de
    A à Z, des chiffres (de 0 à 9) et des '_'.
    Attention : prend et retourne une chaine unicode
    (pas une chaine normale en UTF-8)."""

    # enlever les accents
    s = sans_accents_unicode(s)

    # mettre en majuscules (ne met en majuscules que les lettres
    # minuscules non accentuées)
    s = s.upper()

    # remplacer tout ce qui n'est pas une lettre majuscule
    # non accentée, un chiffre ou un underscore
    # par un underscore
    s = _mauvais_caracteres_trop_stricte.sub('_', s)

    return s



def nom_pour_nom_de_fichier_utf8(s):
    r"""Comme nom_pour_nom_de_fichier_unicode(), mais prend et retourne
    une chaine normale en UTF-8."""

    # de UTF-8 vers Unicode
    s = unicode(s, 'utf-8', errors = 'replace')

    # on remplacer les caractères
    s = nom_pour_nom_de_fichier_unicode(s)

    # de Unicode vers UTF-8
    s = s.encode('utf-8')

    return s



def normaliser_nom_de_fichier_unicode(s):
    r"""Comme la fonction normaliser_nom_de_fichier_utf8 mais
    traite une chaine unicode en entrée. La chaine retournée est en
    ASCII."""

    # on remplace les accents par des lettres non accentuées
    s = sans_accents_unicode(s)

    # on remplace les autres caractères interdits par des '_'
    s = _mauvais_caracteres_pour_nom_de_fichier.sub('_', s)

    return s


def normaliser_nom_de_fichier_utf8(s):
    r"""Cette fonction prend un nom de fichier en UTF-8 et retourne
    le même nom de fichier sans accents ni autres caractères intedits.
    La chaine retournée est une chaine normale en ASCII."""
    
    # de UTF-8 vers Unicode
    s = unicode(s, 'utf-8', errors = 'replace')

    # on remplacer les caractères
    s = normaliser_nom_de_fichier_unicode(s)

    # de Unicode vers ASCII
    s = s.encode('ascii')

    return s


def _test1():
    r"""Exemples d'utilisation."""
    print "--- Avec normalisation forte"
    print sans_accents_unicode(u'liberté, LIBERTÉ')
    print nom_pour_nom_de_fichier_unicode(u'éèêëûùà')
    print nom_pour_nom_de_fichier_unicode(u'ÉÈÊËÛÙÀ')
    print nom_pour_nom_de_fichier_utf8('deux mots')
    print nom_pour_nom_de_fichier_utf8('caractères accentués, œuf, ŒUF')
    print nom_pour_nom_de_fichier_utf8('Ich heiße Læticia.')
    print nom_pour_nom_de_fichier_utf8('>>> des choses encore + bizarres!!!')
    print nom_pour_nom_de_fichier_utf8('des caractères non prévus : αβγδε')
    print nom_pour_nom_de_fichier_utf8('pas_de_nom-composés_avec_signes-moins')
    print "--- Avec normalisation faible"
    print sans_accents_unicode(u'liberté, LIBERTÉ')
    print normaliser_nom_de_fichier_unicode(u'éèêëûùà')
    print normaliser_nom_de_fichier_unicode(u'ÉÈÊËÛÙÀ')
    print normaliser_nom_de_fichier_utf8('deux mots')
    print normaliser_nom_de_fichier_utf8('caractères accentués, œuf, ŒUF')
    print normaliser_nom_de_fichier_utf8('Ich heiße Læticia.')
    print normaliser_nom_de_fichier_utf8('>>> des choses encore + bizarres!!!')
    print normaliser_nom_de_fichier_utf8('des caractères non prévus : αβγδε')
    print normaliser_nom_de_fichier_utf8('pas_de_nom-composés_avec_signes-moins')
    print """ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~"""
    print normaliser_nom_de_fichier_utf8(""" !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~""")

