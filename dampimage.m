function dimage=dampimage(image, height, length, ratio)
    for i=1:height
        for j=1:length
            for k=1:3
               dimage(i,j,k)=floor(double(image(i,j,k))/ratio);
            end
        end
    end
end