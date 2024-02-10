;***********************************************************************************
; 2d_contour_Fig1_map.ncl 
;***********************************************************************************
; plot a 2d contour map
;
; create a 4 panel plot of RH on 1 pressure level 
; and the PW anomaly from RCE and RRCE experiments
;
; RCE:     PW'         RH
; RRCE:    PW'         RH
;
; levi silvers                        may 2023
;***********************************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/glade/work/levi/scripts/nclscripts/lib/trimPNG.ncl"

begin

path="/glade/derecho/scratch/levi/RCEMIP/CAM6_GCM/RCEmip_3KW1/2D/"

;filename_in=path+"CAM6_GCM_RCEmip_3KW1_2D_wap500.nc"
;filename_in=pathn+filen


RCEMIP_dir="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/"
RRCEMIP_dir="/glade/derecho/scratch/levi/fromCheyenne/postp/RotRCEMIP/"

; select which model to use
;path_C5="CAM5_GCM/"
;level=17
;model = "CAM5"

path_C6="CAM6_GCM/"
level=19
model = "CAM6"

temp  =  300

;gsn_define_colormap(wks,"MPL_BrBG") ; "cmp_b2r") ;"MPL_YlGn")   ; choose colormap

plot_time = 1*24*365*2 ; for two year runs

rad     = 4.0*atan(1.0)/180.0

;  ntemp = dimsizes(temp)
;  nmodel= dimsizes(model)
;  plot1 = new(ntemp*nmodel,graphic)
;  plot2 = new(ntemp*nmodel,graphic)
  

  print("Creating plots for temperature = "+temp)

; define files for the PW and wind plots: 
; RCE
file_prw = addfile(RCEMIP_dir+model+"_GCM/RCE_large"+temp+"/2D/"+model+"_GCM_RCE_large"+temp+"_2D_prw.nc","r")
file_u   = addfile(RCEMIP_dir+model+"_GCM/RCE_large"+temp+"/2D/"+model+"_GCM_RCE_large"+temp+"_2D_uabot.nc","r")
file_v   = addfile(RCEMIP_dir+model+"_GCM/RCE_large"+temp+"/2D/"+model+"_GCM_RCE_large"+temp+"_2D_vabot.nc","r")

  print("file to read is: "+RCEMIP_dir+model+"_GCM/RCE_large"+temp+"/2D/"+model+"_GCM_RCE_large"+temp+"_2D_prw.nc")
  print("this script is a piece of shit.")
lat   = file_prw->lat  
;prw_full   = file_prw->prw
;    print("dimensions of prw_full are: "+dimsizes(prw_full))
prw_a   = file_prw->prw(plot_time,:,:)
u_a     = file_u->uabot(plot_time,:,:)
v_a     = file_v->vabot(plot_time,:,:)
time_a  = file_prw->time(plot_time)

  print("Plotting for time = "+time_a)

; compute area weighted average and the anomolous PW field
clat    = cos(lat*rad)
prw_avg = wgt_areaave_Wrap(prw_a, clat, 1.0, 1)
aprw_rce    = prw_a
aprw_rce    = prw_a - prw_avg

  print(min(aprw_rce))
  print(max(aprw_rce))

; RRCE
file_prw = addfile(RRCEMIP_dir+model+"_GCM/RRCE_large"+temp+"/2D/"+model+"_GCM_RRCE_large"+temp+"_2D_prw.nc","r")
file_u   = addfile(RRCEMIP_dir+model+"_GCM/RRCE_large"+temp+"/2D/"+model+"_GCM_RRCE_large"+temp+"_2D_uabot.nc","r")
file_v   = addfile(RRCEMIP_dir+model+"_GCM/RRCE_large"+temp+"/2D/"+model+"_GCM_RRCE_large"+temp+"_2D_vabot.nc","r")

prw_b   = file_prw->prw(plot_time,:,:)
u_b     = file_u->uabot(plot_time,:,:)
v_b     = file_v->vabot(plot_time,:,:)
time_b  = file_prw->time(plot_time)

; compute area weighted average and the anomolous PW field
prw_avg = wgt_areaave_Wrap(prw_b, clat, 1.0, 1)
aprw_rrce    = prw_b
aprw_rrce    = prw_b - prw_avg

  print(min(aprw_rrce))
  print(max(aprw_rrce))

;;;;;;;;;;;;;;;;;

; and now for the humidity data
; I think the time frequency for 3D output is 6 hourly (averged) at the moment
; so 4 times equal 1 day, 28 times equal 1 week. (initially I used times 1-27)
;
;time1=29
;time2=57
time1=1
time2=27

;ncl 'levn=19' 'varn="hur"' 'ntime="two"' 'filen="CAM6_GCM_RCE_large300_3D_hur.nc"' 'pathn="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/CAM6_GCM/RCE_large300/3D/"' 2d_contour_UTH_map.ncl
file_hur = addfile(RCEMIP_dir+model+"_GCM/RCE_large"+temp+"/3D/"+model+"_GCM_RCE_large"+temp+"_3D_hur.nc","r")
field_hur_a = file_hur->hur(time1:time2,level,:,:)
file_hur = addfile(RRCEMIP_dir+model+"_GCM/RRCE_large"+temp+"/3D/"+model+"_GCM_RRCE_large"+temp+"_3D_hur.nc","r")
field_hur_b = file_hur->hur(time1:time2,level,:,:)

