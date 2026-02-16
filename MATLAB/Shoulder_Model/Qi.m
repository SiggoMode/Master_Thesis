function Q_force = Qi(f, q, rpli, rpmi, R_h)
    % Calc drdq
    drdq_ = drdq(R_h*rpli, q);

    % Calc F
    rpli_pmi = - R_h*rpli + rpmi;
    F = Force(f, rpli_pmi);

    % Calc Q
    Q_force = drdq_.' * F;
end

