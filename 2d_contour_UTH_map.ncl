;----------------------------------------------
; plot a 2d contour map
;
; plot RH on 1 pressure level from 3D hur
;
; levi silvers                        may 2023
;----------------------------------------------

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  print("filen is: "+filen)
  print("pathn is: "+pathn)
  print("varn  is: "+varn)

;path="/glade/scratch/levi/RCEMIP/CAM6_GCM/RCEmip_3KW1/2D/"

;filename_in=path+"CAM6_GCM_RCEmip_3KW1_2D_wap500.nc"
filename_in=pathn+filen

maintitle=varn
  print("infile is: "+filename_in)
file1 = addfile(filename_in,"r")

; I think the time frequency for 3D output is 6 hourly (averged) at the moment
; so 4 times equal 1 day, 28 times equal 1 week. (initially I used times 1-27)
timeone=1
;
time1=29
time2=57

; for 1 year of a 3 year experiment: 
;time1=26280
;time2=17520

; for last 100d of a 2 year experiment: 
;time1=8761
;time2=17520

; for last 1d of a 2 year experiment: 
;time1=17496
;time2=17520

;time2=25280
;time1=2160
;time2=2880

;time1=17519
;time2=26279

; look at a monthly average: 24*30=720

;field = file1->$varn(time1:time2,:,:)
;vars = (/"wap500","tabot","pr_avg","cl"/)

  print("incoming level is: "+levn)

if (varn.eq."wap500") then
  field = file1->wap500(time1:time2,:,:)
  scale=864; converts Pa/s to hPa/d
  my_levels1 = (/-100,-90,-80,-70,-60,-50, \
                 -40,-30,-20,-10,0,10, \
                 20,30,40,50,60,70,80 /) ;19  need 1 more color than level
  my_colors1 = (/240,230,220,210,200,      \
                 190,180,170,160,140,         \
                 0,0,75,65,55,           \
                 45,35,25,15,5 /);  
end if

if (varn.eq."ts") then
  field = file1->ts(timeone,:,:)
  scale = 1.
  my_levels1 = (/296,296.5,297,297.5, \
                 298,298.5,299,299.5,300,300.5, \
                 301,301.5,302,302.5,303,303.5,304,304.5,305 /) ;19  need 1 more color than level
end if

if (varn.eq."prw") then
  field = file1->prw(time1:time2,:,:)
  scale = 1.
  my_levels1 = (/20,22,24,26,28,30, \
                 32,34,36,38,40,42, \
                 44,46,48,50,52,54,56 /) ;19  need 1 more color than level
end if

if (varn.eq."hur") then ; float hur(time, lev, lat, lon) ;
  level=levn
  ;field = file1->hur(timeone,level,:,:)
  field = file1->hur(time1:time2,level,:,:)
  levs = file1->lev
    print("height of level 1 is: "+levs(0))
    ;print("height of level 32 is: "+levs(31))
    print("level being used for hur is: "+level)
    print("level being used for hur is: "+levs(level))
  ;scale = 0.01
  scale = 1.
  ;my_levels1 = (/.05,.1,.15,.2,.25,.3, \
  ;               .35,.4,.45,.5,.55,.6, \
  ;               .65,.7,.75,.8,.85,.9,.95 /) ;19  need 1 more color than level
  my_levels1 = (/5,10,15,20,25,30, \
                 35,40,45,50,55,60, \
                 65,70,75,80,85,90,95 /) ;19  need 1 more color than level

  my_colors1 = (/145,125,120,115,110,105, \
               100,95,90,85,80,75, \
               70,65,60,55,50,45,40,35 /);  
end if 

if (varn.eq."mc") then ; float hur(time, lev, lat, lon) ;
  level=levn
  field = file1->mc(time1:time2,level,:,:)
  levs = file1->lev
    printMinMax(field, True); e.g. max of 0.06
    print("height of level 1 is: "+levs(0))
    ;print("height of level 32 is: "+levs(31))
    print("level being used for mc is: "+level)
    print("level being used for mc is: "+levs(level))
  scale = 100.
  my_levels1 = (/.05,.1,.15,.2,.25,.3, \
                 .35,.4,.45,.5,.55,.6, \
                 .65,.7,.75,.8,.85,.9,.95 /) ;19  need 1 more color than level
