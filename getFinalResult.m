close all

load dP1
load dP2
load feature
truth=imread('cheetah_mask.bmp');
load FinRes
%feature=getFeature(src);

[rows,cols]=size(truth);
result=zeros(11,25);

load result
for i=1:11
    for j=1:5
        for k=1:5
           P1=reshape(dP1(i,j,:,:),[rows,cols]);
           P2=reshape(dP2(i,j,:,:),[rows,cols]);
          % result(i,((j-1)*5+k))=getResByP(P1,P2,truth);
        end
    end
end

%save result
index=[1,2,4,8,16,24,32,40,48,56,64]; % 11 element
index2=[1,2,4,8,16,32];

figure (1)

for i=1:5
    for j=1:5
    subplot(2,3,j) 
    plot(index,1-result(:,(i-1)*5+j)');
    title('5 curve');
    xlabel('dimension');
    ylabel('accuracy');
    hold on 
    end
    
end


figure(2)

for i=1:6
    plot(index,1-FinRes(:,i)');
    hold on
end
title('different MixNum');
xlabel('dimension');
ylabel('accuracy');

legend('Mix 1','Mix 2','Mix 4','Mix 8','Mix 16', 'Mix 32');
            