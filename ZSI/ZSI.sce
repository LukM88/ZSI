//----trzcionka 12
//----algorytm wstecznej propagacji bledu
clc;
/*clear;
adresy=["A.png","B.png","C.png","D.png","E.png","F.png","G.png","H.png","I.png","J.png",...
"K.png","L.png","M.png","N.png","O.png","P.png","R.png","S.png","T.png","U.png","W.png",...
"Y.png","Z.png","am.png","bm.png","cm.png","dm.png","em.png","fm.png","gm.png","hm.png",...
"im.png","jm.png","km.png","lm.png","mm.png","nm.png","om.png","pm.png","rm.png","sm.png",...
"tm.png","um.png","wm.png","ym.png","zm.png"]
w=9;
p=20;
wy=46;
znaki=zeros(15,15,wy);
for m=1:wy
znak=imread(adresy(m))/255;
   a2=zeros(15,15);
    for i=1:15//kolumny
        for j=1:15//rzędy
            a2(j,i)=znak(j,i);
            znaki(j,i,m)=a2(j,i)
        end
    end
end
mat=zeros(9,wy);
mat2=zeros(wy,wy);
for n=1:wy
    mat2(n,n)=1;
end

    for j=1:wy
        i=1;
        for m=1:5:15
            for n=1:5:15
                for x=0:4
                    for y=0:4
                        if znaki(m+x,n+y,j)==0
                            mat(i,j)=mat(i,j)+1
                            end
                    end
                end
                mat(i,j)=mat(i,j)/25
                i=i+1;
            end
        end
    end

//DO TEJ PORY BYŁA OBRÓBKA TRENERÓW
//----wykreslenie obszaru klasyfikacji
Licz=0;
IleKrokow=200;

//----utworzenie odpowiednich tablic na dane

//W1= zeros(w,w+1);//wagi
//W2=zeros(p,w+1);//wagi
//W3=zeros(wy,p+1);//wagi

    W1b=W1
    W2b=W2
    W3b=W3
    W1c=W1b
    W2c=W2b
    W3c=W3b
//----losowa inicjalizacja wag poczatkowych
for n=1:w
    for m=1:w+1
    if(p>=n & w+1>=m )
        W2(i)=rand()-0.5;
    end
    if(wy>=n & p+1>=m)
        W3(n,m)=rand()-0.5;
    end
    
    W1(n,m)=rand()-0.5;
    end
end
ro=0.3;

    

iteracja=0;
//ER=zeros(IleKrokow);
while(iteracja<IleKrokow)
if iteracja>3
    if ER(iteracja)>ER(iteracja-1)
        if ro+0.05<1
        ro=ro+0.05
    elseif  ro-0.05>0
        ro=ro-0.05
        end
    end
end
S1=zeros(1,w);//sumy
S2=zeros(1,p);//sumy
S3=zeros(1,wy);//sumy
U1=zeros(1,w);//wartości F aktywacyjnej
U2=zeros(1,p);
U3=zeros(1,wy);
F1=zeros(1,w);
d1=zeros(1,w);//współczynnik zmiany wagi
F2=zeros(1,p);
d2=zeros(1,p);//współczynnik zmiany wagi
F3=zeros(1,wy);
d3=zeros(1,wy);//współczynnik zmiany wagi
    iteracja=iteracja+1;
    //----losowe wybieranie wektora trenujacego    
    i=round(rand()*(wy-1))+1;//numer od 1 do do wy bo musi być ilość liter
    //----faza propagacji w przod -warstwa posrednia
    for m=1:w
        for n=1:w+1
            if(n>1)
                S1(m)=S1(m)+W1(m,n)*mat(n-1,i);
            else
                S1(m)=S1(m)+W1(m,n)*1;//bo stała 1 w każdym neuronie
            end
        end
        U1(m)=1/(1+exp(-S1(m)));
    end
    //WARSTWA2
    for m=1:p
        for n=1:w+1
            if(n>1)
                 S2(m)=S2(m)+W2(m,n)*U1(n-1);
            else
                S2(m)=S2(m)+W2(m,n)*1;//bo stała 1 w każdym neuronie
            end
            
        end
         U2(m)=1/(1+exp(-S2(m)));
    end
    //WARSTWA3
     for m=1:wy
        for n=1:p+1
            if(n>1)
                 S3(m)=S3(m)+W3(m,n)*U2(n-1);
            else
                S3(m)=S3(m)+W3(m,n)*1;//bo stała 1 w każdym neuronie
            end
        end
        U3(m)=1/(1+exp(-S3(m)));
    end   
    //----faza propagacji w przod -warstwa wyjsciowa

    //----faza propagacji wstecz -warstwa wyjsciowa
    for m=1:wy
        F3(m)=U3(m)*(1-U3(m));
        d3(m)=(mat2(i,m)-U3(m))*F3(m);
    end   
  
 
    
    
    //----faza propagacji wstecz -warstwa posrednia
    
    
    for m=1:p
        F2(m)=U2(m)*(1-U2(m));
        for n=1:wy
            d2(m)=d2(m)+d3(n)*W3(n,m+1);
        end
        d2(m)=d2(m)*F2(m)
    end
    for m=1:w
        F1(m)=U1(m)*(1-U1(m));
        for n=1:p
            d1(m)=d1(m)+d2(n)*W2(n,m+1);
        end
        d1(m)=d1(m)*F1(m)
    end
    //----uaktualnienie wag -warstwa wyjsciowa
    W1b=W1
    W2b=W2
    W3b=W3
    
    for n=1:wy
        for m=1:p+1
            if (m>1)
                W3(n,m)=W3b(n,m)+0.3*(W3b(n,m)-W3c(n,m))+(ro*d3(n)*U2(m-1));
            else
                W3(n,m)=W3b(n,m)+0.3*(W3b(n,m)-W3c(n,m))+(ro*d3(n)*1);
            end
        end
    end
    
    for n=1:p
        for m=1:w+1
            if (m>1)
                W2(n,m)=W2b(n,m)+0.3*(W2b(n,m)-W2c(n,m))+(ro*d2(n)*U1(m-1));
            else
                W2(n,m)=W2b(n,m)+0.3*(W2b(n,m)-W2c(n,m))+(ro*d2(n)*1);
            end
        end
    end
    
    for n=1:w
        for m=1:w+1
            if (m>1)
                W1(n,m)=W1b(n,m)+0.3*(W1b(n,m)-W1c(n,m))+(ro*d1(n)*mat(m-1,i));
            else
                W1(n,m)=W1b(n,m)+0.3*(W1b(n,m)-W1c(n,m))+(ro*d1(n)*1);
            end
            
        end
        
        
    end
    W1c=W1b
    W2c=W2b
    W3c=W3b
       if(modulo(iteracja,1000)==0)
           disp(iteracja)
           ER(iteracja)=mat2(i,i)-U3(i);
       else
           if iteracja<5
               ER(iteracja)=mat2(i,i)-U3(i);
           else
           ER(iteracja)=ER(iteracja-1)
           end
           end
    
end
*/
adresy=["test1.png","test2.png","test3.png","test4.png","E.png","F.png","G.png","H.png","I.png","J.png",...
"K.png","L.png","M.png","N.png","O.png","P.png","R.png","S.png","T.png","U.png","W.png",...
"Y.png","Z.png","am.png","bm.png","cm.png","dm.png","em.png","fm.png","gm.png","hm.png",...
"im.png","jm.png","km.png","lm.png","mm.png","nm.png","om.png","pm.png","rm.png","sm.png",...
"tm.png","um.png","wm.png","ym.png","zm.png"]
znaki=zeros(15,15,wy);
for m=1:wy
znak=imread(adresy(m))/255;
   a2=zeros(15,15);
    for i=1:15//kolumny
        for j=1:15//rzędy
            a2(j,i)=znak(j,i);
            znaki(j,i,m)=a2(j,i)
        end
    end
