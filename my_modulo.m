function y = my_modulo(a,m)

%standard modulo returns 0 when a is a multiple of m, I want one that
%returns m when this occurs

y = mod(a,m);

if y == 0
    y = m;
end