
 close all
 clc
 clear

 x=imread('cheetah.bmp');
 
 [rows,cols]=size(x);
 figure(1)
 imshow(x)

 img=cropImage(x,8);
 figure(2)
 imshow(uint8(img))
 [m,n]=size(img)
 dst=dct2Image(img,8);
 
[prob_F,prob_G,prob_F_Cond,prob_G_cond]=get_probability()

figure(3)
plot(prob_F_Cond)
hold on
plot(prob_G_cond)


final_result=zeros(m/8, n/8);
for i=1:m/8
    for j=1:n/8
        cheet=prob_F*prob_F_Cond(dst(i,j));
        grass=prob_G*prob_G_cond(dst(i,j));
        if cheet>grass
            final_result(i,j)=1;
        end
    end
end
figure(4)
imshow( uint8(final_result*255))

%%% insert to a final image;

stride=8;
segResult=zeros(rows,cols);
for i=1:rows
    for j=1:cols
        segResult(i,j)=final_result(floor(i/stride)+1,floor(j/stride)+1);
    end
end

figure (5)
imshow(uint8(segResult)*255)

figure(6)
truth=imread('cheetah_mask.bmp');
imshow(truth);

seg=uint8(segResult)*255;


%% calculate error
tmp=0;
for i=1: rows
    for j= 1:cols
        if seg(i,j)==truth(i,j)
            tmp=tmp+1;
        end
    end
end

correctRate=tmp*1.0/(rows*cols)