end
mat=zeros(9,wy);
mat2=zeros(wy,wy);
for n=1:wy
    mat2(n,n)=1;
end

    for j=1:wy
        i=1;
        for m=1:5:15
            for n=1:5:15
                for x=0:4
                    for y=0:4
                        if znaki(m+x,n+y,j)==0
                            mat(i,j)=mat(i,j)+1
                            end
                    end
                end
                mat(i,j)=mat(i,j)/25
                i=i+1;
            end
        end
    end
    znaki=zeros(46,47);
znaki=string(znaki)
    for m=2:47
        znaki(m-1,m)="1"
    end
    
    znaki(1,1)="A";
    znaki(2,1)="B";
    znaki(3,1)="C";
    znaki(4,1)="D";
    znaki(5,1)="E";
    znaki(6,1)="F";
    znaki(7,1)="G";
    znaki(8,1)="H";
    znaki(9,1)="I";
    znaki(10,1)="J";
    znaki(11,1)="K";
    znaki(12,1)="L";
    znaki(13,1)="M";
    znaki(14,1)="N";
    znaki(15,1)="O";
    znaki(16,1)="P";
    znaki(17,1)="R";
    znaki(18,1)="S";
    znaki(19,1)="T";
    znaki(20,1)="U";
    znaki(21,1)="W";
    znaki(22,1)="Y";
    znaki(23,1)="Z";
    znaki(24,1)="a";
    znaki(25,1)="b";
    znaki(26,1)="c";
    znaki(27,1)="d";
    znaki(28,1)="e";
    znaki(29,1)="f";
    znaki(30,1)="g";
    znaki(31,1)="h";
    znaki(32,1)="i";
    znaki(33,1)="j";
    znaki(34,1)="k";
    znaki(35,1)="l";
    znaki(36,1)="m";
    znaki(37,1)="n";
    znaki(38,1)="o";
    znaki(39,1)="p";
    znaki(40,1)="r";
    znaki(41,1)="s";
    znaki(42,1)="t";
    znaki(43,1)="u";
    znaki(44,1)="w";
    znaki(45,1)="y";
    znaki(46,1)="z";

    
