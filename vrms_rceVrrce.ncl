;---------------------------------------------------------------------------------------------
; vrms_rceVrrce.ncl
; 
; compute the root mean square velocity at the lowest model level for RCE and RRCE experiments
; 
; levi                                                                        Oct 2023
;---------------------------------------------------------------------------------------------

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

conf="RCE"
Stemp=295
;model="CAM5"

temp       = (/295,300,305/)
model      = (/"CAM5","CAM6"/)
configStr  = (/"RCE","RRCE"/)

ntemp    = dimsizes(temp)
nmodel   = dimsizes(model)
nconfigs = dimsizes(configStr)
;nvar     = dimsizes(var_name)

vrms_array = new((/6,2/),float)

; structure of vrms_array: 
; (295, CAM5, RCE), (295, CAM5, RRCE)
; (295, CAM6, RCE), (295, CAM6, RRCE)
; (300, CAM5, RCE), (300, CAM5, RRCE)
; (300, CAM6, RCE), (300, CAM6, RRCE)
; (305, CAM5, RCE), (305, CAM5, RRCE)
; (305, CAM6, RCE), (305, CAM6, RRCE)

pathn=(/"/glade/derecho/scratch/levi/fromCheyenne/postp/RCEMIP/","/glade/derecho/scratch/levi/fromCheyenne/postp/RotRCEMIP/"/)

counter = 0
do i = 0,ntemp-1
  do j = 0,nmodel-1
    do k = 0,nconfigs-1
        print("<><><><><><><><><><><><><><><><><><><><><><><><><>")
        ;print("model is: "+model(j)+",  surface temperature = "+temp(i)+", configuration string is: "+configStr(k))
      path2file=pathn(k)+model(j)+"_GCM/"+configStr(k)+"_large"+temp(i)+"/3D/"+model(j)+"_GCM_"+configStr(k)+"_large"+temp(i)
      filea = path2file+"_3D_ua.nc"
      fileb = path2file+"_3D_va.nc"
        print("filea is: "+filea)
        print("fileb is: "+fileb)
      file1 = addfile(filea,"r")
      file2 = addfile(fileb,"r")
      field_ua = file1->ua(:,:,:,:)
      field_va = file2->va(:,:,:,:)
      dims  = dimsizes(field_va)
      ntime = dims(0)
      nlev  = dims(1)
      nlat  = dims(2)
      nlon  = dims(3)
      nlevm1 = nlev-1
      va_f = file2->va(:,0:nlevm1,:,:)
      ;vrms    = sqrt(field_ua^2+field_va^2)
      ;vrms_a  = sqrt(dim_avg_n(umn_a^2,0)+dim_avg_n(vmn_a^2,0))
      ; average over time:
      vrms  = sqrt(dim_avg_n(field_ua^2,0)+dim_avg_n(field_va^2,0))
        printVarSummary(vrms)
        print("nlevm1 is: "+nlevm1)
      vrms_sf = vrms(nlevm1,:,:)
        printVarSummary(vrms_sf)
      vrms_sf_avg = avg(vrms_sf)
        print("+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*")
        print("model is: "+model(j)+",  surface temperature = "+temp(i)+", configuration string is: "+configStr(k))
        print("average of vrms at level: "+va_f&lev(nlevm1)+" is: "+vrms_sf_avg) 
        print("+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*")
      vrms_array(counter,k)=vrms_sf_avg
      ; delete variables for this itteration in prep for the next.
      delete(field_ua)
      delete(field_va)
      delete(dims)
      delete(nlev)
      delete(nlevm1)
      delete(va_f)
      delete(vrms)
      delete(vrms_sf)
      delete(vrms_sf_avg)
    end do
    counter = counter + 1
  end do 
end do


 ; print("test vrms: "+vrms(100,10,10,10))
 ; print("test vrms: ua and va: "+field_ua(100,10,10,10)+"and now va:"+field_va(100,10,10,10))
;addwindpnt = field_ua(100,10,10,10)^2+field_va(100,10,10,10)^2
 ; print("test vrms: ua^2 and va^2: "+field_ua(100,10,10,10)^2+"and now va:"+field_va(100,10,10,10)^2+" added: "+addwindpnt)


print("+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*")
  print("the array of vrms values is: "+vrms_array)
print("+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*")


end 
