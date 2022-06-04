function L=getLoss(x, mu,sigma, phi,h)
   L=0;
   [sample_num, feature_num]=size(x);
   [tmp,mixNum]=size(phi);
   for i=1:sample_num
       for j=1:mixNum
           tmpmu=mu(j,:);
           tmpsigma=reshape(sigma(j,:,:),[feature_num,feature_num]);
           tinv=tmpsigma;
           dett=1;
           for k=1:feature_num
               tinv(k,k)=1/tmpsigma(k,k);
               dett=dett*tmpsigma(k,k);
           end
           L=L+0.5*h(i,j)*((x(i,:)-tmpmu)*tinv*(x(i,:)-tmpmu)')+0.5*h(i,j)*log(dett)-h(i,j)*log(phi(j)+0.00000001);
           
       end
   end
end