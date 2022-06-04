function feature=getFeature(src)
[rows_img, cols_img]=size(src);
 img=padImage(src);
 feature=zeros(rows_img,cols_img,64); 
  for i=1:rows_img
    for j=1:cols_img
        tmp=img(i:i+7,j:j+7)/255.0;
        dsttmp=dct2(tmp);
        tmpVec=zigzag(dsttmp);
        feature(i,j,:)=tmpVec;
    end
  end

end