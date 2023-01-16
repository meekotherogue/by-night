#! /bin/bash

dir=$1
watermark=$2
out_dir=$3

if [ -z "$out_dir"]
then
  out_dir="${dir}"
fi

for file in $dir*
do
  echo $file
  base_name=$(basename ${file})
  echo "composite $watermark $file -geometry +0+0 $out_dir$base_name"
  composite $watermark $file -geometry +0+0 $out_dir$base_name
  echo "composite $watermark $file -geometry +3000+0 $out_dir$base_name"
  composite $watermark $file -geometry +3000+0 $out_dir$base_name
  echo "composite $watermark $file -geometry +0+3000 $out_dir$base_name"
  composite $watermark $file -geometry +0+3000 $out_dir$base_name
done
