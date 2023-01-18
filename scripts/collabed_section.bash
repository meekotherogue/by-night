#! /bin/bash

echo "\nSpecify type:"
read type
echo "\nLong title:"
read title
echo "\nSpecify new subtype:"
read subtype
echo "\nDefault description (or empty to auto generate):"
read desc

src="img"
out="img"

echo "\n\nEntered: ${type} ${subtype} ${desc} OK? [y/n]"
read confirm

case "$confirm" in 
  y|Y ) echo "Confirmed";;
  n|N ) exit;;
  * ) exit;;
esac

if [ -z "$desc" ]
then
  desc="Art for ${type} from ${subtype}"
fi

image_dir="${src}/${type}/${subtype}/"
type_out_dir="${out}/${type}/"
subtype_out_dir="${out}/${type}/${subtype}/"
is_new_type=1
caps_subtype=`echo $subtype | awk '{print toupper(substr($0,0,1))tolower(substr($0,2))}'`

if [ ! -d "$image_dir" ] 
then
    echo "Error: Directory $image_dir does not exist."
    exit
fi

echo "Making subtype directory ${subtype_out_dir}\n"
mkdir "$subtype_out_dir"

echo "\nGenerating metadata...\n"
meta_out="./_data/${type}Meta${caps_subtype}.json"
echo "sh ./scripts/generate_meta_json.bash ${subtype_out_dir} \"${desc}\" ${subtype} ${meta_out}\n"
sh ./scripts/generate_meta_json.bash ${subtype_out_dir} "${desc}" ${subtype} ${meta_out}

echo "sh ./scripts/generate_boilerplate.bash ${type} ${subtype} ${title} ${is_new_type}"
sh ./scripts/generate_boilerplate.bash ${type} ${subtype} "${title}" ${is_new_type}