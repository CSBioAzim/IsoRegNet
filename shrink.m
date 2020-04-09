
function W=shrink(gamma,W,Bind)
% Get's group structure from binary binding maytrix
%W=W_S;
% do not include interrcept in regularization
Nrow=size(W,1)-1;

Group_index=find(all(Bind~=0));
% Think of doing this step faster
for G=Group_index
    Shared_Site=find(abs(Bind(:,G))>0);
    Group=W(G,Shared_Site);
    Norm=norm(Group,2);
    g=sqrt(length(Shared_Site));
    
    
    if Norm > gamma * g
        W(G,Shared_Site)= (1- (gamma/Norm)).* Group;
    else
        W(G,Shared_Site)=0;
    end
end

end

