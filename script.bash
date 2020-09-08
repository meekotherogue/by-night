#! /bin/bash

dir=$1

for file in $dir*
do
  echo $file
  echo "curl --user api:C3CL0yVkS788rnVS25hZT0XW5lhjnVKz --data-binary @$file -i https://api.tinify.com/shrink"
  shrinkResult=$(curl --user api:C3CL0yVkS788rnVS25hZT0XW5lhjnVKz --data-binary @$file -i https://api.tinify.com/shrink)
  echo "curl $shrinkResult.url --output $file"
  downloadResult=$(curl $shrinkResult.url --output $file)
done
