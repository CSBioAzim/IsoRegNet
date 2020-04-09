function[Feature_matrix] = Task_Features(Y, X, Bind)

% Task specific feature

Num_Task=size(Y,2);

Feature_matrix= cell(1,Num_Task);

for i = 1: Num_Task
    X_t=X;
    Index= Bind(i,:)==0;
    X_t(:,Index)=0;
    X_t=sparse(X_t);
    Feature_matrix{1,i}= X_t;
    
end

end
    
    
 