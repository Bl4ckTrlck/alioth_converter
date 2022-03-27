SCRIPTDIR=$(readlink -f "$0")
CURRENTDIR=$(dirname "$SCRIPTDIR")
sudo apt -y install cpio brotli simg2img abootimg git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev x11proto-core-dev libx11-dev libgl1-mesa-dev libxml2-utils xsltproc unzip zip screen attr ccache libssl-dev imagemagick schedtool
sudo pip install launchpadlib protobuf==3.15.0 six==1.11.0 bsdiff4>=1.1.5
printf "\n" 
printf "\n" 
printf "scripts ready"
printf "\n" 
printf "ready to start"
printf "\n" 
