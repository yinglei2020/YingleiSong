clear all;
image = imread('brain.jpg');
%image=rgb2gray(oimage); 
imwrite(image, 'obrain.jpg');
B=size(image); %testing whether the image is a gray-scale image or a colored image.
choice=1; %use the speedup option if choice=1, otherwise not.
C=size(B);
if C(2)==2
    %if the tested image is a gray scale image.
   [m,n]=size(image);
   %M=m*n;
   figure
   imshow(image);
   beta=0.5;
   %Apply histogram equalization for enhancement. 
   ehiseq=histequal(image, m, n);
   figure
   imshow(ehiseq, []);
   [coef, cfg, nxt]=computeobject(image,m,n);
   %Apply the dynamic programming algorithm to maximize the objective.
   mp=computemapback(coef, cfg, nxt, beta);
   %display(mp);
   %Use the obtained mapping to enhance the image.
   eimg=enhanceimage(mp, image, m, n);
   %display(eimg);
   figure
   imshow(eimg, []);
else
    %Otherwise, the tested image is a colored image.
    %convert it from RGB into HSI form.
    %ratio=1.5;
    %nimage=dampimage(image, B(1), B(2), ratio);
    %imwrite(nimage/256, 'ex24.jpg');
    hsiimg=rgb2hsi(image); 
    %perform the dynamic programming on I component only.
    figure
    imshow(image);
    
    
    m=B(1);
    n=B(2);
    beta=0.3;
    for i=1:m
        for j=1:n
            iimg(i,j)=floor(hsiimg(i,j,3)*255.0);
        end
    end
    
    %Apply histogram equalization for enhancement. 
    eihiseq=histequal(iimg, m, n);
    for i=1:m
        for j=1:n
            ehseqimg(i, j, 1)=hsiimg(i, j, 1);
            ehseqimg(i, j, 2)=hsiimg(i, j, 2);
            ehseqimg(i, j, 3)=double(eihiseq(i, j))/255.0;
        end
    end
    rgbeqimg=hsi2rgb(ehseqimg);
    figure
    imshow(rgbeqimg);
    imwrite(rgbeqimg, 'brainhst.jpg');
    %To determine the objective that needs to be optimized in dp.
    [coef, cfg, nxt]=computeobject(iimg, m, n);
    %Apply the dynamic programming algorithm to maximize the objective.
    if choice==0
       mp=computemapback(coef,cfg, nxt, beta);
    else
       mp=computespup(coef, cfg, nxt, beta);
    end
    %Obtain the enhanced I component.
    eiimg=enhanceimage(mp, iimg, m, n);
    for i=1:m
        for j=1:n
            ehsimg(i, j, 1)=hsiimg(i, j, 1);
            ehsimg(i, j, 2)=hsiimg(i, j, 2);
            ehsimg(i, j, 3)=double(eiimg(i, j))/255.0;
        end
    end
    %Finally, have the HSI form converted back into RGB form
    rgbimg=hsi2rgb(ehsimg);
    figure
    imshow(rgbimg);
    imwrite(rgbimg, 'braindp.jpg');
end
            
    
     
    
    
    
    
