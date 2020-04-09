function[gradient] = Compute_gradient(Feature_Sets,Y,W,Task_Number,m)
% This function compute task specific gradient and return it as a gradient matrix
   gradient_set= cell(1,Task_Number);


 for i =1:Task_Number
     
     x=Feature_Sets{1,i};
     y=Y(:,i);
     W_t=W(:,i);
     gradient_set{1,i}=((-1)/m).*(x') * (y-(x * W_t));
     
 end
 
 % Concatinate task gradients vector into matrix:
  gradient=cat(2,gradient_set{:});
  
end
