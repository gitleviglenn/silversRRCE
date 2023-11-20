;***********************************************************************************
; rrce_vs_lat_fig3.ncl
;***********************************************************************************
; derived originally from the script rrce_vs_lat_4panel.ncl
;
; modifications: 
;    - make final figure 7 panels
;    - plot results from only 1 model, ideally either cam5 or cam6
;    - add additional panels.   the goal is to add the following: 
;          P-E vs latitude
;          filled contour plot of temp anomaly as a function of p and lat
;          filled contour plot of zonal mean zonal wind as a fucntion of p and lat
;
; code from Alyssa:
; /glade/work/alyssas/RRCE_kevin_levi/plot_TC_counts_gencounts_size_vs_lat.py
;
; levi silvers							nov 2023
;***********************************************************************************
; These files are loaded by default in NCL V6.2.0 and newer
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "/glade/work/levi/scripts/nclscripts/lib/trimPNG.ncl"
;***********************************************************************************

begin
;***********************************************************************************
; read in netCDF file
;***********************************************************************************

;path_cheyenne="/glade/scratch/levi/RotRCEMIP/"
path_2pp  = "/glade/derecho/scratch/levi/fromCheyenne/postp/"
path_rce  = path_2pp+"RCEMIP/"
path_rrce = path_2pp+"RotRCEMIP/"

path_C5="CAM5_GCM/";
path_C6="CAM6_GCM/";
path_2mod="CAM6_GCM";

;configStr="RRCE"
 
timelength=8760 ; 1 year
endtime1=17520  
endtime2=26278 ; 3 years 
startime1=endtime1-timelength+1
startime2=endtime2-2*timelength+1

PI=acos(-1.) ; compute pi

halflat=95
halflatp1=halflat+1
lthick2=(/5,10,15/)

varselect = 0; default is varselect = 0

var2read="prw" ; default case 
yaxistitle  = "PW [kg m^-2]"
scale = 1
; probably should set up another case for the plotting of anomalies
yaxistitle  = "PW anomaly[kg m^-2]"

;***********************************************************************************
; read in files of PW 
;***********************************************************************************
; prw
; RRCE files
configStr="RRCE"

; 0D prw
file_prw_avg_6_295=path_rrce+path_2mod+"/"+configStr+"_large295/0D/"+path_2mod+"_"+configStr+"_large295_0D_prw_avg.nc"
file_prw_avg_6_300=path_rrce+path_2mod+"/"+configStr+"_large300/0D/"+path_2mod+"_"+configStr+"_large300_0D_prw_avg.nc"
file_prw_avg_6_305=path_rrce+path_2mod+"/"+configStr+"_large305/0D/"+path_2mod+"_"+configStr+"_large305_0D_prw_avg.nc"

; 2D prw 
file_prw_2D_6a=path_rrce+path_2mod+"/"+configStr+"_large295/2D/"+path_2mod+"_"+configStr+"_large295_2D_"+var2read+".nc"
file_prw_2D_6b=path_rrce+path_2mod+"/"+configStr+"_large300/2D/"+path_2mod+"_"+configStr+"_large300_2D_"+var2read+".nc"
file_prw_2D_6c=path_rrce+path_2mod+"/"+configStr+"_large305/2D/"+path_2mod+"_"+configStr+"_large305_2D_"+var2read+".nc"

; 2D pr
file_pr_2D_6a=path_rrce+path_2mod+"/"+configStr+"_large295/2D/"+path_2mod+"_"+configStr+"_large295_2D_pr.nc"
file_pr_2D_6b=path_rrce+path_2mod+"/"+configStr+"_large300/2D/"+path_2mod+"_"+configStr+"_large300_2D_pr.nc"
file_pr_2D_6c=path_rrce+path_2mod+"/"+configStr+"_large305/2D/"+path_2mod+"_"+configStr+"_large305_2D_pr.nc"

; 2D evspsbl 
file_evspsbl_2D_6a=path_rrce+path_2mod+"/"+configStr+"_large295/2D/"+path_2mod+"_"+configStr+"_large295_2D_evspsbl.nc"
file_evspsbl_2D_6b=path_rrce+path_2mod+"/"+configStr+"_large300/2D/"+path_2mod+"_"+configStr+"_large300_2D_evspsbl.nc"
file_evspsbl_2D_6c=path_rrce+path_2mod+"/"+configStr+"_large305/2D/"+path_2mod+"_"+configStr+"_large305_2D_evspsbl.nc"

; RCE files
configStr="RCE"
; 
file_prw_2D_6a_rce=path_rce+path_2mod+"/"+configStr+"_large295/2D/"+path_2mod+"_"+configStr+"_large295_2D_"+var2read+".nc"
file_prw_2D_6b_rce=path_rce+path_2mod+"/"+configStr+"_large300/2D/"+path_2mod+"_"+configStr+"_large300_2D_"+var2read+".nc"
file_prw_2D_6c_rce=path_rce+path_2mod+"/"+configStr+"_large305/2D/"+path_2mod+"_"+configStr+"_large305_2D_"+var2read+".nc"

; 2D pr
file_pr_2D_6a_rce=path_rce+path_2mod+"/"+configStr+"_large295/2D/"+path_2mod+"_"+configStr+"_large295_2D_pr.nc"
file_pr_2D_6b_rce=path_rce+path_2mod+"/"+configStr+"_large300/2D/"+path_2mod+"_"+configStr+"_large300_2D_pr.nc"
file_pr_2D_6c_rce=path_rce+path_2mod+"/"+configStr+"_large305/2D/"+path_2mod+"_"+configStr+"_large305_2D_pr.nc"

; 2d evspsbl
file_evspsbl_2D_6a_rce=path_rce+path_2mod+"/"+configStr+"_large295/2D/"+path_2mod+"_"+configStr+"_large295_2D_evspsbl.nc"
file_evspsbl_2D_6b_rce=path_rce+path_2mod+"/"+configStr+"_large300/2D/"+path_2mod+"_"+configStr+"_large300_2D_evspsbl.nc"
file_evspsbl_2D_6c_rce=path_rce+path_2mod+"/"+configStr+"_large305/2D/"+path_2mod+"_"+configStr+"_large305_2D_evspsbl.nc"

  print("@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$")
  print("file to be read is: "+file_prw_2D_6b)
  print("evspsbl file to be read is: "+file_evspsbl_2D_6b_rce)
  print("file to be read is: "+file_prw_2D_6b_rce)
  print("@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$@#$")

; for 1D case of prw
fc6_295=addfile(file_prw_avg_6_295,"r")
fc6_300=addfile(file_prw_avg_6_300,"r")
fc6_305=addfile(file_prw_avg_6_305,"r")
c6a_prw=fc6_295->prw_avg(startime1:endtime1)
c6b_prw=fc6_300->prw_avg(startime1:endtime1)
c6c_prw=fc6_305->prw_avg(startime1:endtime1)

  ; RRCE
  generic_2d_fname_c6     =addfile(file_pr_2D_6a,"r")
  c6a_2d_pr     =generic_2d_fname_c6->pr(startime1:endtime1,:,:)
  generic_2d_fname_c6     =addfile(file_pr_2D_6b,"r")
  c6b_2d_pr     =generic_2d_fname_c6->pr(startime1:endtime1,:,:)
  generic_2d_fname_c6     =addfile(file_pr_2D_6c,"r")
  c6c_2d_pr     =generic_2d_fname_c6->pr(startime1:endtime1,:,:)

  generic_2d_fname_c6     =addfile(file_evspsbl_2D_6a,"r")
  c6a_2d_evp     =generic_2d_fname_c6->evspsbl(startime1:endtime1,:,:)
  generic_2d_fname_c6     =addfile(file_evspsbl_2D_6b,"r")
  c6b_2d_evp     =generic_2d_fname_c6->evspsbl(startime1:endtime1,:,:)
  generic_2d_fname_c6     =addfile(file_evspsbl_2D_6c,"r")
  c6c_2d_evp     =generic_2d_fname_c6->evspsbl(startime1:endtime1,:,:)

  ; RCE
  generic_2d_fname_c6_rce =addfile(file_pr_2D_6a_rce,"r")
  c6a_rce_2d_pr =generic_2d_fname_c6_rce->pr(startime2:endtime2,:,:)
  generic_2d_fname_c6_rce =addfile(file_pr_2D_6b_rce,"r")
  c6b_rce_2d_pr =generic_2d_fname_c6_rce->pr(startime2:endtime2,:,:)
  generic_2d_fname_c6_rce =addfile(file_pr_2D_6c_rce,"r")
  c6c_rce_2d_pr =generic_2d_fname_c6_rce->pr(startime2:endtime2,:,:)
