%----------------------------------------------------------------------------------------------- 
% heating_stability_circulation.m
%
% creates two plots
% Plot 1:  scatter plot of the heating and stability from CAM5/CAM6 for RCE/RRCE
% Plot 2:  scatter plot of the circulation intensity from CAM5/CAM6 for RCE/RRCE
%
% imports data tables that were derived on casper
%
% data was processed on casper with the ncl file: CAMRRCE_table_general.ncl
%
% levi silvers                                                                   aug 2022
%----------------------------------------------------------------------------------------------- 


% import three data tables that contain data from cam5 and cam6, rce and rrce simulations
% these tables are read into the following structures: Circ_c5c6_295 Circ_c5c6_300 Circ_c5c6_305
import_cam5cam6_stats_295
import_cam5cam6_stats_300
import_cam5cam6_stats_305

% indicate size of markers
m295=70;
m300=150;
m305=250;

% rgb values 
% see https://www.ncl.ucar.edu/Applications/Scripts/rgb.txt
% old values used in Reed et al., 2021:
%102 205 170 %	aquamarine3 ; cam6
%238 118 33  %	chocolate2  ; cam5

CAM6_col_a      =[122, 197, 205]; % CAM6
%CAM6_col_a      =[102, 205, 170]; % CAM6
CAM6_col        =CAM6_col_a/255;
CAM5_col_a      =[205, 51, 51]; % CAM5
%CAM5_col_a      =[238, 118, 33]; % CAM5
CAM5_col        =CAM5_col_a/255;

colors(1,:)  =CAM5_col;           
colors(2,:)  =CAM5_col;           
colors(3,:)  =CAM6_col;   
colors(4,:)  =CAM6_col;   

figure1 = figure
scatter(-Circ_c5c6_295.sig_mn(1),Circ_c5c6_295.Qmn(1),[],CAM5_col,'filled','o','SizeData',m295)
hold on
scatter(-Circ_c5c6_300.sig_mn(1),Circ_c5c6_300.Qmn(1),[],CAM5_col,'filled','o','SizeData',m300)
scatter(-Circ_c5c6_305.sig_mn(1),Circ_c5c6_305.Qmn(1),[],CAM5_col,'filled','o','SizeData',m305)
scatter(-Circ_c5c6_295.sig_mn(3),Circ_c5c6_295.Qmn(3),[],CAM6_col,'filled','o','SizeData',m295)
scatter(-Circ_c5c6_300.sig_mn(3),Circ_c5c6_300.Qmn(3),[],CAM6_col,'filled','o','SizeData',m300)
scatter(-Circ_c5c6_305.sig_mn(3),Circ_c5c6_305.Qmn(3),[],CAM6_col,'filled','o','SizeData',m305)
%scatter(Circ_omega_CRMs_295.sig_mn(CRM_cs),Circ_omega_CRMs_295.Qmn(CRM_cs),[],colCRM(CRM_cs,:),'filled','h','SizeData',m295b);
scatter(-Circ_c5c6_295.sig_mn(2),Circ_c5c6_295.Qmn(2),[],CAM5_col,'filled','h','SizeData',m295)
scatter(-Circ_c5c6_300.sig_mn(2),Circ_c5c6_300.Qmn(2),[],CAM5_col,'filled','h','SizeData',m300)
scatter(-Circ_c5c6_305.sig_mn(2),Circ_c5c6_305.Qmn(2),[],CAM5_col,'filled','h','SizeData',m305)
scatter(-Circ_c5c6_295.sig_mn(4),Circ_c5c6_295.Qmn(4),[],CAM6_col,'filled','h','SizeData',m295)
scatter(-Circ_c5c6_300.sig_mn(4),Circ_c5c6_300.Qmn(4),[],CAM6_col,'filled','h','SizeData',m300)
scatter(-Circ_c5c6_305.sig_mn(4),Circ_c5c6_305.Qmn(4),[],CAM6_col,'filled','h','SizeData',m305)
%scatter(Circ_omega_CRMs_300.sig_mn(CRM_cs),Circ_omega_CRMs_300.Qmn(CRM_cs),[],colCRM(CRM_cs,:),'filled','h','SizeData',m300b);
%scatter(Circ_omega_CRMs_305.sig_mn(CRM_cs),Circ_omega_CRMs_305.Qmn(CRM_cs),[],colCRM(CRM_cs,:),'filled','h','SizeData',m305b);
ylabel('$Q (\rm{K \> d^{-1}})$','interpreter','latex')
xlabel('$\sigma (\rm{K \> hPa^{-1}})$','interpreter','latex','FontSize',14,'FontWeight','bold')
set(gca,'FontWeight','bold')
set(gca,'FontSize',14)