end if

  printVarSummary(field)

  print("----------------------------------------------")
  print("varname is: "+varn)
  print(min(min(min(field))))
  print(max(max(max(field))))
  print("----------------------------------------------")

if (ntime.eq."one") then
  var_to_plot=scale*field
else
  var_to_plot=scale*dim_avg_n(field,0)
end if
;var_to_plot=dim_avg_n_Wrap(field,0)

if (varn.eq."wap500") then
  znmn_var=dim_avg_n(var_to_plot,1)
  print("the zonal mean wap500 is: "+znmn_var)
end if
  print("----------------------------------------------")
  print("varname is: "+varn)
  print("scaled var is: "+min(min(min(var_to_plot))))
  print("scaled var is: "+max(max(max(var_to_plot))))
  print("----------------------------------------------")

  printVarSummary(field)


var_to_plot!0="lat"
var_to_plot&lat=field&lat
var_to_plot!1="lon"
var_to_plot&lon=field&lon

;************************************************

; cool values here correspond to low contour values...
;my_colors1 = (/13,23,33,43,53,63, \
;               73,83,93,103,113,123, \
;               133,143,153,163,173,183,193,203 /);  \

;; cool values here correspond to high contour values
;my_colors1 = (/203,193,126,120,114,108, \
;               102,96,90,84,78,72, \
;               66,60,54,48,42,34,28,22 /);  \
;
;;if (varn.eq."pr_avg") then
;  my_colors1 = (/145,125,120,115,110,105, \
;               100,95,90,85,80,75, \
;               70,65,60,55,50,45,40,35 /);  \
;else
;  my_colors1 = (/145,125,120,115,110,105, \
;               100,95,90,85,80,75, \
;               70,65,60,55,50,45,40,35 /);  \
;end if
;  my_colors1 = (/13,23,33,43,53,63, \
;               73,83,93,103,113,123, \
;               133,143,153,163,173,183,193,203 /);  \

wks = gsn_open_wks("pdf","testplot_map")          ; send graphics to PNG file
;gsn_define_colormap(wks,"gui_default")
;gsn_define_colormap(wks,"WhBlGrYeRe")
gsn_define_colormap(wks,"cmocean_balance")
plot = new(1,graphic)

res                      = True
res@cnLinesOn            = False
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = my_levels1
res@cnFillColors         = my_colors1
;res@mpProjection         = "Orthographic"       ; choose projection
;res@mpProjection         = "Robinson"       ; choose projection
  res@mpProjection      = "Mollweide"       ; choose projection
res@mpOutlineOn          = False
res@mpCenterLonF         = 180.
;res@mpCenterLatF         = 180.
res@mpCenterLatF         = 0.
res@mpGridAndLimbOn      = True              ; turn on lat/lon lines
res@mpPerimOn            = False             ; turn off box around plot
res@mpGridLatSpacingF    = 30.               ; spacing for lat lines
res@mpGridLonSpacingF    = 30.               ; spacing for lon lines
res@lbLabelAngleF        = 90
res@mpFillOn             = False
res@gsnDraw              = False
res@gsnFrame             = False
res@gsnMaximize          = True
 
res@cnFillOn             = True              ; color plot desired

res@tiMainString         = maintitle
res@tiMainFontHeightF    = .018                               ; font height
;if (varn.eq."cldfrac_avg") then
  contour1 = gsn_csm_contour_map(wks,var_to_plot(:,:),res)  ; create the plot
;else 
;  contour1 = gsn_csm_contour_map(wks,var_to_plot(:,:),res)  ; create the plot
;end if
plot(0) = contour1

respanel = True

gsn_panel(wks,plot,(/1,1/),respanel)

end
