function p=getGaussianProb(mu,sigma, x,detSig,invSig)
[m,n]=size(sigma);
dimension=m;
mu1=reshape(mu,[1,m]);
p=1/(sqrt((2*pi)^dimension*abs(detSig)))*exp(-0.5*(x-mu1)*invSig*(x-mu1)');

end