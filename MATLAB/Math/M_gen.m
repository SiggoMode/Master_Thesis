function M = M_gen(q, system_params)
G = G_gen(q);
I = system_params.I;

M = 4*G'*I*G;
end