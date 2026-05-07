function y = wrapToPi(x)
    y = mod(x + pi, 2*pi) - pi;
end