#!/usr/bin/python
# -*- coding: utf-8 -*-

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

def ackermann1(m, n):
    if m < 0 or n < 0:
	raise ValueError, "m or n is < 0"
    def A(m,n):
	if m == 0:
	    return n + 1
	else:
	    if n == 0:
		return A(m-1, 1)
	    else:
		return A(m-1,A(m,n-1))
    return A(m,n)

print "ackermann.py: %d" % ackermann1(5, 0)
