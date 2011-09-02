#!/bin/bash
# layout-print for pcb -<(kmk)>- 2010
# needs poster, ps2pdf, convert, psmerge 
# optional viewers: gthumb and evince 
########################################################

if [ $# -eq 0 ]    # Script invoked with no command-line args?
then
  echo "Usage: `basename $0` [-p][-V] foobar.pcb"
  echo "-p     produce photo realistic output"
  echo "-V     launch viewers on produced output"
  exit
fi  

PHOTOOUTPUT=0
STARTVIEWER=0
while getopts ":pV" Option
do
  case $Option in
    p     ) echo "produce photorealistic image "; PHOTOOUTPUT=1 ;;
    V     ) echo "produce photorealistic image "; STARTVIEWER=1 ;;
    *     ) echo "Unimplemented option chosen.";;   # Default.
  esac
done
shift $(($OPTIND - 1))   # go to next argument

#######################################################


PCBFILE=$1
OUTPDF=`basename $PCBFILE .pcb`"_layout.pdf"
OUTPNG=`basename $PCBFILE .pcb`"_layout.png"
OUTPNG_BOTTOM=`basename $PCBFILE .pcb`"_layout_bottom.png"
PCB=/opt/bin/pcb
SIZE="20x30cm"

## echo pcb version
$PCB -V

## top-refdes
echo "Bestückungsdruck Nummern, Oberseite von "$OUTPUT

$PCB -x eps \
  --action-string 'DISPLAY(NameOnPCB)' \
  --element-color '#000000' \
  --pin-color '#cccccc' \
  --layer-color-1 '#dddddd' \
  --layer-color-2 '#dddddd' \
  --layer-color-3 '#dddddd' \
  --as-shown  \
  --layer-stack "outline,comment,elements,component" \
  --eps-file "/tmp/out_ref.eps" \
  $PCBFILE

poster -mA4 -p$SIZE -c12x12mm -o "/tmp/out_toprefdes.ps" "/tmp/out_ref.eps"

## top-values
echo "Bestückungsdruck Werte, Oberseite von "$OUTPUT

$PCB -x eps \
  --action-string 'DISPLAY(Value)' \
  --element-color '#000000' \
  --pin-color '#cccccc' \
  --layer-color-1 '#dddddd' \
  --layer-color-2 '#dddddd' \
  --layer-color-3 '#dddddd' \
  --as-shown  \
  --layer-stack "outline,comment,elements,component" \
  --eps-file "/tmp/out_value.eps" \
  $PCBFILE

poster -mA4 -p$SIZE -c12x12mm -o "/tmp/out_topvalue.ps" "/tmp/out_value.eps"


## bottom-refdes
echo "Bestückungsdruck Unterseite, Nummern von "$OUTPUT

$PCB -x eps \
  --action-string 'DISPLAY(NameOnPCB)' \
  --element-color '#000000' \
  --pin-color '#cccccc' \
  --layer-color-4 '#dddddd' \
  --layer-color-5 '#dddddd' \
  --layer-color-6 '#dddddd' \
  --as-shown \
  --layer-stack "outline,elements,solder,solderside" \
  --eps-file "/tmp/out.eps" \
  $PCBFILE

poster -mA4 -p$SIZE -c12x12mm -o "/tmp/out_bottomrefdes.ps" "/tmp/out.eps"


## bottom-value
echo "Bestückungsdruck Unterseite, Werte von "$OUTPUT

$PCB -x eps \
  --action-string 'DISPLAY(Value)' \
  --element-color '#000000' \
  --pin-color '#cccccc' \
  --layer-color-4 '#dddddd' \
  --layer-color-5 '#dddddd' \
  --layer-color-6 '#dddddd' \
  --as-shown  \
  --layer-stack "outline,elements,solder,solderside" \
  --eps-file "/tmp/value.eps" \
  $PCBFILE

poster -mA4 -p$SIZE -c12x12mm -o "/tmp/out_bottomvalue.ps" "/tmp/out.eps"

## combine to a single PDF document
psmerge -o/tmp/out.ps \
   /tmp/out_toprefdes.ps \
   /tmp/out_topvalue.ps \
   /tmp/out_bottomrefdes.ps \
   /tmp/out_bottomvalue.ps
 
ps2pdf "/tmp/out.ps" $OUTPDF

### optionally start viewer.###
if [ "$STARTVIEWER" = "1" ]
then
  evince $OUTPDF
fi


### photorealistic output is optional, because time consuming ####
if [ "$PHOTOOUTPUT" = "1" ]
then

echo  "Do a photo realistic view of the top side of the pcb"
pcb -x png --photo-mode \
  --dpi 600  \
  --use-alpha \
  --only-visible \
  --outfile /tmp/out.png \
  $PCBFILE

convert /tmp/out.png \
  \( +clone -background black -shadow 75x20+20+20 \)  +swap \
  -background white \
  -layers merge \
  -resize 50% \
  $OUTPNG

echo "Do a photo realistic view of the bottom side of the pcb"
pcb -x png --photo-mode \
  --dpi 600  \
  --use-alpha \
  --only-visible \
  --photo-flip-x \
  --outfile /tmp/out.png \
  $PCBFILE

convert /tmp/out.png \
  \( +clone -background black -shadow 75x20+20+20 \)  +swap \
  -background white \
  -layers merge \
  -resize 50% \
  $OUTPNG_BOTTOM

### optionally start viewer.###
if [ "$STARTVIEWER" = "1" ]
then
  gthumb $OUTPNG $OUTPNG_BOTTOM
fi

fi # PHOTOOUTPUT

exit # end of script
