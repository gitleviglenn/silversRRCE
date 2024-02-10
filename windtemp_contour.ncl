;-------------------------------------------------------------------------------
; windtemp_contour.ncl
;
; initial script to compute and plot the streamfunction using the u and v 
; wind fields for the RRCE simulations
;
; CAM levels start at the top of the model domain (~ toa)
;
; levi                                                            sep 2023
;-------------------------------------------------------------------------------

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

;  print("filen is: "+filen)
;  print("pathn is: "+pathn)
;
;;temp=295
;conf="RRCE"
;;conf="RCE"
;
;;model="CAM5"
;model="CAM6"

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

path2file=pathn+model+"_GCM/"+conf+"_large"+Stemp+"/3D/"+model+"_GCM_"+conf+"_large"+Stemp

filea = path2file+"_3D_ta_100d.nc"
fileb = path2file+"_3D_ua_100d.nc"
filec = path2file+"_3D_va_100d.nc"

  print("filea is: "+filea)
  print("file2 is: "+fileb)
  print("file3 is: "+filec)

maintitle="main title"
file1 = addfile(filea,"r")
file2 = addfile(fileb,"r")
file3 = addfile(filec,"r")

; need to have surface pressure to compute streamfunction

; pick a longitude
; probably should calculate a zonal mean over all longitudes...
;longi=30

;va_f = file3->va(:,0:29,:,:)
;;va_f = file3->va(:,0:29,:,:)
;;va_f = file3->va(:,:,:,:); time, level, lat, lon
;  printVarSummary(va_f)

field_ta = file1->ta(:,:,:,:)
field_ua = file2->ua(:,:,:,:)
field_va = file3->va(:,:,:,:)
troplev  = file3->lev

dims  = dimsizes(field_va)
ntime = dims(0)
nlev  = dims(1)
nlat  = dims(2)
nlon  = dims(3)

nlevm1 = nlev-1
va_f = file3->va(:,0:nlevm1,:,:)

; create new arrays
temp_prof = new((/nlev,nlat/),float)
;temp_prof = new((/nlev/),float)
;levm1 =  new((/31/),float)

  print("nlev is: "+nlev)

;  printMinMax(field_ta,False)
;  printVarSummary(field_ta) ; 101x30x192x288
;  printVarSummary(field_va); 101x30x192x288

scale = 1.
;var_to_plot=scale*dim_avg_n(field_ta,0)
var_to_plot_a=dim_avg_n(field_ta,0); 30x192x288
var_to_plot2_a=dim_avg_n(field_ua,0)
var_to_plot3_a=dim_avg_n(field_va,0)
; compute averages over longitude:
var_to_plot=dim_avg_n(var_to_plot_a,2); 30x192
var_to_plot2=dim_avg_n(var_to_plot2_a,2)
var_to_plot3=dim_avg_n(var_to_plot3_a,2)
; compute the time averaged vertical temperature profile: 
var_temp_vmn=dim_avg_n(var_to_plot,1); 

; compute anomalous temperature field
;var_to_plot_t=var_to_plot(i,:)-var_temp_vmn(i)

  print("number of levels is: "+nlev)
  count = 0
;if (dim .eq. 1 .or. dim .eq. 3) then
do while (count .le. nlev-1) 
  temp_prof(count,:) = var_to_plot(count,:)-var_temp_vmn(count)
  count = count +1
    print("count value is: "+count)
end do
;  else if (dim .eq. 0 .or. dim .eq. 2) then
;        ps    = f[:]->PSL(nstart:nend,:)
;  end if
  printVarSummary(var_temp_vmn)
  print("var_temp_vmn: "+var_temp_vmn)

  printVarSummary(temp_prof)
  printMinMax(temp_prof,False)

; compute averages for wind field: 
;vrms_sf_tm=dim_avg_n(vrms_sf,0)

var_to_plot!1="lat"
var_to_plot&lat=field_va&lat
var_to_plot!0="lev"
var_to_plot&lev=field_va&lev

