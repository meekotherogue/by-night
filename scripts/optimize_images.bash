#! /bin/bash

dir=$1

for file in $dir*
do
  echo $file
  echo "curl --user api:C3CL0yVkS788rnVS25hZT0XW5lhjnVKz --data-binary @$file -i https://api.tinify.com/shrink | jq '.output.url' | tr -d '\"'"
  url=$(curl --user api:C3CL0yVkS788rnVS25hZT0XW5lhjnVKz --data-binary @$file -s https://api.tinify.com/shrink | jq ".output.url" | tr -d '"')
  echo "curl $url --output $file"
  downloadResult=$(curl $url --output $file)
done
