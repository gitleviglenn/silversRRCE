#!/bin/bash -l
#PBS -q casper
#PBS -N htc_job
### Request one chunk of resources with 1 CPU and 100GB of memory
#PBS -l select=1:ncpus=1:mem=50GB
#PBS -l walltime=15:00
###PBS -A UNSB0017  
#PBS -A UNSB0036
##PBS -A UFSU0014  
#PBS -j oe

module load ncl

cd /glade/work/levi/scripts/nclscripts/ncl_rrcemip

echo "--------- beginning of driver script for RRCE vs RCE analysis -----------"

# select the desired case: 
# possible cases: figure1draft, figure1, figure2, figure3, analysis, sm, psitempwind

#whichcase=analysis
#whichcase=figure1
#whichcase=figure1draft
whichcase=figure3
#whichcase=psitempwind

echo "selected case is: $whichcase"

case $whichcase in
  figure1draft)
  echo '<<<<<<<<<<<<<<<<< begin analysis for figure 1 draft>>>>>>>>>>>>>>>>>>>>>>>>' 
  ncl 2d_contour_Fig1_map.ncl 'configString="rotating"'
  mv testplot_map.png prw_wind_2panel_C6_300K.png
  ;;
  figure1)
  echo '<<<<<<<<<<<<<<<<< begin analysis for figure 1 >>>>>>>>>>>>>>>>>>>>>>>>' 
  ncl 'levn=19' 'varn="hur"' 'ntime="two"' 'filen="CAM6_GCM_RCE_large300_3D_hur.nc"' 'pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/CAM6_GCM/RCE_large300/3D/"' 2d_contour_UTH_map.ncl 
  mv testplot_map.pdf RCE_RH_300_contmap_cam6_hur_l19.pdf

  ncl 'levn=19' 'varn="hur"' 'ntime="two"' 'filen="CAM6_GCM_RRCE_large300_3D_hur.nc"' 'pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RotRCEMIP/CAM6_GCM/RRCE_large300/3D/"' 2d_contour_UTH_map.ncl 
  mv testplot_map.pdf RRCE_RH_300_contmap_cam6_hur_l19.pdf

  ncl 'levn=19' 'varn="wap500"' 'ntime="two"' 'filen="CAM6_GCM_RCE_large300_2D_wap500.nc"' 'pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/CAM6_GCM/RCE_large300/2D/"' 2d_contour_UTH_map.ncl 
  mv testplot_map.pdf RCE_300_contmap_cam6_1dEnd_w500.pdf
  ncl 'levn=19' 'varn="wap500"' 'ntime="two"' 'filen="CAM6_GCM_RRCE_large300_2D_wap500.nc"' 'pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RotRCEMIP/CAM6_GCM/RRCE_large300/2D/"' 2d_contour_UTH_map.ncl 
  mv testplot_map.pdf RRCE_300_contmap_cam6_1dEnd_w500.pdf
  ## below should produce the precipitable water anomaly plots with velocity vectors overlaid.
  ncl cam_prw_wind_comp.ncl 'configString="rotating"'
  mv prw_wind_comparison.pdf prw_wind_comparison_RRCE.pdf
  ncl cam_prw_wind_comp.ncl 'configString="default"'
  mv prw_wind_comparison.pdf prw_wind_comparison_RCE.pdf
  ;;

  figure3)
  ##ncl rrce_vs_lat_3panel.ncl
  #ncl 'tempS=300' 'modelStr="CAM6"' 'confStr="RRCE"' windtemp_contour.ncl 
  #mv windTemp_3pan.pdf windTemp_c6_rrce_3pan_300K_testT.pdf

  #ncl PminusE_vs_lat_rrce.ncl

  ncl 'tempS=300' 'modelStr="CAM6"' 'confStr="RRCE"' rrce_vs_lat_fig3.ncl
  ;;

  analysis)
  echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< compute Vrms>>>>>>>>>>>>>>>>>>>>>>>>>>>' 
  
  ncl vrms_rceVrrce.ncl
  ;;

  psitempwind)
  echo '<<<<<<<<<<<<<<<<< begin wind temp calculations >>>>>>>>>>>>>>>>>>>>>>>>>' 
  
  ncl 'tempS=300' 'modelStr="CAM6"' 'confStr="RRCE"' windtemp_contour.ncl 
  mv windTemp_3pan.pdf windTemp_c6_rrce_3pan_300K_100d.pdf

  echo '<<<<<<<<<<<<<<<<< begin PSI calculations >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' 

  ncl 'tempS=300' 'modelStr="CAM6"' 'confStr="RRCE"' psi_contour.ncl 
  mv testplot_psi_new.pdf rrce_c6_psi_300K_25d.pdf

  ncl 'tempS=300' 'modelStr="CAM6"' 'confStr="RCE"' psi_contour.ncl 
  mv testplot_psi_new.pdf rce_c6_psi_300K_25d.pdf
  ;;
  *)
  echo '<<<<<<<<<<<<<<<<<< WARNING!! no analysis script run >>>>>>>>>>>>>>>>>>>>>>' 
  ;;