;file_evspbl_2D_6a_rce
  generic_2d_fname_c6     =addfile(file_evspsbl_2D_6a_rce,"r")
  c6a_2d_evp_rce     =generic_2d_fname_c6->evspsbl(startime1:endtime1,:,:)
  generic_2d_fname_c6     =addfile(file_evspsbl_2D_6b_rce,"r")
  c6b_2d_evp_rce     =generic_2d_fname_c6->evspsbl(startime1:endtime1,:,:)
  generic_2d_fname_c6     =addfile(file_evspsbl_2D_6c_rce,"r")
  c6c_2d_evp_rce     =generic_2d_fname_c6->evspsbl(startime1:endtime1,:,:)

  ; RRCE
  generic_2d_fname_c6     =addfile(file_prw_2D_6a,"r")
  c6a_2d_prw     =generic_2d_fname_c6->prw(startime1:endtime1,:,:)
  generic_2d_fname_c6     =addfile(file_prw_2D_6b,"r")
  c6b_2d_prw     =generic_2d_fname_c6->prw(startime1:endtime1,:,:)
  generic_2d_fname_c6     =addfile(file_prw_2D_6c,"r")
  c6c_2d_prw     =generic_2d_fname_c6->prw(startime1:endtime1,:,:)
  ; RCE
  generic_2d_fname_c6_rce =addfile(file_prw_2D_6a_rce,"r")
  c6a_rce_2d_prw =generic_2d_fname_c6_rce->prw(startime2:endtime2,:,:)
  generic_2d_fname_c6_rce =addfile(file_prw_2D_6b_rce,"r")
  c6b_rce_2d_prw =generic_2d_fname_c6_rce->prw(startime2:endtime2,:,:)
  generic_2d_fname_c6_rce =addfile(file_prw_2D_6c_rce,"r")
  c6c_rce_2d_prw =generic_2d_fname_c6_rce->prw(startime2:endtime2,:,:)

  printVarSummary(c6a_2d_prw)

; print out some of the garbage...
print("mean values of prw for CAM6 295K: "+dim_avg_n(c6a_prw,0)+" and 300K: "+dim_avg_n(c6b_prw,0)+" and 305K: "+dim_avg_n(c6c_prw,0))

;*************************************************************
; read in files for the temperature and meridional wind
;*************************************************************

; read in variables from command line of driver script
if (.not.tempS) then
  print("temp string not present using 295")
  Stemp=295
else
  print("temp string present")
  Stemp=tempS
end if

if (modelStr .eq. "CAM6") then
  print("using data from CAM6")
  model="CAM6"
else
  print("using data from CAM5")
  model="CAM5"
end if

if (confStr .eq. "RCE") then
  print("using RCE configuration")
  conf="RCE"
  pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/"
else
  print("using RRCE configuration")
  conf="RRCE"  ;  = f[:]->PSL(nstart:nend,:)
  pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RotRCEMIP/"
end if

;path_rrce+path_C6+configStr+"_large305
;path2file=pathn+model+"_GCM/"+conf+"_large"+Stemp+"/3D/"+model+"_GCM_"+conf+"_large"+Stemp
path2file=path_rrce+model+"_GCM/"+conf+"_large"+Stemp+"/3D/"+model+"_GCM_"+conf+"_large"+Stemp
;path2file=path_rrce+path_C6+"/"+conf+"_large"+Stemp+"/3D/"+model+"_GCM_"+conf+"_large"+Stemp

filea = path2file+"_3D_ta_100d.nc"
fileb = path2file+"_3D_ua_100d.nc"

  print("filea is: "+filea)
  print("file2 is: "+fileb)

maintitle="main title"
file1 = addfile(filea,"r")
file2 = addfile(fileb,"r")

field_ta = file1->ta(:,:,:,:)
field_ua = file2->ua(:,:,:,:)

field_lat = file1->lat

dims  = dimsizes(field_ua)
ntime = dims(0)
nlev  = dims(1)
nlat  = dims(2)
nlon  = dims(3)

nlevm1 = nlev-1
nsims=6

temp_prof = new((/nlev,nlat/),float)
PminusE   = new((/nsims,halflatp1/), float)
temp_1hem = new((/nlev,halflatp1/), float)
temp_1h_a = new((/nlev,halflatp1/), float)
temp_1h_b = new((/nlev,halflatp1/), float)
uznm_1hem = new((/nlev,halflatp1/), float)
uznm_1h_a = new((/nlev,halflatp1/), float)
uznm_1h_b = new((/nlev,halflatp1/), float)

;var_to_plot=scale*dim_avg_n(field_ta,0)
var_to_plot_a  =dim_avg_n(field_ta,0); 30x192x288
var_to_plot2_a =dim_avg_n(field_ua,0)

; compute averages over longitude:
var_to_plot    =dim_avg_n(var_to_plot_a,2); 30x192
var_to_plot2   =dim_avg_n(var_to_plot2_a,2)

; compute the time averaged vertical temperature profile: 
var_temp_vmn=dim_avg_n(var_to_plot,1); 

; compute anomalous temperature field

  print("number of levels is: "+nlev)
count = 0
;if (dim .eq. 1 .or. dim .eq. 3) then
do while (count .le. nlev-1) 
  temp_prof(count,:) = var_to_plot(count,:)-var_temp_vmn(count)
  count = count +1
    print("count value is: "+count)
end do

; compute hemispheric average of time averaged anomalies
 temp_1h_a = temp_prof(:,:halflat)
 temp_1h_b = temp_prof(:,halflatp1::-1)

  printVarSummary(temp_1h_a)
temp_1hem = (temp_1h_a+temp_1h_b)/2
temp_1hem = temp_1hem(:,::-1)
  printVarSummary(temp_1hem)

  printVarSummary(var_temp_vmn)
  print("var_temp_vmn: "+var_temp_vmn)

  printVarSummary(temp_prof)
  printMinMax(temp_prof,False)

  print("field _ lat: "+field_lat(halflatp1:))

;lat_sin=sin(field_lat(halflatp1:)/180*PI)
lat_sin=field_lat(halflatp1:)
  printVarSummary(lat_sin)
  print("lat_sin: "+lat_sin)
temp_1hem!0="lev"
temp_1hem&lev=field_ua&lev
;temp_1hem!1="lat"
temp_1hem!1="lat"
temp_1hem&lat=lat_sin
;temp_1hem&lat=field_lat(halflatp1:)

  printVarSummary(temp_1hem)

temp_prof!0="lev"
temp_prof&lev=field_ua&lev
temp_prof!1="lat"
temp_prof&lat=field_ua&lat

var_to_plot_ua=dim_avg_n(field_ua,0)
; compuate average over longitudes
var_to_plot2_u=dim_avg_n(var_to_plot_ua,2)

;uznm_1h_a
uznm_1h_a = var_to_plot2_u(:,:halflat)
uznm_1h_b = var_to_plot2(:,halflatp1::-1)
uznm_1hem = (uznm_1h_a+uznm_1h_b)/2
uznm_1hem = uznm_1hem(:,::-1)

