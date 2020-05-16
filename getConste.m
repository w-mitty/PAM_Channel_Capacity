function conste_norm = getConste(M)

    conste = pammod(0:M-1,M);
    total_Es = sum(abs(conste).^2);
    norm_factor = sqrt(M/total_Es);
    conste_norm= conste*norm_factor;
    
end