% This script runs MTL
parpool(45)


%% This is for sumlated data part
%Bind=Bind';
load('Bind.mat')
Bind(Bind==0)=2;
%load('mir.mat')
%load('Transcript.mat')
load('miRNA_test')
load('Transcript_test')
% 
% x= miRNAExprFileTrainscale;
% y= TranscriptexprTrain;

x= miRNAExprFileTestscale(1:500,:);
y= TranscriptexprTestnew(1:500,:);

% x = Mir.z;
% y = Tran.y;
% y=y(:,1:2);

x=scale_features(x);
m=size(x,1);
x=[x,ones(m,1)];

params.x = x;
params.y = y;
params.Bind=Bind;
% Set the hyper param grid
%params.lambda_list = 5:-0.05:2;
params.lambda_list = logspace(-1,-2,100);
params.gamma_list = logspace(-1,-2,100);

params.stopVal = 10^-8;
params.MAX_ITR = 4000;
params.epsilon=0.001;
nfolds=4;

%% Do cross validation and get optimum hyper parameters
tic
[optparams,min_cvError,CVerr_Grid] = do_CV(params,nfolds);
toc

% Train optimum model:

opt_lambda = optparams.opt_lambda;

opt_gamma = optparams.opt_gamma;

MAX_ITR=params.MAX_ITR;
epsilon=0.001;
coef = proxgrad(x,y,MAX_ITR, opt_lambda,opt_gamma,Bind,epsilon);

%% Save the model coefficents- Predict it on test dataset and 
% grather hyper parameter info of model into one object

Model.opt_lambda = opt_lambda;
Model.opt_gamma = opt_gamma;
Model.min_cvError= min_cvError;

csvwrite('Optimum_Model_Coefficents',coef);
csvwrite('cross_validation_errGrid',CVerr_Grid)
save Final_hyperparam  Model;




