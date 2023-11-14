%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
% rrce_ts_LHvsPW_fluxes.m
%
% create a 6 panel figure showning the timeseries from RCE and RRCE
% simulatiosn 
%
% also estimates the amount of extra precipitable water (PW) that results
% from the latent heat flux being initially larger than the precipitation
%
% levi silvers                                                       nov 2023
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

% specify RGB values for colors: 
col_lh   = [0 0.4470 0.7410];
col_sh   = [0.8500 0.3250 0.0980];
col_ta   = [0.9290 0.6940 0.1250];
col_pw   = [0.4940 0.1840 0.5560];
col_pr   = [0.6350 0.0780 0.1840];
col_vrms = [0 0 0];


source='/Users/silvers/data/CAM/RRCEvsRCE/';

var1='hfls_avg';
var2='hfss_avg';
var3='pr_avg';
var4='prw_avg';
var6='ta_avg';

% latent heat of evaporation ~ J/kg, see cime/src/share/util/shr_const_mod.F90
Lv=2.501e6

ndays2plot=200;
tsteps=24*ndays2plot+1;

xdays=0:1/24.:ndays2plot;

sgtitle("how do you cope?")

% begin loop
config='RRCE'
sst='295'
exp_string    =strcat('CAM6_GCM_',config,'_large',sst,'_0D_')
exp_string_1d =strcat('CAM6_GCM_',config,'_large',sst,'_1D_')
Title1        =strcat(config,' with { }',sst,'K')

s_var1=strcat(source,exp_string,var1,'.nc');
s_var2=strcat(source,exp_string,var2,'.nc');
s_var3=strcat(source,exp_string,var3,'.nc');
s_var4=strcat(source,exp_string,var4,'.nc');
s_var6=strcat(source,exp_string_1d,var6,'.nc');
hfls_ts_a   = ncread(s_var1,var1);
hfss_ts_a   = ncread(s_var2,var2);
pr_ts_a     = ncread(s_var3,var3);
prw_ts_a    = ncread(s_var4,var4);
ta_ts_a     = ncread(s_var6,var6);
%
sst='300'
exp_string    =strcat('CAM6_GCM_',config,'_large',sst,'_0D_')
exp_string_1d =strcat('CAM6_GCM_',config,'_large',sst,'_1D_')
Title2        =strcat(config,' with { }',sst,'K')

s_var1=strcat(source,exp_string,var1,'.nc');
s_var2=strcat(source,exp_string,var2,'.nc');
s_var3=strcat(source,exp_string,var3,'.nc');
s_var4=strcat(source,exp_string,var4,'.nc');
s_var6=strcat(source,exp_string_1d,var6,'.nc');
hfls_ts_b   = ncread(s_var1,var1);
hfss_ts_b   = ncread(s_var2,var2);
pr_ts_b     = ncread(s_var3,var3);
prw_ts_b    = ncread(s_var4,var4);
ta_ts_b     = ncread(s_var6,var6);
%
sst='305'
exp_string    =strcat('CAM6_GCM_',config,'_large',sst,'_0D_')
exp_string_1d =strcat('CAM6_GCM_',config,'_large',sst,'_1D_')
Title3        =strcat(config,' with { }',sst,'K')

s_var1=strcat(source,exp_string,var1,'.nc');
s_var2=strcat(source,exp_string,var2,'.nc');
s_var3=strcat(source,exp_string,var3,'.nc');
s_var4=strcat(source,exp_string,var4,'.nc');
s_var6=strcat(source,exp_string_1d,var6,'.nc');
hfls_ts_c   = ncread(s_var1,var1);
hfss_ts_c   = ncread(s_var2,var2);
pr_ts_c     = ncread(s_var3,var3);
prw_ts_c    = ncread(s_var4,var4);
ta_ts_c     = ncread(s_var6,var6);

%----------------------------------------
config='RCE'
%
sst='295'
exp_string    =strcat('CAM6_GCM_',config,'_large',sst,'_0D_')
exp_string_1d =strcat('CAM6_GCM_',config,'_large',sst,'_1D_')
Title4        =strcat(config,' with { }',sst,'K')

