#! /bin/bash

echo "\nSpecify type:"
read type
echo "\nSpecify new subtype:"
read subtype
echo "\nSpecify image source directory (orig or img):"
read src
echo "\nSpecify image output directory (img):"
read out
echo "\nDefault description (or empty to auto generate):"
read desc

echo "\n\nEntered: ${type} ${subtype} ${src} ${out} ${desc} OK? [y/n]"
read confirm

case "$confirm" in 
  y|Y ) echo "Confirmed";;
  n|N ) exit;;
  * ) exit;;
esac

image_dir="${src}/${type}/${subtype}"
type_out_dir="${out}/${type}"
subtype_out_dir="${out}/${type}/${subtype}"

if [ ! -d "$image_dir" ] 
then
    echo "Error: Directory $image_dir does not exist."
    exit
fi

if [ -d "$subtype_out_dir" ] 
then
    echo "Error: Directory $subtype_out_dir already exists. Double check your entries"
    exit
fi

if [ -d "$type_out_dir" ]
then
  is_new_type=0
else
  is_new_type=1
  mkdir "$type_out_dir"
fi

mkdir "$subtype_out_dir"

echo "\nOptimising images...\n"
echo "sh ./scripts/optimize_images.bash ${image_dir} ${subtype_out_dir}\n"

# for file in $dir*
# do
#   echo $file
#   echo "curl --user api:${TINYPNG_API} --data-binary @$file -i https://api.tinify.com/shrink | jq '.output.url' | tr -d '\"'"
#   url=$(curl --user api:${TINYPNG_API} --data-binary @$file -s https://api.tinify.com/shrink | jq ".output.url" | tr -d '"')
#   echo "curl $url --output $file"
#   downloadResult=$(curl $url --output $file)
# done

# dir=$1
# desc=$2
# year=$3
# out=$4

# sh ./scripts/optimize_images.bash ./img/commissions/2022/