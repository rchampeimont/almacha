function [I, Imax, Ith] = intensite_transfo(U, P, R)
% Supposons que l'on ait un transfo qui en entrée ait
% une tension U1 et une intensité max I1 telles que P = U1 * I1.
% On branche en sortie une résistance R.
% On cherche l'intensité qui la traversera.
Imax = P ./ U;
Ith = U ./ R;
I = min(Imax, Ith);
end