esac

##
## CAM5
#ncl 'Stemp=295' 'filen="CAM5_GCM_RRCE_large295_3D_ta.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM5_GCM/RRCE_large295/3D/"' psi_contour.ncl 
#mv testplot_4pan_psi.pdf rrce_cam5_4pan_psi_295K.pdf
#ncl 'Stemp=300' 'filen="CAM5_GCM_RRCE_large300_3D_ta.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM5_GCM/RRCE_large300/3D/"' psi_contour.ncl 
#mv testplot_4pan_psi.pdf rrce_cam5_4pan_psi_300K.pdf
#ncl 'Stemp=305' 'filen="CAM5_GCM_RRCE_large305_3D_ta.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM5_GCM/RRCE_large305/3D/"' psi_contour.ncl 
#mv testplot_4pan_psi.pdf rrce_cam5_4pan_psi_305K.pdf

#ncl 'Stemp=295' 'filen="CAM5_GCM_RRCE_large295_3D_ta.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM5_GCM/RRCE_large295/3D/"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_cam5_3pan_295K.pdf
#ncl 'Stemp=300' 'filen="CAM5_GCM_RRCE_large300_3D_ta.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM5_GCM/RRCE_large300/3D/"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_cam5_3pan_300K.pdf
#ncl 'Stemp=305' 'filen="CAM5_GCM_RRCE_large305_3D_ta.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM5_GCM/RRCE_large305/3D/"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_cam5_3pan_305K.pdf
#

##
## CAM6
#ncl 'tempS=300' 'modelStr="CAM6"' 'confStr="RRCE"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_c6_rrce_3pan_300K_100d.pdf
#ncl 'tempS=300' 'modelStr="CAM6"' 'confStr="RCE"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_c6_rce_3pan_300K_100d.pdf
#ncl 'tempS=305' 'modelStr="CAM6"' 'confStr="RRCE"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_c6_rrce_3pan_305K_100d.pdf
#ncl 'tempS=305' 'modelStr="CAM6"' 'confStr="RCE"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_c6_rce_3pan_305K_100d.pdf
#ncl 'tempS=295' 'modelStr="CAM6"' 'confStr="RRCE"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_c6_rrce_3pan_295K_100d.pdf
#ncl 'tempS=295' 'modelStr="CAM6"' 'confStr="RCE"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_c6_rce_3pan_295K_100d.pdf
#ncl 'tempS=295' 'modelStr="CAM5"' 'confStr="RRCE"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_c5_rrce_3pan_295K.pdf
#ncl 'tempS=295' 'modelStr="CAM5"' 'confStr="RCE"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_c5_rce_3pan_295K.pdf

#ncl 'Stemp=295' 'filen="CAM6_GCM_RRCE_large295_3D_ta.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM6_GCM/RRCE_large295/3D/"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_3pan_295K_a.pdf
#ncl 'Stemp=300' 'filen="CAM6_GCM_RRCE_large300_3D_ta.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM6_GCM/RRCE_large300/3D/"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_3pan_300K.pdf
#ncl 'Stemp=305' 'filen="CAM6_GCM_RRCE_large305_3D_ta.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM6_GCM/RRCE_large305/3D/"' windtemp_contour.ncl 
#mv windTemp_3pan.pdf windTemp_3pan_305K.pdf
##

