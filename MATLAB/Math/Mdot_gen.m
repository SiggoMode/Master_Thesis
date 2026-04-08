function Mdot = Mdot_gen(q, qdot, system_params)
I = system_params.I;
G = G_gen(q);
Gdot = G_gen(qdot);

Mdot = 4*(Gdot'*I*G + G'*I*Gdot);
end