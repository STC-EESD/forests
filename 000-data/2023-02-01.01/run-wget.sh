#!/bin/bash

# https://ccea-ccae.org/ecozones-downloads/

SHP_FILES=( \
    # CA Forest Fires 1985-2020
    "https://opendata.nfis.org/downloads/forest_change/CA_Forest_Fire_1985-2020.zip" \
    # CA Forest Harvest 1985-2020
    "https://opendata.nfis.org/downloads/forest_change/CA_Forest_Harvest_1985-2020.zip"
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    # #
    # "" \
    )

for tempzip in "${SHP_FILES[@]}"
do
    echo downloading: ${tempzip}
    wget ${tempzip}
done

echo

for tempzip in *.zip; do
    echo unzipping: ${tempzip}
    tempstem=`basename ${tempzip} .zip`
    unzip ${tempzip} -d ${tempstem}
    sleep 10
    rm -f tempsip
done

echo
echo done
echo
