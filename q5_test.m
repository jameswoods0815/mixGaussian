clc
clear
close all

%% this part is for probability --- cheetah and grass;
load TrainingSamplesDCT_8_new.mat;
[rows_grass,cols_grass]=size(TrainsampleDCT_BG);
[rows_cheetah, cols_cheetah]=size(TrainsampleDCT_FG);
cheetah_prob=rows_cheetah*1.0/(rows_cheetah+rows_grass*1.0);
grass_prob=1-cheetah_prob;
%% load image
src=imread('cheetah.bmp');
truth=imread('cheetah_mask.bmp');
%feature=getFeature(src);
load feature

[rows,cols]=size(src);

index=[1,2,4,8,16,24,32,40,48,56,64]; % 11 element
index2=[1,2,4,8,16,32];

dP1=zeros(11,5,rows,cols);
dP2=zeros(11,5,rows,cols);
for i=1:11
    for j=1:5
        [i,j]
        x=TrainsampleDCT_FG(:,1:index(i));
        [mu,sigma,phi]=get_mix_parameter(x,8);

        y=TrainsampleDCT_BG(:,1:index(i));
        [mu1,sigma1,phi1]=get_mix_parameter(y,8);
        [result,P1,P2] = q5_GetAccuracy(feature,truth,grass_prob, cheetah_prob, mu,sigma, phi,mu1,sigma1,phi1);
        
       dP1(i,j,:,:)=P1;
       dP2(i,j,:,:)=P2;
       result
    end   
end

save dP1
save dP2


FinRes=zeros(11,6);
for i=1:11
    
    for j=1:6
        
        [i,j]
        x=TrainsampleDCT_FG(:,1:index(i));
        [mu,sigma,phi]=get_mix_parameter(x,index2(j));

        y=TrainsampleDCT_BG(:,1:index(i));
        [mu1,sigma1,phi1]=get_mix_parameter(y,index2(j));
        [result,P1,P2] = q5_GetAccuracy(feature,truth,grass_prob, cheetah_prob, mu,sigma, phi,mu1,sigma1,phi1);
        FinRes(i,j)=result;
        result
    end   
end
save FinRes

