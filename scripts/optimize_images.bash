#! /bin/bash

dir=$1

for file in $dir*
do
  echo $file
  echo "curl --user api:${TINYPNG_API} --data-binary @$file -i https://api.tinify.com/shrink | jq '.output.url' | tr -d '\"'"
  url=$(curl --user api:${TINYPNG_API} --data-binary @$file -s https://api.tinify.com/shrink | jq ".output.url" | tr -d '"')
  echo "curl $url --output $file"
  downloadResult=$(curl $url --output $file)
done
