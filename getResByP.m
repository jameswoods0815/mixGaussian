function result=getResByP(P1,P2,truth)

[rows,cols]=size(P1);
seg=zeros(rows,cols);
for i=1:rows
    for j=1:cols
        if P1(i,j)>P2(i,j)
            seg(i,j)=1;
        end
    end
end

tmp=0;
dst=uint8(seg)*255;
imshow(dst)
for i=1:rows
    for j=1:cols
        if truth(i,j)==dst(i,j)
            tmp=tmp+1;
        end
    end
end
result=tmp*1.0/rows/cols;
end