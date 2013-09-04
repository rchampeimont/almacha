/* I, Raphael Champeimont, the author of this work,
 * hereby release it into the public domain.
 * This applies worldwide.
 * 
 * In case this is not legally possible:
 * I grant anyone the right to use this work for any purpose,
 * without any conditions, unless such conditions are required by law.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

/* This program is a simulation like the one explained by Richard
 * Dawkins in The Selfish Gene, in the chapter "You scratch my back,
 * I'll ride on yours" about birds that remove other's parasites.
 *
 * This program is not really serious, and I did it more to
 * learn the Java programming language than to do a real simulation.
 * It is a bad program because:
 * - Grudgers way of searching in their memory is very
 *   inefficient (in O(#birds) for every search).
 * - It does not contain random, and the population size is only 100,
 *   so if the gene differiential is has only 2 significative numbers,
 *   so a too small mutation positive effect will simply be ignored.
 */

import java.util.Vector;
import java.util.Iterator;

abstract class Bird {
    final public void myParasiteIsRemoved() {
        geneSurvival += 10;
    }
    final public boolean iAmAskedToRemoveParasiteOf(Bird b) {
        if (decideIfIRemoveParasiteOf(b)) {
            geneSurvival += -1;
            return true;
        } else {
            return false;
        }
    }
    final public void askOtherToRemoveMyParasite(Bird b) {
        boolean answer = b.iAmAskedToRemoveParasiteOf(this);
        if (answer) {
            // He accepts, so removes my parasite.
            myParasiteIsRemoved();
        }
        iAskedHimToRemoveMyParasite(b, answer);
    }
    public void iAskedHimToRemoveMyParasite(Bird b, boolean answer) {
        // by default do nothing
        return;
    }
    public abstract boolean decideIfIRemoveParasiteOf(Bird b);
    private double geneSurvival = -5.0;
    public double getGeneSurvival() {
        return geneSurvival;
    }
    public abstract String getBirdType();
}

class Sucker extends Bird {
    public String getBirdType() {
        return "Sucker";
    }
    public boolean decideIfIRemoveParasiteOf(Bird b) {
        // I am the pure altruist, so I accept.
        return true;
    }
}

class Cheat extends Bird {
    public String getBirdType() {
        return "Cheat";
    }
    public boolean decideIfIRemoveParasiteOf(Bird b) {
        // I am a pure selfish bird, se I refuse.
        return false;
    }
}

class Grudger extends Bird {
    private class MemoryOfOtherBird {
        public MemoryOfOtherBird(Bird b, boolean g) {
            bird = b;
            isAGoodBird = g;
        }
        public Bird bird;
        public boolean isAGoodBird;
    }
    public String getBirdType() {
        return "Grudger";
    }
    public boolean decideIfIRemoveParasiteOf(Bird b) {
        Iterator i = listOfSelfishBirds.iterator();
        while (i.hasNext()) {
            MemoryOfOtherBird a = (MemoryOfOtherBird) i.next();
            if (a.bird == b) {
                // We know him, is he a good bird?
                if (a.isAGoodBird) {
                    // Yes, so remove his parasite.
                    return true;
                } else {
                    // No, he is selfish, so don't help him.
                    return false;
                }
            }
        }
        // We do not know him, so remove his parasite.
        return true;
    }
    public void iAskedHimToRemoveMyParasite(Bird b, boolean answer) {
        // Did I already know him?
        boolean found = false;
        {
            Iterator i = listOfSelfishBirds.iterator();
            while (i.hasNext()) {
                MemoryOfOtherBird a = (MemoryOfOtherBird) i.next();
                if (a.bird == b) {
                    found = true;
                    // We know him, so remebember that he is
                    // good if he removed my parasite this time
                    // and all the previous times.
                    a.isAGoodBird = a.isAGoodBird && answer;
                }
            }
        }
        if (!found) {
            // We didn't know him yet, so remember if he was kind.
            MemoryOfOtherBird mem = new MemoryOfOtherBird(b, answer);
            listOfSelfishBirds.add(mem);
        }
    }
    private Vector listOfSelfishBirds = new Vector();
}

public class BirdParasites {
    final static private int populationSize = 100;
    final static private int howManyTimesDoBirdsIntarctWithEachOther = 2;
    public static void main(String[] args) throws Exception {
        int[] childrenInitialNumber = new int[3];

        // Initial conditions:
        childrenInitialNumber[0] = 70; // Suckers
        childrenInitialNumber[1] = 16; // Cheats
        childrenInitialNumber[2] = 14; // Grudgers
        // Some interesting values to try:
        // (90,10,0)  Is Sucker stable against Cheat?
        // (0,10,90)  Is Grudger stable against Cheat?
        // (0,90,10)  Can Grudgers invade if they are a small number?
        // (0,80,20)  But if they are over a critical minimum,
        //            so that they can benefit from enough other Grudgers?
        // (70,16,14) Cheats can first exploit Suckers, but what
        //            will happen when there will be no more Suckers?

        Vector population = new Vector();
        for (int i=0; i<childrenInitialNumber[0]; i++) {
            population.add(new Sucker());
        }
        for (int i=0; i<childrenInitialNumber[1]; i++) {
            population.add(new Cheat());
        }
        for (int i=0; i<childrenInitialNumber[2]; i++) {
            population.add(new Grudger());
        }
        System.out.println("Sucker, Cheat, Grudger");
        System.out.println(childrenInitialNumber[0] + ", " + childrenInitialNumber[1] + ", " + childrenInitialNumber[2]);

        for (int l=0; l<1000; l++) {
            /* Make birds interact with each other. */
            for (int k=0; k<howManyTimesDoBirdsIntarctWithEachOther; k++) {
                Iterator i = population.iterator();
                while (i.hasNext()) {
                    Bird a = (Bird) i.next();
                    Iterator j = population.iterator();
                    while (j.hasNext()) {
                        Bird b = (Bird) j.next();
                        if (a != b) {
                            a.askOtherToRemoveMyParasite(b);
                        }
                    }
                }
            }

            /* Birds have children. */
            {
                double[] success = new double[3];
                int[] count = new int[3];
                Iterator i = population.iterator();
                while (i.hasNext()) {
                    Bird a = (Bird) i.next();
                    if (a.getBirdType() == "Sucker") {
                        success[0] += a.getGeneSurvival();
                        count[0] += 1;
                    } else if (a.getBirdType() == "Cheat") {
                        success[1] += a.getGeneSurvival();
                        count[1] += 1;
                    } else if (a.getBirdType() == "Grudger") {
                        success[2] += a.getGeneSurvival();
                        count[2] += 1;
                    } else {
                        throw (new Exception("Unknown bird."));
                    }
                }

                double[] children = new double[3];
                int[] childrenNumber = new int[3];
                double total = 0.0;
                for (int j=0; j<3; j++) {
                    children[j] = success[j];
                    if (children[j] < 0.0) {
                        children[j] = 0.0;
                    }
                    total += children[j];
                }
                for (int j=0; j<3; j++) {
                    childrenNumber[j] = (int) ((children[j] * populationSize) / total);
                }

                System.out.println(childrenNumber[0] + ", " + childrenNumber[1] + ", " + childrenNumber[2]);

                population = new Vector();
                for (int j=0; j<3; j++) {
                    for (int k=0; k<childrenNumber[j]; k++) {
                        switch (j) {
                            case 0:
                                population.add(new Sucker());
                                break;
                            case 1:
                                population.add(new Cheat());
                                break;
                            case 2:
                                population.add(new Grudger());
                                break;
                            default:
                                throw (new Exception());
                        }
                    }
                }
            }
            

        }
    }
}