var_to_plot2!1="lat"
var_to_plot2&lat=field_ua&lat
var_to_plot2!0="lev"
var_to_plot2&lev=field_ua&lev

uznm_1hem!0="lev"
uznm_1hem&lev=field_ua&lev
uznm_1hem!1="lat"
uznm_1hem&lat=lat_sin
;uznm_1hem&lat=field_lat(halflatp1:)

  printVarSummary(uznm_1hem)

;*************************************************************
; compute the cosine weighted average
;*************************************************************
; read the latitude array
;PI=acos(-1.) ; compute pi
rad  = 4.0*atan(1.0)/180.0
;latitude_c5=generic_2d_fname->lat(:)
latitude_c6=generic_2d_fname_c6->lat(:)

;halflat=95
;halflatp1=halflat+1
lat_c6_plot=latitude_c6(:halflat)

clat6 = cos(latitude_c6*rad)
  
f6a_rce_wgt_ave     = wgt_areaave(c6a_rce_2d_prw,clat6,1.0,0)
f6b_rce_wgt_ave     = wgt_areaave(c6b_rce_2d_prw,clat6,1.0,0)
f6c_rce_wgt_ave     = wgt_areaave(c6c_rce_2d_prw,clat6,1.0,0)
f6a_wgt_ave         = wgt_areaave(c6a_2d_prw,clat6,1.0,0)
f6b_wgt_ave         = wgt_areaave(c6b_2d_prw,clat6,1.0,0)
f6c_wgt_ave         = wgt_areaave(c6c_2d_prw,clat6,1.0,0)

  print(" f6a_wgt_ave should be a time series ")
  printVarSummary(f6a_wgt_ave)

;*************************************************************

; compute the zonal mean of the 2D PW field, don't average in time yet
; 2 models, 3 SST, 2 configurations... 12 calculations

;; compute zonal mean profiles for rrce

; precipitable water 
c6a_prw_zmn      = dim_avg_n(c6a_2d_prw,2)  ; should be time,lat
c6a_prw_tzmn     = dim_avg_n(c6a_prw_zmn,0) ; should be just lat
c6a_prw_tzmn_a   = dim_avg_n(c6a_prw_zmn(:,:halflat),0)  ; should be lat
c6a_prw_tzmn_b   = dim_avg_n(c6a_prw_zmn(:,halflatp1::-1),0)  ; should be lat
c6a_prw_tzmn_c   = (c6a_prw_tzmn_a+c6a_prw_tzmn_b)/2
c6a_prw_tmn      = dim_avg_n(f6a_wgt_ave,0) ; should be single value

; precipitation
c6a_pr_zmn       = dim_avg_n(c6a_2d_pr,2)  ; should be time,lat
c6a_pr_tzmn_a    = dim_avg_n(c6a_pr_zmn(:,:halflat),0)  ; should be lat
c6a_pr_tzmn_b    = dim_avg_n(c6a_pr_zmn(:,halflatp1::-1),0)  ; should be lat
c6a_pr_tzmn_c    = (c6a_pr_tzmn_a+c6a_pr_tzmn_b)/2

c6b_pr_zmn       = dim_avg_n(c6b_2d_pr,2)  ; should be time,lat
c6b_pr_tzmn_a    = dim_avg_n(c6b_pr_zmn(:,:halflat),0)  ; should be lat
c6b_pr_tzmn_b    = dim_avg_n(c6b_pr_zmn(:,halflatp1::-1),0)  ; should be lat
c6b_pr_tzmn_c    = (c6b_pr_tzmn_a+c6b_pr_tzmn_b)/2

c6c_pr_zmn       = dim_avg_n(c6c_2d_pr,2)  ; should be time,lat
c6c_pr_tzmn_a    = dim_avg_n(c6c_pr_zmn(:,:halflat),0)  ; should be lat
c6c_pr_tzmn_b    = dim_avg_n(c6c_pr_zmn(:,halflatp1::-1),0)  ; should be lat
c6c_pr_tzmn_c    = (c6c_pr_tzmn_a+c6c_pr_tzmn_b)/2

; evaporation
c6a_evp_zmn       = dim_avg_n(c6a_2d_evp,2)  ; should be time,lat
c6a_evp_tzmn_a    = dim_avg_n(c6a_evp_zmn(:,:halflat),0)  ; should be lat
c6a_evp_tzmn_b    = dim_avg_n(c6a_evp_zmn(:,halflatp1::-1),0)  ; should be lat
c6a_evp_tzmn_c    = (c6a_evp_tzmn_a+c6a_evp_tzmn_b)/2

c6b_evp_zmn       = dim_avg_n(c6b_2d_evp,2)  ; should be time,lat
c6b_evp_tzmn_a    = dim_avg_n(c6b_evp_zmn(:,:halflat),0)  ; should be lat
c6b_evp_tzmn_b    = dim_avg_n(c6b_evp_zmn(:,halflatp1::-1),0)  ; should be lat
c6b_evp_tzmn_c    = (c6b_evp_tzmn_a+c6b_evp_tzmn_b)/2

c6c_evp_zmn       = dim_avg_n(c6c_2d_evp,2)  ; should be time,lat
c6c_evp_tzmn_a    = dim_avg_n(c6c_evp_zmn(:,:halflat),0)  ; should be lat
c6c_evp_tzmn_b    = dim_avg_n(c6c_evp_zmn(:,halflatp1::-1),0)  ; should be lat
c6c_evp_tzmn_c    = (c6c_evp_tzmn_a+c6c_evp_tzmn_b)/2

; precipitable water 
c6b_prw_zmn      = dim_avg_n(c6b_2d_prw,2)
c6b_prw_tzmn     = dim_avg_n(c6b_prw_zmn,0)
c6b_prw_tzmn_a   = dim_avg_n(c6b_prw_zmn(:,:halflat),0)  ; should be lat
c6b_prw_tzmn_b   = dim_avg_n(c6b_prw_zmn(:,halflatp1::-1),0)  ; should be lat
c6b_prw_tzmn_c   = (c6b_prw_tzmn_a+c6b_prw_tzmn_b)/2
c6b_prw_tmn      = dim_avg_n(f6b_wgt_ave,0)

c6c_prw_zmn      = dim_avg_n(c6c_2d_prw,2)
c6c_prw_tzmn     = dim_avg_n(c6c_prw_zmn,0)
c6c_prw_tzmn_a   = dim_avg_n(c6c_prw_zmn(:,:halflat),0)  ; should be lat
c6c_prw_tzmn_b   = dim_avg_n(c6c_prw_zmn(:,halflatp1::-1),0)  ; should be lat
c6c_prw_tzmn_c   = (c6c_prw_tzmn_a+c6c_prw_tzmn_b)/2
c6c_prw_tmn      = dim_avg_n(f6c_wgt_ave,0)

c6a_rce_prw_zmn  = dim_avg_n(c6a_rce_2d_prw,2)
c6a_rce_prw_tzmn = dim_avg_n(c6a_rce_prw_zmn,0)
c6a_rce_prw_tzmn_a   = dim_avg_n(c6a_rce_prw_zmn(:,:halflat),0)  ; should be lat
c6a_rce_prw_tzmn_b   = dim_avg_n(c6a_rce_prw_zmn(:,halflatp1::-1),0)  ; should be lat
c6a_rce_prw_tzmn_c   = (c6a_rce_prw_tzmn_a+c6a_rce_prw_tzmn_b)/2
c6a_rce_prw_tmn  = dim_avg_n(f6a_rce_wgt_ave,0)

