#! /bin/bash

function replace_types() {
  filename=$1
  old_type=$2
  new_type=$3
  old_subtype=$4
  new_subtype=$5
  old_caps_type=$6
  new_caps_type=$7
  old_title=$8
  new_title=$9

  sed -i.bak "s/${old_type}/${new_type}/g" ${filename}
  sed -i.bak "s/${old_subtype}/${new_subtype}/g" ${filename}
  sed -i.bak "s/${old_title}/${new_title}/g" ${filename}
  sed -i.bak "s/${old_caps_type}/${new_caps_type}/g" ${filename}
}

echo "\nSpecify type:"
read type
echo "\nNow with a capital:"
read caps_type
echo "\nLong title:"
read title
echo "\nSpecify new subtype:"
read subtype
echo "\nNow with a captial:"
read caps_subtype
src="img"
orig="img"
desc="Some of my personal favourites"

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
is_new_type=1

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

old_type="art"
old_subtype="2017"
old_caps_type="Art"
old_title="Artwork"
echo "\nCreating templates from ${old_type} and ${old_subtype}...\n"

new_data_file="_data/${type}${caps_subtype}.js"
echo "Creating ${new_data_file}"
cp _data/${old_type}$old_subtype.js ${new_data_file}
replace_types $new_data_file $old_type $type $old_subtype $caps_subtype $old_caps_type $caps_type $old_title $title 

echo "Creating markdown..."
if [ "$is_new_type" = 1 ]
then
  mkdir "$type"
  new_base_markdown_file="${type}/${type}.md"
  cp "${old_type}/${old_type}.md" ${new_base_markdown_file}
  replace_types $new_base_markdown_file $old_type $type $old_subtype $caps_subtype $old_caps_type $caps_type $old_title $title
fi
new_markdown_dir="$type/$subtype"
mkdir "$new_markdown_dir"
cp "${old_type}/${old_subtype}/image-detail.md" ${new_markdown_dir}
replace_types "${new_markdown_dir}/image-detail.md" $old_type $type $old_subtype $caps_subtype $old_caps_type $caps_type $old_title $title
cp "${old_type}/${old_subtype}/gallery.md" ${new_markdown_dir}
replace_types "${new_markdown_dir}/gallery.md" $old_type $type $old_subtype $caps_subtype $old_caps_type $caps_type $old_title $title

echo "Creating template..."
new_template_dir="_includes/${type}"
if [ "$is_new_type" = 1 ]
then
  mkdir "${new_template_dir}"
fi
new_template_file="${new_template_dir}/gallery${caps_subtype}.liquid"
cp "_includes/${old_type}/gallery${old_subtype}.liquid" "${new_template_file}"
replace_types $new_template_file $old_type $type $old_subtype $caps_subtype $old_caps_type $caps_type $old_title $title

echo "Cleanup"
find . -name *.bak -exec rm {} \;