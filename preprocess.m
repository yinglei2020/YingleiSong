function nimage=preprocess(dimage, height, length)
     s1=2.5;
     s2=0.5;
     [nimage1,ent1]=newfunc(dimage, height, length, s1);
     [nimage2, ent2]=newfunc(dimage, height, length, s2);
     display(ent1);
     display(ent2);
     if ent1>ent2
         nimage=nimage1;
     else
         nimage=nimage2;
     end
end