export CURRENTUSER=$(whoami)
SCRIPTDIR=$(readlink -f "$0")
CURRENTDIR=$(dirname "$SCRIPTDIR")
CURRENTUSER=$3
ZIP=$1
NEKO=$2
AT=$CURRENTDIR/AT
MA=$CURRENTDIR/MA
MK=$CURRENTDIR/MK
MN=$CURRENTDIR/MN
RZIP=$CURRENTDIR/rzip
A=/mnt/sysa
B=/mnt/syse
C=/mnt/ven
D=/mnt/pro
E=/mnt/odm
AA=/mnt/sysa2
BB=/mnt/syse2
CC=/mnt/ven2
DD=/mnt/pro2
EE=/mnt/odm2
rm -r $AT $MA || true
mkdir $AT $MA || true
rm -r $CURRENTDIR/MIUI* || true

#PAYLOAD
if unzip -d $AT $ZIP payload.bin
then
unzip -d $AT $ZIP apex_info.pb care_map.pb payload_properties.txt
cp -af $CURRENTDIR/pay_per.py $AT/
cp -af $CURRENTDIR/update_metadata_pb2.py $AT/
python3 $AT/pay_per.py $AT/payload.bin --out $AT/output
#FIRMWAREUPDATE
rm -r $MN $MK || true
mkdir $MN $MK || true
mv $AT/output/abl.img $CURRENTDIR/MK/
mv $AT/output/aop.img $CURRENTDIR/MK/
mv $AT/output/bluetooth.img $CURRENTDIR/MK/
mv $AT/output/cmnlib.img $CURRENTDIR/MK/
mv $AT/output/cmnlib64.img $CURRENTDIR/MK/
mv $AT/output/devcfg.img $CURRENTDIR/MK/
mv $AT/output/dsp.img $CURRENTDIR/MK/
mv $AT/output/dtbo.img $CURRENTDIR/MK/
mv $AT/output/featenabler.img $CURRENTDIR/MK/
mv $AT/output/hyp.img $CURRENTDIR/MK/
mv $AT/output/imagefv.img $CURRENTDIR/MK/
mv $AT/output/keymaster.img $CURRENTDIR/MK/
mv $AT/output/modem.img $CURRENTDIR/MK/
mv $AT/output/qupfw.img $CURRENTDIR/MK/
mv $AT/output/tz.img $CURRENTDIR/MK/
mv $AT/output/uefisecapp.img $CURRENTDIR/MK/	
mv $AT/output/vbmeta.img $CURRENTDIR/MK/
mv $AT/output/vbmeta_system.img $CURRENTDIR/MK/
mv $AT/output/xbl.img $CURRENTDIR/MK/
mv $AT/output/xbl_config.img $CURRENTDIR/MK/


#NEWIMGSIZE
cp $CURRENTDIR/new_size.sh $MN/

cp $CURRENTDIR/Dlac.img $MN/system.img
system=`du -b $AT/output/system.img | awk '{print $1}'`
let sysn=$system/512 
let sysn1=$sysn+586250
sed -i "s/apo/$sysn1/g" $MN/new_size.sh

cp $CURRENTDIR/Dlac.img $MN/system_ext.img
system_ext=`du -b $AT/output/system_ext.img | awk '{print $1}'`
let sysa=$system_ext/512
let sysa1=$sysa+586000
sed -i "s/rac/$sysa1/g" $MN/new_size.sh

cp $CURRENTDIR/Dlac.img $MN/vendor.img
vendor=`du -b $AT/output/vendor.img | awk '{print $1}'`
let syse=$vendor/512 
let syse1=$syse+585900
sed -i "s/tac/$syse1/g" $MN/new_size.sh

cp $CURRENTDIR/Dlac.img $MN/product.img
product=`du -b $AT/output/product.img | awk '{print $1}'`
let sysf=$product/512 
let sysf1=$sysf+585900
sed -i "s/dac/$sysf1/g" $MN/new_size.sh

cp $CURRENTDIR/Dlac.img $MN/odm.img
odm=`du -b $AT/output/odm.img | awk '{print $1}'`
let sysx=$odm/512 
let sysx1=$sysx+1000
sed -i "s/lam/$sysx1/g" $MN/new_size.sh

sudo bash $MN/new_size.sh 
echo

#MOUNT
sudo rm -r $A $B $C $D $E $AA $BB $CC $DD $EE || true
sudo mkdir $A $B $C $D $E $AA $BB $CC $DD $EE || true

sudo mount -o rw,noatime $MN/system.img $A
sudo mount -o rw,noatime $MN/system_ext.img $B
sudo mount -o rw,noatime $MN/vendor.img $C
sudo mount -o rw,noatime $MN/product.img $D
sudo mount -o rw,noatime $MN/odm.img $E