s_var1=strcat(source,exp_string,var1,'.nc');
s_var2=strcat(source,exp_string,var2,'.nc');
s_var3=strcat(source,exp_string,var3,'.nc');
s_var4=strcat(source,exp_string,var4,'.nc');
s_var6=strcat(source,exp_string_1d,var6,'.nc');
hfls_ts_d   = ncread(s_var1,var1);
hfss_ts_d   = ncread(s_var2,var2);
pr_ts_d     = ncread(s_var3,var3);
prw_ts_d    = ncread(s_var4,var4);
ta_ts_d     = ncread(s_var6,var6);

%
sst='300'
exp_string    =strcat('CAM6_GCM_',config,'_large',sst,'_0D_')
exp_string_1d =strcat('CAM6_GCM_',config,'_large',sst,'_1D_')
Title5        =strcat(config,' with { }',sst,'K')

s_var1=strcat(source,exp_string,var1,'.nc');
s_var2=strcat(source,exp_string,var2,'.nc');
s_var3=strcat(source,exp_string,var3,'.nc');
s_var4=strcat(source,exp_string,var4,'.nc');
s_var6=strcat(source,exp_string_1d,var6,'.nc');

hfls_ts_e   = ncread(s_var1,var1);
hfss_ts_e   = ncread(s_var2,var2);
pr_ts_e     = ncread(s_var3,var3);
prw_ts_e    = ncread(s_var4,var4);
ta_ts_e     = ncread(s_var6,var6);

%
sst='305'
exp_string    =strcat('CAM6_GCM_',config,'_large',sst,'_0D_')
exp_string_1d =strcat('CAM6_GCM_',config,'_large',sst,'_1D_')
Title6        =strcat(config,' with { }',sst,'K')

s_var1=strcat(source,exp_string,var1,'.nc');
s_var2=strcat(source,exp_string,var2,'.nc');
s_var3=strcat(source,exp_string,var3,'.nc');
s_var4=strcat(source,exp_string,var4,'.nc');
s_var6=strcat(source,exp_string_1d,var6,'.nc');

hfls_ts_f   = ncread(s_var1,var1);
hfss_ts_f   = ncread(s_var2,var2);
pr_ts_f     = ncread(s_var3,var3);
prw_ts_f    = ncread(s_var4,var4);
ta_ts_f     = ncread(s_var6,var6);
%-------------------------------------------------------------

figure2 = figure;
axes2 = axes('Parent',figure2);
subplot(3,2,1)
%hold(axes2,'on');
plot1 = plot(xdays,hfss_ts_a(1:tsteps),'LineWidth',2,'Color',col_sh);
hold on
set(plot1,'Displayname','SH flux');
plot2 = plot(xdays,hfls_ts_a(1:tsteps),'LineWidth',2,'Color',col_lh);
set(plot2,'Displayname','LH flux');
plot3 = plot(xdays,Lv*pr_ts_a(1:tsteps),'LineWidth',2,'Color',col_pr);
set(plot3,'Displayname','Precip');
plot4 = plot(xdays,prw_ts_a(1:tsteps),'LineWidth',2,'Color',col_pw)
set(plot4,'DisplayName','scaled PW');
ylim([0 150]);
xlim([0 ndays2plot]);
%legend(axes2,'show')
ylabel('W/m2; kg/m2')
xlabel('time (days)')
title(Title1)
set(gca,'FontSize',10)
set(gca,'FontWeight','bold')

subplot(3,2,3)
plot1 = plot(xdays,hfss_ts_b(1:tsteps),'LineWidth',2,'Color',col_sh);
hold on
set(plot1,'Displayname','SH flux');
plot2 = plot(xdays,hfls_ts_b(1:tsteps),'LineWidth',2,'Color',col_lh);
set(plot2,'Displayname','LH flux');
plot3 = plot(xdays,Lv*pr_ts_b(1:tsteps),'LineWidth',2,'Color',col_pr);
set(plot3,'Displayname','Precip');
plot4 = plot(xdays,prw_ts_b(1:tsteps),'LineWidth',2,'Color',col_pw)
set(plot4,'DisplayName','scaled PW');
ylim([0 150]);
xlim([0 ndays2plot]);
ylabel('W/m2; kg/m2')
xlabel('time (days)')
set(gca,'FontWeight','bold')
title(Title2)