c6b_rce_prw_zmn  = dim_avg_n(c6b_rce_2d_prw,2)
c6b_rce_prw_tzmn = dim_avg_n(c6b_rce_prw_zmn,0)
c6b_rce_prw_tzmn_a   = dim_avg_n(c6b_rce_prw_zmn(:,:halflat),0)  ; should be lat
c6b_rce_prw_tzmn_b   = dim_avg_n(c6b_rce_prw_zmn(:,halflatp1::-1),0)  ; should be lat
c6b_rce_prw_tzmn_c   = (c6b_rce_prw_tzmn_a+c6b_rce_prw_tzmn_b)/2
c6b_rce_prw_tmn  = dim_avg_n(f6b_rce_wgt_ave,0)

c6c_rce_prw_zmn  = dim_avg_n(c6c_rce_2d_prw,2)
c6c_rce_prw_tzmn = dim_avg_n(c6c_rce_prw_zmn,0)
c6c_rce_prw_tzmn_a   = dim_avg_n(c6c_rce_prw_zmn(:,:halflat),0)  ; should be lat
c6c_rce_prw_tzmn_b   = dim_avg_n(c6c_rce_prw_zmn(:,halflatp1::-1),0)  ; should be lat
c6c_rce_prw_tzmn_c   = (c6c_rce_prw_tzmn_a+c6c_rce_prw_tzmn_b)/2
c6c_rce_prw_tmn  = dim_avg_n(f6c_rce_wgt_ave,0)

; evaporation
c6a_rce_evp_zmn       = dim_avg_n(c6a_2d_evp_rce,2)  ; should be time,lat
c6a_rce_evp_tzmn_a    = dim_avg_n(c6a_rce_evp_zmn(:,:halflat),0)  ; should be lat
c6a_rce_evp_tzmn_b    = dim_avg_n(c6a_rce_evp_zmn(:,halflatp1::-1),0)  ; should be lat
c6a_rce_evp_tzmn_c    = (c6a_rce_evp_tzmn_a+c6a_rce_evp_tzmn_b)/2

c6b_rce_evp_zmn       = dim_avg_n(c6b_2d_evp_rce,2)  ; should be time,lat
c6b_rce_evp_tzmn_a    = dim_avg_n(c6b_rce_evp_zmn(:,:halflat),0)  ; should be lat
c6b_rce_evp_tzmn_b    = dim_avg_n(c6b_rce_evp_zmn(:,halflatp1::-1),0)  ; should be lat
c6b_rce_evp_tzmn_c    = (c6b_rce_evp_tzmn_a+c6b_rce_evp_tzmn_b)/2

c6c_rce_evp_zmn       = dim_avg_n(c6c_2d_evp_rce,2)  ; should be time,lat
c6c_rce_evp_tzmn_a    = dim_avg_n(c6c_rce_evp_zmn(:,:halflat),0)  ; should be lat
c6c_rce_evp_tzmn_b    = dim_avg_n(c6c_rce_evp_zmn(:,halflatp1::-1),0)  ; should be lat
c6c_rce_evp_tzmn_c    = (c6c_rce_evp_tzmn_a+c6c_rce_evp_tzmn_b)/2

; precipitation
c6a_rce_pr_zmn       = dim_avg_n(c6a_rce_2d_pr,2)  ; should be time,lat
c6a_rce_pr_tzmn_a    = dim_avg_n(c6a_rce_pr_zmn(:,:halflat),0)  ; should be lat
c6a_rce_pr_tzmn_b    = dim_avg_n(c6a_rce_pr_zmn(:,halflatp1::-1),0)  ; should be lat
c6a_rce_pr_tzmn_c    = (c6a_rce_pr_tzmn_a+c6a_rce_pr_tzmn_b)/2

c6b_rce_pr_zmn       = dim_avg_n(c6b_rce_2d_pr,2)  ; should be time,lat
c6b_rce_pr_tzmn_a    = dim_avg_n(c6b_rce_pr_zmn(:,:halflat),0)  ; should be lat
c6b_rce_pr_tzmn_b    = dim_avg_n(c6b_rce_pr_zmn(:,halflatp1::-1),0)  ; should be lat
c6b_rce_pr_tzmn_c    = (c6b_rce_pr_tzmn_a+c6b_rce_pr_tzmn_b)/2

c6c_rce_pr_zmn       = dim_avg_n(c6c_rce_2d_pr,2)  ; should be time,lat
c6c_rce_pr_tzmn_a    = dim_avg_n(c6c_rce_pr_zmn(:,:halflat),0)  ; should be lat
c6c_rce_pr_tzmn_b    = dim_avg_n(c6c_rce_pr_zmn(:,halflatp1::-1),0)  ; should be lat
c6c_rce_pr_tzmn_c    = (c6c_rce_pr_tzmn_a+c6c_rce_pr_tzmn_b)/2

;*************************************************************
; calculate the precipitation minus evaporation
printVarSummary(PminusE)
printVarSummary(c6a_pr_tzmn_c)
PminusE(0,:) = c6a_pr_tzmn_c(:)-c6a_evp_tzmn_c(:)
PminusE(1,:) = c6b_pr_tzmn_c(:)-c6b_evp_tzmn_c(:)
PminusE(2,:) = c6c_pr_tzmn_c(:)-c6c_evp_tzmn_c(:)
PminusE(3,:) = c6a_rce_pr_tzmn_c(:)-c6a_rce_evp_tzmn_c(:)
PminusE(4,:) = c6b_rce_pr_tzmn_c(:)-c6b_rce_evp_tzmn_c(:)
PminusE(5,:) = c6c_rce_pr_tzmn_c(:)-c6c_rce_evp_tzmn_c(:)

;*************************************************************
; compute anomalies

c6a_prw_anom     = c6a_prw_tzmn-c6a_prw_tmn
c6a_prw_anom_c     = c6a_prw_tzmn_c-c6a_prw_tmn
c6b_prw_anom     = c6b_prw_tzmn-c6b_prw_tmn
c6b_prw_anom_c     = c6b_prw_tzmn_c-c6b_prw_tmn
c6c_prw_anom     = c6c_prw_tzmn-c6c_prw_tmn
c6c_prw_anom_c     = c6c_prw_tzmn_c-c6c_prw_tmn
c6a_rce_prw_anom = c6a_rce_prw_tzmn-c6a_rce_prw_tmn
c6a_rce_prw_anom_c = c6a_rce_prw_tzmn_c-c6a_rce_prw_tmn
c6b_rce_prw_anom = c6b_rce_prw_tzmn-c6b_rce_prw_tmn
c6b_rce_prw_anom_c = c6b_rce_prw_tzmn_c-c6b_rce_prw_tmn
c6c_rce_prw_anom = c6c_rce_prw_tzmn-c6c_rce_prw_tmn
c6c_rce_prw_anom_c = c6c_rce_prw_tzmn_c-c6c_rce_prw_tmn

; no anomaly
c6a_prw_clim     = c6a_prw_tzmn
c6b_prw_clim     = c6b_prw_tzmn
c6c_prw_clim     = c6c_prw_tzmn
c6a_rce_prw_clim = c6a_rce_prw_tzmn
c6b_rce_prw_clim = c6b_rce_prw_tzmn
c6c_rce_prw_clim = c6c_rce_prw_tzmn
;*************************************************************
;*************************************************************

;*************************************************************
; read data files with PW within Cyclones 
;*************************************************************
;
;path_cheyenne="/glade/scratch/levi/RotRCEMIP/"
;
; 2D prw 
;CAM5_GCM_RRCE_large295_2D_tracked_prw.nc
configStr="RRCE"
var2read="prw" ; default case 
file_prw_2D_6a=path_rrce+path_C6+configStr+"_large295/2D/CAM6_GCM_"+configStr+"_large295_2D_tracked_"+var2read+".nc"
file_prw_2D_6b=path_rrce+path_C6+configStr+"_large300/2D/CAM6_GCM_"+configStr+"_large300_2D_tracked_"+var2read+".nc"
file_prw_2D_6c=path_rrce+path_C6+configStr+"_large305/2D/CAM6_GCM_"+configStr+"_large305_2D_tracked_"+var2read+".nc"