for q=1:wy
i=q;
S1=zeros(1,w);//sumy
S2=zeros(1,p);//sumy
S3=zeros(1,wy);//sumy
U1=zeros(1,w);//wartości F aktywacyjnej
U2=zeros(1,p);
U3=zeros(1,wy);

    for m=1:w
        for n=1:w+1
            if(n>1)
                S1(m)=S1(m)+W1(m,n)*mat(n-1,i);
            else
                S1(m)=S1(m)+W1(m,n)*1;//bo stała 1 w każdym neuronie
            end
        end
        U1(m)=1/(1+exp(-S1(m)));
    end
    //WARSTWA2
    for m=1:p
        for n=1:w+1
            if(n>1)
                 S2(m)=S2(m)+W2(m,n)*U1(n-1);
            else
                S2(m)=S2(m)+W2(m,n)*1;//bo stała 1 w każdym neuronie
            end
            
        end
         U2(m)=1/(1+exp(-S2(m)));
    end
    //WARSTWA3
     for m=1:wy
        for n=1:p+1
            if(n>1)
                 S3(m)=S3(m)+W3(m,n)*U2(n-1);
            else
                S3(m)=S3(m)+W3(m,n)*1;//bo stała 1 w każdym neuronie
            end
        end
        U3(m)=1/(1+exp(-S3(m)));
    end  
    temp=max(U3)
    for n=1:length(U3)
        
        if U3(n)<temp
            U3(n)=0;
        else
            U3(n)=1;
        end
        
    end
    for k=1:46
        if znaki(k,2:47)==string(U3)
        disp(znaki(k,1));
        end
    end
    plot(ER)
end