var_to_plot2!1="lat"
var_to_plot2&lat=field_va&lat
var_to_plot2!0="lev"
var_to_plot2&lev=field_va&lev

;va_f = file3->va(:,0:29,:,:)
;va_f = file3->va(:,0:29,:,:)
;va_f = file3->va(:,:,:,:); time, level, lat, lon
;  printVarSummary(va_f)

  print("print out zeroth level:"+troplev(0))
  print("print out levels:"+troplev)

; vrms = sqrt(mean(square velocity))
; compute time average
umn_a=dim_avg_n(field_ua,0)
vmn_a=dim_avg_n(field_va,0)
;  printVarSummary(vmn_a)

vrms    = sqrt(field_ua^2+field_va^2)
;vrms_a  = sqrt(dim_avg_n(umn_a^2,0)+dim_avg_n(vmn_a^2,0))
vrms_a  = sqrt(dim_avg_n(field_ua^2,0)+dim_avg_n(field_va^2,0))
  printVarSummary(vrms)
  printVarSummary(vrms_a)
  print("nlevm1 is: "+nlevm1)
vrms_sf = vrms(:,nlevm1,:,:)
vrms_sf_a = vrms_a(nlevm1,:,:)
  printVarSummary(vrms_sf)
vrms_sf_avg = avg(vrms_sf)
vrms_a_sf_avg = avg(vrms_sf_a)

  print("+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*")
  print("average of vrms at level: "+va_f&lev(nlevm1)+" is: "+vrms_sf_avg) 
  print("average of vrms_a at level: "+va_f&lev(nlevm1)+" is: "+vrms_a_sf_avg) 
  print("+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*")

  print("test vrms: "+vrms(100,10,10,10))
  print("test vrms: ua and va: "+field_ua(100,10,10,10)+"and now va:"+field_va(100,10,10,10))
  addwindpnt = field_ua(100,10,10,10)^2+field_va(100,10,10,10)^2
  print("test vrms: ua^2 and va^2: "+field_ua(100,10,10,10)^2+"and now va:"+field_va(100,10,10,10)^2+" added: "+addwindpnt)

dims  = dimsizes(field_va)
ntime = dims(0)
nlev  = dims(1)
nlat  = dims(2)
nlon  = dims(3)
temp_prof = new((/nlev,nlat/),float)
;temp_prof = new((/nlev/),float)
;levm1 =  new((/31/),float)
  print("nlev is: "+nlev)

;  printMinMax(field_ta,False)
;  printVarSummary(field_ta) ; 101x30x192x288
;  printVarSummary(field_va); 101x30x192x288

scale = 1.
;var_to_plot=scale*dim_avg_n(field_ta,0)
var_to_plot_a=dim_avg_n(field_ta,0); 30x192x288
var_to_plot2_a=dim_avg_n(field_ua,0)
var_to_plot3_a=dim_avg_n(field_va,0)
; compute averages over longitude:
var_to_plot=dim_avg_n(var_to_plot_a,2); 30x192
var_to_plot2=dim_avg_n(var_to_plot2_a,2)
var_to_plot3=dim_avg_n(var_to_plot3_a,2)
; compute the time averaged vertical temperature profile: 
var_temp_vmn=dim_avg_n(var_to_plot,1); 

; compute anomalous temperature field
;var_to_plot_t=var_to_plot(i,:)-var_temp_vmn(i)

  print("number of levels is: "+nlev)
  count = 0
;if (dim .eq. 1 .or. dim .eq. 3) then
do while (count .le. nlev-1) 
  temp_prof(count,:) = var_to_plot(count,:)-var_temp_vmn(count)
  count = count +1
  ;  print("count value is: "+count)
end do
;  else if (dim .eq. 0 .or. dim .eq. 2) then
;        ps    = f[:]->PSL(nstart:nend,:)
;  end if
  printVarSummary(var_temp_vmn)
  print("var_temp_vmn: "+var_temp_vmn)

  printVarSummary(temp_prof)
  printMinMax(temp_prof,False)

