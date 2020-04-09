function [W] = proxgrad(X,Y,MAX_ITR, lambda,gamma,Bind,epsilon)

% Stepsize selection


if nargin < 7
    
    error('7 input arguments needed');
end

m= size(X,1);
Task_Number=size(Y,2);

% Compute task specific featues:
Feature_Sets=Task_Features(Y, X, Bind);

% Compute step size
S=Compute_StepSize(Feature_Sets,Task_Number);


for num_iter = 1:MAX_ITR
    
    if num_iter==1
        
        W = zeros(size(X,2),size(Y,2));
        W_pre = W;
    end
    
    
    W = Compute_gradient(Feature_Sets,Y,W,Task_Number,m);
    
    % do proximal opertor:
    gradient = proximal(W,lambda,gamma,Bind);
    
    % Update the gradient:
    W = W_pre - times(S , gradient) ;
    
    W= W + (num_iter/(num_iter + 3)) * ( W - W_pre);
    
    W_pre = W;
    
    % if mod(num_iter,500)==1
    Conv_Criteria = norm(gradient(:));
    
    if Conv_Criteria < epsilon
        
        break;
    end
    
    %end
    %disp(num_iter);
end


end



