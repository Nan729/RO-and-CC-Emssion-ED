function b=BarPlotBreak(X,Y,y_break_start,y_break_end,break_type,scale)

% BarBreakPlot(y,y_break_start,y_break_end,break_type,scale)
% Produces a plot who's y-axis skips to avoid unecessary blank space
% 
% INPUT
% y
% y_break_start
% y_break_end
% break_type
%    if break_type='RPatch' the plot will look torn
%       in the broken space
%    if break_type='Patch' the plot will have a more
%       regular, zig-zag tear
%    if break_plot='Line' the plot will merely have
%       some hash marks on the y-axis to denote the
%       break
% scale = between 0-1, the % of max Y value that needs to subtracted from
% the max value bars
% USAGE:
% figure;
% BarPlotBreak([10,40,1000], 50, 60, 'RPatch', 0.85);
%
% Original Version developed by:
% Michael Robbins
% robbins@bloomberg.net
% michael.robbins@bloomberg.net
%
% Modified by: 
% Chintan Patel
% chintan.patel@dbmi.columbia.edu

% data
if nargin<5 break_type='RPatch'; end
if nargin<4 y_break_end=40; end
if nargin<3 y_break_start=10; end
if nargin<2 y=[1:10,40:50]; end
if nargin<1 x=rand(1,21); end

y_break_mid   = (y_break_end-y_break_start)./2+y_break_start;

Y2=Y;
Y2(Y2>=y_break_end)=Y2(Y2>=y_break_end)-(Y2(Y2>=y_break_end)*scale);

%find the max and min and cut max to 1.5 times the min
b=bar(X,Y2);

xlim=get(gca,'xlim');
% xlim=[-0.2,5.2];
%ylim([0 ceil(max(max(Y))/1000)*1000]);
ytick=get(gca,'YTick');
[junk,i]=min(ytick<=y_break_start);
y=(ytick(i)-ytick(i-1))./2+ytick(i-1);
dy=(ytick(2)-ytick(1))./15;
xtick=get(gca,'XTick');
%xtick=[1,2,3,4];
x1=xlim(1);
x2=xlim(2);
dx=(xtick(2)-xtick(1))./10;
length=size(xtick,2);
%break_type = 'Patch';
switch break_type
    case 'Patch'
		% this can be vectorized
        dx=(xlim(2)-xlim(1))./10;
        yy=repmat([y-2.*dy y-dy],1,6);
        xx=xlim(1)+dx.*[0:11];
		patch([xx(:);flipud(xx(:))], ...
            [yy(:);flipud(yy(:)-2.*dy)], ...
            [.8 .8 .8])
    case 'RPatch'
		% this can be vectorized
        dx=(xlim(2)-xlim(1))./100;
        yy=y+rand(101,1).*2.*dy;
        xx=xlim(1)+dx.*(0:100);
		patch([xx(:);flipud(xx(:))], ...
            [yy(:);flipud(yy(:)-2.*dy)], ...
            [.8 .8 .8])
    case 'Line'
		line([x1 x1+dx   ],[y-2.*dy y-dy   ],'Color',[0,0,0],'LineStyle','-','lineWidth',1.5);
        line([x1 x1+dx   ],[y-2*dy   y+dy],'Color',[0,0,0],'LineStyle','-','lineWidth',1.5);
		line([x1 x1+dx],[y   y+dy],'Color',[0,0,0],'LineStyle','-','lineWidth',1.5);
        
%         line([4 4.8 ],[y-3.*dy y-2.*dy],'Color',[0, 0.4470, 0.7410]','LineStyle','-','lineWidth',2);
%         line([4 4.8 ],[y-3.*dy y],'Color',[0, 0.4470, 0.7410]','LineStyle','-','lineWidth',2);
% 		line([4 4.8 ],[y-dy y],'Color',[0, 0.4470, 0.7410]','LineStyle','-','lineWidth',2);
        aa=xtick(length)+0.4*dx;
        bb=xtick(length)+2.6*dx;
        nn=4;
        dxx=(bb-aa)./nn;
        yy=y+rand(nn+1,1).*2.*dy;
        xx=aa+dxx.*(0:nn);
		patch([xx(:);flipud(xx(:))], ...
            [yy(:);flipud(yy(:)-2.*dy)], ...
            [1 1 1])
        
		line([x2-dx x2   ],[y-3.*dy y-2.*dy],'Color',[0,0,0],'LineStyle','-','lineWidth',1.5);
        line([x2-dx x2   ],[y-3.*dy y],'Color',[0, 0,0]','LineStyle','-','lineWidth',1.5);
		line([x2-dx x2],[y-dy y],'Color',[0, 0, 0]','LineStyle','-','lineWidth',1.5);
end

%ytick(ytick>y_break_start)=ytick(ytick>y_break_start)+y_break_mid;

ytick(ytick>y_break_start)=ytick(ytick>y_break_start)+(Y(Y>=y_break_end)*scale);
nytick=size(ytick,2);
for i=1:nytick
   yticklabel{i}=sprintf('%d',ceil(ytick(i)));
end
set(gca,'yticklabel',yticklabel);