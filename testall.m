clear all;
imgdir='testdata/train'; %the directory that holds all images that need to be tested.
allfiles=dir(imgdir); %obtain the list of all files in the directory.
nofiles=length(allfiles); %the number of files under the directory.
choice=0; %choice=1, choose the histgram equalization, otherwise the dynamic programming method is chosen.
spornot=1; %spornot=1, choose to use the speed up option for dynamic programming, otherwise do not choose it (only for nonconvex functions).
tic;
for ind=3:nofiles
    imgfile=allfiles(ind).name; %the string that contains the file name.
    imgfullname=sprintf('%s/%s',imgdir, imgfile);
    clear image;
    clear ohsiimg;
    clear dimg;
    clear hsiimg;
    clear immg;
    clear ehseqimg;
    clear rgbeqimg;
    clear mp;
    clear eiimg;
    clear ehsiimg;
    clear rgbimg;
    image=imread(imgfullname);
    %perform the dynamic programming on I component only.
    %figure
    %imshow(image);
    B=size(image); %obtain the size of the image. 
    m=B(1);
    n=B(2);
    ratio=2.5;
    ohsiimg=rgb2hsi(image); %obtain the original image.
    dimg=dampimage(image, m, n, ratio);
    imwrite(dimg/256, 'inter.jpg');
    dimg=imread('inter.jpg');
    hsiimg=rgb2hsi(dimg); 
    beta=0.05;
    for i=1:m
        for j=1:n
            iimg(i,j)=floor(hsiimg(i,j,3)*255.0);
        end
    end
    
    %Apply histogram equalization for enhancement. 
    if choice==1
       eihiseq=histequal(iimg, m, n);
       for i=1:m
         for j=1:n
            ehseqimg(i, j, 1)=hsiimg(i, j, 1);
            ehseqimg(i, j, 2)=hsiimg(i, j, 2);
            ehseqimg(i, j, 3)=double(eihiseq(i, j))/255.0;
         end
       end
       rgbeqimg=hsi2rgb(ehseqimg);
       %figure
       %imshow(rgbeqimg);
       diff1=0.0;
       for i=1:m
          for j=1:n
            diff1=diff1+(ohsiimg(i,j,3)-ehseqimg(i,j,3))^2;
          end
       end
       if diff1>0.0
         psnr1(ind-2)=10.0*(log10(double(m*n)/double(diff1)));
       end
    else
       %To determine the objective that needs to be optimized in dp.
       [coef, cfg, nxt]=computeobject(iimg, m, n);
       %Apply the dynamic programming algorithm to maximize the objective.
       
       if spornot==1
          mp=computespup(coef,cfg,nxt,beta);
       else
          mp=computemapback(coef,cfg, nxt, beta);
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
       %figure
       %imshow(rgbimg);
       diff2=0.0;
       for i=1:m
          for j=1:n
            diff2=diff2+(ehsimg(i,j,3)-ohsiimg(i,j,3))^2;
          end
       end
       if diff2>0.0
          psnr2(ind-2)=10.0*(log10(double(m*n)/double(diff2)));
       end
    end
end
toc;
if choice==1
   display(psnr1);
else
   display(psnr2);
end
    
        
    