// Public domain
package org.almacha.misc;

public class PrimeMakerTester {
	public static void main(String[] args) {
		PrimeMaker pm = new PrimeMaker();
		for (Integer prime: pm) {
			System.out.println(prime);
		}
	}
}
