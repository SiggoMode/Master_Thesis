function F = Force(f, rpli_pmi)
    F = f * rpli_pmi / norm(rpli_pmi);
end

