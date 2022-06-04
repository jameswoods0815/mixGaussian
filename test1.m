clc
clear
close all

%% this part is for probability --- cheetah and grass;
load TrainingSamplesDCT_8_new.mat;
[rows_grass,cols_grass]=size(TrainsampleDCT_BG);
[rows_cheetah, cols_cheetah]=size(TrainsampleDCT_FG);
cheetah_prob=rows_cheetah*1.0/(rows_cheetah+rows_grass*1.0);
grass_prob=1-cheetah_prob;

%% this part is for maginal probability of cheetah and grass
% for cheetah and grass, I use both 50 bins to simulate the num;
featureLength=cols_grass;
grass_bin=50;
grass_edge=grass_bin+1;
cheetah_bin=50;
cheetah_edge=cheetah_bin+1;

cheetah_prob_index=zeros(featureLength,cheetah_edge);
cheetah_prob_counts=zeros(featureLength,cheetah_bin);
grass_prob_index=zeros(featureLength,grass_edge);
grass_prob_counts=zeros(featureLength,grass_bin);

% get cheetah prob:
for i=1:featureLength
    [cheetah_prob_counts(i,:),cheetah_prob_index(i,:)]=histcounts(TrainsampleDCT_FG(:,i),cheetah_bin);
    [grass_prob_counts(i,:),grass_prob_index(i,:)]=histcounts(TrainsampleDCT_BG(:,i),grass_bin);
end


cheetah_prob_counts=cheetah_prob_counts/rows_cheetah;
grass_prob_counts=grass_prob_counts/rows_grass;

figure(1);

for i=1:64
subplot(8,8,i)
plot(cheetah_prob_index(i,1:cheetah_bin),cheetah_prob_counts(i,:),'red')
hold on
plot(grass_prob_index(i,1:grass_bin),grass_prob_counts(i,:),'green')

t_title=strcat('feature  ',int2str(i));
title(t_title);

end
legend('chetah','grass');

%% This part is get conditional probibility of cheetah and grass


mean_cheetah_full=mean(TrainsampleDCT_FG);
mean_grass_full=mean(TrainsampleDCT_BG);

conv_cheetah_full=cov(TrainsampleDCT_FG);
conv_grass_full=cov(TrainsampleDCT_BG);

det_grass_full=det(conv_grass_full);
det_cheetah_full=det(conv_cheetah_full);

inv_grass_full=inv(conv_grass_full);
inv_cheetah_full=inv(conv_cheetah_full);

