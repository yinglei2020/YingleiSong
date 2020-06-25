clear all;
filename1='testdata/testdp40.txt';
%Read in the results for dynamic programming.
fid=fopen(filename1, 'r'); %open the file for reading.
str1=fscanf(fid, '%s', 5);
str2=fscanf(fid, '%s', 7);
ind=1;
for i=1:18
   line2=fscanf(fid, '%s', 4);
   line3=fscanf(fid, '%f', 11);
   for j=1:11
      dp(ind)=line3(j);
      ind=ind+1;
   end
end
line2=fscanf(fid, '%s', 4);
line4=fscanf(fid, '%f', 2);
dp(199)=line4(1);
dp(200)=line4(2);
fclose(fid);
%display(dp);
for i=1:30
    distdp(i)=0;
end

for i=1:200
    ind=floor(dp(i));
    distdp(ind+1)=distdp(ind+1)+1;
end
    
filename2='testdata/testhisteq40.txt';
%Read in the results for histogram equalization.
fid=fopen(filename2, 'r'); %open the file for reading.
str1=fscanf(fid, '%s', 7);
ind=1;
for i=1:18
   line2=fscanf(fid, '%s', 4);
   line3=fscanf(fid, '%f', 11);
   for j=1:11
      hist(ind)=line3(j);
      ind=ind+1;
   end
end
line2=fscanf(fid, '%s', 4);
line4=fscanf(fid, '%f', 2);
hist(199)=line4(1);
hist(200)=line4(2);
fclose(fid);
display(hist);
for i=1:30
    disthist(i)=0;
end

for i=1:200
    ind=floor(hist(i));
    disthist(ind+1)=disthist(ind+1)+1;
end

filename3='testdata/testpso40.txt';
%Read in the results for PSO based method.
fid=fopen(filename3,'r'); %open the file for reading.
str1=fscanf(fid, '%s', 7);
ind=1;
for i=1:40
   line2=fscanf(fid, '%s', 4);
   line3=fscanf(fid, '%f', 5);
   for j=1:5
      pso(ind)=line3(j);
      ind=ind+1;
   end
end
fclose(fid);
%display(pso);
mdp=mean(dp);
stddp=std(dp);
mhist=mean(hist);
stdhist=std(hist);
mpso=mean(pso);
stdpso=std(pso);

for i=1:30
    distpso(i)=0;
end

for i=1:200
    ind=floor(pso(i));
    distpso(ind+1)=distpso(ind+1)+1;
end

%display the result.

display(mdp);
display(stddp);
display(mhist);
display(stdhist);
display(mpso);
display(stdpso);

ohist=0;
opso=0;
oboth=0;

for i=1:200
    if dp(i)>hist(i)
        ohist=ohist+1;
        if dp(i)>pso(i)
            oboth=oboth+1;
        end
    end
    if dp(i)>pso(i)
        opso=opso+1;
    end
end

display(ohist);
display(opso);
display(oboth);
display(distdp);
display(disthist);
display(distpso);
 



