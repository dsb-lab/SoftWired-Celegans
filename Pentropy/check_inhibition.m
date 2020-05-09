function rows_inhi_W = check_inhibition(W)

sumW = sum(W,2);
rows_inhi_W = sum(sumW<0);

end

