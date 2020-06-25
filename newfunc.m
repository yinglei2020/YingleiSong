function [nimage, tent]=newfunc(image, height, length, s)
     maxv=image(1, 1);
     nimage=image;
     minv=image(1, 1);
     for i=1:height
         for j=1:length
             if image(i, j)>maxv
                 maxv=image(i, j);
             end
             if image(i, j)<minv
                 minv=image(i, j);
             end           
         end
     end
     
     for i=1:height
         for j=1:length
             nimage(i, j)=image(i, j)^s;
         end
     end
     
     mmax=255.0/256.0;
     mmin=0.0;
     
     for i=1:256
         count(i)=0;
     end
     
     for i=1:height
         for j=1:length
             nimage(i, j)=((mmax-mmin)/(maxv^s-minv^s))*(nimage(i, j)-minv^s)+mmin;
             ind=floor(nimage(i, j)*256.0)+1;
             count(ind)=count(ind)+1;
         end
     end
     tent=0.0;
     mcount=0;
     for i=1:256
         if count(i)>0
             prob=double(count(i))/double(height*length);
             tent=tent-prob*log2(prob);
             if count(i)>mcount
                 mcount=count(i);
             end
         end
     end
     display(mcount);
end
     
             