; compute averages for wind field: 
vrms_sf_tm=dim_avg_n(vrms_sf,0)

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

temp_prof!1="lat"
temp_prof&lat=field_va&lat
temp_prof!0="lev"
temp_prof&lev=field_va&lev



; I think the time frequency for 3D output is 6 hourly (averged) at the moment
; so 4 times equal 1 day, 28 times equal 1 week. (initially I used times 1-27)

  ;my_levels1 = (/230,235,240,245,250,255,260, \
  ;               265,270,275,280,  \
  ;               282,284,286,288,290,  \
  ;               292,294,296,298,300 /) ;19  need 1 more color than level
  my_levels1 = (/-10,-9,-8,-7,-6,   \
                 -5,-4,-3,-2,-1,   \
                 0,1,2,3,4,   \
                 5,6,7,8,9,   \
                 10 /) ; need 1 more color than level
  my_levels2 = (/-10,-9,-8,-7,-6, \ 
                 -5,-4,-3,-2,-1, \
                 0,  \
                 1,2,3,4,5,  \
                 6,7,8,9,10 /) ;19  need 1 more color than level
  my_levels3 = (/-10,-9,-8,-7,-6, \ 
                 -5,-4,-3,-2,-1, \
                 0,  \
                 1,2,3,4,5,  \
                 6,7,8,9,10 /) ;19  need 1 more color than level
  pscale = 1.e10
  blah = (/-10*pscale,-9*pscale,-8*pscale,-7*pscale,-6*pscale, \ 
                 -5*pscale,-4*pscale,-3*pscale,-2*pscale,-1*pscale, \
                 0*pscale,  \
                 1*pscale,2*pscale,3*pscale,4*pscale,5*pscale,  \
                 6,7,8,9,10 /) ;19  need 1 more color than level
  my_levels4 = tointeger(blah)
  my_colors1 = (/49,56,63,70,77,       \
                 83,90,97,104,111,      \
                 0,0,              \
                 ;118,138,              \
                 145,152,159,166,173,  \
                 180,187,194,201,208 /);  \

printVarSummary(my_levels3)

;==============================================================================
wks = gsn_open_wks("pdf","windTemp_3pan")          ; send graphics to PNG file
;gsn_define_colormap(wks,"gui_default")
;gsn_define_colormap(wks,"WhBlGrYeRe")
gsn_define_colormap(wks,"cmocean_balance")
plot = new(3,graphic)

res                        = True
res@cnLinesOn              = False
res@cnLevelSelectionMode   = "ExplicitLevels"
res@cnLevels               = my_levels1
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
res@tmYLMode               = "Explicit"
res@tmYLValues             = (/100,200,400,600,800,1000/)
res@tmYLLabels             = (/"100","200","400","600","800","1000"/)
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

res@tiMainString           = "temperature" 
res@tiMainFontHeightF      = .018                               ; font height
  printVarSummary(var_to_plot2); 30x192
  printVarSummary(temp_prof) ; 30x192
  print("temp_prof: "+temp_prof(:,45))
;  print("temp_prof: "+temp_prof(5,:))
contour1 = gsn_csm_contour(wks,temp_prof(:,:),res)  ; create the plot
;contour1 = gsn_csm_contour(wks,var_to_plot(:,:),res)  ; create the plot
res@tiMainString           = "u wind" 
res@cnLevels               = my_levels2
contour2 = gsn_csm_contour(wks,var_to_plot2(:,:),res)  ; create the plot
res@tiMainString           = "v wind" 
res@cnLevels               = my_levels3
contour3 = gsn_csm_contour(wks,var_to_plot3(:,:),res)  ; create the plot

plot(0) = contour1
plot(1) = contour2
plot(2) = contour3

respanel = True

gsn_panel(wks,plot,(/3,1/),respanel)
;==============================================================================


end
