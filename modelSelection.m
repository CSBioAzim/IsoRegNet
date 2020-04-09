
function [optimum_lambda, optimum_gamma,min_err]= modelSelection(CVerr_Grid,lambda_list,gamma_list)

% Find the minimum cross validation error at the CV error and find
% associated hyperparameters
min_err=min(CVerr_Grid(:));
[m,n] = find(CVerr_Grid == min_err);

if length(m) || length(n) > 1
    m=m(1);
    n=n(1);
else
    m=m;
    n=n;
end

%optimum Parameters with lowest CV
optimum_lambda = lambda_list(n);
optimum_gamma= gamma_list(m);

end