;  print("file with tracked data is:"+)

; CAM6
generic_2d_fname_c6     =addfile(file_prw_2D_6a,"r")
c6a_2d_prw     =generic_2d_fname_c6->prw(startime1:endtime1,:,:)
generic_2d_fname_c6     =addfile(file_prw_2D_6b,"r")
c6b_2d_prw     =generic_2d_fname_c6->prw(startime1:endtime1,:,:)
generic_2d_fname_c6     =addfile(file_prw_2D_6c,"r")
c6c_2d_prw     =generic_2d_fname_c6->prw(startime1:endtime1,:,:)

;  printVarSummary(c6a_2d_prw)

;; compute zonal mean profiles for rrce
; cam6
c6a_prw_zmn      = dim_avg_n(c6a_2d_prw,2)  ; should be time,lat
c6a_prw_tzmn     = dim_avg_n(c6a_prw_zmn,0) ; should be just lat
c6a_tc_prw_tzmn_a   = dim_avg_n(c6a_prw_zmn(:,:halflat),0)  ; should be lat
c6a_tc_prw_tzmn_b   = dim_avg_n(c6a_prw_zmn(:,halflatp1::-1),0)  ; should be lat
c6a_tc_prw_tzmn_c   = (c6a_tc_prw_tzmn_a+c6a_tc_prw_tzmn_b)/2
c6a_prw_tmn      = dim_avg_n(f6a_wgt_ave,0) ; should be single value

c6b_prw_zmn      = dim_avg_n(c6b_2d_prw,2)
c6b_prw_tzmn     = dim_avg_n(c6b_prw_zmn,0)
c6b_tc_prw_tzmn_a   = dim_avg_n(c6b_prw_zmn(:,:halflat),0)  ; should be lat
c6b_tc_prw_tzmn_b   = dim_avg_n(c6b_prw_zmn(:,halflatp1::-1),0)  ; should be lat
c6b_tc_prw_tzmn_c   = (c6b_tc_prw_tzmn_a+c6b_tc_prw_tzmn_b)/2
c6b_prw_tmn      = dim_avg_n(f6b_wgt_ave,0)

  print(";*************************************************************")
  printVarSummary(c6c_2d_prw)
c6c_prw_zmn      = dim_avg_n(c6c_2d_prw,2)
  printVarSummary(c6c_prw_zmn)
c6c_prw_tzmn     = dim_avg_n(c6c_prw_zmn,0); only latitude dim remaining
  printVarSummary(c6c_prw_tzmn)
; average over first half of latitude points:
c6c_tc_prw_tzmn_a   = dim_avg_n(c6c_prw_zmn(:,:halflat),0) 
;  printVarSummary(c6c_tc_prw_tzmn_a)
; average over second half of latitude points:
c6c_tc_prw_tzmn_b   = dim_avg_n(c6c_prw_zmn(:,halflatp1::-1),0)  ; should be lat
;  printVarSummary(c6c_tc_prw_tzmn_b)
c6c_tc_prw_tzmn_c   = (c6c_tc_prw_tzmn_a+c6c_tc_prw_tzmn_b)/2
;  printVarSummary(c6c_tc_prw_tzmn_c)
  print(";*************************************************************")

c6c_prw_tmn      = dim_avg_n(f6c_wgt_ave,0)

;*************************************************************
;*************************************************************
  my_levels1 = (/-10,-9,-8,-7,-6,   \
                 -5,-4,-3,-2,-1,   \
                 0,1,2,3,4,   \
                 5,6,7,8,9,   \
                 10 /) ; need 1 more color than level
  pscale = 1.e10
  my_colors1 = (/49,56,63,70,77,       \
                 83,90,97,104,111,      \
                 0,0,              \
                 ;118,138,              \
                 145,152,159,166,173,  \
                 180,187,194,201,208 /);  \

; cam6, cam5
;rgbcolors=(/"(/122/255, 197/255, 205/255/)","(/205/255, 51/255, 51/255/)"/)
rgbcolors=(/"(/1., 1., 1/)","(/0., 0., 0/)","(/0.48, 0.77, 0.80/)","(/0.80, 0.2, 0.2/)"/)
;cam5color = rgbcolors(3) 
;cam6color = rgbcolors(2) 

cam5color = "black"
cam6color = "black"

;fontsize=0.04
;fontsize=0.018
;fontsize=0.012
;TitSize=0.018
fontsize=0.010
TitSize=0.012; was 0.014

;*************************************************************
; draw the plots
;*************************************************************

wtype = "png"
wtype@wkWidth  = 2500  ; increase size of pdf image
wtype@wkHeight = 2500
;wtype@wkOrientation = "landscape" ; is this only for pdf and ps? 
wks = gsn_open_wks(wtype,"rrce_vs_lat")           
;wks = gsn_open_wks("pdf","rrce_vs_lat")         

;gsn_define_colormap(wks,"cb_9step")
;gsn_define_colormap(wks,rgbcolors)
gsn_define_colormap(wks,"cmocean_balance")

lthick    = 3.0
panlength = 0.17; originally was 0.2
yaxislow  = 0 
yaxishigh = 80
 
; begin first panel -------------------------------------------------------------------------------------

res                        = True
lgres                      = True
   
;res@tiMainFont = 21
res@tiMainFontHeightF = TitSize
;res@tiYAxisString  = yaxistitle
;res@tiYAxisFont    = 21
res@tiYAxisFontHeightF = fontsize 
;res@tiXAxisFont    = 21
res@tiXAxisFontHeightF = fontsize

res@tmYLLabelFontHeightF = fontsize 
res@tmXBLabelFontHeightF = fontsize

res@xyLineThicknessF     = lthick
;res@tmXBMode             = "explicit"
res@trXMinF              = -90
res@trXMaxF              = 0

res@tmXBValues = (/-90.,-60.,-30.,0./)
;;res@tmXBValues = (/sin(-90./180*PI),sin(-60./180*PI),sin(-30./180*PI),sin(0.)/)
res@tmXBLabels = (/90,60,30,0/)
res@tiYAxisFontHeightF     = fontsize 
res@tiXAxisFontHeightF     = fontsize
;;res@tmXBMinorValues =sin((/-10.,-20.,-40.,-50.,-70.,-80./)/180.*PI)
;res@tmXBMinorValues =(/-10.,-20.,-40.,-50.,-70.,-80./)

res@trXReverse = True  ; goal: plot equator at left, increasing to the pole on the right

;res@gsnDraw         = False
res@gsnFrame          = False

; plot climatology first
res@trYMinF           = yaxislow 
res@trYMaxF           = yaxishigh 
res@tiMainString      = "PW mean"
res@tiXAxisString     = "Latitude"
res@tiYAxisString     = "kg m~S~-2~"
;res@tiYAxisString     = "kg m^-2"

;res@tiYAxisString  = yaxistitle

res@vpXF              = 0.05
res@vpYF              = 0.7
res@vpWidthF          = panlength 
res@vpHeightF         = panlength 

res@xyDashPattern="16"
;res@gsnPaperOrientation  = "landscape"; this appears to only be useful for ps,eps,x11, etc.... not pdf's
res@xyLineColors = cam6color ; CAM6 color
res@xyLineThicknessF     = 1.5
res@xyLineThicknessF     = lthick2(0)
plot0a=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6a_rce_prw_tzmn_c(:halflat),res)
;plot0a=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6a_rce_prw_tzmn_c(:halflat),res)
res@xyDashPattern="0"
res@xyLineThicknessF     = lthick2(0)
plot1b=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6a_prw_tzmn_c(:halflat),res)
;plot1b=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6a_prw_tzmn_c(:halflat),res)
res@xyDashPattern="16"
res@xyLineThicknessF     = lthick2(1)
plot1c=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6b_rce_prw_tzmn_c(:halflat),res)
;plot1c=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6b_rce_prw_tzmn_c(:halflat),res)
res@xyDashPattern="0"
plot1d=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6b_prw_tzmn_c(:halflat),res)
;plot1d=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6b_prw_tzmn_c(:halflat),res)
res@xyDashPattern="16"
res@xyLineThicknessF     = lthick2(2)
plot1e=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6c_rce_prw_tzmn_c(:halflat),res)
;plot1e=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6c_rce_prw_tzmn_c(:halflat),res)
res@xyDashPattern="0"
plot1f=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6c_prw_tzmn_c(:halflat),res)
;plot1f=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6c_prw_tzmn_c(:halflat),res)

