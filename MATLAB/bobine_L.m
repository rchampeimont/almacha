function [ L ] = bobine_L( d, b, e, n )
% d = diamètre de la bobine en m
% b = longueur de la bobine en m
% e = épaisseur de l'enroulement en m
% n = nombre de spires
%http://www.tavernier-c.com/bobinages.htm
L = (n^2 * d^2) * (d^2 - 2.25 * e) / (d * (43.8 * d + 112.5 * b^2));
end

