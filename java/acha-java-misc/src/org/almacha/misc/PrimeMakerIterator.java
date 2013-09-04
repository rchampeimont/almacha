// Public domain
package org.almacha.misc;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;

public class PrimeMakerIterator implements Iterator<Integer> {
	private int lastPrime;
	List<Integer> knownPrimes;
	
	public PrimeMakerIterator() {
		lastPrime = 1;
		knownPrimes = new ArrayList<Integer>();
	}
	
	public void remove() {
		throw (new UnsupportedOperationException());
	}
	
	private int tryNext() {
		int nextPrime = lastPrime;
		boolean isPrime = false;
		while (!isPrime) {
			nextPrime++;
			isPrime = true;
			for (Integer p: knownPrimes) {
				if ((nextPrime % p) == 0) {
					isPrime = false;
					break;
				}
			}
		}

		return nextPrime;
	}
	
	public Integer next() {
		int nextPrime = tryNext();
		if (nextPrime > 0) {
			lastPrime = nextPrime;
			knownPrimes.add(nextPrime);
			return nextPrime;
		} else {
			// integer has wrapped, so we have gone over MAX_INT
			throw (new NoSuchElementException());
		}
	}
	
	public boolean hasNext() {
		int nextPrime = tryNext();
		// There is an infinity of primes, but a finite number of java-int primes!
		return (nextPrime > 0);
	}
}
