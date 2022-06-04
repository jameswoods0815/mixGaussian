clc
close all
load('Prior_1.mat');
load('Alpha.mat');
load('TrainingSamplesDCT_subsets_8.mat');
src=imread('cheetah.bmp');
truth=imread('cheetah_mask.bmp');
%priSig=diag(W0)*alpha(5);
%result=GetBaysianAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D3_FG, D3_BG)

%result1=GetMapAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D3_FG, D3_BG)

%result2=GetMLAccuracy(src, truth,D1_FG, D1_BG)

%%
% this part for ML 
result_ML=zeros(1,4);
result_ML(1)=GetMLAccuracy(src, truth,D1_FG, D1_BG);
result_ML(2)=GetMLAccuracy(src, truth,D2_FG, D2_BG);
result_ML(3)=GetMLAccuracy(src, truth,D3_FG, D3_BG);
result_ML(4)=GetMLAccuracy(src, truth,D4_FG, D4_BG);

save('result/ML_result', 'result_ML');

%%
%this part for BAY and MAP;
[rows,cols]=size(alpha);

result_BAY_S1=zeros(4,cols);
result_BAY_S2=zeros(4,cols);
result_MAP_S1=zeros(4,cols);
result_MAP_S2=zeros(4,cols);

% for S1:
load('Prior_1.mat');
load('Alpha.mat');

for i=1:cols
    i
    priSig=diag(W0)*alpha(i);
    result_BAY_S1(1,i)=GetBaysianAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D1_FG, D1_BG);
    result_MAP_S1(1,i)=GetMapAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D1_FG, D1_BG);
    result_BAY_S1(2,i)=GetBaysianAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D2_FG, D2_BG);
    result_MAP_S1(2,i)=GetMapAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D2_FG, D2_BG);
    result_BAY_S1(3,i)=GetBaysianAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D3_FG, D3_BG);
    result_MAP_S1(3,i)=GetMapAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D3_FG, D3_BG);
    result_BAY_S1(4,i)=GetBaysianAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D4_FG, D4_BG);
    result_MAP_S1(4,i)=GetMapAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D4_FG, D4_BG);
end


load('Prior_2.mat');
 for i=1:cols
    i
    priSig=diag(W0)*alpha(i);
    result_BAY_S2(1,i)=GetBaysianAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D1_FG, D1_BG);
    result_MAP_S2(1,i)=GetMapAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D1_FG, D1_BG);
    result_BAY_S2(2,i)=GetBaysianAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D2_FG, D2_BG);
    result_MAP_S2(2,i)=GetMapAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D2_FG, D2_BG);
    result_BAY_S2(3,i)=GetBaysianAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D3_FG, D3_BG);
    result_MAP_S2(3,i)=GetMapAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D3_FG, D3_BG);
    result_BAY_S2(4,i)=GetBaysianAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D4_FG, D4_BG);
    result_MAP_S2(4,i)=GetMapAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D4_FG, D4_BG);
 end   
 
save('result/BAY_MAP','result_BAY_S1','result_BAY_S2','result_MAP_S1','result_MAP_S2');
    
    
    