% circulation figure (Figure 2 from Circulation paper) modified for CAM RCE and RRCE
% new figure 2

sst_4a=[295 295 295 295];
sst_4b=[300 300 300 300];
sst_4c=[305 305 305 305];

figure2 = figure
subplot(2,3,5)
%scatter(sst_4a,Circ_c5c6_295.I,[],colors,'filled','o','SizeData',m295);
scatter(sst_4a(1),Circ_c5c6_295.I(1),[],CAM5_col,'filled','o','SizeData',m295);
hold on
scatter(sst_4a(2),Circ_c5c6_295.I(2),[],CAM5_col,'filled','h','SizeData',m295);
scatter(sst_4a(3),Circ_c5c6_295.I(3),[],CAM6_col,'filled','o','SizeData',m295);
scatter(sst_4a(4),Circ_c5c6_295.I(4),[],CAM6_col,'filled','h','SizeData',m295);
%scatter(sst_4b,Circ_c5c6_300.I,[],colors,'filled','o','SizeData',m300);
scatter(sst_4b(2),Circ_c5c6_300.I(1),[],CAM5_col,'filled','o','SizeData',m300);
scatter(sst_4b(2),Circ_c5c6_300.I(2),[],CAM5_col,'filled','h','SizeData',m300);
scatter(sst_4b(2),Circ_c5c6_300.I(3),[],CAM6_col,'filled','o','SizeData',m300);
scatter(sst_4b(2),Circ_c5c6_300.I(4),[],CAM6_col,'filled','h','SizeData',m300);
%scatter(sst_4c,Circ_c5c6_305.I,[],colors,'filled','o','SizeData',m305);
scatter(sst_4c(3),Circ_c5c6_305.I(1),[],CAM5_col,'filled','o','SizeData',m305);
scatter(sst_4c(3),Circ_c5c6_305.I(2),[],CAM5_col,'filled','h','SizeData',m305);
scatter(sst_4c(3),Circ_c5c6_305.I(3),[],CAM6_col,'filled','o','SizeData',m305);
scatter(sst_4c(3),Circ_c5c6_305.I(4),[],CAM6_col,'filled','h','SizeData',m305);
xlim([294 306])
line([sst_4a(1),sst_4b(1),sst_4c(1)],[Circ_c5c6_295.I(1),Circ_c5c6_300.I(1),Circ_c5c6_305.I(1)],'Color',colors(1,:),'LineWidth',2)
line([sst_4a(1),sst_4b(1),sst_4c(1)],[Circ_c5c6_295.I(2),Circ_c5c6_300.I(2),Circ_c5c6_305.I(2)],'Color',colors(2,:),'LineWidth',2)
line([sst_4a(1),sst_4b(1),sst_4c(1)],[Circ_c5c6_295.I(3),Circ_c5c6_300.I(3),Circ_c5c6_305.I(3)],'Color',colors(3,:),'LineWidth',2)
line([sst_4a(1),sst_4b(1),sst_4c(1)],[Circ_c5c6_295.I(4),Circ_c5c6_300.I(4),Circ_c5c6_305.I(4)],'Color',colors(4,:),'LineWidth',2)
ylabel('$I \, (\rm{hPa \> d^{-1}})$','interpreter','latex','FontSize',12,'FontWeight','bold')
xlabel('$T_s \, (\rm{K}) $','interpreter','latex','FontSize',14,'FontWeight','bold')
set(gca,'FontWeight','bold')
set(gca,'FontSize',14)
ylim([40 130])

% P: surface precipitation rate, units=kg m-2 s-1
% PRW->PW: water vapor path, units=kg m-2
% CWP: condensed water path = mean(clwvi)+mean(clivi), units=kg m-2

scale2d=86400.; % (1/s)*(3600s/hr)*(24hr/d) = 86400 d-1
scale2h=3600.; 

% model   P/PW(s-1)    P/PW(s-1)   P/PW(s-1)   P/CWP(s-1)   P/CWP(s-1)  P/CWP(s-1)
%         295     300    305    295     300    305
% cam5
% cam6
%rce_cycle =[0.103 0.091 0.073 0.00070 0.00068 0.00068; 0.107 0.093 0.073 0.00057 0.00063 0.00064]
%rrce_cycle=[0.103 0.082 0.063 0.00075 0.00073 0.00070; 0.105 0.081 0.060 0.000715 0.000699 0.000643]
%
rce_cycle =1e-6.*[1.19775 1.05681 0.84727 452.51 513.81 546.69; 1.2385 1.0721 0.84749 376.01 457.12 512.85]
rrce_cycle=1e-6.*[1.19595 0.95179 0.72827 524.76 563.73 570.54; 1.2132 0.9335 0.68884 471.50 499.30 481.82]