% get prob=
% 1/(sqrt((2*pi)^64)*det(conv)*exp(-0.5*(x-mean)*inv(cov)*(x-mean)')

%% this part is to select feature;
% I use f1=sigma1/sigma2; 
ratio=ones(1,64);
for i=1:64
     if conv_cheetah_full(i,i)>conv_grass_full(i,i)
         ratio(1,i)=conv_cheetah_full(i,i)/conv_grass_full(i,i);
     else
         ratio(1,i)=conv_grass_full(i,i)/conv_cheetah_full(i,i);
    
     end
end

ratio(1)=1000;
[A,B]=sort(ratio);

bestindex=B(57:64);
worstindex=B(1:8);

figure(5)

for i=1:8
subplot(3,3,i)
plot(cheetah_prob_index(bestindex(i),1:cheetah_bin),cheetah_prob_counts(bestindex(i),:),'red')
hold on
plot(grass_prob_index(bestindex(i),1:grass_bin),grass_prob_counts(bestindex(i),:),'green')

t_title=strcat('feature  ',int2str(bestindex(i)));
title(t_title);

end
legend('chetah','grass');

figure(6)

for i=1:8
subplot(3,3,i)
plot(cheetah_prob_index(worstindex(i),1:cheetah_bin),cheetah_prob_counts(worstindex(i),:),'red')
hold on
plot(grass_prob_index(worstindex(i),1:grass_bin),grass_prob_counts(worstindex(i),:),'green')

t_title=strcat('feature  ',int2str(worstindex(i)));
title(t_title);

end
legend('chetah','grass');


%% image dst 
x=imread('cheetah.bmp');
[rows_img,cols_img]=size(x);
img=padImage(x);

dst_full=zeros(rows_img, cols_img);
tmp=zeros(8,8);
dsttmp=zeros(8,8);
tmpVec=zeros(1,64);

for i=1:rows_img
    for j=1:cols_img
        tmp=img(i:i+7,j:j+7)/255.0;
        dsttmp=dct2(tmp);
        tmpVec=zigzag(dsttmp);
        p1=getGaussianProb(mean_cheetah_full,conv_cheetah_full,tmpVec,det_cheetah_full,inv_cheetah_full)*cheetah_prob;
        p2=getGaussianProb(mean_grass_full,conv_grass_full,tmpVec,det_grass_full,inv_grass_full)*grass_prob;
        if p1>p2
            dst_full(i,j)=1;
        end
    end
end

figure(2);
imshow(uint8(dst_full*255));

%% this part for 8 best;
sel_num=8;
%index=[ 64    63    59     3     5    62     4    60];  %this one is 0.8264
 index=[1 41    18    33    40    25    27    32]; %this index is 0.9342;
%index=[19    41    18    33    40    25    27    32];  %this index is
%0.8917
sel_grass=zeros(rows_grass,sel_num);
sel_cheetah=zeros(rows_cheetah,sel_num);
for i=1:sel_num
    sel_grass(:,i)=TrainsampleDCT_BG(:,index(i));
    sel_cheetah(:,i)=TrainsampleDCT_FG(:,index(i));
end

mean_cheetah_sel=mean(sel_cheetah);
mean_grass_sel=mean(sel_grass);

conv_cheetah_sel=cov(sel_cheetah);
conv_grass_sel=cov(sel_grass);

det_grass_sel=det(conv_grass_sel);
det_cheetah_sel=det(conv_cheetah_sel);

inv_grass_sel=inv(conv_grass_sel);
inv_cheetah_sel=inv(conv_cheetah_sel);

dst_sel=zeros(rows_img, cols_img);
tmp=zeros(8,8);
dsttmp=zeros(8,8);
tmpVec=zeros(1,64);
selVec=zeros(1,sel_num);

for i=1:rows_img
    for j=1:cols_img
        tmp=img(i:i+7,j:j+7)/255.0;
        dsttmp=dct2(tmp);
        tmpVec=zigzag(dsttmp);
        for pp=1:sel_num
            selVec(pp)=tmpVec(index(pp));
        end
        p1=getGaussianProb(mean_cheetah_sel,conv_cheetah_sel,selVec,det_cheetah_sel,inv_cheetah_sel)*cheetah_prob;
        p2=getGaussianProb(mean_grass_sel,conv_grass_sel,selVec,det_grass_sel,inv_grass_sel)*grass_prob;
        if p1>p2
            dst_sel(i,j)=1;
        end
    end
end

figure(3)
imshow(uint8(dst_sel*255));







%% this part for calculation error;
truth=imread('cheetah_mask.bmp');
seg1=uint8(dst_full)*255;

muFore=zeros(1,64);
muFore(1,:,:)=mean_cheetah_full;
sigmaFore=zeros(1,64,64);
sigmaFore(1,:,:)=conv_cheetah_full;
phiFore=1;


muBack=zeros(1,64);
muBack(1,:,:)=mean_grass_full;
sigmaBack=zeros(1,64,64);
sigmaBack(1,:,:)=conv_grass_full;
phiBack=1;


result =q5_GetAccuracy(x,truth,grass_prob, cheetah_prob, muFore,sigmaFore, phiFore,muBack,sigmaBack,phiBack)

tmp=0;
for i=1: rows_img
    for j= 1:cols_img
        if seg1(i,j)==truth(i,j)
            tmp=tmp+1;
        end
    end
end

correctRate_full=tmp*1.0/(rows_img*cols_img)

seg2=uint8(dst_sel)*255;
tmp=0;
for i=1: rows_img
    for j= 1:cols_img
        if seg2(i,j)==truth(i,j)
            tmp=tmp+1;
        end
    end
end

correctRate_sel=tmp*1.0/(rows_img*cols_img)




        
    