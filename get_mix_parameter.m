% input the Mix num: 

function [mu, sigma, phi]= get_mix_parameter(x,mixNum)
      [sample_num,featureNum]=size(x);
      muNext=zeros(mixNum,featureNum);
      sigmaNext=zeros(mixNum,featureNum,featureNum);
      phiNext=zeros(1,mixNum);
      
      %% 1-32 muNow and 0.5 -0.25 work
      muNow=rand(mixNum,featureNum)-0.5; 
      sigmaNow=ones(mixNum,featureNum,featureNum)+rand(mixNum,featureNum,featureNum)*0.1-0.05; %0~100
      phiNow=rand(1,mixNum);
     
      for i=1:mixNum
           for j=1:featureNum
               for k=1:featureNum
                   if(j~=k)
                       sigmaNow(i,j,k)=0;
                   else
                       if(sigmaNow(i,j,k)<0.1)
                           sigmaNow(i,j,k)=0.1;
                       end
                   end
               end
           end
      end
      
      tmp=sum(phiNow);
      phiNow=phiNow/tmp;
      
      Lnow=100000;
      Lpre=0;
      
      %loop
   for step=1:30
      % E step step:  get hij;
      h=zeros(sample_num,mixNum);
      tmpGau=zeros(sample_num,mixNum);
      for i=1:sample_num
          for j=1:mixNum
              tmpmu=muNow(j,:);
              tmpsigma=reshape(sigmaNow(j,:,:),[featureNum,featureNum]);
               tinv=tmpsigma;
               dett=1;
                for k=1:featureNum
                    tinv(k,k)=1/tmpsigma(k,k);
                    dett=dett*tmpsigma(k,k);
                end 
              tmpGau(i,j)=exp(-0.5*(x(i,:)-tmpmu)*tinv*(x(i,:)-tmpmu)')/(sqrt((2*pi)^featureNum*abs(dett)))+0.0000000000000000000000000000001;
              
          end
      end
      % get h
      for i=1:sample_num
          for j=1:mixNum
              h(i,j)=tmpGau(i,j)*phiNow(j)/(tmpGau(i,:)*phiNow');
          end
      end
      
      Lnow=getLoss(x,muNow,sigmaNow,phiNow,h);
      if abs(Lnow-Lpre)<1 ||abs(Lnow)<1
          break;
      else
          Lpre=Lnow;
      end
      %M step  get u(n+1), phi (n+1), sigma(n+1)
      % muNext
  
      for j=1:mixNum
          tmp1=0;
          tmp2=0;
        for i=1:sample_num
         tmp1=tmp1+h(i,j)*x(i,:);
         tmp2=tmp2+h(i,j);
        end
        muNext(j,:)=tmp1/(tmp2);
      end
      
      % phi
      for j=1:mixNum
          tmp=0;
          for i=1:sample_num
              tmp=tmp+h(i,j);
          end
          phiNext(j)=tmp/sample_num;
      end
      
      % sigma:
      
     for j=1:mixNum
         tmp1=0;
         tmp2=0;
         for i=1:sample_num
            tmp1=tmp1+h(i,j)*(x(i,:)-muNext(j,:))'* (x(i,:)-muNext(j,:));
            tmp2=tmp2+h(i,j);
         end
         tmp3=tmp1/(tmp2);
         for k=1:featureNum
             for p=1:featureNum
                 if(k~=p)
                     tmp3(k,p)=0;
                 else
                     if tmp3(k,p)<0.001
                         tmp3(k,p)=0.001;
                     end
                 end
             end
         end
         sigmaNext(j,:,:)=tmp3;
     end
     
     muNow=muNext;
     phiNow=phiNext;
     sigmaNow=sigmaNext;
   end

    mu=muNext;
    sigma=sigmaNext;
    phi=phiNext;
end