#echo '<<<<<<<<<<<<<<<<< begin PSI calculations >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' 

#ncl 'tempS=295' 'modelStr="CAM5"' 'confStr="RRCE"' psi_contour.ncl 
#mv testplot_psi_new.pdf rrce_c5_psi_295K.pdf
#ncl 'tempS=295' 'modelStr="CAM6"' 'confStr="RRCE"' psi_contour.ncl 
#mv testplot_psi_new.pdf rrce_c6_psi_295K_100d.pdf
#ncl 'tempS=295' 'modelStr="CAM5"' 'confStr="RCE"' psi_contour.ncl 
#mv testplot_psi_new.pdf rce_c5_psi_295K_1yr.pdf
#ncl 'tempS=295' 'modelStr="CAM6"' 'confStr="RCE"' psi_contour.ncl 
#mv testplot_psi_new.pdf rce_c6_psi_295K_1yr.pdf
#ncl 'tempS=305' 'modelStr="CAM5"' 'confStr="RRCE"' psi_contour.ncl 
#mv testplot_psi_new.pdf rrce_c5_psi_305K.pdf
#ncl 'tempS=305' 'modelStr="CAM6"' 'confStr="RRCE"' psi_contour.ncl 
#mv testplot_psi_new.pdf rrce_c6_psi_305K_100d.pdf
##ncl 'tempS=305' 'modelStr="CAM5"' 'confStr="RCE"' psi_contour.ncl 
##mv testplot_psi_new.pdf rce_c5_psi_305K.pdf
#ncl 'tempS=305' 'modelStr="CAM6"' 'confStr="RCE"' psi_contour.ncl 
#mv testplot_psi_new.pdf rce_c6_psi_305K_1yr.pdf
#ncl 'tempS=300' 'modelStr="CAM5"' 'confStr="RRCE"' psi_contour.ncl 
#mv testplot_psi_new.pdf rrce_c5_psi_300K.pdf
#ncl 'tempS=300' 'modelStr="CAM5"' 'confStr="RCE"' psi_contour.ncl 
#mv testplot_psi_new.pdf rce_c5_psi_300K.pdf
#ncl 'tempS=300' 'modelStr="CAM6"' 'confStr="RRCE"' psi_contour.ncl 
#mv testplot_psi_new.pdf rrce_c6_psi_300K_25d.pdf
#ncl 'tempS=300' 'modelStr="CAM6"' 'confStr="RCE"' psi_contour.ncl 
#mv testplot_psi_new.pdf rce_c6_psi_300K_25d.pdf

#ncl 'tempS=300' 'modelStr="CAM6"' 'confStr="RRCE"' psi_contour.ncl 
#mv testplot_psi_new.pdf rrce_c6_psi_300K_quarterglobe_100d.pdf

#ncl 'Stemp=300' 'filen="CAM6_GCM_RRCE_large300_3D_ta.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM6_GCM/RRCE_large300/3D/"' psi_contour.ncl 
#mv testplot_4pan_psi.pdf rrce_4pan_psi_300K.pdf
#ncl 'Stemp=305' 'filen="CAM6_GCM_RRCE_large305_3D_ta.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM6_GCM/RRCE_large305/3D/"' psi_contour.ncl 
#mv testplot_4pan_psi.pdf rrce_4pan_psi_305K.pdf

#ncl 'Stemp=295' 'filen="CAM6_GCM_RCE_large295_3D_ta.nc"' 'pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/CAM6_GCM/RCE_large295/3D/"' psi_contour.ncl 
#mv testplot_4pan_psi.pdf rce_4pan_psi_295K.pdf
#ncl 'Stemp=300' 'filen="CAM6_GCM_RCE_large300_3D_ta.nc"' 'pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/CAM6_GCM/RCE_large300/3D/"' psi_contour.ncl 
#mv testplot_4pan_psi.pdf rce_4pan_psi_300K.pdf
#ncl 'Stemp=305' 'filen="CAM6_GCM_RCE_large305_3D_ta.nc"' 'pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/CAM6_GCM/RCE_large305/3D/"' psi_contour.ncl 
#mv testplot_4pan_psi.pdf rce_4pan_psi_305K.pdf

