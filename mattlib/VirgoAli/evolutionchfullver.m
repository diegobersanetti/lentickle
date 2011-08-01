% 20/01/05
% M.Mantovani
%
% Program evolutionchNWhor.m
% 
% This program save in vectors called B(7/8)q(1/2)_(p/q)h_(N/W)(I/E)
% the values of the corrispective matrix element for different demodulation 
% phases. 
% the demodulation phase values are collected in the vector evolv
%

% in the file is written the input data matrix in the format:
% GPSb GPSe dempha
% filen='lines-at-HF-on-tytx-790972162-a.txt';


TxTy=0;   % for horizontal matrix
startp=1; % starting index of the filename matrix 
stopp=19; % stopping index of the filename matrix 
fres=500; % resampling frequency for the matrix measurement
ave=13;   % number of averages for the matrix measurement
calibration=0; 


len=stopp-startp+1;  % length of the vectors
Matrix=zeros(16,6);

evolv=zeros(len,1);
chtx=zeros(len,6,8);
chtxq=zeros(len,6,8);
chq=zeros(len,6,8);

Data=load(filen);

if (len>0)
for i=startp:stopp,
    GPSb=Data(i,1);
    GPSe=Data(i,2);
    demph=Data(i,3);
    [Matrix]=Mmeasure(TxTy,GPSb,GPSe,fres,ave,'','MLF',1,calibration)
    for inc=1:8,
        for compt=1:6,
            chtx(i,compt,inc)=abs(Matrix(2*inc-1,compt));
            chq(i,compt,inc)=abs(Matrix(2*inc,compt));
        end
    end
    evolv(i,1)=-demph;
end
end
delta=(90/(evolv(2,1)-evolv(1,1)));
 if (max(evolv)>=180)
    for i=1:len,
        for inc=1:8,
                for compt=1:6,
                    if (i>delta)
                        chtxq(i,compt,inc)=chq(i-delta,compt,inc);
                    end
                    if (i<delta)
                        chtxq(i,compt,inc)=chq(i+delta,compt,inc);
                    end
                end
            end
        end
 end
