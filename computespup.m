%the function that implements the dynamic programming approach for
%determining the mapping needed for enhancement.
%map: the resulting map needed for enhancement.
%coef: the coeficient for the objective function that needs to be
%maximized.
%cfg: the flag array that indicate the status of grey values in the image.
%nxt: the array that stores the next array needed for dynamic programming.
%beta: the parameter utilized in the objective function for optimization.
%ws: the window size needed for dynamic programming.
function map=computespup(coef, cfg, nxt, beta)
%Initialize the 256*256 dynamic programming table to be all zeros.
for i=1:256
    ppv(i)=0; %the array that stores the order for trace back.
    map(i)=0; %the array that stores the mapping result.
    for j=1:256
        M(i, j)=0.0; %the dynamic programming table for mapping.
        Tr(i, j)=0;   %the trace back table for dynamic programming.
    end
end

cur=nxt(1);
ppv(cur)=-1; %cur is the first one in the current order and is the last one
            %in the order of traceback.

%Initialize the base values needed for dynamic programming.
    
%Start the dynamic programming procedure.
%st=1;
while nxt(cur)>0
    prv=cur;
    cur=nxt(cur);
    ppv(cur)=prv;  %set the value for the one before cur.
    popt=1;
    for j=1:256
        for k=popt:j
           val=M(prv, k)+coef(cur)*((double(j-k)/double(cur-prv))^beta);
           %val=M(prv, j)+coef(cur)*(j-1);
           if k==popt
              maxv=val;
              maxid=k;
           elseif maxv<val
              maxv=val;
              maxid=k;
           end
           if k>popt
               if val<pval
                   break; %break out of the loop if val starts to go down.
               end
           end
           pval=val;
        end
        M(cur, j)=maxv;
        Tr(cur, j)=maxid;
        popt=maxid;
    end
end

%Now, the dynamic programming procedure is complete, it is the turn to
%determine the mapping that can maximize the objective function from the trace 
%back table.
 edp=256;
 while ppv(cur)>0
    map(cur)=edp;
    edp=Tr(cur, edp);
    cur=ppv(cur);
 end
 
 map(cur)=1;
 %display(M);
end