lev_all   = file_hur->lev  
  print("levels are: "+lev_all)
  print("level being used is: "+level+"which is: "+lev_all(level))

my_levels1 = (/5,10,15,20,25,30, \
               35,40,45,50,55,60, \
               65,70,75,80,85,90,95 /) ;19  need 1 more color than level

; for use with the cmp_b2r colortable
;my_colors1 = (/45,35,32,30,28,      \
;               26,24,23,22,21,      \
;               20,19,18,17,16,      \
;               15,14,13,12,11       /)
my_colors1 = (/45,35,28,      \
               26,24,23,22,21,      \
               20,19,18,17,16,      \
               15,14,13,12,11,9,7       /)

;; for use with the GMT_globe colortable
;my_colors1 = (/150,136,128,123,118, \
;               113,108,103,98,93,   \
;               88,83,78,73,68,      \
;               63,58,53,48,43/);
;
;my_colors1 = (/155,145,125,120,115,110,105, \
;             100,95,90,85,80,75, \
;             70,65,60,55,50,45,40 /);  
;
;average over time:
scale=1.
var_to_plot_a=scale*dim_avg_n(field_hur_a,0)

var_to_plot_a!0="lat"
var_to_plot_a&lat=prw_a&lat
var_to_plot_a!1="lon"
var_to_plot_a&lon=prw_a&lon

var_to_plot_b=scale*dim_avg_n(field_hur_b,0)

var_to_plot_b!0="lat"
var_to_plot_b&lat=prw_a&lat
var_to_plot_b!1="lon"
var_to_plot_b&lon=prw_a&lon

;
;;************************************************
;
wtype = "png"
wtype@wkWidth  = 2500  ; increase size of pdf image
wtype@wkHeight = 2500
fout    =  "testplot_map"
wks = gsn_open_wks(wtype,fout)          ; send graphics to PNG file
;gsn_define_colormap(wks,"gui_default")
;gsn_define_colormap(wks,"WhBlGrYeRe")
;gsn_define_colormap(wks,"cmocean_balance")
;gsn_define_colormap(wks,"MPL_BrBG") ; "cmp_b2r") ;"MPL_YlGn")   ; choose colormap
gsn_define_colormap(wks,"MPL_RdBu")
plotA = new(2,graphic)
plotB = new(2,graphic)
;
;

  res1                      = True         ; plot modifications desired
  res1@gsnDraw              = False        ; don't draw plot
  res1@gsnFrame             = False        ; don't advance frame

  res1@gsnScalarContour      = True
  res1@cnLevelSelectionMode = "manualLevels"    ; set contour intervals
 ; res1@cnLevelSpacingF      =  5.                ;
 ; res1@cnMinLevelValF       =  10.0           ;
 ; res1@cnMaxLevelValF       =  80.0 ;
  res1@cnLevelSpacingF      =  2                ;
  res1@cnMinLevelValF       =  -20.0           ;
  res1@cnMaxLevelValF       =  20.0 ;
  res1@cnFillOn             = True         ; Turn on contour fill
  res1@cnFillMode           = "RasterFill"
  res1@cnLinesOn            = False        ; Turn off contour lines
  res1@cnLineLabelsOn       = False        ; Turn off contour line labels
  res1@lbLabelBarOn         = False        ; turn off individual label bars

  res1@mpGridAndLimbOn   = True           ; turn on lat/lon lines
  res1@mpGridLatSpacingF = 30.
  res1@mpGridLonSpacingF = 30.
  res1@mpCenterLatF      = 0.            
  res1@mpPerimOn         = False               ; turn off perimeter
  res1@mpFillOn         = False
  res1@mpOutlineBoundarySets     = "NoBoundaries"
  res1@mpProjection = "Mollweide"

  res1@gsnRightString  = ""
  res1@gsnLeftString   = ""

  res1@tiYAxisFontHeightF    = 0.025
  res1@tiYAxisFont           = 22   
  res1@tiYAxisSide           = "Left"

  res1@gsnAddCyclic             = True           ; regional data
  res1@vcRefMagnitudeF          = 10.0             ; define vector ref mag
  res1@vcRefLengthF             = 0.1
;  res1@vcFillArrowWidthF        = 1.6             ; should help to make vector lns thicker
  res1@vcGlyphStyle             = "CurlyVector"    ; turn on curly vectors
  res1@vcMinDistanceF           = 0.0275            ; thin vectors
  res1@vcRefAnnoOrthogonalPosF  = -.25               ; move ref vector down
  res1@vcRefAnnoParallelPosF    = 1.135 
  res1@vcRefAnnoOn              = False
  res1@vcGlyphOpacityF          = 1
  res1@vcLineArrowColor         = "Black"           ; change vector color
  res1@vcLineArrowThicknessF    = 6.0               ; change vector thickness
  res1@vcVectorDrawOrder        = "PostDraw"        ; draw vectors last
  res1@vcRefAnnoString2On       = True
  res1@vcRefAnnoString2         = "Wind"
  res1@vcRefAnnoString1         = "10 m/s"

