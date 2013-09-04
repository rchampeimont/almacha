-------------------------------------------------------------------------------
-- I, Raphael Champeimont, the author of this program,
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

ackermann 0 n = n + 1
ackermann m 0 = ackermann (m-1) 1
ackermann m n = ackermann (m-1) (ackermann m (n-1))

main = do
    putStrLn ("ackermann_haskell: " ++ (show (ackermann 5 0)))