## below are commands to compute upper tropospheric humidity contour plots: 
#
##ncl 'levn=21' 'varn="mc"' 'ntime="two"' 'filen="CAM6_GCM_RRCE_large300_3D_mc.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM6_GCM/RRCE_large300/3D/"' 2d_contour_UTH_map.ncl 
##mv testplot_map.eps RRCE_mc_300_contmap_cam6_l21.eps
##
##ncl 'levn=21' 'varn="mc"' 'ntime="two"' 'filen="CAM6_GCM_RCE_large300_3D_mc.nc"' 'pathn="/glade/scratch/levi/RCEMIP/CAM6_GCM/RCE_large300/3D/"' 2d_contour_UTH_map.ncl 
##mv testplot_map.eps RCE_mc_300_contmap_cam6_l21.eps
#
#ncl 'levn=17' 'varn="hur"' 'ntime="two"' 'filen="CAM5_GCM_RRCE_large300_3D_hur.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM5_GCM/RRCE_large300/3D/"' 2d_contour_UTH_map.ncl 
#mv testplot_map.eps RRCE_RH_300_contmap_cam5_l17.eps
##
#ncl 'levn=17' 'varn="hur"' 'ntime="two"' 'filen="CAM5_GCM_RCE_large300_3D_hur.nc"' 'pathn="/glade/scratch/levi/RCEMIP/CAM5_GCM/RCE_large300/3D/"' 2d_contour_UTH_map.ncl 
#mv testplot_map.eps RCE_RH_300_contmap_cam5_l17.eps
##
#ncl 'levn=19' 'varn="hur"' 'ntime="two"' 'filen="CAM6_GCM_RRCE_large300_3D_hur.nc"' 'pathn="/glade/scratch/levi/RotRCEMIP/CAM6_GCM/RRCE_large300/3D/"' 2d_contour_UTH_map.ncl 
#mv testplot_map.eps RRCE_RH_300_contmap_cam6_l19.eps
##
#ncl 'levn=19' 'varn="hur"' 'ntime="two"' 'filen="CAM6_GCM_RCE_large300_3D_hur.nc"' 'pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/CAM6_GCM/RCE_large300/3D/"' 2d_contour_UTH_map.ncl 
#mv testplot_map.pdf RCE_RH_300_contmap_cam6_hur_l19.pdf
#ncl 'levn=19' 'varn="wap500"' 'ntime="two"' 'filen="CAM6_GCM_RCE_large300_2D_wap500.nc"' 'pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/CAM6_GCM/RCE_large300/2D/"' 2d_contour_UTH_map.ncl 
#ncl 'levn=19' 'varn="wap500"' 'ntime="two"' 'filen="CAM6_GCM_RRCE_large300_2D_wap500.nc"' 'pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RotRCEMIP/CAM6_GCM/RRCE_large300/2D/"' 2d_contour_UTH_map.ncl 
#mv testplot_map.pdf RRCE_300_contmap_cam6_1dEnd_w500.pdf

#ncl 'levn=19' 'varn="wap500"' 'ntime="two"' 'filen="CAM6_GCM_RCE_large305_2D_wap500.nc"' 'pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/CAM6_GCM/RCE_large305/2D/"' 2d_contour_UTH_map.ncl 
#mv testplot_map.pdf RCE_RH_305_contmap_cam6_1yearEnd_w500.pdf
#
#
##ls /glade/scratch/levi/RCEMIP/CAM5_GCM/RCE_large300/3D/CAM5_GCM_RCE_large300_3D_hur.nc
##ls /glade/scratch/levi/RotRCEMIP/CAM5_GCM/RRCE_large300/3D/CAM5_GCM_RRCE_large300_3D_hur.nc
