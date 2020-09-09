
% This script runs MTL
parpool(45)


%% This is for sumlated data part
%Bind=Bind';
load('Bind.mat')
%Bind(Bind==0)=2;

%load('mir.mat')
%load('Transcript.mat')
load('miRNA_learn.mat')
load('Transcript_learn.mat')
load('Task_Inf.mat')
% 
load('miRNA_test.mat')
load('Transcript_test.mat')


x= miRNA_Learn;
Y= Transcript_Learn';
% test data
x_test=miRNA_Test;
Y_test= Transcript_Test';
x_test=scale_features(x_test);
m=size(x_test,1);
x_test=[x_test,ones(m,1)];

%

x=scale_features(x);
m=size(x,1);
x=[x,ones(m,1)];

params.x = x;

% Set the hyper param grid
%params.lambda_list = 5:-0.05:2;
params.lambda_list = logspace(-0.3,-2,50);
params.gamma_list = logspace(-0.3,-2,50);

params.stopVal = 10^-8;
params.MAX_ITR = 2000;
params.epsilon=0.001;
nfolds=4;

%% Do cross validation and get optimum hyper parameters

%task_gene_info = cell2mat(martexport);
gene_idx = task_gene_info(2:end,2);
task_idx = task_gene_info(2:end,1);
unique_genes = unique(gene_idx);
Errors = cell(1,length(unique_genes));
Weights = cell(1,length(unique_genes));
Correlations = cell(1,length(unique_genes));

tic
for cnt = 1:length(unique_genes)
    idx = find(gene_idx==unique_genes(cnt));
    sub_Bind = Bind(idx,:);
    sub_y = Y(:,idx);
    sub_y_test = Y_test(:,idx);
    params.y = sub_y;
    params.Bind=sub_Bind;
    [optparams,min_cvError,CVerr_Grid] = do_CV(params,nfolds);
    
    % Train optimum model:
    opt_lambda = optparams.opt_lambda;
    
    opt_gamma = optparams.opt_gamma;
    
    MAX_ITR = params.MAX_ITR;
    epsilon=0.001;
    coef = proxgrad(x,sub_y,MAX_ITR, opt_lambda,opt_gamma,sub_Bind,epsilon);
    % predict on test data;
    predict_y = x_test * coef;
    CoR = Compute_Corr( predict_y,sub_y_test);
    Errors{cnt} = min_cvError;
    Weights{cnt} = coef;
    Correlations{cnt} = CoR;
    disp(cnt)
end
toc
save('Errors','Errors')
save('Weights','Weights')
save('Correlations','Correlations')


%% Save the model coefficents- Predict it on test dataset and
% grather hyper parameter info of model into one object

Model.opt_lambda = opt_lambda;
Model.opt_gamma = opt_gamma;
Model.min_cvError= min_cvError;

csvwrite('Optimum_Model_Coefficents_FineGraine',coef);
csvwrite('cross_validation_errGrid',CVerr_Grid)
save Final_hyperparam  Model;

% [sorted_gene,I] = sort(gene_names);

% task_gene = [task_names(I),sorted_gene];