overlay(plot0a,plot1b)
overlay(plot0a,plot1c)
overlay(plot0a,plot1d)
overlay(plot0a,plot1e)
overlay(plot0a,plot1f)

;plot(0)=plot0a

; begin second panel -------------------------------------------------------------------------------------
; plot anomalies

res2                        = True
res2@gsnFrame               = False
   
;res2@tiMainFont = 21
;res2@tiYAxisFont    = 21
;res2@tiXAxisFont    = 21
res2@tiMainFontHeightF = TitSize
;res2@tiYAxisString  = yaxistitle
res2@tiYAxisFontHeightF = fontsize 
res2@tiXAxisFontHeightF = fontsize

res2@tmYLLabelFontHeightF = fontsize 
res2@tmXBLabelFontHeightF = fontsize

res2@xyLineThicknessF     = lthick
res2@tmXBMode = "explicit"
res2@trXMinF = -90
res2@trXMaxF = 0

;; these 4 lines should be uncommented.  this is a test.
;;res2@tmXBValues = (/sin(-90./180*PI),sin(-60./180*PI),sin(-30./180*PI),sin(0.)/)
res2@tmXBLabels = (/90,60,30,0/)
res2@tiYAxisFontHeightF     = fontsize 
res2@tiXAxisFontHeightF     = fontsize
;;res2@tmXBMinorValues =sin((/-10.,-20.,-40.,-50.,-70.,-80./)/180.*PI)
;res2@tmXBMinorValues =(/-10.,-20.,-40.,-50.,-70.,-80./)
res2@trXReverse = True  ; goal: plot equator at left, increasing to the pole on the right

;res2@tmXBValues = (/-90.,-60,-30,0./)
;res2@tmXBLabels = (/90,60,30,0/)
;res2@trXReverse = True  ; goal: plot equator at left, increasing to the pole on the right
;res2@tmXBValues             = (/0, 30, 60, 90/)
;res2@tmXBLabels             = (/0,30,60,90/)
;res7@tmXBMinorValues        = sin((/-10.,-20.,-40.,-50.,-70.,-80./)/180.*PI)

; plot climatology first
res2@trYMinF = yaxislow 
res2@trYMaxF = yaxishigh 
res2@tiMainString = "PW anomaly"
res2@tiXAxisString  = "Latitude"
res2@tiYAxisString  = "kg m^-2"

;yaxislow  = 0 
;yaxishigh = 80

;res2@tiYAxisString  = "kg m^-2"

yaxislow  = -10 
yaxishigh = 10
res2@trYMinF = yaxislow 
res2@trYMaxF = yaxishigh 
;res2@xyDashPattern="1"
res2@xyLineThicknessF     = 1.5
;res2@tiYAxisString  = yaxistitle
res2@tiXAxisString  = "Latitude"
res2@tiYAxisString  = "kg m~S~-2~"

res2@vpXF           = 0.275
res2@vpYF           = 0.7
res2@vpWidthF       = panlength 
res2@vpHeightF      = panlength 

res2@xyDashPattern="16"
res2@xyLineColors = cam6color 
res2@xyLineThicknessF     = lthick2(0)
plot2a=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6a_rce_prw_anom_c(:halflat),res2)
;plot2a=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6a_rce_prw_anom_c(:halflat),res2)
res2@xyDashPattern="0"
plot3b=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6a_prw_anom_c(:halflat),res2)
;plot3b=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6a_prw_anom_c(:halflat),res2)
res2@xyDashPattern="16"
res2@xyLineThicknessF     = lthick2(1)
plot3c=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6b_rce_prw_anom_c(:halflat),res2)
;plot3c=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6b_rce_prw_anom_c(:halflat),res2)
res2@xyDashPattern="0"
plot3d=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6b_prw_anom_c(:halflat),res2)
;plot3d=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6b_prw_anom_c(:halflat),res2)
res2@xyDashPattern="16"
res2@xyLineThicknessF     = lthick2(2)
plot3e=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6c_rce_prw_anom_c(:halflat),res2)
;plot3e=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6c_rce_prw_anom_c(:halflat),res2)
res2@xyDashPattern="0"
plot3f=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6c_prw_anom_c(:halflat),res2)
;plot3f=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6c_prw_anom_c(:halflat),res2)

overlay(plot2a,plot3b)
overlay(plot2a,plot3c)
overlay(plot2a,plot3d)
overlay(plot2a,plot3e)
overlay(plot2a,plot3f)

;plot(1)=plot2a

; begin third panel -------------------------------------------------------------------------------------
; plot PW in cyclones
;--------------------------------------------------
res3                        = True
res3@gsnFrame               = False

res3@trYMinF                = 0 
res3@trYMaxF                = 20 
res3@tiMainString           = "PW within TCs"
;res3@tiYAxisString          = "kg m^-2"
res3@tiYAxisString  = "kg m~S~-2~"
res3@tiXAxisString          = "Latitude"

res3@tiMainFontHeightF      = TitSize
;res2@tiYAxisString          = yaxistitle
res3@tiYAxisFontHeightF     = fontsize 
res3@tiXAxisFontHeightF     = fontsize

res3@tmYLLabelFontHeightF   = fontsize 
res3@tmXBLabelFontHeightF   = fontsize

;res3@xyLineThicknessF       = lthick
res3@tmXBMode               = "explicit"
res3@trXMinF                = -90
res3@trXMaxF                = 0

;res3@tmXBValues = (/sin(-90./180*PI),sin(-60./180*PI),sin(-30./180*PI),sin(0.)/)
res3@tmXBValues = (/-90.,-60.,-30.,0./)
res3@tmXBLabels = (/90,60,30,0/)
;res3@tmXBMinorValues =sin((/-10.,-20.,-40.,-50.,-70.,-80./)/180.*PI)
res3@trXReverse = True  ; goal: plot equator at left, increasing to the pole on the right
res3@tiYAxisFontHeightF     = fontsize 
res3@tiXAxisFontHeightF     = fontsize

res3@vpXF           = 0.5
res3@vpYF           = 0.7
res3@vpWidthF       = panlength 
res3@vpHeightF      = panlength 

res3@xyDashPattern="0"
res3@xyLineThicknessF     = 1.5
res3@xyLineColors = cam5color ; CAM5 color

; c6c_tc_prw_tzmn_c

res3@xyDashPattern="0"
res3@xyLineThicknessF     = lthick2(0)
res3@xyLineColors = cam6color ; CAM6 color
;plot5a=gsn_csm_xy(wks,sin(latitude_c6(:)/180*PI),scale*c6a_prw_tzmn(:),res3)
;
;
plot5a=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6a_tc_prw_tzmn_c(:halflat),res3)
;plot5a=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6a_tc_prw_tzmn_c(:halflat),res3)
;
;
res3@xyDashPattern="0"
res3@xyLineThicknessF     = lthick2(1)
;plot5b=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6b_tc_prw_tzmn_c(:halflat),res3)
plot5b=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6b_tc_prw_tzmn_c(:halflat),res3)
res3@xyDashPattern="0"
res3@xyLineThicknessF     = lthick2(2)
;plot5c=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6c_tc_prw_tzmn_c(:halflat),res3)
plot5c=gsn_csm_xy(wks,latitude_c6(:halflat),scale*c6c_tc_prw_tzmn_c(:halflat),res3)

