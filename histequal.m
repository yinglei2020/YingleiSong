%This function implements the histogram equalization method for
%enhancement.
%image: the grey scale image provided as input.
%height: height of the image.
%length: length of the image.
function ehim=histequal(image, height, length)

N=height*length; %total number of pixels in the image.
for i=1:256
    hist(i)=0;
    accu(i)=0.0;
end
%compute the histogram of intensities in the image.
for i=1:height
    for j=1:length
        pst=image(i,j)+1;
        hist(pst)=hist(pst)+1;
        ehim(i,j)=0;
    end
end
%compute the accumulated histogram in the image.
for i=1:256
    sum=0.0;
    for j=1:i
        sum=sum+double(hist(j))/double(N);
    end
    accu(i)=sum;
end

%compute the mapping from the histogram
L=256;
for i=1:256
    mapping(i)=floor(accu(i)*double(L-1)+0.5);
end

for i=1:height
    for j=1:length
        pst=image(i, j)+1;
        ehim(i,j)=mapping(pst);
    end
end
end
    
        
        
    