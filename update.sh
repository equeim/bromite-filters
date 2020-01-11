#!/bin/bash

readonly -A FILTERS=(
    ['ublock_filters.txt']='https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt'
    ['ublock_badware.txt']='https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt'
    ['ublock_privacy.txt']='https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt'
    ['ublock_resource-abuse.txt']='https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt'
    ['ublock_unbreak.txt']='https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt'
    ['easylist.txt']='https://easylist.to/easylist/easylist.txt'
    ['easyprivacy.txt']='https://easylist.to/easylist/easyprivacy.txt'
    ['nano.txt']='https://gitcdn.xyz/repo/NanoMeow/MDLMirror/master/hosts.txt'
    ['malwaredomains.txt']='https://mirror.cedia.org.ec/malwaredomains/justdomains'
    ['peter.txt']='https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=1&mimetype=plaintext'
    ['ruadlist.txt']='https://easylist-downloads.adblockplus.org/advblock+cssfixes.txt'
    ['adguard.txt']='https://filters.adtidy.org/extension/ublock/filters/1.txt'
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

#join_by , "${!FILTERS[@]}"

echo "Converting filters"
./ruleset_converter --input_format=filter-list \
                    --output_format=unindexed-ruleset \
                    --input_files="$(join_by , "${!FILTERS[@]}")" \
                    --output_file=filters.dat
