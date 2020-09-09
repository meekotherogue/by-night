#! /bin/bash

dir=$1
desc=$2
year=$3
out=$4

meta=()

for file in $dir*
do
  json="{\"file\": \"$file\", \"year\": \"$year\", \"description\": \"$desc\"}"
  meta+=("$json")
done

joined=$(printf ",%s" "${meta[@]}")
joined=${joined:1}
jq -n "[$joined]" > $out
