function [imgL,imgS]=plotpeak(ax,fig,x,y,m1,m2,dim)

hold(ax,'off')
plt=plot(ax,x,y,'k','LineWidth',1);
set(ax,'TickDir','out');
set(ax,'linewidth',1)
xlabel(ax,'Seconds','fontsize',10);
ylabel(ax,'Intensity','FontSize',10);
ytickangle(ax,90)
%m1=pk.mz-pk.mz*settings.ppm;
%m2=pk.mz+ pk.mz*settings.ppm;
title(ax,{['Extracted ion Chromatogram m/z ',num2str(m1,'%.6f'),' - ',num2str(m2,'%.6f')];''},'FontSize',10);

X=getframe(fig);

XX=rgb2gray(X.cdata);
imgL=X;
imgS=imresize(XX/max(max(XX))*255,[dim dim]);
