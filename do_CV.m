function[optparams,min_cvError,CVerr_Grid]= do_CV(params,nfolds)

% This function does corss validation over grid of parameters and return
% back the optimum hyperparam and min cross validation error.

x=params.x;
y=params.y;
MAX_ITR=params.MAX_ITR;
epsilon=params.epsilon;
lambda_list=params.lambda_list;
gamma_list=params.gamma_list;
Bind=params.Bind;
CVerr_Grid=zeros(length(gamma_list),length(lambda_list));
Num_Tasks=size(y,2);
% get the data

Fold_indices = Generate_CV_Folds(x,nfolds)>0;

% do cross validation over grid of parameters:
cX_train = arrayfun(@(idx_fold) x(Fold_indices(:,idx_fold),:),1:nfolds, 'Unif', 0);
cY_train = arrayfun(@(idx_fold) y(Fold_indices(:,idx_fold),:),1:nfolds, 'Unif', 0);
cX_test = arrayfun(@(idx_fold) x(~Fold_indices(:,idx_fold),:),1:nfolds, 'Unif', 0);
cY_test = arrayfun(@(idx_fold) y(~Fold_indices(:,idx_fold),:),1:nfolds, 'Unif', 0);
parfor k=1:length(lambda_list)
    lambda=lambda_list(k);
    
    mse = zeros(nfolds,Num_Tasks);
    
    CV_err = zeros(1,length(gamma_list)) ;
    
    
    for p=1:length(gamma_list)
        
        gamma = gamma_list(p);
        
        % Train model over N folds
        for idx_fold = 1:size(Fold_indices,2)
            
            % Creat fold data andd
            
            X_train = cX_train{idx_fold};
            y_train = cY_train{idx_fold};
            
            X_test = cX_test{idx_fold};
            y_test = cY_test{idx_fold};
            
            
            coff = proxgrad(X_train,y_train,MAX_ITR, lambda,gamma,Bind,epsilon);
            
            % Compute prediction error for each task
            
            mse(idx_fold,:) = mean((X_test * coff- y_test).^2);
        end
        %In_Fold_Error{1,p} = tmp;
        
        CV_err(p) = mean(mse(:));
        
    end
    
    % CVErr_twoparam{1,k} = In_Fold_Error;
    CVerr_Grid(:,k)=CV_err;
end


[opt_lambda, opt_gamma,min_cvError]= modelSelection(CVerr_Grid,lambda_list,gamma_list);


optparams.opt_lambda = opt_lambda;
optparams.opt_gamma = opt_gamma;



end