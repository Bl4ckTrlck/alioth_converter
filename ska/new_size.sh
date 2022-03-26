export CURRENTUSER=$(whoami)
SCRIPTDIR=$(readlink -f "$0")
CURRENTDIR=$(dirname "$SCRIPTDIR")
e2fsck -y -f $CURRENTDIR/system.img
resize2fs $CURRENTDIR/system.img apos

e2fsck -y -f $CURRENTDIR/system_ext.img
resize2fs $CURRENTDIR/system_ext.img racs

e2fsck -y -f $CURRENTDIR/vendor.img
resize2fs $CURRENTDIR/vendor.img tacs

e2fsck -y -f $CURRENTDIR/product.img
resize2fs $CURRENTDIR/product.img dacs

e2fsck -y -f $CURRENTDIR/odm.img
resize2fs $CURRENTDIR/odm.img lams

