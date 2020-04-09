function W = softhreshould(lambda,W)

W=sign(W).* (max(abs(W)-lambda,0));

end