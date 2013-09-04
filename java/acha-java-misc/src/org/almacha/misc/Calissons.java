package org.almacha.misc;

public class Calissons {
	private int[][][] A;
	
	public Calissons() {
		// Convention : 1 = gagne; -1 = perd; 0 = non encore calculé
		A = new int[33][33][33];
	}
	
	private boolean essayer(int boiteNonVidee1, int boiteNonVidee2) {
		int i, j;
		for (i = 0; i <= boiteNonVidee1 - 1; i++) {
			for (j = 0; j <= boiteNonVidee2 - 1; j++) {
				if (i + j == 0) {
					continue;
				}
				if (estGagnante(i+j, boiteNonVidee1-i, boiteNonVidee2-j)) {
					return true;
				}
			}
		}
		
		return false;
	}
	
	private boolean estGagnante(int boite1, int boite2, int boite3) {
		boolean r;
		if (A[boite1][boite2][boite3] == 0) {
			// Il faut calculer la valeur
			// Je gagne si et seulement si il existe un choix que je puisse
			// faire qui fait que l'adversaire perde.
			r = (!essayer(boite1, boite2))  // on vide la boite 3
			 || (!essayer(boite1, boite3))  // on vide la boite 2
			 || (!essayer(boite2, boite3)); // on vide la boite 1
			
			// On mémorise la valeur pour un accès plus rapide par la suite
			A[boite1][boite2][boite3] = r ? 1 : -1;
		} else {
			r = (A[boite1][boite2][boite3] == 1);
		}
		return r;
	}
	
	public void calcul() {
		A[1][1][1] = -1;
		int somme = 32;
		int gagnes = 0;
		int perds = 0;
		for (int i = 1; i <= somme - 2; i++) {
			for (int j = i; j <= somme - i - 1; j++) {
				int k = somme - i - j;
				if (k < j) {
					continue;
				}
				boolean aliceGagne = estGagnante(i, j, k);
				System.out.println("Config (" + i + "," + j + "," + k +
							") : Alice " + (aliceGagne ? "gagne" : "perd") + ".");
				if (aliceGagne) {
					gagnes++;
				} else {
					perds++;
				}
			}
		}
		
		System.out.println("Alice gagne dans " + gagnes
				+ " cas et perd dans " + perds + " cas.");
	}
	
	public static void main(String[] args) {
		Calissons x = new Calissons();
		x.calcul();
	}
}
