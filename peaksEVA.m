% Inputs:
% fn_mzXML:  file name of mzXML
% fn_pklist: file name of peak list
% cols: a two-number array that specifies the columns of m/z and rt in the peaklist.
% model: pre-trained CNN model name
% ppm (optional): ppm window used in reading EIC, default is 5
% ave (optional): EIC moving average, default is 5 

% Output:
% ispeak: an array of 1 or 0. This new column will be appended to peaklist
% img: an array that stores all the EIC curves as images. 
% In addition, all results will be saved in a temp folder ('tmp' followed by time stamp) containing: 
% -- a true folder: images of EICs classified as true peaks.
% -- a false folder: images of EICs classified as false peaks.
% -- updated peaklist, with an added column of 'ispeak'.

% example usage:
% peaksEVA('example_pos.mzXML','example_peaks_pos.csv',[5,6],'net64')

function [ispeak,img]=peaksEVA(fn_mzXML,fn_pklist,cols,model,ppm,ave) 
ispeak=[];img=[];
% fn_mzXML='pos-mix-01.mzXML';
% fn_pklist='peaks_pos_scan2.csv';
[~,fname]=fileparts(fn_pklist);
fn_out=[fname,'_CNN.csv'];

 settings.ppm=5*1e-6;
 settings.rtm=1;
 settings.ave=5;
 settings.prominence=1e3;
 settings.peakwidth=0.02;
if nargin>4
 settings.ave=ave;
 settings.ppm=ppm*1e-6;
end

M=mzxml2M(fn_mzXML);
T=readtable(fn_pklist);
O=load([model,'.mat']);
dim=O.dim;
net=O.net;

folder=['tmp',datestr(now,'yyyy-mm-dd-HH-MM')];
mkdir(folder);
mkdir(fullfile(folder,'true'));
mkdir(fullfile(folder,'false'));
fig=figure;
ax=axes(fig);
TRUE=0;FALSE=0;
for i=1:size(T,1) 
%i=i+1;
pk=[];
pk.mz=T{i,cols(1)};
pk.rt=T{i,cols(2)};
spec=getEIC(M,pk,settings);
m1=pk.mz-pk.mz*settings.ppm;
m2=pk.mz+ pk.mz*settings.ppm;
x=spec{1}(:,1)*60;
y=spec{1}(:,3);

[imgL,imgS]=plotpeak(ax,fig,x,y,m1,m2,dim);
img{i}=imgL;
cc=classify(net,imgS);
if strcmp(string(cc),'true')
  imwrite(imgL.cdata,fullfile(folder,'true',['pk',num2str(i,'%.5d'),'.png']));
  T{i,'isPeak'}=1;
  ispeak(i)=1;
  TRUE=TRUE+1;
else
  imwrite(imgL.cdata,fullfile(folder,'false',['pk',num2str(i,'%.5d'),'.png']));
  T{1,'isPeak'}=0;
  ispeak(i)=0;
  FALSE=FALSE+1;
end
fprintf(['#',num2str(i),'/',num2str(size(T,1)),':',char(cc),'--',num2str(TRUE),':',num2str(FALSE),'\n'])
end
writetable(T,fullfile(folder,fn_out));
fprintf('Done!\n')
