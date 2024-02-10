;-------------------------------------------------------------------------------
; psi_contour.ncl
;
; script to compute and plot the streamfunction using the u and v 
; wind fields for the RRCE simulations
;
; to compute the streamfunction an ncl function is used: zonal_mpsi
; 
; levi                                                            sep 2023
;-------------------------------------------------------------------------------

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

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
  ;model=modelStr
  model="CAM5"
end if

;if (dim .eq. 1 .or. dim .eq. 3) then
if (confStr .eq. "RCE") then
  print("using RCE configuration")
  conf="RCE"
  pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/"
else
  print("using RRCE configuration")
  conf="RRCE"  ;  = f[:]->PSL(nstart:nend,:)
  pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RotRCEMIP/"
end if

path2file=pathn+model+"_GCM/"+conf+"_large"+Stemp+"/3D/"+model+"_GCM_"+conf+"_large"+Stemp

; various options for input: 
;filea = path2file+"_3D_ta_365d.nc"
;fileb = path2file+"_3D_ua_365d.nc"
;filec = path2file+"_3D_va_365d.nc"
;filea = path2file+"_3D_ta_100d.nc"
;fileb = path2file+"_3D_ua_100d.nc"
;filec = path2file+"_3D_va_100d.nc"
filea = path2file+"_3D_ta.nc"
fileb = path2file+"_3D_ua.nc"
filec = path2file+"_3D_va.nc"

;filed = "/glade/scratch/levi/RotRCEMIP/CAM5_GCM/"+conf+"_large"+Stemp+"/2D/CAM5_GCM_"+conf+"_large"+Stemp+"_2D_psl.nc"

;/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/CAM6_GCM/
;/glade/derecho/scratch/levi/fromCheyenne/postp/RotRCEMIP/CAM6_GCM/

;filed = pathn+model+"_GCM/"+conf+"_large"+Stemp+"/2D/"+model+"_GCM_"+conf+"_large"+Stemp+"_2D_psl_last100_6hrmn.nc"

;filed = pathn+model+"_GCM/"+conf+"_large"+Stemp+"/2D/"+model+"_GCM_"+conf+"_large"+Stemp+"_2D_psl_last365d.nc"

filed = "/glade/derecho/scratch/levi/fromCheyenne/postp/RotRCEMIP/CAM6_GCM/"+"RRCE"+"_large"+Stemp+"/2D/"+model+"_GCM_"+"RRCE"+"_large"+Stemp+"_2D_psl_last25_6hrmn.nc"

;filed = "/glade/derecho/scratch/levi/fromCheyenne/postp/RotRCEMIP/CAM6_GCM/RRCE_large295/2D/CAM6_GCM_RRCE_large295_2D_psl_last25_6hrmn.nc"


  print("file2 is: "+fileb)
  print("file3 is: "+filec)

maintitle="main title"
file1 = addfile(filea,"r")
file2 = addfile(fileb,"r")
file3 = addfile(filec,"r")
file4 = addfile(filed,"r")

; need to have surface pressure to compute streamfunction

; pick a longitude
; probably should calculate a zonal mean over all longitudes...
;longi=30

; test out a smaller domain.  how are boundary conditions dealt with using zonal_mpsi?
lat1=0
lat2=191

lon1=0
;lon2=72
lon2=287

va_f = file3->va(:,1:29,lat1:lat2,lon1:lon2)
;va_f = file3->va(:,:,:,:)
  printVarSummary(va_f)

field_ta = file1->ta(:,:,lat1:lat2,lon1:lon2)
field_ua = file2->ua(:,:,lat1:lat2,lon1:lon2)
field_va = file3->va(:,:,lat1:lat2,lon1:lon2)
field_ps = file4->psl(:,lat1:lat2,lon1:lon2)

ps_avg=avg(field_ps)
  printVarSummary(field_ps)
  print("average of ps is: "+ps_avg)

dims  = dimsizes(field_va)
ntime = dims(0)
nlev  = dims(1)
nlat  = dims(2)
nlon  = dims(3)
levm1 =  new((/nlev/),float)

va_arr = new((/ntime,nlev,nlat,nlon/),float)
  printVarSummary(va_arr)
  
  print(va_f&lev*100)
levels=va_f&lev
  print("dimensions of levels are: "+dimsizes(levels))
  print("dimensions of levm1 are: "+dimsizes(levm1))
;levm1(:)=levels(:)

; output for zonal_mpsi has units of kg/s 
zmpsi = zonal_mpsi(va_f,va_f&lat,va_f&lev*100,field_ps)
  printVarSummary(zmpsi)

;  printMinMax(field_ta,False)
  printVarSummary(field_ta)
  printVarSummary(field_va)
  printMinMax(zmpsi,False)

scale = 1.
var_to_plot_a=dim_avg_n(field_ta,0)
var_to_plot2_a=dim_avg_n(field_ua,0)
var_to_plot3_a=dim_avg_n(field_va,0)

; compute averages over longitude:
var_to_plot=dim_avg_n(var_to_plot_a,2)
var_to_plot2=dim_avg_n(var_to_plot2_a,2)
var_to_plot3=dim_avg_n(var_to_plot3_a,2)

scalep=1e-10
var_to_plot4=scalep*dim_avg_n(zmpsi,0)
  print("----------------------------------------------------------")
  print("var_to_plot4 is the zmpsi output scaled by scalep: "+scalep)
  printVarSummary(var_to_plot4)
  printMinMax(var_to_plot4,False)
  print("----------------------------------------------------------")

