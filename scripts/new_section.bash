#! /bin/bash

function replace_types() {
  filename=$1
  old_type=$2
  new_type=$3
  old_subtype=$4
  new_subtype=$5

  sed -i.bak "s/${old_type}/${new_type}/g" ${filename}
  sed -i.bak "s/${old_subtype}/${new_subtype}/g" ${filename}
}

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

image_dir="${src}/${type}/${subtype}/"
type_out_dir="${out}/${type}/"
subtype_out_dir="${out}/${type}/${subtype}/"

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

if [ -z "$desc"]
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
meta_out="./_data/${type}Meta${subtype}.json"
echo "sh ./scripts/generate_meta_json.bash ${subtype_out_dir} \"${desc}\" ${subtype} ${meta_out}\n"
sh ./scripts/generate_meta_json.bash ${subtype_out_dir} "${desc}" ${subtype} ${meta_out}

old_type="art"
old_subtype="2017"
echo "\nCreating templates from ${old_type} and ${old_subtype}...\n"

new_data_file="_data/${type}${subtype}.js"
echo "Creating ${new_data_file}"
cp _data/${old_type}$old_subtype.js ${new_data_file}
replace_types $new_data_file $old_type $type $old_subtype $subtype 

echo "Creating markdown..."
if [ "$is_new_type" = 1 ]
then
  mkdir "$type"
  new_base_markdown_file="${type}/${type}.md"
  cp "${old_type}/${old_type}.md" ${new_base_markdown_file}
  replace_types $new_base_markdown_file $old_type $type $old_subtype $subtype
fi
new_markdown_dir="$type/$subtype"
mkdir "$new_markdown_dir"
cp "${old_type}/${old_subtype}/image-detail.md" ${new_markdown_dir}
replace_types "${new_markdown_dir}/image-detail.md" $old_type $type $old_subtype $subtype
cp "${old_type}/${old_subtype}/gallery.md" ${new_markdown_dir}
replace_types "${new_markdown_dir}/gallery.md" $old_type $type $old_subtype $subtype

echo "Creating template..."
new_template_dir="_includes/${type}"
if [ "$is_new_type" = 1 ]
then
  mkdir "${new_template_dir}"
fi
new_template_file="${new_template_dir}/gallery${subtype}.liquid"
cp "_includes/${old_type}/gallery${old_subtype}.liquid" "${new_template_file}"
replace_types $new_template_file $old_type $type $old_subtype $subtype

echo "Cleanup"
find . -name *.bak -exec rm {} \;