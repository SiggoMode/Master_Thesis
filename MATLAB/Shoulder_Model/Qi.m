function Q = Qi(f, q, rpli, rpmi, R)
    % Calc drdq
    drdq_ = drdq(R*rpli, q);

    % Calc F
    rpli_pmi = - R*rpli + rpmi;
    F = Force(f, rpli_pmi);

    % Calc Q
    Q = drdq_.' * F;
end

