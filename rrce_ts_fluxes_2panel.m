%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-                
% rrce_ts_fluxes_2panel.m                                                                     
%                                                                                             
% two panel plot showing the time evolution of surface fluxes for 
% RRCE and RCE cases with an SST of 300K                                                                                             
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
var5='ta_avg';                             
var6='uabot';
var7='vabot';

% latent heat of evaporation ~ J/kg, see cime/src/share/util/shr_const_mod.F90                
Lv=2.501e6                                                                                    
                                                                                              
ndays2plot=100;                                                                               
tsteps=24*ndays2plot+1;                                                                       
                                                                                              
xdays=0:1/24.:ndays2plot;      

config='RRCE'
sst='300'                                                                                     
exp_string    =strcat('CAM6_GCM_',config,'_large',sst,'_0D_')                                 
exp_string_1d =strcat('CAM6_GCM_',config,'_large',sst,'_1D_')                                 
exp_string_2d =strcat('CAM6_GCM_',config,'_large',sst,'_2D_')
Title1        =strcat(config,' with { }',sst,'K')

s_var1=strcat(source,exp_string,var1,'.nc');
s_var2=strcat(source,exp_string,var2,'.nc');
s_var3=strcat(source,exp_string,var3,'.nc');
s_var4=strcat(source,exp_string,var4,'.nc');
s_var5=strcat(source,exp_string_1d,var5,'.nc');
s_var6=strcat(source,exp_string_2d,var6,'.nc');
s_var7=strcat(source,exp_string_2d,var7,'.nc');

hfls_ts_a   = ncread(s_var1,var1);
hfss_ts_a   = ncread(s_var2,var2);
pr_ts_a     = ncread(s_var3,var3);
prw_ts_a    = ncread(s_var4,var4);
ta_ts_a     = ncread(s_var5,var5);
uabot_a     = ncread(s_var6,var6);
vabot_a     = ncread(s_var7,var7);

uabot_rms_ts=sqrt(mean(uabot_a.*uabot_a,[1 2]));
vabot_rms_ts=sqrt(mean(vabot_a.*vabot_a,[1 2]));

uabotRMS=squeeze(uabot_rms_ts(1,1,:));
vabotRMS=squeeze(vabot_rms_ts(1,1,:));

Vrms_a=uabotRMS+vabotRMS-mean(vabotRMS+uabotRMS)

%----------------------------------------------------------------------------------------------------------
config='RCE'
exp_string    =strcat('CAM6_GCM_',config,'_large',sst,'_0D_')
exp_string_1d =strcat('CAM6_GCM_',config,'_large',sst,'_1D_')
exp_string_2d =strcat('CAM6_GCM_',config,'_large',sst,'_2D_')
Title2        =strcat(config,' with { }',sst,'K')

s_var1=strcat(source,exp_string,var1,'.nc');
s_var2=strcat(source,exp_string,var2,'.nc');
s_var3=strcat(source,exp_string,var3,'.nc');
s_var4=strcat(source,exp_string,var4,'.nc');
s_var5=strcat(source,exp_string_1d,var5,'.nc');
s_var6=strcat(source,exp_string_2d,var6,'.nc');
s_var7=strcat(source,exp_string_2d,var7,'.nc');

hfls_ts_b   = ncread(s_var1,var1);
hfss_ts_b   = ncread(s_var2,var2);
pr_ts_b     = ncread(s_var3,var3);
prw_ts_b    = ncread(s_var4,var4);
ta_ts_b     = ncread(s_var5,var5);
uabot_b     = ncread(s_var6,var6);
vabot_b     = ncread(s_var7,var7);

uabot_rms_ts=sqrt(mean(uabot_b.*uabot_b,[1 2]));
vabot_rms_ts=sqrt(mean(vabot_b.*vabot_b,[1 2]));

uabotRMS=squeeze(uabot_rms_ts(1,1,:));
vabotRMS=squeeze(vabot_rms_ts(1,1,:));

Vrms_b=uabotRMS+vabotRMS-mean(vabotRMS+uabotRMS)

%----------------------------------------------------------------------------------------------------------
% make the plot

figure1 = figure;
axes1 = axes('Parent',figure1);
subplot(1,2,1)
plot1 = plot(xdays,hfls_ts_a(1:tsteps)-mean(hfls_ts_a(1:tsteps)),'LineWidth',2,'Color',col_lh);
hold on
plot2 = plot(xdays,hfss_ts_a(1:tsteps)-mean(hfss_ts_a(1:tsteps)),'LineWidth',2,'Color',col_sh)
plot3 = plot(xdays,Lv*pr_ts_a(1:tsteps)-mean(Lv*pr_ts_a(1:tsteps)),'LineWidth',2,'Color',col_pr)
plot4 = plot(xdays,3*prw_ts_a(1:tsteps)-mean(3*prw_ts_a(1:tsteps)),'LineWidth',2,'Color',col_pw)
plot5 = plot(xdays,100*ta_ts_a(32,1:tsteps)-mean(100*ta_ts_a(32,1:tsteps)),'LineWidth',2,'Color',col_ta)
set(plot5,'DisplayName','ta32');
plot6 = plot(xdays,30*Vrms_a(1:tsteps),'LineWidth',2,'Color',col_vrms)
ylabel('Anomalous magnitude')
xlabel('time (days)')
title(Title1)
xlim([0 ndays2plot]);
ylim([-300 150]);
daspect([1 4 1])
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')

subplot(1,2,2)
plot1 = plot(xdays,hfls_ts_b(1:tsteps)-mean(hfls_ts_b(1:tsteps)),'LineWidth',2,'Color',col_lh);
hold on
set(plot1,'DisplayName','LH flux');
plot2 = plot(xdays,hfss_ts_b(1:tsteps)-mean(hfss_ts_b(1:tsteps)),'LineWidth',2,'Color',col_sh)
set(plot2,'DisplayName','SH flux');
plot3 = plot(xdays,Lv*pr_ts_b(1:tsteps)-mean(Lv*pr_ts_b(1:tsteps)),'LineWidth',2,'Color',col_pr)
set(plot3,'DisplayName','P');
plot4 = plot(xdays,3*prw_ts_b(1:tsteps)-mean(3*prw_ts_b(1:tsteps)),'LineWidth',2,'Color',col_pw)
set(plot4,'DisplayName','PW');
plot5 = plot(xdays,100*ta_ts_b(32,1:tsteps)-mean(100*ta_ts_b(32,1:tsteps)),'LineWidth',2,'Color',col_ta)
set(plot5,'DisplayName','T');
plot6 = plot(xdays,30*Vrms_b(1:tsteps),'LineWidth',2,'Color',col_vrms)
set(plot6,'DisplayName','Vrms');
ylabel('Anomalous magnitude')
xlabel('time (days)')
title(Title2)
xlim([0 ndays2plot]);
ylim([-300 150]);
daspect([1 4 1])
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')

legend('show','Location','southeast')

% export the figure at higher then default resolution (I think the  number is 
% some idiotic unit like points per inch; default 150)
exportgraphics(figure1,'SI_EnergyFlux_ts.pdf','Resolution',500)








