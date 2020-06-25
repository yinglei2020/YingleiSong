%The function is responsible for the computation of the coeficients in the
%objective function that needs to be opimized for enhancement.
function [coef,cfg, nxt]=computeobject(image, height,length)
%image: the filename of the image file.
%heigth: the height of the image.
%length: the length of the image.
%alpha: the value of the parameter used to obtain the coeficients of the 
%coef: the array that contains the coeficients of the objective function.
%cfg: the array that stores the status of each pixel intensity value.
%nxt: the array that stores the next pixel value in dynamic programming.
%image=imread(filename);
%[m,n]=size(image);
m=height;
n=length;

%Now, start computing the vertical and horizontal gradients
maxhg=0.0;
maxhv=0.0;
for i=1:256
    cfg(i)=0;
    hist(i)=0;
end
for i=1:m
    for j=1:n
        %set the position in the array for status to be 1.
        pst=image(i,j)+1;
        cfg(pst)=1;
        hist(pst)=hist(pst)+1;
    end
end
%Now, compute the coefficients associated with each pixel intensity value
%from 0 to 255.
%Initialize the coeficients to be all zeros.
for i=1:256
    coef(i)=0.0;
    nxt(i)=0;
end     

%find the first grey value that needs to be mapped.
for i=1:256
    if cfg(i)==1
        fst=i;
        break;
    end
end

%determine the array nxt for the dynamic programming.
prev=fst;
nxt(1)=fst;
for i=fst+1:256
    if cfg(i)==1
        nxt(prev)=i;
        prev=i;
    end
end
%The end of the sequence.
nxt(prev)=-1;
%display(coef);
%display(nxt);
%now, determine the coeficient of dynamic programming.
cur=nxt(1);
N=m*n;
while nxt(cur)>0
    prev=cur;
    cur=nxt(cur);
    ratio=double(hist(prev)+hist(cur))/double(2*N);
    coef(cur)=ratio;
end
end

             
                
        