% a residence time can be defined in terms of the inverse of the cycling rate.  because the numbers will be quite large in seconds
% it makes sense to scale the residence times to be in hours/days; because PW > CWP, the water vapor cycling rate is much smaller than the 
% cycling rate of the condensate and therefore the residence time of condensate will be much smaller than that of water vapor.   
% if residence times are desired instead:
rce_cycle = 1./(1e-6.*[scale2d*1.19775 scale2d*1.05681 scale2d*0.84727 scale2h*452.51 scale2h*513.81 scale2h*546.69; scale2d*1.2385 scale2d*1.0721 scale2d*0.84749 scale2h*376.01 scale2h*457.12 scale2h*512.85]);
rrce_cycle= 1./(1e-6.*[scale2d*1.19595 scale2d*0.95179 scale2d*0.72827 scale2h*524.76 scale2h*563.73 scale2h*570.54; scale2d*1.2132 scale2d*0.9335 scale2d*0.68884 scale2h*471.50 scale2h*499.30 scale2h*481.82]);

% RRCE
%         =[cam5aRCE cam5bRCE cam5a cam5b; cam6aRCE cam6bRCE cam6a cam6b]
% note that the difference between the two methods of calculation is much smaller for P
% than it is for PW.
fddPdT    =[0.078 0.039 0.047 0.037; 0.055 0.058 0.040 0.031] % finite difference rate of change
diffdPdT  =[0.066 0.035 0.042 0.034; 0.048 0.051 0.036 0.029] % differential rate of change following O'Gorman and Muller, 2010

fddPWdT   =[0.115 0.098 0.111 0.110; 0.094 0.127 0.112 0.113] % finite difference
diffdPWdT =[0.091 0.080 0.088 0.088; 0.077 0.098 0.088 0.090] % differential rate

% assuming that the differential rate of change is more accurate than the finite difference... the finite difference method 
% overestimates the change.

%figure3 = figure
subplot(2,3,2)
scatter(sst_4a(1),rce_cycle(1,1),[],CAM5_col,'filled','o','SizeData',m295);
hold on
scatter(sst_4b(1),rce_cycle(1,2),[],CAM5_col,'filled','o','SizeData',m300);
scatter(sst_4c(1),rce_cycle(1,3),[],CAM5_col,'filled','o','SizeData',m305);
scatter(sst_4a(1),rce_cycle(2,1),[],CAM6_col,'filled','o','SizeData',m295);
scatter(sst_4b(1),rce_cycle(2,2),[],CAM6_col,'filled','o','SizeData',m300);
scatter(sst_4c(1),rce_cycle(2,3),[],CAM6_col,'filled','o','SizeData',m305);
scatter(sst_4a(1),rrce_cycle(1,1),[],CAM5_col,'filled','h','SizeData',m295);
scatter(sst_4b(1),rrce_cycle(1,2),[],CAM5_col,'filled','h','SizeData',m300);
scatter(sst_4c(1),rrce_cycle(1,3),[],CAM5_col,'filled','h','SizeData',m305);
scatter(sst_4a(1),rrce_cycle(2,1),[],CAM6_col,'filled','h','SizeData',m295);
scatter(sst_4b(1),rrce_cycle(2,2),[],CAM6_col,'filled','h','SizeData',m300);
scatter(sst_4c(1),rrce_cycle(2,3),[],CAM6_col,'filled','h','SizeData',m305);
xlim([294 306])
%ylabel('P/PW, Cycling Rate, $M_{wv} \, (s^{-1})$','interpreter','latex','FontSize',12,'FontWeight','bold')
ylabel('$ \tau_{wv} (\rm{days})$','interpreter','latex','FontSize',12,'FontWeight','bold')
xlabel('$T_s \, (\rm{K}) $','interpreter','latex','FontSize',14,'FontWeight','bold')
set(gca,'FontWeight','bold')
set(gca,'FontSize',14)
%ylim([40 130])

