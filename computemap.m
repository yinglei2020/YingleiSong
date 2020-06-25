%the function that implements the dynamic programming approach for
%determining the mapping needed for enhancement.
%map: the resulting map needed for enhancement.
%coef: the coeficient for the objective function that needs to be
%maximized.
%cfg: the flag array that indicate the status of grey values in the image.
%nxt: the array that stores the next array needed for dynamic programming.
function map=computemap(coef, cfg, nxt, beta,ws)
%Initialize the 256*256 dynamic programming table to be all zeros.
rg=2*ws+1;
for i=1:256
    ppv(i)=0; %the array that stores the order for trace back.
    map(i)=0; %the array that stores the mapping result.
    for j=1:rg
        M(i, j)=0.0; %the dynamic programming table for mapping.
        Tr(i, j)=0;   %the trace back table for dynamic programming.
    end
end

cur=nxt(1);
ppv(cur)=-1; %cur is the first one in the current order and is the last one
            %in the order of traceback.

%Initialize the base values needed for dynamic programming.
for j=1:rg
    nv=j-1-ws+cur;
    %check if the nv is within the allowed boundaries or not.
    if nv<0
        nv=0;
    elseif nv>255
        nv=255;
    end
    
    val=coef(cur)*(log(double(nv+1))^beta);
    if j==1
       M(cur, j)=val;
       maxv=M(cur, j);
       Tr(cur, j)=j;
       maxid=j;
    elseif maxv<val
       maxv=val;
       M(cur, j)=maxv;
       Tr(cur, j)=j;
       maxid=j;
    else
       M(cur, j)=maxv;
       Tr(cur, j)=maxid; 
    end
end
    
%Start the dynamic programming procedure.
%st=1;
while nxt(cur)>0
    prv=cur;
    cur=nxt(cur);
    ppv(cur)=prv;  %set the value for the one before cur.
    for j=1:rg
        nv=j-1-ws+cur;
        
            %check if the nv is within the allowed boundaries or not.
        if nv<0
          nv=0;
        elseif nv>255
          nv=255;
        end
        %compute the distance from the previous image.
        pdis=nv-1-prv;
        %obtain the integer index to work with for dynamic programming.
        if pdis>ws
            prvin=rg;
        else
            prvin=pdis+ws+1;
        end
        
        val=M(prv, prvin)+coef(cur)*(log(double(nv+1))^beta);
        %val=M(prv, j)+coef(cur)*(j-1);
        if j==1
           maxv=val;
           M(cur, j)=maxv;
           Tr(cur, j)=j;
           maxid=j;
        elseif maxv<val
            maxv=val;
            M(cur, j)=maxv;
            Tr(cur, j)=j;
            maxid=j;
        else
            M(cur, j)=maxv;
            Tr(cur, j)=maxid;
        end
    end
end

%Now, the dynamic programming procedure is complete, it is the turn to
%determine the mapping that can maximize the objective function from the trace 
%back table.
 edp=rg;
 while ppv(cur)>0
    ned=Tr(cur, edp);
    map(cur)=cur+ned-1-ws;
    %edp=ned;
    prev=ppv(cur);
    edp=map(cur)-prev+ws;
    if edp>rg
       edp=rg;
    end
    cur=ppv(cur);
 end
 %display(M);
end