#!/usr/bin/python
# -*- coding: utf-8 -*-
# $Id: achavote.py 471 2009-01-06 17:34:51Z almacha $

# I, Raphael Champeimont, the author of this work,
# hereby release it into the public domain.
# This applies worldwide.
# 
# In case this is not legally possible:
# I grant anyone the right to use this work for any purpose,
# without any conditions, unless such conditions are required by law.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# This program requires Python >= 2.4.
# This is an implementation of the Schulze voting method.
# See: http://en.wikipedia.org/wiki/Schulze_method
# It should be production ready. If you find a bug, let me know.

class AchaVoteException(Exception):
    r"""An exception was raised by an AchaVote function."""
    def __init__(self, reason):
        Exception.__init__(self, reason)

class AchaVoteBadArgument(AchaVoteException):
    r"""When an argument given to an AchaVote function is incorrect."""

def winner_list_from_matrix(c, d):
    r"""Arguments:
        * c is a integer greater or equal to 0, which represents
        the number of candidates.
        * d is matrix with c lines and c columns
        (ie. it is in fact a sequence of sequences), so that
        * d[i][j] is the number of votes in which candidate i
        is strictly preferred to j
        To be logical, the matrix you supply should have zeroes
        on the diagonal (as no one can stricty prefer i to i,
        by definition of "strictly") but the values on the digonal
        will simply be ignored (the function will work as if there
        were zeroes on the digonal).
        This function will return the list of potential winner
        according to the Schulze method. This list is is a list
        of integers in range(0,c), corresponding to the candidates
        numbers.
        """
    
    # check argument: c
    if c < 0:
        raise AchaVoteBadArgument, "Bad argument: c < 0"

    # range of indexes of the matrix
    candidates = range(0,c)

    # check argument: d
    if len(d) != c:
        raise AchaVoteBadArgument, "Wrong number of lines in matrix."
    for line in d: 
        if len(line) != c:
            raise AchaVoteBadArgument, \
                "Matrix has line with wrong number of elements."

    # We use this procedure (from http://en.wikipedia.org/wiki/Schulze_method):
    # (The d and p matrix in this algorithm are the d and p matrix
    # of our python function.)
    # 
    # Procedure
    #
    # Suppose d[V,W] is the number of voters who strictly
    # prefer candidate V to candidate W.
    #
    # A path from candidate X to candidate Y of strength p
    # is a sequence of candidates C(1),...,C(n) with the following properties:
    #
    #       1. C(1) = X and C(n) = Y.
    #       2. For all i = 1,...,(n-1): d[C(i),C(i+1)] > d[C(i+1),C(i)].
    #       3. For all i = 1,...,(n-1): d[C(i),C(i+1)] ≥ p.
    #
    # p[A,B], the strength of the strongest path from candidate A to
    # candidate B, is the maximum value such that there is a path
    # from candidate A to candidate B of that strength.
    # If there is no path from candidate A to candidate B at all,
    # then p[A,B] : = 0.
    #
    # Candidate D is better than candidate E if and only if p[D,E] > p[E,D].
    # 
    # Candidate D is a potential winner if and only if p[D,E] ≥ p[E,D]
    # for every other candidate E.


    # initialize variables
    winner = [True for i in candidates]
    p = [[0 for j in candidates] for i in candidates]

    for i in candidates:
        for j in candidates:
           if i != j:
               if d[i][j] > d[j][i]:
                   p[i][j] = d[i][j]
               else:
                   p[i][j] = 0

    for i in candidates:
        for j in candidates:
            if i != j:
                for k in candidates:
                    if (i != k) and (j != k):
                        p[j][k] = max(p[j][k], min(p[j][i], p[i][k]))

    # "Candidate i is a potential winner if and only if p[i][j] ≥ p[j][i]
    # for every other candidate j." is equivalent to
    # "Candidate i is not a pentential winner if and only if
    # there exists an other candidate j such that p[j][i] > p[i][j]"
    # This second formulation is exacly what we do here:
    for i in candidates:
        for j in candidates:
            if i != j:
                if p[j][i] > p[i][j]:
                     winner[i] = False

    # create the list of potential winners
    potential_winners = filter(lambda i: winner[i], candidates)

    return potential_winners



