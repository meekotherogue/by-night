#! /bin/bash
old_type="art"
old_subtype="2017"
old_caps_type="Art"
old_title="Artwork"

filename=$1
new_type=$2
new_subtype=$3
new_caps_type=$4
new_title=$5

sed -i.bak "s/${old_type}/${new_type}/g" ${filename}
sed -i.bak "s/${old_subtype}/${new_subtype}/g" ${filename}
sed -i.bak "s/${old_title}/${new_title}/g" ${filename}
sed -i.bak "s/${old_caps_type}/${new_caps_type}/g" ${filename}