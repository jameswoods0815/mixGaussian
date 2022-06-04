%phi n*1 vector, for component mixture;
% mu: n*m vector; m is the dimension for input vector; n 
% this function keep first k vaule of src; 
%sigma n *(m*m) matrix, where m is the dimension for select feature vector;
function [result,P1,P2] = q5_GetAccuracy(feature,truth,backPrior, forePrior, muFore,sigmaFore, phiFore,muBack,sigmaBack,phiBack)
  [rows_img, cols_img,f]=size(feature);
  dst_full=zeros(rows_img,cols_img);
  P1=zeros(rows_img,cols_img);
  P2=zeros(rows_img,cols_img);
  
  [mixNum,featureNum]=size(muFore);
  sigmaDetFore=zeros(1,mixNum);
  sigmaInvFore=zeros(mixNum,featureNum, featureNum);
  sigmaDetBack=zeros(1,mixNum);
  sigmaInvBack=zeros(mixNum,featureNum, featureNum);
  
  for i=1:mixNum
      sigmaDetFore(1,i)=det(reshape(sigmaFore(i,:,:),[featureNum,featureNum]));
      sigmaInvFore(i,:,:)=inv(reshape(sigmaFore(i,:,:),[featureNum,featureNum]));
      sigmaDetBack(1,i)=det(reshape(sigmaBack(i,:,:),[featureNum,featureNum]));
      sigmaInvBack(i,:,:)=inv(reshape(sigmaBack(i,:,:),[featureNum,featureNum]));
  end
  
 
  for i=1:rows_img
    for j=1:cols_img
        tmpVecSel=reshape(feature(i,j,1:featureNum),[1,featureNum]);
        p1=0;
        p2=0;
        for k=1:mixNum
            p1=p1+1/sqrt(sigmaDetFore(1,k))*exp(-0.5*(tmpVecSel-muFore(k,:))*reshape(sigmaInvFore(k,:,:),[featureNum,featureNum])*(tmpVecSel-muFore(k,:))')*phiFore(1,k);
            p2=p2+1/sqrt(sigmaDetBack(1,k))*exp(-0.5*(tmpVecSel-muBack(k,:))*reshape(sigmaInvBack(k,:,:),[featureNum,featureNum])*(tmpVecSel-muBack(k,:))')*phiBack(1,k);
     
           % p1=p1+getGaussianProb(muFore(k,:),reshape(sigmaFore(k,:,:),[featureNum,featureNum]),tmpVecSel,sigmaDetFore(1,k),reshape(sigmaInvFore(k,:,:),[featureNum,featureNum]))*phiFore(1,k);
            %p2=p2+getGaussianProb(muBack(k,:),reshape(sigmaBack(k,:,:),[featureNum,featureNum]),tmpVecSel,sigmaDetBack(1,k),reshape(sigmaInvBack(k,:,:),[featureNum,featureNum]))*phiBack(1,k);
        end
        
        if p1*forePrior>p2*backPrior
            dst_full(i,j)=1;
        end
        
        P1(i,j)=p1*forePrior;
        P2(i,j)=p2*backPrior;
    end
  end
  
  seg1=uint8(dst_full)*255;

  imshow(seg1)
tmp=0;
for i=1: rows_img
    for j= 1:cols_img
        if seg1(i,j)==truth(i,j)
            tmp=tmp+1;
        end
    end
end

result=tmp*1.0/(rows_img*cols_img);
end