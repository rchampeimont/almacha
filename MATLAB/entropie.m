function r = entropie(x, y)
s = x + y;
t1 = - x/s * log2(x/s);
if x == 0
    t1 = 0;
end
t2 = - y/s * log2(y/s);
if y == 0
    t2 = 0;
end
r = t1 + t2;
end