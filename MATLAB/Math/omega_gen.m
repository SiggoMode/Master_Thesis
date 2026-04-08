function omega = omega_gen(q, qdot)
G = G_gen(q);
omega = 2 * G * qdot;
end