function[x_scaled] = scale_features(x)
% This function scales the input featues
mu=mean(x);
sigma=std(x);
%

for cl=1:size(x,2)
    
    x(:,cl) = (x(:,cl) - mu(cl))./ sigma(cl);
end
x_scaled = x;

end