#!/bin/bash

readonly -A FILTERS=(
    ['adguad-easy.txt']='https://filters.adtidy.org/android/filters/2_optimized.txt'
    ['annoyances.txt']='https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_14_Annoyances/filter.txt'
    ['tracking.txt']='https://filters.adtidy.org/android/filters/17_optimized.txt'
    ['abpvn-ext.txt']='https://github.com/luxysiv/filters/raw/main/abpvn-ext.txt'
    ['spyware.txt']='https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_3_Spyware/filter.txt'
    ['social_filters.txt']='https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_4_Social/filter.txt'
)

function join_by { local IFS="$1"; shift; echo "$*"; }

for filter in "${!FILTERS[@]}"; do
    url="${FILTERS[$filter]}"
    echo "Downloading $filter from $url"
    if ! curl -o "$filter" "$url"; then
        echo "Failed to download $url"
        exit 1
    fi
    echo
done

#download ruleset_converter 

wget https://github.com/bromite/bromite/releases/latest/download/ruleset_converter



#join_by , "${!FILTERS[@]}"

echo "Converting filters"
chmod +x ruleset_converter
./ruleset_converter --input_format=filter-list \
                    --output_format=unindexed-ruleset \
                    --input_files="$(join_by , "${!FILTERS[@]}")" \
                    --output_file=filters.dat
