%map: the mapping needed to enhance the image.
%image: the image before the enhancement.
%img: the image obtained from enhancement.
%height: the height of the image.
%the length of the image.
function img=enhanceimage(map, image, height, length)
  for i=1:height
    for j=1:length
        img(i, j)=0;
    end
  end

  for i=1:height
    for j=1:length
        plv=image(i, j);
        npl=map(plv+1);
        img(i, j)=npl;
    end
  end
end
