function [Loss]=computeLoss(x,y, W, Bind)
% This function compute the objective function for multi-task groul lasso
% penalty

group_objective = Compute_groupobj(W,Bind);

Loss = 1 / (2 * m) * sum(((x * W) - y) .^ 2) + norm(W,1) + group_objective;

% com......

end
