// Public domain
package org.almacha.misc;

import java.util.Iterator;

public class PrimeMaker implements Iterable<Integer>{
	
	public Iterator<Integer> iterator() {
		return (new PrimeMakerIterator());
	}
}