subplot(3,2,5)
plot1 = plot(xdays,hfss_ts_c(1:tsteps),'LineWidth',2,'Color',col_sh);
hold on
plot2 = plot(xdays,hfls_ts_c(1:tsteps),'LineWidth',2,'Color',col_lh);
plot3 = plot(xdays,Lv*pr_ts_c(1:tsteps),'LineWidth',2,'Color',col_pr);
plot4 = plot(xdays,prw_ts_c(1:tsteps),'LineWidth',2,'Color',col_pw)
ylim([0 200]);
xlim([0 ndays2plot]);
ylabel('W/m2; kg/m2')
xlabel('time (days)')
set(gca,'FontWeight','bold')
title(Title3)

subplot(3,2,2)
plot1 = plot(xdays,hfss_ts_d(1:tsteps),'LineWidth',2,'Color',col_sh);
hold on
plot2 = plot(xdays,hfls_ts_d(1:tsteps),'LineWidth',2,'Color',col_lh);
plot3 = plot(xdays,Lv*pr_ts_d(1:tsteps),'LineWidth',2,'Color',col_pr);
plot4 = plot(xdays,prw_ts_d(1:tsteps),'LineWidth',2,'Color',col_pw)
ylim([0 150]);
xlim([0 ndays2plot]);
ylabel('W/m2; kg/m2')
xlabel('time (days)')
set(gca,'FontWeight','bold')
title(Title4)

subplot(3,2,4)
plot1 = plot(xdays,hfss_ts_e(1:tsteps),'LineWidth',2,'Color',col_sh);
hold on
plot2 = plot(xdays,hfls_ts_e(1:tsteps),'LineWidth',2,'Color',col_lh);
plot3 = plot(xdays,Lv*pr_ts_e(1:tsteps),'LineWidth',2,'Color',col_pr);
plot4 = plot(xdays,prw_ts_e(1:tsteps),'LineWidth',2,'Color',col_pw)
ylim([0 150]);
xlim([0 ndays2plot]);
ylabel('W/m2; kg/m2')
xlabel('time (days)')
set(gca,'FontWeight','bold')
title(Title5)

subplot(3,2,6)
plot1 = plot(xdays,hfss_ts_f(1:tsteps),'LineWidth',2,'Color',col_sh);
hold on
plot2 = plot(xdays,hfls_ts_f(1:tsteps),'LineWidth',2,'Color',col_lh);
plot3 = plot(xdays,Lv*pr_ts_f(1:tsteps),'LineWidth',2,'Color',col_pr);
plot4 = plot(xdays,prw_ts_f(1:tsteps),'LineWidth',2,'Color',col_pw)
ylim([0 150]);
xlim([0 ndays2plot]);
ylabel('W/m2; kg/m2')
xlabel('time (days)')
set(gca,'FontWeight','bold')
title(Title6)

sgtitle("Time Series of Initial 200 days")
set(gca,'FontWeight','bold')

% export the figure at higher then default resolution (I think the  number is 
% some idiotic unit like points per inch; default 150)
exportgraphics(figure2,'SI_LHvsPrecip.pdf','Resolution',500)

% calculated the amount of water vapor that accumulated during period over which 
% the LHFLX is greater than the precipitation
% result should be in kg/m2
% grab the part of the time series when hfls is greater than pr and when they are
% not approximately in balance with each other, over approximately 1000 hours.
t1=1;
t2=1000; % should be hourly timesteps
normfac=t2-t1;
moist=hfls_ts_a(t1:t2)-Lv*pr_ts_a(t1:t2); % Lv converts precip to energy units
%moist=mean(hfls_ts(t1:t2))-Lv*mean(pr_ts(t1:t2)); % Lv converts precip to energy units; W/m2
totalE=sum(moist)/Lv; % add up the accumulated 'extra' moisture in the atmosphere and convert back into kg/m2s
numsecs=(t2-t1)*3600; % data is output on hourly intevals.  convert to seconds
%ans*0.0023
scaledE=totalE*numsecs/normfac % I am not totally sure why this 1000 needs to be here.  t2-t1?





