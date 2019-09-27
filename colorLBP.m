function [ T ] = colorLBP( input,th )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
I = imread(input);%E:\BaiduYunDownload\ai\Bw\Bw1\rgb\19_Bw.png
T=I;

%t0=clock;
[m,n]=size(I);
%figure;
%subplot(1,2,1);
%imshow(I,[]);


for i=2:m-1
    for j=2:size(I,2)-1
        %det=5;
        Rij=I(i,j,1);%ERij[i,j]='000';fprintf('%s',ERij{i,j});
        Gij=I(i,j,2);%EGij='000';
        Bij=I(i,j,3);%EBij='000';
        ERij=[0 0 0];
        if sqrt(double((Rij-I(i,j+1,1))*(Rij-I(i,j+1,1))+(Gij-I(i,j+1,2))*(Gij-I(i,j+1,2))+...
            (Bij-I(i,j+1,3))*(Bij-I(i,j+1,3))))>=th
        %A3= bitget(bin2dec(ERij),3);
        ERij(3)=1;
        end
        if sqrt(double((Rij-I(i-1,j+1,1))*(Rij-I(i-1,j+1,1))+(Gij-I(i-1,j+1,2))*(Gij-I(i-1,j+1,2))+...
            (Bij-I(i-1,j+1,3))*(Bij-I(i-1,j+1,3))))>=th
        %A2=bitget(bin2dec(ERij),2);
        ERij(2)=1;
        end
        if sqrt(double((Rij-I(i-1,j,1))*(Rij-I(i-1,j,1))+(Gij-I(i-1,j,2))*(Gij-I(i-1,j,2))+...
            (Bij-I(i-1,j,3))*(Bij-I(i-1,j,3))))>=th
        %A1=bitget(bin2dec(ERij),1);
         ERij(1)=1;
        end
        SRij=4*ERij(1)+2*ERij(2)+ERij(3);
        T(i,j,1)=256*SRij/8;%fprintf('%d\n',SRij);
        
        EGij=[0 0 0];
        if sqrt(double((Rij-I(i+1,j-1,1))*(Rij-I(i+1,j-1,1))+(Gij-I(i+1,j-1,2))*(Gij-I(i+1,j-1,2))+...
            (Bij-I(i+1,j-1,3))*(Bij-I(i+1,j-1,3))))>=th
        %B3=bitget(bin2dec(EGij),3);
       EGij(3)=1;
        end
        if sqrt(double((Rij-I(i+1,j,1))*(Rij-I(i+1,j,1))+(Gij-I(i+1,j,2))*(Gij-I(i+1,j,2))+...
            (Bij-I(i+1,j,3))*(Bij-I(i+1,j,3))))>=th
        %B2=bitget(bin2dec(EGij),2);
         EGij(2)=1;
        end
        if sqrt(double((Rij-I(i+1,j+1,1))*(Rij-I(i+1,j+1,1))+(Gij-I(i+1,j+1,2))*(Gij-I(i+1,j+1,2))+...
            (Bij-I(i+1,j+1,3))*(Bij-I(i+1,j+1,3))))>=th
        %B1=bitget(bin2dec(EGij),1);
        EGij(1)=1;
        end
        SGij=4*EGij(1)+2*EGij(2)+EGij(3);%fprintf('%d\n',SGij);
        T(i,j,2)=256*SGij/8;
        
        EBij=[0 0 0];
        if sqrt(double((Rij-I(i-1,j,1))*(Rij-I(i-1,j,1))+(Gij-I(i-1,j,2))*(Gij-I(i-1,j,2))+...
            (Bij-I(i-1,j,3))*(Bij-I(i-1,j,3))))>=th
        %C3=bitget(bin2dec(EBij),3);
        EBij(3)=1;
        end
        if sqrt(double((Rij-I(i-1,j-1,1))*(Rij-I(i-1,j-1,1))+(Gij-I(i-1,j-1,2))*(Gij-I(i-1,j-1,2))+...
            (Bij-I(i-1,j-1,3))*(Bij-I(i-1,j-1,3))))>=th
        %C2=bitget(bin2dec(EBij),2);
        EBij(2)=1;
        end
        if sqrt(double((Rij-I(i,j-1,1))*(Rij-I(i,j-1,1))+(Gij-I(i,j-1,2))*(Gij-I(i,j-1,2))+...
            (Bij-I(i,j-1,3))*(Bij-I(i,j-1,3))))>=th
        %C1=bitget(bin2dec(EBij),1);
        EBij(1)=1;
        end
        SBij=4*EBij(1)+2*EBij(2)+EBij(3);%fprintf('%d\n',SBij);
        T(i,j,3)=256*SBij/8;
    end
end
%subplot(1,2,2);
%figure;
%imshow(T,[]);
%t=etime(clock,t0);fprintf('%f\n',t);

end

