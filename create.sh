#!/bin/bash -v
#
# any2djvu-low
#

if [ -z `which c44` ]; then
  usage
  echo "Error: c44 is needed"
  echo
  exit 1
fi

shopt -s extglob

DEFMASK="*.jpg*"
DPI=300
DEFNCOLORS=256

# uncomment the following line to compile a bundled DjVu document
OUTPUT="gits.djvu"



if [ -n "$1" ]; then
  MASK=$1
else
  MASK=$DEFMASK
  NCOLORS=$DEFNCOLORS
fi

PAGENUM=0

for i in $MASK; do
  echo "hi $i"
  if [ ! -e "$i" ]; then
    echo "Error: current directory must contain files with the mask $MASK"
    echo
    exit 1
  fi
  if [ ! -e "$i.djvu" ]; then
    echo "$i"
    #cpaldjvu -dpi $DPI -colors $NCOLORS $i $i.djvu
    #c44 -dpi 720 -bpp 0.4,0.5,0.5  "$i" "$i.djvu"
    #for higher quality black and white comics
    c44 -dpi 720 -bpp 0.4,0.5,0.7,1 "$i" "$i.djvu"
  fi
  #j=`basename $i .jpg.djvu`
  if [ ! -e $OUTPUT ]; then
    djvm -c $OUTPUT "$i.djvu"
    PAGENUM=1
  else
    echo "UTPUT = $OUTPUT"
    echo "djvm -i $OUTPUT \"$i.djvu\""
    djvm -i $OUTPUT "$i.djvu"
    #djvm -i $OUTPUT "$i.djvu" $PAGENUM
    PAGENUM=$[$PAGENUM+1]
  fi
done

# uncomment the following line to compile a bundled DjVu document
#djvm -c $OUTFILE $MASK.djvu