plotA(0)     = gsn_csm_vector_scalar_map(wks,u_a,v_a,aprw_rce,res1)
;plot(0)   = plot1
plotA(1)     = gsn_csm_vector_scalar_map(wks,u_b,v_b,aprw_rrce,res1)
;plot(1)   = plot2

res                      = True
res@cnLevelSelectionMode = "ExplicitLevels"
;res@cnFillPalette        = "cmocean_balance"
res@cnFillPalette        = "cmp_b2r"
;res@cnFillPalette        = "GMT_globe"
res@cnLevels             = my_levels1
res@cnFillColors         = my_colors1
;res@mpProjection         = "Orthographic"       ; choose projection
;res@mpProjection         = "Robinson"       ; choose projection
res@mpProjection         = "Mollweide"       ; choose projection
res@mpOutlineOn          = False
res@mpCenterLonF         = 180.
;res@mpCenterLatF         = 180.
res@mpCenterLatF         = 0.
res@mpGridAndLimbOn      = True              ; turn on lat/lon lines
res@mpPerimOn            = False             ; turn off box around plot
res@mpGridLatSpacingF    = 30.               ; spacing for lat lines
res@mpGridLonSpacingF    = 30.               ; spacing for lon lines
res@lbLabelBarOn         = False        ; turn off individual label bars
res@lbLabelAngleF        = 90
res@mpFillOn             = False
res@cnLinesOn            = False        ; Turn off contour lines
res@cnLineLabelsOn       = False        ; Turn off contour line labels
res@gsnDraw              = False
res@gsnFrame             = False
res@gsnMaximize          = True
res@cnFillOn             = True              ; color plot desired

plotB(0) = gsn_csm_contour_map(wks,var_to_plot_a(:,:),res)  ; create the plot
;plot(2) = contour3
plotB(1) = gsn_csm_contour_map(wks,var_to_plot_b(:,:),res)  ; create the plot

pres1                        = True
pres1@gsnFrame               = False           ; save panel until both ready
pres1@gsnPanelRight          = 0.5             ; draw from left edge to center
pres1@gsnPanelLabelBar       = True            ; common label bar
pres1@lbLabelStride          = 2               ; every other label
;resP@txString                = " "
;pres1@pmLabelBarWidthF     = 0.3
;pres1@pmLabelBarHeightF    = 0.06
pres1@vpXF                   = 0.5-.4         ; Position labelbar at
pres1@vpYF                   = 0.295         ; Position labelbar at
pres1@vpHeightF              = 0.075     ; Height of labelbar
pres1@vpWidthF               = 0.3      ; Width of labelbar
pres1@lbTitleOn           = True 
pres1@lbTitlePosition     = "Bottom"
pres1@lbTitleString       = "PW anom"
pres1@lbTitleString       = "PW anomaly (kg/m~S~2~N~)"
;resP@lbTitleFontHeightF  = 0.015
pres1@lbTitleFontHeightF  = 16
pres1@lbTitleFont         = 22
;resP@lbLabelFontHeightF      = 0.015
pres1@gsnPanelFigureStrings = (/"a.  RCE","c.  RRCE"/)
pres1@gsnPanelFigureStringsPerimOn = False
pres1@gsnPanelFigureStringsFontHeightF = 0.015
pres1@amJust                = "TopLeft"



pres2                        = True
pres2@gsnFrame               = False           ; save panel until both ready
pres2@gsnPanelLeft           = 0.5             ; draw from left edge to center
pres2@gsnPanelLabelBar       = True            ; common label bar
pres2@lbLabelStride          = 2               ; every other label
;pres2@pmLabelBarWidthF       = 0.3
;pres2@pmLabelBarHeightF      = 0.06
pres2@vpXF                   = 0.5+.1         ; Position labelbar at
pres2@vpYF                   = 0.3         ; Position labelbar at
pres2@vpHeightF              = 0.075     ; Height of labelbar
pres2@vpWidthF               = 0.3      ; Width of labelbar
pres2@lbTitleOn           = True 
pres2@lbTitlePosition     = "Bottom"
pres2@lbTitleString       = "RH aloft (%)"
pres2@lbTitleFontHeightF  = 16
pres2@lbTitleFont         = 22
pres2@gsnPanelFigureStrings = (/"b.  RCE","d.  RRCE"/)
pres2@gsnPanelFigureStringsPerimOn = False
pres2@amJust                = "TopLeft"
pres2@gsnPanelFigureStringsFontHeightF = 0.015


gsn_panel(wks,plotA,(/2,1/),pres1)
gsn_panel(wks,plotB,(/2,1/),pres2)

frame(wks)

trimPNG(fout)

end




