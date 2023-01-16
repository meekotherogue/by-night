#! /bin/bash

dir=$1
out_dir=$2

if [ -z "$out_dir" ]
then
  out_dir="${dir}"
fi

echo "\nSource directory: ${dir}\nOutput directory: ${out_dir}\n"

for file in $dir*
do
  echo "${file}\n"
  base_name=$(basename ${file})
  echo "curl --user api:${TINYPNG_API} --data-binary @$file -i https://api.tinify.com/shrink | jq '.output.url' | tr -d '\"'\n"
  url=$(curl --user api:${TINYPNG_API} --data-binary @$file -s https://api.tinify.com/shrink | jq ".output.url" | tr -d '"')
  echo "curl $url --output $out_dir$base_name\n"
  downloadResult=$(curl $url --output $out_dir/$base_name)
done
