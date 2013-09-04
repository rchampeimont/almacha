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
using System;
using System.Collections.Generic;

public class AchaVoteException : Exception {
    public AchaVoteException(string message): base(message) {}
}

public class AchaVoteBadArgument : AchaVoteException {
    public AchaVoteBadArgument(string message): base(message) {}
}

public class AchaVote {
    public static long[,] MatrixFromRankLists(uint c, LinkedList<long[]> l) {
        /*
        The l argument is a sequence of "votes",
        c is a integer greater or equal to 0, which represents
        the number of candidates.
        For all i:
            l[i] has only elements of type non-None or None.
            They represent the ranks given to the candidates.
            If l[i][j0] and l[i][j1] are of type non-None, then
            l[i][j0] < l[i][j1] means that candidate j0 is strictly preferred
            to j1 in vote i. (saller = better ranked, ie 1 is better
            than 2).
            If l[i][j0] > l[i][j1],
            then j1 is strictly preferred to J0 in vote i.
            If l[i][j0] == l[i][j1], then j0 and j1 are equally preferred
            in vote i.
            If l[i][j0] is of type None, then for any
            candidate j1 such that l[i][j1] is of type non-None,
            j1 is strictly preferred to j0 in vote i.
            If l[i][j0] and l[i][j1] are of type None, then they are
            equally preferred.

        Non-None can be any type, this function will compare them
        with the "<" and ">" operators of python. So you can use ints,
        longs, floats, strings, anything else, and a mix of all that
        (although mixing, say, strings with longs, is not really
        recommended if you want meaningfull results...).

        Informally, we could say that None plays the role of "+infinity"
        (ie. something greater than anything else, except itself)
        if we take the convention that "+infinity" == "+infinity".
        
        In non-mathematical language:
        "Voters may give the same preference to more than one candidate
        and may keep candidates unranked. When a given voter does not rank
        all candidates, then it is presumed that this voter strictly
        prefers all ranked candidates to all not ranked candidates and
        that this voter is indifferent between all not ranked candidates."
        (Wikipedia)

        The returned value is a c*c matrix, ie. it is a sequence of
        sequences of length c, and in which every element
        is of length c too. It contains ints or longs, that are all
        greater or equal than 0. If we call this returned matrix m,
        then m[i][j] is the number of votes in which candidate i
        is strictly preferred to j. A trivial consequence of this is
        that the diagonal is full of zeros.

        Example: If we have l =
        [[    2,    1,    2,    2, None, None],
         [-10.0, -0.2,  0.0,  0.0, None,    0]]
         In the first vote (l[0]) we have, in order of preference
         (best to worst):
         - Candidate 1.
         - Candidates 0, 2 and 3.
         - Candidates 4 and 5.
         In the second vote (l[1]) we have, in order of preference
         (best to worst):
         - Candidate 0.
         - Candidate 1.
         - Candidates 2, 3 and 5.
         - Candidate 4.
        */

        // check argument
        if (c < 0) {
            throw (new AchaVoteException("Bad argument: c < 0"));
        }

        long[,] m = new long[c, c];
        return m;
    }
}

class AchaHello {  
    static void Main() {  
        System.Console.WriteLine("aaa");
    }  
}  
