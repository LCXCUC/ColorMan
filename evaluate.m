Root='/home/Downloads/hint/hint200/';
%N=1;
th5=ones(3,200);
th10=ones(3,200);
th15=ones(3,200);
light = ones(3,200);
fid_th5 = fopen(fullfile(Root,'th5.txt'),'w');
fid_th10 = fopen(fullfile(Root,'th10.txt'),'w');
fid_th15 = fopen(fullfile(Root,'th15.txt'),'w');
fid_light = fopen(fullfile(Root,'light.txt'),'w');
for N= 1:200
    N
%res = ones(4,4);

for t=1:3
    th=t*5
original=fullfile(Root,num2str(N),[num2str(N), '_Bw.png']);

 T  = colorLBP( original,th );

 imwrite(T,fullfile(Root,num2str(N),['T_' num2str(th) '.png']));
 
 chainer=fullfile(Root,num2str(N),'ch_hi.png');
 Tch=colorLBP( chainer,th );

 imwrite(Tch,fullfile(Root,num2str(N),['ch_' num2str(th) '.png']));
 
 style=fullfile(Root,num2str(N),'style1.jpg');
 Ts=colorLBP( style,th );

 imwrite(Ts,fullfile(Root,num2str(N),['style_' num2str(th) '.png']));
 
 deep=fullfile(Root,num2str(N),'our.png');
 Tde=colorLBP( deep,th );

 imwrite(Tde,fullfile(Root,num2str(N),['our_' num2str(th) '.png']));
 
 D=sum(sum(abs(T)));
 D=D/262144;

Dch=sum(sum(abs(Tch)));
 Dch=Dch/262144;
 Dch=-(Dch-D);

 Ds=sum(sum(abs(Ts)));
 Ds=Ds/262144;
 Ds=-(Ds-D);

 Dde=sum(sum(abs(Tde)));
 Dde=Dde/262144;
 Dde=-(Dde-D);

 D_p=(D(:,:,1)+D(:,:,2)+D(:,:,3))/3;
 %res(1,t)=D_p;
 Dch_p=(Dch(:,:,1)+Dch(:,:,2)+Dch(:,:,3))/3;
 if t==1
     th5(1,N)=Dch_p;
 elseif t==2
     th10(1,N)=Dch_p;
 else
     th15(1,N)=Dch_p;
 end
 Ds_p=(Ds(:,:,1)+Ds(:,:,2)+Ds(:,:,3))/3;
 if t==1
     th5(2,N)=Ds_p;
 elseif t==2
     th10(2,N)=Ds_p;
 else
     th15(2,N)=Ds_p;
 end
 %res(3,t)=Ds_p;
 Dde_p=(Dde(:,:,1)+Dde(:,:,2)+Dde(:,:,3))/3;
 %res(4,t)=Dde_p;
 if t==1
     th5(3,N)=Dde_p;
 elseif t==2
     th10(3,N)=Dde_p;
 else
     th15(3,N)=Dde_p;
 end
end

original=fullfile(Root,num2str(N),[num2str(N), '_Bw.png']);
original=imread(original);
original2=255-rgb2gray(original);
imwrite(original2,fullfile(Root,num2str(N),['original'  '_light.png']));
chainer=fullfile(Root,num2str(N),'ch_hi.png');
chainer=imread(chainer);
chainer2=255-rgb2gray(chainer);
imwrite(chainer2,fullfile(Root,num2str(N),['ch'  '_light.png']));
style=fullfile(Root,num2str(N),'style1.jpg');
style=imread(style);
style2=255-rgb2gray(style);
imwrite(style2,fullfile(Root,num2str(N),['style'  '_light.png']));
deep=fullfile(Root,num2str(N),'our.png');
deep=imread(deep);
deep2=255-rgb2gray(deep);
imwrite(deep2,fullfile(Root,num2str(N),['our'  '_light.png']));
Dg=sum(sum(abs(original2)));
 Dg=Dg/2621440;
 %res(1,4)=Dg;
 %light(1,N)=Dde_p;
Dchg=sum(sum(abs(chainer2)));
 Dchg=Dchg/2621440;
 Dchg=(Dchg-Dg);
 %res(2,4)=Dchg;
 light(1,N)=Dchg;
 Dsg=sum(sum(abs(style2)));
 Dsg=Dsg/2621440;
 Dsg=(Dsg-Dg);
 %res(3,4)=Dsg;
 light(2,N)=Dsg;
 Ddeg=sum(sum(abs(deep2)));
 Ddeg=Ddeg/2621440;
 Ddeg=(Ddeg-Dg);
 %res(4,4)=Ddeg;
 light(3,N)=Ddeg;

end
%s_th5=s_th
 for m = 1:3
     for n = 1:200
         if n==200
             fprintf(fid_th5,'%f\n',th5(m,n));
         else
             fprintf(fid_th5,'%f\t',th5(m,n));
         end
     end
 end
 fclose(fid_th5);
  for m = 1:3
     for n = 1:200
         if n==200
             fprintf(fid_th10,'%f\n',th10(m,n));
         else
             fprintf(fid_th10,'%f\t',th10(m,n));
         end
     end
 end
 fclose(fid_th10);
  for m = 1:3
     for n = 1:200
         if n==200
             fprintf(fid_th15,'%f\n',th15(m,n));
         else
             fprintf(fid_th15,'%f\t',th15(m,n));
         end
     end
 end
 fclose(fid_th15);
 
  for m = 1:3
     for n = 1:200
         if n==200
             fprintf(fid_light,'%f\n',light(m,n));
         else
             fprintf(fid_light,'%f\t',light(m,n));
         end
     end
 end
 fclose(fid_light);
     
