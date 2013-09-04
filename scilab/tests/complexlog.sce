// Public domain script.

function z = f(x, y)
  z = abs(log(x+%i*y));
endfunction

X = -2.4:0.05:2.4;
Y = -2.0:0.05:2.0;

fplot3d(X, Y, f);

