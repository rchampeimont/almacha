(*
# I, Raphael Champeimont, the author of this program,
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
*)

let ackermann m n =
    if m < 0 or n < 0 then failwith("m or n is < 0");
    let rec a m n = match (m, n) with
    | (0, n) -> n + 1
    | (m, 0) -> a (m-1) 1
    | (m, n) -> a (m-1) (a m (n-1))
    in
    a m n
;;

print_string ("ackermann_caml: " ^ (string_of_int (ackermann 5 0)) ^ "\n");;
