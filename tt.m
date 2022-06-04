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
load('result/ML_result');
result_MLtmp=GetMLAccuracy(src, truth,D4_FG, D4_BG);
ML=[result_ML,result_MLtmp];
save('result/ML', 'ML');

%%
%this part for BAY and MAP;
[rows,cols]=size(alpha);

result_BAY_S1_tmp=zeros(1,cols);
result_BAY_S2_tmp=zeros(1,cols);
result_MAP_S1_tmp=zeros(1,cols);
result_MAP_S2_tmp=zeros(1,cols);

% for S1:
load('Prior_1.mat');
load('Alpha.mat');

load('result/BAY_MAP')
for i=1:cols
    i
    priSig=diag(W0)*alpha(i);
    result_BAY_S1_tmp(1,i)=GetBaysianAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D4_FG, D4_BG);
    result_MAP_S1_tmp(1,i)=GetMapAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D4_FG, D4_BG);
    
end


load('Prior_2.mat');
 for i=1:cols
    i
    priSig=diag(W0)*alpha(i);
    result_BAY_S2_tmp(1,i)=GetBaysianAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D4_FG, D4_BG);
    result_MAP_S2_tmp(1,i)=GetMapAccuracy(src, truth,mu0_FG,priSig,mu0_BG,priSig,D4_FG, D4_BG);
    
 end   
 
BAY_S1=[result_BAY_S1;result_BAY_S1_tmp];
BAY_S2=[result_BAY_S2;result_BAY_S2_tmp];
MAP_S1=[result_MAP_S1;result_MAP_S1_tmp];
MAP_S2=[result_MAP_S2;result_MAP_S2_tmp];
save('result/BAY_AND_MAP','BAY_S1','BAY_S2','MAP_S1','MAP_S2');
    
    
    