def matrix_from_rank_lists(c, l):
    r"""The l argument is a sequence of "votes",
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
        """

    # check argument: c
    if c < 0:
        raise AchaVoteBadArgument, "Bad argument: c < 0"

    # the list of candidates
    candidates = range(0,c)

    # check argument: l
    for vote in l: 
        if len(vote) != c:
            raise AchaVoteBadArgument, \
                "Sequence l contains a vote that has %d instead of c = %d elements." % (len(l), c)

    # create matrix
    # m[i][j] is the number of votes in which i is preferred to j
    m = [[0 for j in candidates] for i in candidates]
 
    # compute results
    for vote in l:
        for i in candidates:
            for j in candidates:
                # Is i strictly preferred over j in this vote?
                if ((vote[i] != None)
                        and (vote[j] != None)
                        and (vote[i] < vote[j])) \
                    or ((vote[i] != None)
                        and (vote[j] == None)):
                    # yes, so increment m[i][j]
                    m[i][j] += 1

    return m
                    


def winner_list_from_rank_lists(c, l):
    r"""Takes the same arguments as matrix_from_rank_lists,
        and returns the same sort of value as matrix_from_rank_lists."""
    d = matrix_from_rank_lists(c, l)
    w = winner_list_from_matrix(c, d)
    return w

      

def _test1():
    def first():
        print "EXAMPLE: FROM A MATRIX (EXAMPLE 1)"
        candidates = ["A", "B", "C", "D", "E"]
        m1 = [[ 0, 20, 26, 30, 22],
              [25,  0, 16, 33, 18],
              [19, 29,  0, 17, 24],
              [15, 12, 28,  0, 14],
              [23, 27, 21, 31,  0]]
        w1 = winner_list_from_matrix(len(candidates), m1)
        print map(lambda i: candidates[i], w1)

    def second():
        print "EXAMPLE: FROM A MATRIX (EXAMPLE 2)"
        c1 = 4
        candidates = ["A", "B", "C", "D", "E"]
        m1 = [[ 0, 11, 20, 14],
              [19,  0,  9, 12],
              [10, 21,  0, 17],
              [16, 18, 13,  0]]
        w1 = winner_list_from_matrix(c1, m1)
        print map(lambda i: candidates[i], w1)

    def third():
        print "EXAMPLE: FROM A MATRIX (EXAMPLE 3)"
        candidates = ["A", "B", "C", "D", "E"]
        m1 = [[ 0, 18, 11, 21, 21],
              [12,  0, 14, 17, 19],
              [19, 16,  0, 10, 10],
              [ 9, 13, 20,  0, 30],
              [ 9, 11, 20,  0,  0]]
        w1 = winner_list_from_matrix(len(candidates), m1)
        print map(lambda i: candidates[i], w1)

    def fourth():
        print "EXAMPLE: FROM A MATRIX (EXAMPLE 4)"
        c1 = 4
        candidates = ["A", "B", "C", "D", "E"]
        m1 = [[0, 5, 5, 3],
              [4, 0, 7, 5],
              [4, 2, 0, 5],
              [6, 4, 4, 0]]
        w1 = winner_list_from_matrix(c1, m1)
        print map(lambda i: candidates[i], w1)

    def cities_example():
        print "EXAMPLE: CITIES (FROM VOTE LIST)"
        # Taken from the example in Wikipedia:
        # http://en.wikipedia.org/wiki/Schulze_method
        cities = ['Memphis', 'Nashville', 'Knoxville', 'Chattengona']
        c2 = len(cities)
        #    # Memphis      Nashville       Knoxville       Chattenogona \
        v2 = [[1,           2,              4,              3           ]] *42 \
           + [[4,           1,              3,              2           ]] *26 \
           + [[4,           3,              2,              1           ]] *15 \
           + [[4,           3,              1,              2           ]] *17
        w2 = winner_list_from_rank_lists(c2, v2)
        print map(lambda citynum: cities[citynum], w2)

    def amb_example():
        print "EXAMPLE: AMBIGUITY RESOLUTION EXAMPLE"
        candidates = ["A", "B", "C", "D"]
        preferences_matrix = [[ 0, 68, 48, 62],
                              [32,  0, 72, 84],
                              [52, 28,  0, 91],
                              [38, 16,  9, 0]]
        winner_list_by_num = winner_list_from_matrix(len(candidates),
            preferences_matrix)
        winner_list_with_names = map(lambda i: candidates[i],
            winner_list_by_num)
        print "results : %s" % winner_list_with_names



    first()
    second()
    third()
    fourth()
    cities_example()
    amb_example()