%figure4 = figure
subplot(2,3,3)
scatter(sst_4a(1),rce_cycle(1,4),[],CAM5_col,'filled','o','SizeData',m295);
hold on
scatter(sst_4b(1),rce_cycle(1,5),[],CAM5_col,'filled','o','SizeData',m300);
scatter(sst_4c(1),rce_cycle(1,6),[],CAM5_col,'filled','o','SizeData',m305);
scatter(sst_4a(1),rce_cycle(2,4),[],CAM6_col,'filled','o','SizeData',m295);
scatter(sst_4b(1),rce_cycle(2,5),[],CAM6_col,'filled','o','SizeData',m300);
scatter(sst_4c(1),rce_cycle(2,6),[],CAM6_col,'filled','o','SizeData',m305);
scatter(sst_4a(1),rrce_cycle(1,4),[],CAM5_col,'filled','h','SizeData',m295);
scatter(sst_4b(1),rrce_cycle(1,5),[],CAM5_col,'filled','h','SizeData',m300);
scatter(sst_4c(1),rrce_cycle(1,6),[],CAM5_col,'filled','h','SizeData',m305);
scatter(sst_4a(1),rrce_cycle(2,4),[],CAM6_col,'filled','h','SizeData',m295);
scatter(sst_4b(1),rrce_cycle(2,5),[],CAM6_col,'filled','h','SizeData',m300);
scatter(sst_4c(1),rrce_cycle(2,6),[],CAM6_col,'filled','h','SizeData',m305);
%ylabel('P/CWP, $(s^{-1})$','interpreter','latex','FontSize',12,'FontWeight','bold')
ylabel('$\tau_{cwp} (\rm{hours})$','interpreter','latex','FontSize',12,'FontWeight','bold')
xlim([294 306])
xlabel('$T_s \, (\rm{K}) $','interpreter','latex','FontSize',14,'FontWeight','bold')
set(gca,'FontWeight','bold')
set(gca,'FontSize',14)

%figure
% scatter plot of the differential fractional rate of change of PW vs
% the differential fractional change of P.
subplot(2,3,4)
scatter(diffdPdT(1,1),diffdPWdT(1,1),[],CAM5_col,'filled','o','SizeData',m300);
hold on
scatter(diffdPdT(1,3),diffdPWdT(1,3),[],CAM5_col,'filled','h','SizeData',m300);
scatter(diffdPdT(1,2),diffdPWdT(1,2),[],CAM5_col,'filled','o','SizeData',m305);
scatter(diffdPdT(1,4),diffdPWdT(1,4),[],CAM5_col,'filled','h','SizeData',m305);
scatter(diffdPdT(2,1),diffdPWdT(2,1),[],CAM6_col,'filled','o','SizeData',m300);
scatter(diffdPdT(2,2),diffdPWdT(2,2),[],CAM6_col,'filled','o','SizeData',m305);
scatter(diffdPdT(2,3),diffdPWdT(2,3),[],CAM6_col,'filled','h','SizeData',m300);
scatter(diffdPdT(2,4),diffdPWdT(2,4),[],CAM6_col,'filled','h','SizeData',m305);
line([0.025,0.05,0.1],[0.025,0.05,0.1],'Color','k','LineWidth',1)
%xlabel('differential change $\delta P$','interpreter','latex','FontSize',12,'FontWeight','bold')
xlabel('$\delta P$','interpreter','latex','FontSize',12,'FontWeight','bold')
xlim([0.02 0.08])
ylim([0.04 0.11])
ylabel('$\delta PW$','interpreter','latex','FontSize',14,'FontWeight','bold')
set(gca,'FontWeight','bold')
set(gca,'FontSize',14)

%figure
% scatter plot of the differential fractional rate of change of PW vs
% the finite difference fractional change of P.
subplot(2,3,1)
scatter(fddPdT(1,1),diffdPWdT(1,1),[],CAM5_col,'filled','o','SizeData',m300);
hold on
scatter(fddPdT(1,3),diffdPWdT(1,3),[],CAM5_col,'filled','h','SizeData',m300);
scatter(fddPdT(1,2),diffdPWdT(1,2),[],CAM5_col,'filled','o','SizeData',m305);
scatter(fddPdT(1,4),diffdPWdT(1,4),[],CAM5_col,'filled','h','SizeData',m305);
scatter(fddPdT(2,1),diffdPWdT(2,1),[],CAM6_col,'filled','o','SizeData',m300);
scatter(fddPdT(2,2),diffdPWdT(2,2),[],CAM6_col,'filled','o','SizeData',m305);
scatter(fddPdT(2,3),diffdPWdT(2,3),[],CAM6_col,'filled','h','SizeData',m300);
scatter(fddPdT(2,4),diffdPWdT(2,4),[],CAM6_col,'filled','h','SizeData',m305);
line([0.025,0.05,0.1],[0.025,0.05,0.1],'Color','k','LineWidth',1)
xlabel('$\Delta P$','interpreter','latex','FontSize',12,'FontWeight','bold')
xlim([0.02 0.08])
ylim([0.04 0.11])
ylabel('$\delta PW$','interpreter','latex','FontSize',14,'FontWeight','bold')
set(gca,'FontWeight','bold')
set(gca,'FontSize',14)