overlay(plot5a,plot5b)
overlay(plot5a,plot5c)


; begin fourth panel -----------------------------------------------------------------------------------
; plot Precipitation minus Evaporation 
;--------------------------------------------------
res4                        = True
res4@gsnFrame               = False

;res4@trYMinF = 0 
;res4@trYMaxF = 30 
res4@tiMainString = "P - E"
;res4@tiYAxisString  = "kg m-2 s-1"
res4@tiYAxisString  = "kg m~S~-2~N~s~S~-1~N~"
res4@tiXAxisString  = "Latitude"

res4@tiMainFontHeightF = TitSize
;res2@tiYAxisString  = yaxistitle
res4@tiYAxisFontHeightF = fontsize 
res4@tiXAxisFontHeightF = fontsize

res4@tmYLLabelFontHeightF = fontsize 
res4@tmXBLabelFontHeightF = fontsize

;res4@xyLineThicknessF     = lthick
res4@tmXBMode = "explicit"
res4@trXMinF = -90
res4@trXMaxF = 0
res4@trYMinF = -10
res4@trYMaxF = 10

;res4@tmXBValues = (/sin(-90./180*PI),sin(-60./180*PI),sin(-30./180*PI),sin(0.)/)
res4@tmXBValues = (/-90,-60,-30,0/)
res4@tmXBLabels = (/90,60,30,0/)
;res4@tmXBMinorValues =(/-10.,-20.,-40.,-50.,-70.,-80./)
;res4@tmXBMinorValues =sin((/-10.,-20.,-40.,-50.,-70.,-80./)/180.*PI)
res4@trXReverse = True  ; goal: plot equator at left, increasing to the pole on the right
res4@tiYAxisFontHeightF     = fontsize 
res4@tiXAxisFontHeightF     = fontsize

res4@vpXF           = 0.05
res4@vpYF           = 0.43
res4@vpWidthF       = panlength 
res4@vpHeightF      = panlength 

res4@xyDashPattern="0"
res4@xyLineThicknessF     = 1.5
res4@xyLineColors = cam5color ; CAM5 color

; c6c_tc_prw_tzmn_c

scalef=1e6
res4@xyDashPattern="0"
res4@xyLineThicknessF     = lthick2(0)
res4@xyLineColors = cam6color ; CAM6 color
;plot5a=gsn_csm_xy(wks,sin(latitude_c6(:)/180*PI),scale*c6a_prw_tzmn(:),res4)
;
;
plot6a=gsn_csm_xy(wks,latitude_c6(:halflat),scalef*PminusE(0,:halflat),res4)
;plot6a=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scalef*PminusE(0,:halflat),res4)
res4@xyLineThicknessF     = lthick2(1)
plot6b=gsn_csm_xy(wks,latitude_c6(:halflat),scalef*PminusE(1,:halflat),res4)
;plot6b=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scalef*PminusE(1,:halflat),res4)
res4@xyLineThicknessF     = lthick2(2)
plot6c=gsn_csm_xy(wks,latitude_c6(:halflat),scalef*PminusE(2,:halflat),res4)
;plot6c=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scalef*PminusE(2,:halflat),res4)
;res4@xyDashPattern="16"
;res4@xyLineThicknessF     = lthick2(0)
;plot6d=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scalef*PminusE(3,:halflat),res4)
;res4@xyLineThicknessF     = lthick2(1)
;plot6e=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scalef*PminusE(4,:halflat),res4)
;res4@xyLineThicknessF     = lthick2(2) 
;plot6f=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scalef*PminusE(5,:halflat),res4)

overlay(plot6a,plot6b)
overlay(plot6a,plot6c)
;overlay(plot6a,plot6d)
;overlay(plot6a,plot6e)
;overlay(plot6a,plot6f)

;plot(2)=plot5a
;;
;; begin fifth panel -----------------------------------------------------------------------------------
;; plot Precipitation minus Evaporation 
;;--------------------------------------------------
;res5                        = True
;res5@gsnFrame               = False
;
;res5@tiMainString = "P minus E"
;res5@tiYAxisString  = "Shenandoah"
;res5@tiXAxisString  = "Latitude"
;
;res5@tiMainFontHeightF = TitSize
;;res2@tiYAxisString  = yaxistitle
;res5@tiYAxisFontHeightF = fontsize 
;res5@tiXAxisFontHeightF = fontsize
;
;res5@tmYLLabelFontHeightF = fontsize 
;res5@tmXBLabelFontHeightF = fontsize
;
;;res5@xyLineThicknessF     = lthick
;res5@tmXBMode = "explicit"
;res5@trXMinF = -1
;res5@trXMaxF = 0
;res5@trYMinF = -10
;res5@trYMaxF = 10
;
;res5@tmXBValues = (/sin(-90./180*PI),sin(-60./180*PI),sin(-30./180*PI),sin(0.)/)
;res5@tmXBLabels = (/90,60,30,0/)
;res5@tmXBMinorValues =sin((/-10.,-20.,-40.,-50.,-70.,-80./)/180.*PI)
;
;res5@trXReverse = True  ; goal: plot equator at left, increasing to the pole on the right
;
;res5@vpXF           = 0.275
;res5@vpYF           = 0.43
;res5@vpWidthF       = panlength 
;res5@vpHeightF      = panlength 
;
;res5@xyDashPattern="0"
;res5@xyLineThicknessF     = 1.5
;res5@xyLineColors = cam5color ; CAM5 color
;
;; c6c_tc_prw_tzmn_c
;
;res5@xyDashPattern="0"
;res5@xyLineThicknessF     = 1.5
;res5@xyLineColors = cam6color ; CAM6 color
;;plot5a=gsn_csm_xy(wks,sin(latitude_c6(:)/180*PI),scale*c6a_prw_tzmn(:),res5)
;;
;;
;plot7a=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scalef*PminusE(1,:halflat),res5)
;;
;;
;;res5@xyDashPattern="0"
;;res5@xyLineThicknessF     = 2.5
;;;plot5b=gsn_csm_xy(wks,sin(latitude_c6(:)/180*PI),scale*c6b_prw_tzmn(:),res5)
;;plot5b=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6b_tc_prw_tzmn_c(:halflat),res5)
;;res5@xyDashPattern="0"
;;res5@xyLineThicknessF     = 3.5
;;;plot5d=gsn_csm_xy(wks,sin(latitude_c6(:)/180*PI),scale*c6c_prw_tzmn(:),res5)
;;plot5c=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6c_tc_prw_tzmn_c(:halflat),res5)
;
;;overlay(plot5a,plot5b)
;;overlay(plot5a,plot5c)
;
;;plot(2)=plot5a
;
; begin sixth panel -------------------------------------------------------------------------------
;--------------------------------------
res6                        = True
res6@cnLinesOn              = False
res6@cnLevelSelectionMode   = "ExplicitLevels"
res6@cnLevels               = my_levels1
res6@cnFillColors           = my_colors1
res6@tmYLMode               = "Explicit"
res6@tmXBMode               = "Explicit"
res6@tmXBValues             = (/90,60,30,0/)
res6@tmXBLabels             = (/90,60,30,0/)
res6@trXReverse             = True     ; reverse the y-axis
;;res6@tmXBValues             = (/sin(-90./180*PI),sin(-60./180*PI),sin(-30./180*PI),sin(0.)/)
;;res6@tmXBValues             = (/sin(90./180*PI),sin(60./180*PI),sin(30./180*PI),sin(0.)/)
;res6@tmXBValues             = (/sin(0./180*PI),sin(30./180*PI),sin(60./180*PI),sin(90.)/)
;res6@tmXBLabels             = (/90,60,30,0/)
;;res6@tmXBMinorValues        = sin((/-10.,-20.,-40.,-50.,-70.,-80./)/180.*PI)
;res6@tmXBMinorValues        = sin((/10.,20.,40.,50.,70.,80./)/180.*PI)
res6@tmYLValues             = (/100,200,400,600,800,1000/)
res6@tmYLLabels             = (/"100","200","400","600","800","1000"/)
res6@trYReverse             = True     ; reverse the y-axis
res6@gsnYAxisIrregular2Log  = True
res6@trYMaxF                = 1000. 
res6@trYMinF                = 100.
res6@tiYAxisString          = "pressure (hPa)"
res6@tiYAxisFontHeightF     = fontsize 
res6@tiXAxisFontHeightF     = fontsize
res6@lbTitleOn           = True 
;res6@lbTitlePosition     = "Bottom"
res6@lbTitlePosition     = "Right"; why doesn't this work? 
res6@lbTitleString       = "K"
res6@lbTitleFontHeightF  = 10
res6@lbTitleFont         = 22; was 22
;res6@lbLabelAngleF          = 90
;res6@gsnDraw                = False
res6@gsnFrame               = False
;res6@gsnMaximize            = True
res6@cnFillOn               = True              ; color plot desired

