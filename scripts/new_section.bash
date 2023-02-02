#! /bin/bash

echo "\nSpecify type:"
read type
echo "\nLong title:"
read title
echo "\nSpecify new subtype:"
read subtype
# echo "\nSpecify image source directory (orig or img):"
# read src
# echo "\nSpecify image output directory (img):"
# read out
echo "\nDefault description (or empty to auto generate):"
read desc

if [ -z "$out" ] 
then
    out="img"
fi

echo "\n\nEntered: ${type} ${subtype} ${src} ${out} ${desc} OK? [y/n]"
read confirm

case "$confirm" in 
  y|Y ) echo "Confirmed";;
  n|N ) exit;;
  * ) exit;;
esac

src="orig"
out="img"
image_dir="${src}/${type}/${subtype}/"
type_out_dir="${out}/${type}/"
subtype_out_dir="${out}/${type}/${subtype}/"
caps_subtype=`echo $subtype | awk '{print toupper(substr($0,0,1))tolower(substr($0,2))}'`

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
  echo "Making type directory ${type_out_dir}\n"
  mkdir "$type_out_dir"
fi

if [ -z "$desc" ]
then
  desc="Art for ${type} from ${subtype}"
fi

echo "Making subtype directory ${subtype_out_dir}\n"
mkdir "$subtype_out_dir"

echo "\nOptimising images...\n"
echo "sh ./scripts/optimize_images.bash ${image_dir} ${subtype_out_dir}\n"
sh ./scripts/optimize_images.bash ${image_dir} ${subtype_out_dir}

echo "\nWatermarking images...\n"
echo "sh ./scripts/watermark.bash ${subtype_out_dir} img/assets/watermark.png\n"
sh ./scripts/watermark.bash ${subtype_out_dir} img/assets/watermark.png

echo "\nGenerating metadata...\n"
meta_out="./_data/${type}Meta${caps_subtype}.json"
echo "sh ./scripts/generate_meta_json.bash ${subtype_out_dir} \"${desc}\" ${subtype} ${meta_out}\n"
sh ./scripts/generate_meta_json.bash ${subtype_out_dir} "${desc}" ${subtype} ${meta_out}

echo "sh ./scripts/generate_boilerplate.bash ${type} ${subtype} ${title} ${is_new_type}"
sh ./scripts/generate_boilerplate.bash ${type} ${subtype} "${title}" ${is_new_type}