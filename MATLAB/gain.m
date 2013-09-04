function r = gain(CS, A)
    n = length(CS);
    r = entropie(sum(CS==1),sum(CS==0)) - sum(A == 1)/n*entropie(sum((A==1).*(CS==1)), sum((A==1).*(CS==0))) - sum(A == 0)/n*entropie(sum((A==0).*(CS==1)), sum((A==0).*(CS==0))) ;
end