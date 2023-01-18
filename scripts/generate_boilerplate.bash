#! /bin/bash

old_type="art"
old_subtype="2017"

type=$1
subtype=$2
title=$3
is_new_type=$4

caps_type=`echo $type | awk '{print toupper(substr($0,0,1))tolower(substr($0,2))}'`
caps_subtype=`echo $subtype | awk '{print toupper(substr($0,0,1))tolower(substr($0,2))}'`

echo "\n Data: \"${type}\" \"${subtype}\" \"${title}\" \"${is_new_type}\" \"${caps_type}\" \"${caps_subtype}\""

echo "\nCreating templates from ${old_type} and ${old_subtype}...\n"

new_data_file="_data/${type}${caps_subtype}.js"
echo "Creating ${new_data_file}"
echo "cp _data/${old_type}$old_subtype.js ${new_data_file}"
cp _data/${old_type}$old_subtype.js ${new_data_file}
sh ./scripts/replace_types.bash $new_data_file $type $caps_subtype $caps_type "$title"

echo "Creating markdown..."
if [ "$is_new_type" = 1 ]
then
  mkdir "$type"
  new_base_markdown_file="${type}/${type}.md"
  cp "${old_type}/${old_type}.md" ${new_base_markdown_file}
  sh ./scripts/replace_types.bash $new_base_markdown_file $type $caps_subtype $caps_type "$title"
fi
new_markdown_dir="$type/$subtype"
mkdir "$new_markdown_dir"
cp "${old_type}/${old_subtype}/image-detail.md" ${new_markdown_dir}
sh ./scripts/replace_types.bash "${new_markdown_dir}/image-detail.md" $type $caps_subtype $caps_type "$title"
cp "${old_type}/${old_subtype}/gallery.md" ${new_markdown_dir}
sh ./scripts/replace_types.bash "${new_markdown_dir}/gallery.md" $type $caps_subtype $caps_type "$title"

echo "Creating template..."
new_template_dir="_includes/${type}"
if [ "$is_new_type" = 1 ]
then
  mkdir "${new_template_dir}"
fi
new_template_file="${new_template_dir}/gallery${caps_subtype}.liquid"
cp "_includes/${old_type}/gallery${old_subtype}.liquid" "${new_template_file}"
sh ./scripts/replace_types.bash $new_template_file $type $caps_subtype $caps_type "$title"

echo "Cleanup"
find . -name *.bak -exec rm {} \;