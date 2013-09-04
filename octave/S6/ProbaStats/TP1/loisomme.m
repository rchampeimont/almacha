% Public domain.
function [val, prob] = loisomme(n, a, p)
    r = length(p);
    val = n*a:n*(a+r-1);
    prob = p;
    for x = 2:n
        prob = conv(prob, p);
    end
end
