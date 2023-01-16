#! /bin/bash

dir=$1
watermark=$2

for file in $dir*
do
  echo $file
  echo "composite $watermark $file -geometry +0+0 $file"
  composite $watermark $file -geometry +0+0 $file
  echo "composite $watermark $file -geometry +3000+0 $file"
  composite $watermark $file -geometry +3000+0 $file
  echo "composite $watermark $file -geometry +0+3000 $file"
  composite $watermark $file -geometry +0+3000 $file
done