res6@tiMainString           = "T anomaly" 
res6@tiMainFontHeightF      = TitSize                               ; font height
;  printVarSummary(var_to_plot2); 30x192
;  printVarSummary(temp_prof) ; 30x192
;  print("temp_prof: "+temp_prof(:,45))

;res6@vpXF              = 0.5
;res6@vpYF              = 0.43
res6@vpXF           = 0.275
res6@vpYF           = 0.43
res6@vpWidthF          = panlength 
res6@vpHeightF         = panlength 

;temp_1hem
;  print("%^&%^&%^& blah blah blah 4567456745674567")
;  print(temp_1hem(12,:))
;  print("%^&%^&%^& blah blah blah 4567456745674567")
;  print(temp_1hem(:,12))
;  print("%^&%^&%^& blah blah blah 4567456745674567")
;
contour3 = gsn_csm_contour(wks,temp_1hem(:,:),res6)  ; create the plot
;contour3 = gsn_csm_contour(wks,temp_prof(:,:),res6)  ; create the plot
;plot5c=gsn_csm_xy(wks,sin(latitude_c6(:halflat)/180*PI),scale*c6c_tc_prw_tzmn_c(:halflat),res5)

; begin sixth panel -------------------------------------------------------------------------------
res7                        = True
res7@gsnFrame               = False
res7@tiMainString           = "zonal wind" 
res7@tiMainFontHeightF      = TitSize                               ; font height
res7@cnLinesOn              = False
res7@cnLevelSelectionMode   = "ExplicitLevels"
res7@cnLevels               = my_levels1
res7@cnFillColors           = my_colors1
res7@tmYLMode               = "Explicit"
res7@tmYLValues             = (/100,200,400,600,800,1000/)
res7@tmYLLabels             = (/"100","200","400","600","800","1000"/)
res7@tmXBMode               = "Explicit"
;res7@trXMaxF                = 0.99
;res7@trXMinF                = 0.001
;res7@tmXBValues             = (/sin(-90./180*PI),sin(-60./180*PI),sin(-30./180*PI),sin(0.)/)
;res7@tmXBValues             = (/sin(90./180*PI),sin(60./180*PI),sin(30./180*PI),sin(0.)/)
;res7@tmXBValues             = (/sin(0.001/180*PI),sin(30./180*PI),sin(60./180*PI),sin(89./180*PI)/)
res7@tmXBValues             = (/90,60,30,0/)
res7@tmXBLabels             = (/90,60,30,0/)

;res4@tmXBValues = (/sin(-90./180*PI),sin(-60./180*PI),sin(-30./180*PI),sin(0.)/)
;res4@tmXBLabels = (/90,60,30,0/)
;res4@tmXBMinorValues =sin((/-10.,-20.,-40.,-50.,-70.,-80./)/180.*PI)

;res7@tmXBMinorValues        = sin((/-10.,-20.,-40.,-50.,-70.,-80./)/180.*PI)
;res7@tmXBMinorValues        = sin((/10.,20.,40.,50.,70.,80./)/180.*PI)
res7@trYReverse             = True     ; reverse the y-axis
res7@gsnYAxisIrregular2Log  = True
res7@trYMaxF                = 1000. 
res7@trYMinF                = 100.
res7@tiYAxisString          = "pressure (hPa)"
res7@tiYAxisFontHeightF     = fontsize 
res7@tiXAxisFontHeightF     = fontsize
res7@lbTitleOn              = True 
res7@lbTitlePosition        = "Right"
res7@lbTitleDirection       = "Across"
res7@lbTitleString          = "m/s"
res7@lbTitleFontHeightF     = 9 
res7@lbTitleFont            = 22
res7@cnFillOn               = True              ; color plot desired

;res7@vpXF                   = 0.725
;res7@vpYF                   = 0.43
res7@vpXF                   = 0.5
res7@vpYF                   = 0.43
res7@vpWidthF               = panlength
res7@vpHeightF              = panlength 

;uznm_1hem
contour4 = gsn_csm_contour(wks,uznm_1hem(:,:),res7)  ; create the plot
;contour4 = gsn_csm_contour(wks,sin(latitude_c6(:halflat)/180*PI),uznm_1hem(:halflat,:),res7)
;contour4 = gsn_csm_contour(wks,var_to_plot2(:,:),res7)  ; create the plot

;plot(3) = contour3

; create the legend
textres                 = True
res@xyExplicitLabels    = (/"i ", "walk", "alone", "to see"/)

  genres                     = True
  textres                    = True
  lineres                    = True
  genres@XPosPercent         = 74
  genres@YPosPercent         = 70
  textres@lgLabels           = (/"RRCE","RCE"," ","295 K","300 K","305 K"/)
  ;textres@lgLabels           = res@xyExplicitLabels(::-1) ; reverse label order legend
  textres@lgItemCount        = 6
  lineres@lgLineThicknesses  = (/5,5,0,5,10,15/)
  lineres@lgLineColors       = (/"black","black","white","black","black","black"/)     ; reverse color order for legend
  lineres@lgDashIndexes      = (/0,16,0,0,0,0/)   ; reverse pattern order for legend
  lineres@LineLengthPercent  = 6
;
  simple_legend_ndc(wks, genres, lineres, textres)
;
;  drawNDCGrid(wks)  ; Uncomment this line to display a coordinate grid for debugging purposes

draw((/plot0a,plot2a,plot5a,plot6a,contour3,contour4/))
;draw((/plot0a,plot2a,plot5a,plot6a,plot7a,contour3,contour4/))
frame(wks)

end 

;trimPNG(rrce_vs_lat)

;; the code below was written by Walter Hannah, to trim the extra 
;; space around a png figure.  
;; https://hannahlab.org/ncl-cropping-the-white-space-from-a-png-file/
;; 
;; copied in November, 2023
;;=======================================================================
;;=======================================================================
;undef("trimPNG")
;procedure trimPNG(fig_file)
;local res,cmd
;begin
;    strver = systemfunc("ncl -V") 
;    ver = tofloat(strver)
;    sub = str_sub_str(strver,ver+".","")
;    if .not.isStrSubset(fig_file,".png") then 
;        fig_file = fig_file + ".png" 
;    end if
;    cmd = "convert -trim "+fig_file+" "+fig_file
;    if (ver.ge.6.2) .or. ((ver.eq.6.2).and.(sub.ge.1)) then
;        if fileexists(fig_file) then system(cmd) end if
;    else
;        if isfilepresent(fig_file) then system(cmd) end if
;    end if
;    print("")
;    print("    "+fig_file)
;    print("")
;end
;;=======================================================================
;;=======================================================================
;  
;trimPNG(rrce_vs_lat)

;end