var_to_plot!1="lat"
var_to_plot&lat=field_va&lat
var_to_plot!0="lev"
var_to_plot&lev=field_va&lev

var_to_plot2!1="lat"
var_to_plot2&lat=field_va&lat
var_to_plot2!0="lev"
var_to_plot2&lev=field_va&lev

var_to_plot3!1="lat"
var_to_plot3&lat=field_va&lat
var_to_plot3!0="lev"
var_to_plot3&lev=field_va&lev

var_to_plot4!1="lat"
var_to_plot4&lat=va_f&lat
var_to_plot4!0="lev"
var_to_plot4&lev=levels
;;var_to_plot4&lev=va_f&lev
  printVarSummary(var_to_plot4)



; I think the time frequency for 3D output is 6 hourly (averged) at the moment
; so 4 times equal 1 day, 28 times equal 1 week. (initially I used times 1-27)

  my_levels1 = (/230,235,240,245,250,255,260, \
                 265,270,275,280,  \
                 282,284,286,288,290,  \
                 292,294,296,298,300 /) ;19  need 1 more color than level
  my_levels2 = (/-10,-9,-8,-7,-6, \ 
                 -5,-4,-3,-2,-1, \
                 -0.5,0,0.5,  \
                 1,2,3,4,5,  \
                 6,7,8,9,10 /) ;19  need 1 more color than level
  ;my_levels3 = (/-10,-9,-8,-7,-6, \ 
  ;               -5,-4,-3,-2,-1, \
  ;               -0.25,0,0.25,  \
  ;               1,2,3,4,5,  \
  ;               6,7,8,9,10 /) ;19  need 1 more color than level
  my_levels3 = (/-5.5,-5,-4.5,-4,-3.5, \ 
                 -3,-2.5,-2,-1.5,-1, \
                 -0.5,0,0.5,  \
                 1,1.5,2,2.5,3,  \
                 3.5,4,4.5,5,5.5 /) ;19  need 1 more color than level
;  pscale = 1.e10
;  blah = (/-10*pscale,-9*pscale,-8*pscale,-7*pscale,-6*pscale, \ 
;                 -5*pscale,-4*pscale,-3*pscale,-2*pscale,-1*pscale, \
;                 0*pscale,  \
;                 1*pscale,2*pscale,3*pscale,4*pscale,5*pscale,  \
;                 6,7,8,9,10 /) ;19  need 1 more color than level
;  my_levels4 = tointeger(blah)
  my_colors1 = (/49,56,63,70,77,       \
                 83,90,97,104,111,      \
                 118,0,0,138,              \
                 145,152,159,166,173,  \
                 180,187,194,201,208 /);  \

printVarSummary(my_levels3)
;printVarSummary(my_levels4)

;==============================================================================
wks = gsn_open_wks("png","testplot_psi_new")          ; send graphics to PNG file
;gsn_define_colormap(wks,"gui_default")
;gsn_define_colormap(wks,"WhBlGrYeRe")
gsn_define_colormap(wks,"cmocean_balance")
plot = new(1,graphic)

res                        = True
res@cnLinesOn              = False
res@cnLevelSelectionMode   = "ExplicitLevels"
;res@cnLevels               = my_levels1
res@cnFillColors           = my_colors1
;res@mpOutlineOn            = False
;res@mpCenterLonF           = 180.
;;res@mpCenterLatF           = 180.
;res@mpCenterLatF           = 0.
;res@mpGridAndLimbOn        = True              ; turn on lat/lon lines
;res@mpPerimOn              = False             ; turn off box around plot
;res@mpGridLatSpacingF      = 30.               ; spacing for lat lines
;res@mpGridLonSpacingF      = 30.               ; spacing for lon lines
;res@mpFillOn               = False
res@trYReverse             = True     ; reverse the y-axis
res@gsnYAxisIrregular2Log  = True
res@trYMaxF                = 1000. 
res@trYMinF                = 100.
res@tiYAxisString          = "pressure (hPa)"
res@lbLabelAngleF          = 90
res@gsnDraw                = False
res@gsnFrame               = False
res@gsnMaximize            = True
res@cnFillOn               = True              ; color plot desired

;res@tiMainString           = "temperature" 
;res@tiMainFontHeightF      = .018                               ; font height
;contour1 = gsn_csm_contour(wks,var_to_plot(:,:),res)  ; create the plot
;res@tiMainString           = "u wind" 
;res@cnLevels               = my_levels2
;contour2 = gsn_csm_contour(wks,var_to_plot2(:,:),res)  ; create the plot
;res@tiMainString           = "v wind" 
;res@cnLevels               = my_levels3
;contour3 = gsn_csm_contour(wks,var_to_plot3(:,:),res)  ; create the plot
;res@trYMaxF                = 100000. 
;res@trYMinF                = 10000.
res@tiMainString           = "streamfunction" 
res@cnLevels               = my_levels3
contour4 = gsn_csm_contour(wks,var_to_plot4(:,:),res)  ; create the plot

plot = contour4
;plot(0) = contour1
;plot(1) = contour2
;plot(2) = contour3
;plot(3) = contour4

respanel = True

;gsn_panel(wks,plot,(/2,2/),respanel)
gsn_panel(wks,plot,(/1,1/),respanel)
;==============================================================================


end