sudo mount -r $AT/output/system.img $AA
sudo mount -r $AT/output/system_ext.img $BB 
sudo mount -r $AT/output/vendor.img $CC
sudo mount -r $AT/output/product.img $DD
sudo mount -r $AT/output/odm.img $EE 

#COPYNEWF
echo "copiando archivos"
echo
echo "copiando system"
sudo cp -Raf $AA/* $A/
echo "copiando system_ext"
sudo cp -Raf $BB/* $B/
echo "copiando vendor"
sudo cp -Raf $CC/* $C/
echo "copiando product" 
sudo cp -Raf $DD/* $D/
echo "copiando odm"
sudo cp -Raf $EE/* $E/
ROMVERSION=$(grep ro.system.build.version.incremental= $A/system/build.prop | sed "s/ro.system.build.version.incremental=//g"; )
ROMANDROID=$(grep ro.build.version.release= $A/system/build.prop | sed "s/ro.build.version.release=//g"; )
ROMBUILD=$(grep ro.build.id= $A/system/build.prop | sed "s/ro.build.id=//g"; )
sudo umount /mnt/*

#ZIPF
rm -r $RZIP || true
mkdir $RZIP || true
cp -af $CURRENTDIR/dynamic_partitions_op_list $RZIP/

systemop=`du -b $MN/system.img | awk '{print $1}'`
sed -i "s/apo/$systemop/g" $RZIP/dynamic_partitions_op_list

system_extop=`du -b $MN/system_ext.img | awk '{print $1}'`
sed -i "s/rac/$system_extop/g" $RZIP/dynamic_partitions_op_list

vendorop=`du -b $MN/vendor.img | awk '{print $1}'`
sed -i "s/tac/$vendorop/g" $RZIP/dynamic_partitions_op_list

productop=`du -b $MN/product.img | awk '{print $1}'`
sed -i "s/dac/$productop/g" $RZIP/dynamic_partitions_op_list

odmop=`du -b $MN/odm.img | awk '{print $1}'`
sed -i "s/lam/$odmop/g" $RZIP/dynamic_partitions_op_list

let SUMATO=$systemop+$system_extop+$vendorop+$productop+$odmop
sleep 2s
echo
echo "limite de oplist 9122611200"
echo 
echo "system      =    $systemop"
echo "system_ext  =    $system_extop"
echo "vendor      =    $vendorop"
echo "product     =    $productop"
echo "odm         =    $odmop"
echo "suma total  =    $SUMATO"
echo
cp -Raf $CURRENTDIR/META-INF $RZIP/
cp -Raf $CURRENTDIR/img2sdat $MA/
mv $MN/* $MA/

#DATBR
echo "chingandose system"
#SYSTEM
img2simg $MA/system.img $MA/system2.img 
python3 $MA/img2sdat/img2sdat.py $MA/system2.img -o output -v 4 -p system --out $MA/output/

brotli -4fk $MA/output/system.new.dat 
rm -rf $MA/output/system.new.dat 
echo "chingandose system_ext"
#SYSTEMEXT
img2simg $MA/system_ext.img $MA/system_ext2.img 
python3 $MA/img2sdat/img2sdat.py $MA/system_ext2.img -o output -v 4 -p system_ext --out $MA/output/

brotli -4fk $MA/output/system_ext.new.dat 
rm -rf $MA/output/system_ext.new.dat 
echo "chingandose vendor"
#VENDOR
img2simg $MA/vendor.img $MA/vendor2.img 
python3 $MA/img2sdat/img2sdat.py $MA/vendor2.img -o output -v 4 -p vendor --out $MA/output/

brotli -4fk $MA/output/vendor.new.dat 
rm -rf $MA/output/vendor.new.dat   
echo "chingandose product"
#PRODUCT
img2simg $MA/product.img $MA/product2.img 
python3 $MA/img2sdat/img2sdat.py $MA/product2.img -o output -v 4 -p product --out $MA/output/

brotli -4fk $MA/output/product.new.dat 
rm -rf $MA/output/product.new.dat 
echo "chingandose odm"
#ODM
img2simg $MA/odm.img $MA/odm2.img 
python3 $MA/img2sdat/img2sdat.py $MA/odm2.img -o output -v 4 -p odm --out $MA/output/

brotli -4fk $MA/output/odm.new.dat 
rm -rf $MA/output/odm.new.dat 

#FINIZI
cd ..
mv $MA/output/* $RZIP/
mv $AT/output/boot.img $RZIP/
mv $AT/output/vendor_boot.img $RZIP/
mkdir $RZIP/firmware-update
mv $CURRENTDIR/MK/* $RZIP/firmware-update/
cd $RZIP
zip -ry MIUI_Alioth_RW_$ROMVERSION-$ROMBUILD-v$ROMANDROID.zip *
mv $RZIP/MIUI* $CURRENTDIR/ 
mv $CURRENTDIR/MIUI_Alioth* $NEKO/
sudo rm -r $AT $MA $MK $MN $RZIP
chmod -R 777 $NEKO/MIUI_Alioth*
exit
else
echo "saltando payload.bin"
sleep 3s
fi

#FASTBOOTZIP
if unzip -d $AT $ZIP linux*
then
unzip -d $AT $ZIP images/*
echo
#FIRMWAREUPDATE
rm -r $MN $MK || true
mkdir $MN $MK || true
mv $AT/images/abl.img $CURRENTDIR/MK/
mv $AT/images/aop.img $CURRENTDIR/MK/
mv $AT/images/bluetooth.img $CURRENTDIR/MK/
mv $AT/images/cmnlib.img $CURRENTDIR/MK/
mv $AT/images/cmnlib64.img $CURRENTDIR/MK/
mv $AT/images/devcfg.img $CURRENTDIR/MK/
mv $AT/images/dsp.img $CURRENTDIR/MK/
mv $AT/images/dtbo.img $CURRENTDIR/MK/
mv $AT/images/featenabler.img $CURRENTDIR/MK/
mv $AT/images/hyp.img $CURRENTDIR/MK/
mv $AT/images/imagefv.img $CURRENTDIR/MK/
mv $AT/images/keymaster.img $CURRENTDIR/MK/
mv $AT/images/modem.img $CURRENTDIR/MK/
mv $AT/images/qupfw.img $CURRENTDIR/MK/
mv $AT/images/tz.img $CURRENTDIR/MK/
mv $AT/images/uefisecapp.img $CURRENTDIR/MK/	
mv $AT/images/vbmeta.img $CURRENTDIR/MK/
mv $AT/images/vbmeta_system.img $CURRENTDIR/MK/
mv $AT/images/xbl.img $CURRENTDIR/MK/
mv $AT/images/xbl_config.img $CURRENTDIR/MK/


#SUPER
mkdir $AT/output || true
python3 $CURRENTDIR/lu.py $AT/images/super.img $AT/output/


#NEWIMGSIZE
cp $CURRENTDIR/new_size.sh $MN/

cp $CURRENTDIR/Dlac.img $MN/system.img
system=`du -b $AT/output/system_a.img | awk '{print $1}'`
let sysn=$system/512 
let sysn1=$sysn+586250
sed -i "s/apo/$sysn1/g" $MN/new_size.sh

cp $CURRENTDIR/Dlac.img $MN/system_ext.img
system_ext=`du -b $AT/output/system_ext_a.img | awk '{print $1}'`
let sysa=$system_ext/512
let sysa1=$sysa+586000
sed -i "s/rac/$sysa1/g" $MN/new_size.sh

cp $CURRENTDIR/Dlac.img $MN/vendor.img
vendor=`du -b $AT/output/vendor_a.img | awk '{print $1}'`
let syse=$vendor/512 
let syse1=$syse+585900
sed -i "s/tac/$syse1/g" $MN/new_size.sh

cp $CURRENTDIR/Dlac.img $MN/product.img
product=`du -b $AT/output/product_a.img | awk '{print $1}'`
let sysf=$product/512 
let sysf1=$sysf+585900
sed -i "s/dac/$sysf1/g" $MN/new_size.sh

cp $CURRENTDIR/Dlac.img $MN/odm.img
odm=`du -b $AT/output/odm_a.img | awk '{print $1}'`
let sysx=$odm/512 
let sysx1=$sysx+1000
sed -i "s/lam/$sysx1/g" $MN/new_size.sh

sudo bash $MN/new_size.sh 
echo

#MOUNT
sudo rm -r $A $B $C $D $E $AA $BB $CC $DD $EE || true
sudo mkdir $A $B $C $D $E $AA $BB $CC $DD $EE || true

sudo mount -o rw,noatime $MN/system.img $A
sudo mount -o rw,noatime $MN/system_ext.img $B
sudo mount -o rw,noatime $MN/vendor.img $C
sudo mount -o rw,noatime $MN/product.img $D
sudo mount -o rw,noatime $MN/odm.img $E

sudo mount -r $AT/output/system_a.img $AA
sudo mount -r $AT/output/system_ext_a.img $BB 
sudo mount -r $AT/output/vendor_a.img $CC
sudo mount -r $AT/output/product_a.img $DD
sudo mount -r $AT/output/odm_a.img $EE 

#COPYNEWF
echo "copiando archivos"
echo
echo "copiando system"
sudo cp -Raf $AA/* $A/
echo "copiando system_ext"
sudo cp -Raf $BB/* $B/
echo "copiando vendor"
sudo cp -Raf $CC/* $C/
echo "copiando product" 
sudo cp -Raf $DD/* $D/
echo "copiando odm"
sudo cp -Raf $EE/* $E/
ROMVERSION=$(grep ro.system.build.version.incremental= $A/system/build.prop | sed "s/ro.system.build.version.incremental=//g"; )
ROMANDROID=$(grep ro.build.version.release= $A/system/build.prop | sed "s/ro.build.version.release=//g"; )
ROMBUILD=$(grep ro.build.id= $A/system/build.prop | sed "s/ro.build.id=//g"; )
sudo umount /mnt/*

#ZIPF
rm -r $RZIP || true
mkdir $RZIP || true
cp -af $CURRENTDIR/dynamic_partitions_op_list $RZIP/

systemop=`du -b $MN/system.img | awk '{print $1}'`
sed -i "s/apo/$systemop/g" $RZIP/dynamic_partitions_op_list

system_extop=`du -b $MN/system_ext.img | awk '{print $1}'`
sed -i "s/rac/$system_extop/g" $RZIP/dynamic_partitions_op_list

vendorop=`du -b $MN/vendor.img | awk '{print $1}'`
sed -i "s/tac/$vendorop/g" $RZIP/dynamic_partitions_op_list

productop=`du -b $MN/product.img | awk '{print $1}'`
sed -i "s/dac/$productop/g" $RZIP/dynamic_partitions_op_list

odmop=`du -b $MN/odm.img | awk '{print $1}'`
sed -i "s/lam/$odmop/g" $RZIP/dynamic_partitions_op_list

let SUMATO=$systemop+$system_extop+$vendorop+$productop+$odmop
sleep 2s
echo
echo "limite de oplist 9122611200"
echo 
echo "system      =    $systemop"
echo "system_ext  =    $system_extop"
echo "vendor      =    $vendorop"
echo "product     =    $productop"
echo "odm         =    $odmop"
echo "suma total  =    $SUMATO"
echo
cp -Raf $CURRENTDIR/META-INF $RZIP/
cp -Raf $CURRENTDIR/img2sdat $MA/
mv $MN/* $MA/

#DATBR
echo "chingandose system"
#SYSTEM
img2simg $MA/system.img $MA/system2.img 
python3 $MA/img2sdat/img2sdat.py $MA/system2.img -o output -v 4 -p system --out $MA/output/

brotli -4fk $MA/output/system.new.dat 
rm -rf $MA/output/system.new.dat 
echo "chingandose system_ext"
#SYSTEMEXT
img2simg $MA/system_ext.img $MA/system_ext2.img 
python3 $MA/img2sdat/img2sdat.py $MA/system_ext2.img -o output -v 4 -p system_ext --out $MA/output/

brotli -4fk $MA/output/system_ext.new.dat 
rm -rf $MA/output/system_ext.new.dat 
echo "chingandose vendor"
#VENDOR
img2simg $MA/vendor.img $MA/vendor2.img 
python3 $MA/img2sdat/img2sdat.py $MA/vendor2.img -o output -v 4 -p vendor --out $MA/output/

brotli -4fk $MA/output/vendor.new.dat 
rm -rf $MA/output/vendor.new.dat   
echo "chingandose product"
#PRODUCT
img2simg $MA/product.img $MA/product2.img 
python3 $MA/img2sdat/img2sdat.py $MA/product2.img -o output -v 4 -p product --out $MA/output/

brotli -4fk $MA/output/product.new.dat 
rm -rf $MA/output/product.new.dat 
echo "chingandose odm"
#ODM
img2simg $MA/odm.img $MA/odm2.img 
python3 $MA/img2sdat/img2sdat.py $MA/odm2.img -o output -v 4 -p odm --out $MA/output/

brotli -4fk $MA/output/odm.new.dat 
rm -rf $MA/output/odm.new.dat 

#FINIZI
cd ..
mv $MA/output/* $RZIP/
mv $AT/images/boot.img $RZIP/
mv $AT/images/vendor_boot.img $RZIP/
mkdir $RZIP/firmware-update
mv $CURRENTDIR/MK/* $RZIP/firmware-update/
cd $RZIP
zip -ry MIUI_Alioth_RW_$ROMVERSION-$ROMBUILD-v$ROMANDROID.zip *
mv $RZIP/MIUI* $CURRENTDIR/ 
mv $CURRENTDIR/MIUI_Alioth* $NEKO/
sudo rm -r $AT $MA $MK $MN $RZIP
chmod -R 777 $NEKO/MIUI_Alioth*
else
echo "Saltando fastboot zip"
sleep 3s
fi
