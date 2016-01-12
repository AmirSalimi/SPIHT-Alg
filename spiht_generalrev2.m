
 clc
 clear all;
% close all;



%1)"pixno"==image size for our case you can set 512*512
%2)"a' == the input image here I have tryed with some matrix to evaluate the
%ans, therefore just put a = what you have for image :lena,....
%3"itno"== Number of itterations so put it  same as the one for ezw
%pixno=64

%a=[26 6 13 10;-7 7 6 4;4 -4 4 -3 ;2 -2 -2 0]
% a=[63 -34 49 10 7 13 -12 7;-31 23 14 -13 3 4 6 -1; ...
%     15 14 3 -12 5 -7 3 9; -9 -7 -14 8 4 -2 3 2; -5 9 -1 47 4 6 -2 2 ;...
%     3 0 -3 2 3 -2 0 4 ; 2 -3 6 -4 3 6 3 6;5 11 5 6 0 3 -4 4] 

load lena_512x512
test_image = double(lena_512x512(:,:,1));

[ll1 lu1 ul1 uu1] = dwt2(test_image, 'db1');
[ll2 lu2 ul2 uu2] = dwt2(ll1, 'db1');
[ll3 lu3 ul3 uu3] = dwt2(ll2, 'db1');
[ll4 lu4 ul4 uu4] = dwt2(ll3, 'db1');
[ll5 lu5 ul5 uu5] = dwt2(ll4, 'db1');
[ll6 lu6 ul6 uu6] = dwt2(ll5, 'db1');
[ll7 lu7 ul7 uu7] = dwt2(ll6, 'db1');
[ll8 lu8 ul8 uu8] = dwt2(ll7, 'db1');
[ll9 lu9 ul9 uu9] = dwt2(ll8, 'db1');

%'put together' matrix

a = [[[[[[[[[ll9 lu9; ul9 uu9] lu8; ul8 uu8] lu7; ul7 uu7] lu6;...
    ul6 uu6] lu5; ul5 uu5] lu4; ul4 uu4] lu3; ul3 uu3] lu2; ul2 uu2] ...
    lu1; ul1 uu1];


[imagex imagey] = size(a);
pixno=imagex * imagey;


%Number of iterations
itno=15;

% a=[63 -34 49 10 7 13 -12 7;-31 23 14 -13 3 4 6 -1; ...
%     15 14 3 -12 5 -7 3 9; -9 -7 -14 8 4 -2 3 2; -5 9 -1 47 4 6 -2 2 ;...
%     3 0 -3 2 3 -2 0 4 ; 2 -3 6 -4 3 6 3 6;5 11 5 6 0 3 -4 4] 

LIS=[];

%construct LIP and LIS at initialization phase
LIP=[a(1:2,1);a(1:2,2)]
cellimage=mat2cell(a,2*ones(1,imagex/2),ones(imagey/2,1)*2);
% for co=1:imagex/2
%     for co2=1:imagey/2
%         if (co>1) | (co2>1)
%             LIS=[LIS;cellimage{co,co2}]
%         end
%         
%         
%     end
% end

%At first, (1,1) is the only biggest amoount

observmx=zeros(size(a));


 prelis=mat2cell(a,2.*ones(imagex/2,1),2.*ones(imagey/2,1));
 observmxcell=  mat2cell(observmx,2.*ones(imagex/2,1),2.*ones(imagey/2,1));             
  observmxcell{1,1}=[1 1 ;1 1];            
%LIS=[a(1:2,3:8);a(3:8,:)
LIStest=LIS

LSP=[]
   mm=[] 
   ml=[]
t0=2^floor((log2(max(max((a))))));

%Number of initial bits
Nobits=0;
lsp=0;
Ltypelis=0;
for i=1:itno

         comp1=abs(LIP)>=t0;
% 
%         comp2=abs(LIS)>=t0
%         [m n]=size(LIS)
% 
%             C=mat2cell(comp2,2.*ones(m/2,1),2)
%             C2=mat2cell(LIS,2.*ones(m/2,1),2)
             LIS=[];
            
%comp2=abs(prelis)>=t0
             %%%forming LIS
               Comp2=mat2cell(abs(a)>=t0,2.*ones(imagex/2,1),2.*ones(imagey/2,1));
              
                    for count=imagex/2:-1:1
                         for count2=imagey/2:-1:1
                            if sum(sum(Comp2{count,count2}))==0 && sum(sum(observmxcell{count,count2}))==0;

                              LIS=[cellimage{count,count2};LIS];
                            elseif sum(sum(Comp2{count,count2}.*(1-observmxcell{count,count2})))>0;
                                
                            mm=cellimage{count,count2};
                            
                            observmxcell{count,count2}=[1 1 ; 1 1];
                                if observmxcell{round(count/2),round(count2/2)}~=[1 1 ; 1 1];
                                    ml=cellimage{round(count/2),round(count2/2)};
                                     observmxcell{round(count/2),round(count2/2)}=[1 1 ; 1 1];
                                     Ltypelis=Ltypelis+4;
                                end
                            end 

                                LIP=[LIP(find(abs(LIP)<t0));mm(find(abs(mm)<t0));ml(find(abs(ml)>=0))];
                                     mm=[];
                                     ml=[];

                                 [lip qq]=size(LIP);
                                 [lipsg qw]=size(LIP(find(abs(LIP)<t0)));
                                 [lis qw1]=size(LIS);
                                 [lissg qw2]=size(LIS(find(abs(LIS)<t0)));
                        %%%we just need the size of lsp 
                                % Cardinality of LSP in Previous step
                                
                         end
                    end
            
                                lspprev=lsp;
                                lsp=pixno-lip-lis*qw1;
                                lis256=floor(lissg/(256^2));
                                lis64=floor((lissg-lis256*256^2)/(64^2));
                                lis16=floor((lissg-lis256*256^2-lis64*64^2)/(16^2));
                                lis4=floor((lissg-lis256*256^2-lis64*64^2-lis16*16^2)/(4^2));
                                lis2=floor((lissg-lis256*256^2-lis64*64^2-lis16*16^2-lis4*4^2)/4);
                                i 
                                Nobits=(lsp-lspprev)*2+lipsg+Ltypelis+lis256+lis64+lis16+lis4+lis2+lspprev+Nobits
           
            
            
%             for k=1:m/2
%                 
%             if sum(sum(C{k}))==0
% 
%                 
%         LIS=[LIS;C2{k}]
%             elseif sum(sum(C{k}))>0
%                 mm=C2{k}
% 
%             end

                       
          %  end
            t0=t0/2;
end
