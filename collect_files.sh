#!/bin/bash

input_dir="$1"
output_dir="$2"
max_depth_arg=""


if [[ "$3" == --max_depth=* ]]; then
  depth_val="${3#--max_depth=}"
  max_depth_arg="-maxdepth $depth_val"
fi


declare -A filename_count


if [ -z "$max_depth_arg" ]; then
  find "$input_dir" -type f
else
  find "$input_dir" -maxdepth "$depth_val" -type f
fi | while read -r file; do
  base_name=$(basename "$file")
  new_name="$base_name"

  if [ -e "$output_dir/$new_name" ]; then
    count=${filename_count["$base_name"]}
    if [ -z "$count" ]; then
      count=1
    else
      ((count++))
    fi
    filename_count["$base_name"]=$count

    name="${base_name%.*}"
    ext="${base_name##*.}"
    if [[ "$name" == "$ext" ]]; then
      new_name="${name}${count}"
    else
      new_name="${name}${count}.${ext}"
    fi
  else
    filename_count["$base_name"]=1
  fi

  cp "$file" "$output_dir/$new_name"
  echo "Copied: $file → $new_name"
done


