function [S] = Compute_StepSize(Feature_Sets,Task_Number)

 S=zeros;
 for i= 1:Task_Number
     
     feature_matrix=Feature_Sets{1,i};
     Lipsitch= max(eig(feature_matrix' * feature_matrix));
     S(i)= 2/Lipsitch;
 end



end



