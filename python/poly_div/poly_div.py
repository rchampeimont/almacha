# Division of polynomials

# Example of input:
# python poly_div.py 4 -3 2 -7 0 0 1 -2

import sys

def num_to_str(n):
    if type(n) == str:
        return n
    if int(n) == n:
        return '%d' % n
    return '%s' % n

def poly_to_string(poly):
    # Remove leading zeros
    while len(poly) > 0 and poly[0] == 0:
        poly = poly[1:]
    if len(poly) == 0:
        return '0'
    s = ""
    maxcoeff = len(poly) - 1
    for i in range(len(poly)):
        if poly[i] != 0:
            sign = '+ ' if poly[i] >= 0 else '- '
            if i == 0 and sign == '+ ':
                sign = ''
            abscoeff = num_to_str(poly[i] if poly[i] >= 0 else - poly[i])
            if abscoeff == '1' and i < len(poly) - 1:
                # No need of 1 in front of an x^n
                abscoeff = ''
            s += sign + abscoeff + num_to_str('x' if i < len(poly) - 1 else '') + num_to_str('^' if i < len(poly) - 2 else '') + num_to_str(maxcoeff - i if i < len(poly) - 2 else '')
            if i < len(poly) - 1:
                s += ' '
    return s.strip()
    
def leading_index(poly):
    for i in range(len(poly)):
        if poly[i] != 0:
            return i

def leading_coeff(poly):
    return poly[leading_index(poly)]

def deg(poly):
    return index_to_deg(leading_index(poly))

def index_to_deg(k):
    return n - k - 1

def deg_to_index(k):
    return n - k - 1

def devide_leadings(a, b):
    assert len(a) == len(b)
    newdeg = deg(a) - deg(b)
    #print("newdeg %d" % newdeg)
    newcoeff = leading_coeff(a) / leading_coeff(b)
    #print("newcoeff %d" % newcoeff)
    newpoly = [newcoeff if deg_to_index(newdeg) == i else 0 for i in range(len(a))]
    return newpoly

def multiply(a, b):
    assert len(a) == len(b)
    assert len(a) == n
    result = [0 for i in range(n)]
    assert len(result) == n
    for i in range(len(a)):
        if a[i] != 0:
            deg_of_current_coeff_of_a = index_to_deg(i)
            for j in range(len(b)):
                if b[j] != 0:
                    deg_of_current_coeff_of_b = index_to_deg(j)
                    newdeg = deg_of_current_coeff_of_a + deg_of_current_coeff_of_b
                    newindex = deg_to_index(newdeg)
                    result[newindex] += a[i] * b[j]
    return result

def substract(a, b):
    assert len(a) == len(b)
    return [a[i] - b[i] for i in range(len(a))]

def add(a, b):
    assert len(a) == len(b)
    return [a[i] + b[i] for i in range(len(a))]

n = len(sys.argv[1:])/2
assert(n == int(n))
n = int(n)
dividend = [int(x) for x in sys.argv[1:(1+n)]]
divisor = [int(x) for x in sys.argv[(1+n):]]

print('Degree %d\n' % (n-1))
print("We are going to calculate %s divided by %s\n" % (poly_to_string(dividend), poly_to_string(divisor)))

quotient = [0 for i in range(n)]
orig_dividend = dividend

while True:
    div_result = devide_leadings(dividend, divisor)
    print("Divide the leading term of %s by the leading term of %s. This gives: %s" % (poly_to_string(dividend), poly_to_string(divisor), poly_to_string(div_result)))
    quotient = add(quotient, div_result)
    mult_result = multiply(div_result, divisor)
    print("Multiply %s by %s to get %s" % (poly_to_string(div_result), poly_to_string(divisor), poly_to_string(mult_result)))
    sub_result = substract(dividend, mult_result)
    print("Substract %s from %s. This leaves %s" % (poly_to_string(mult_result), poly_to_string(dividend), poly_to_string(sub_result)))
    dividend = sub_result
    if deg(dividend) < deg(divisor):
        remainder = dividend
        break
    print('\nWe now repeat:')

print("")
print("Quotient: %s" % poly_to_string(quotient))
print("Remainder: %s" % poly_to_string(remainder))
print("")
print("Final result:")
print("%s = (%s)(%s) + (%s)" % (poly_to_string(orig_dividend), poly_to_string(divisor), poly_to_string(quotient), poly_to_string(remainder)))