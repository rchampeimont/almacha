-------------------------------------------------------------------------------
-- I, Raphael Champeimont, the author of this work,
-- hereby release it into the public domain.
-- This applies worldwide.
-- 
-- In case this is not legally possible:
-- I grant anyone the right to use this work for any purpose,
-- without any conditions, unless such conditions are required by law.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-- WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-------------------------------------------------------------------------------

-- experimental thing

winner_list_from_matrix :: (Integral a) => Int -> [[a]] -> [a]
winner_list_from_matrix number_of_candidates defeat_matrix =
    let check_c (c,d) =
            -- check argument: c
            if c < 0
                then error "Bad argument: c < 0"
                else (c,d)
        check_m_len (c,d) =
            -- check argument: m
            if length d /= c
                then error "Wrong number of lines in matrix"
                else (c,d)
        check_m_lines (c,d) =
            if any (\line -> length line == c) d
                then error "Matrix has line with wrong number of elements"
                else (c,d)
        compute_result (c,d) =
            let candidates = [0..c-1] in
            let compute_p_from_d i j =
                if i == j
                    then 0
                    else let a = (d !! i) !! j in
                         let b = (d !! j) !! i in
                         if a > b then a else 0
            in
            let p =
                [[compute_p_from_d i j | j <- candidates | i <- candidates]]
            in
            let compute_p'_from_p i j =
                if i == j
                    then (p !! i) !! j
                    else let compute_-- TODO later if I want
            in
            d !! 0
    in
    let f = compute_result . check_m_lines . check_m_len . check_c in
    f (number_of_candidates, defeat_matrix)

main = do
    putStrLn (show (1000))
