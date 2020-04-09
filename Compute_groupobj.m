function [group_obj] = Compute_groupobj(W,Bind)

% This function compute the objective value for non-overlapping group lasso
% in multi-task learning 


% do not include interrcept in regularization

Nrow=size(W,1)-1;

% Find the index of shared binding sites
Group_index=find(all(Bind ~=0 ));

group_value=zeros(1,Nrow);

for G=Group_index
    
    Shared_Site=find(abs(Bind(:,G))>0);
    Group=W(G,Shared_Site);
    Norm=norm(Group,2);
    g=sqrt(length(Shared_Site));
    group_value(G)=g * Norm;
end

group_obj=sum(group_value);


end
