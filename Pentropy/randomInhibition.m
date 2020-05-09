function W = random_inhibition(W,k)

    W = abs(W);
    L = length(W);
    inhi_pos = randsample(L,k);
    W(inhi_pos,:) = -W(inhi_pos,:)

end