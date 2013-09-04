P = 25; % Watts
R = 25E3; % Ohms
U = 100:1000; % Volts
[I, Imax, Ith] = intensite_transfo(U, P, R);
plot(U, Imax, U, Ith, U, I); legend('Imax', 'Ith', 'I')
