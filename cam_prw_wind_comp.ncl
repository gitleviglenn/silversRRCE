load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin
;******************************************************
;  Open a netCDF file containing the grid and data from the HOMME
;  (High-Order Multiscale Modeling Environment) model, formerly
;  called SEAM (Spectral Element Atmosphere Model).
;******************************************************

;path_cheyenne="/glade/scratch/levi/RotRCEMIP/"
if (configString.eq."rotating") then
    print("  Analyzing RRCE experiments    ")
  rotStr="RRCE"
  RCEMIP_dir="/glade/derecho/scratch/levi/fromCheyenne/postp/RotRCEMIP/"
else
    print("  Analyzing RCE experiments    ")
  rotStr="RCE"
  RCEMIP_dir="/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/"
end if

path_C5="CAM5_GCM/"
path_C6="CAM6_GCM/"


  wks_type = "pdf"
  wks_type@wkPaperWidthF  =  8.5  ; in inches
  wks_type@wkPaperHeightF = 11.0  ; in inches
  wks = gsn_open_wks(wks_type,"prw_wind_comparison")
  gsn_define_colormap(wks,"MPL_BrBG") ; "cmp_b2r") ;"MPL_YlGn")   ; choose colormap

  ;RCEMIP_dir = "/glade/scratch/levi/RCEMIP/"
  ;plot_time = 1*24*365*3
  plot_time = 1*24*365*2 ; for two year runs
  ;plot_time = 1*24 ; for two year runs
  temp  = (/295,300,305/)
  model = (/"CAM5","CAM6"/)

  ntemp = dimsizes(temp)
  nmodel= dimsizes(model)
  plot1 = new(ntemp*nmodel,graphic)
  ;plot2 = new(ntemp*nmodel,graphic)
  
  do i = 0,ntemp-1 
  do j = 0,nmodel-1
  print("Creating plots for temperature = "+temp(i))
  file_prw = addfile(RCEMIP_dir+model(j)+"_GCM/"+rotStr+"_large"+temp(i)+"/2D/"+model(j)+"_GCM_"+rotStr+"_large"+temp(i)+"_2D_prw.nc","r")
  file_u   = addfile(RCEMIP_dir+model(j)+"_GCM/"+rotStr+"_large"+temp(i)+"/2D/"+model(j)+"_GCM_"+rotStr+"_large"+temp(i)+"_2D_uabot.nc","r")
  file_v   = addfile(RCEMIP_dir+model(j)+"_GCM/"+rotStr+"_large"+temp(i)+"/2D/"+model(j)+"_GCM_"+rotStr+"_large"+temp(i)+"_2D_vabot.nc","r")

;    print("one of the files used is: "+file_prw)
  print("this script is a piece of shit.")
  lat   = file_prw->lat  
  prw_full   = file_prw->prw
;    print("dimensions of prw_full are: "+dimsizes(prw_full))
  prw   = file_prw->prw(plot_time,:,:)
  u     = file_u->uabot(plot_time,:,:)
  v     = file_v->vabot(plot_time,:,:)
  time  = file_prw->time(plot_time)

  print("Plotting for time = "+time)

  rad     = 4.0*atan(1.0)/180.0
  clat    = cos(lat*rad)
  prw_avg = wgt_areaave_Wrap(prw, clat, 1.0, 1)
  aprw    = prw
  aprw    = prw - prw_avg

  print(min(aprw))
  print(max(aprw))
  
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
  res1@lbLabelBarOn         = False


  res1@mpGridAndLimbOn   = True           ; turn on lat/lon lines
  res1@mpGridLatSpacingF = 30.
  res1@mpGridLonSpacingF = 30.
  res1@mpCenterLatF      = 90.            ; centers on the north pole
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
  res1@vcGlyphStyle             = "CurlyVector"    ; turn on curly vectors
  res1@vcMinDistanceF           = 0.0275            ; thin vectors
  res1@vcRefAnnoOrthogonalPosF  = -.25               ; move ref vector down
  res1@vcRefAnnoParallelPosF    = 1.135 
  res1@vcRefAnnoOn              = False
  res1@vcGlyphOpacityF          = 1
  res1@vcLineArrowColor         = "Black"           ; change vector color
  res1@vcLineArrowThicknessF    = 2.0               ; change vector thickness
  res1@vcVectorDrawOrder        = "PostDraw"        ; draw vectors last
  res1@vcRefAnnoString2On       = True
  res1@vcRefAnnoString2         = "Wind"
  res1@vcRefAnnoString1         = "10 m/s"
  res1@vcRefAnnoFontHeightF     = 0.015


  if (j .eq. 0) then
    res1@tiYAxisString       = temp(i)+" K"
  else
    res1@tiYAxisString       = ""  
  end if

  if (i .eq. 0) then
    res1@gsnCenterString        = model(j) 
    res1@gsnStringFont              = "helvetica-bold"  ; will be used for gsnCenterString later
    res1@gsnCenterStringFontHeightF = 0.025              ; ditto
  else
    res1@gsnCenterString        = ""
  end if
  if (i .eq. 2 .and. j .eq. 0) then
    res1@vcRefAnnoOn = True
  end if

  plot1(2*i+j)   = gsn_csm_vector_scalar_map(wks,u,v,aprw,res1)

  delete(aprw)
  delete(prw)
  delete(u)
  delete(v)
  end do 
  end do

 panelres1                            = True
 panelres1@gsnPanelBottom             = 0.2			 ; shrink panel plot by setting bottom edge of plot
 panelres1@gsnPanelTop                = 0.9			 ; shrink panel plot by setting top edge of plot
 panelres1@gsnPanelLabelBar           = True
 panelres1@vpXF                       = 0.518-.22         ; Position labelbar at
 panelres1@vpHeightF                  = 0.095     ; Height of labelbar
 panelres1@vpWidthF                   = 0.44      ; Width of labelbar
 panelres1@lbLabelFontHeightF         = 0.01
 panelres1@lbLabelStride              = 2
 panelres1@txPosXF                    = 0.72
 panelres1@txPosYF                    = 0.925
 panelres1@txFont                     = 22 
 panelres1@lbTitleString              = "Precipitable Water (kg/m~S~2~N~)"
 panelres1@lbTitlePosition            = "Top"
 panelres1@lbTitleFontHeightF         = 16
 panelres1@lbTitleFont                = 22
 panelres1@pmLabelBarOrthogonalPosF   = -.01
 gsn_panel(wks,plot1, (/ntemp,nmodel/),panelres1)

end