subplot(2,3,6)
scatter(-Circ_c5c6_295.sig_mn(1),Circ_c5c6_295.Qmn(1),[],CAM5_col,'filled','o','SizeData',m295)
hold on
scatter(-Circ_c5c6_300.sig_mn(1),Circ_c5c6_300.Qmn(1),[],CAM5_col,'filled','o','SizeData',m300)
scatter(-Circ_c5c6_305.sig_mn(1),Circ_c5c6_305.Qmn(1),[],CAM5_col,'filled','o','SizeData',m305)
scatter(-Circ_c5c6_295.sig_mn(3),Circ_c5c6_295.Qmn(3),[],CAM6_col,'filled','o','SizeData',m295)
scatter(-Circ_c5c6_300.sig_mn(3),Circ_c5c6_300.Qmn(3),[],CAM6_col,'filled','o','SizeData',m300)
scatter(-Circ_c5c6_305.sig_mn(3),Circ_c5c6_305.Qmn(3),[],CAM6_col,'filled','o','SizeData',m305)
%scatter(Circ_omega_CRMs_295.sig_mn(CRM_cs),Circ_omega_CRMs_295.Qmn(CRM_cs),[],colCRM(CRM_cs,:),'filled','h','SizeData',m295b);
scatter(-Circ_c5c6_295.sig_mn(2),Circ_c5c6_295.Qmn(2),[],CAM5_col,'filled','h','SizeData',m295)
scatter(-Circ_c5c6_300.sig_mn(2),Circ_c5c6_300.Qmn(2),[],CAM5_col,'filled','h','SizeData',m300)
scatter(-Circ_c5c6_305.sig_mn(2),Circ_c5c6_305.Qmn(2),[],CAM5_col,'filled','h','SizeData',m305)
scatter(-Circ_c5c6_295.sig_mn(4),Circ_c5c6_295.Qmn(4),[],CAM6_col,'filled','h','SizeData',m295)
scatter(-Circ_c5c6_300.sig_mn(4),Circ_c5c6_300.Qmn(4),[],CAM6_col,'filled','h','SizeData',m300)
scatter(-Circ_c5c6_305.sig_mn(4),Circ_c5c6_305.Qmn(4),[],CAM6_col,'filled','h','SizeData',m305)
%scatter(Circ_omega_CRMs_300.sig_mn(CRM_cs),Circ_omega_CRMs_300.Qmn(CRM_cs),[],colCRM(CRM_cs,:),'filled','h','SizeData',m300b);
%scatter(Circ_omega_CRMs_305.sig_mn(CRM_cs),Circ_omega_CRMs_305.Qmn(CRM_cs),[],colCRM(CRM_cs,:),'filled','h','SizeData',m305b);
line([-Circ_c5c6_295.sig_mn(3),-1.5*Circ_c5c6_295.sig_mn(3),-2*Circ_c5c6_295.sig_mn(3)],[Circ_c5c6_295.Qmn(3),1.5*Circ_c5c6_295.Qmn(3),2*Circ_c5c6_295.Qmn(3)],'Color','k','LineWidth',1)
ylabel('$Q (\rm{K \> d^{-1}})$','interpreter','latex')
xlabel('$\sigma (\rm{K \> hPa^{-1}})$','interpreter','latex','FontSize',14,'FontWeight','bold')
ylim([-1.7 -1.1])
set(gca,'FontWeight','bold')
set(gca,'FontSize',14)


% RCE
% calculate mean values
(rce_cycle(1,1)+rce_cycle(1,2)+rce_cycle(1,3))/3 % CAM5 P/PW
(rce_cycle(1,4)+rce_cycle(1,5)+rce_cycle(1,6))/3 % CAM5 P/CWP
(rce_cycle(2,1)+rce_cycle(2,2)+rce_cycle(2,3))/3 % CAM6 P/PW
(rce_cycle(2,4)+rce_cycle(2,5)+rce_cycle(2,6))/3 % CAM6 P/CWP

