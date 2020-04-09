function[Fold_indices]=Generate_CV_Folds(X,nfolds)

 % This function take the input feature matrix and partition data into N
 % folds of cross validation and provides the indeces of these data points
 
Fold_indices=zeros(size(X,1),nfolds);

C = cvpartition(size(X,1),'kfold',nfolds);

for cl=1:size(Fold_indices,2)
    
    Fold_indices(1:end,cl)=training(C,cl);
end
end