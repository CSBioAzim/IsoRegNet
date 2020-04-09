function W=proximal(W,lambda, gamma, Bind)

W_S= softhreshould(lambda, W);
W=shrink(gamma, W_S, Bind);

end