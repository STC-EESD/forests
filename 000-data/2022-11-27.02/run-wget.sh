#!/bin/bash

# https://ccea-ccae.org/ecozones-downloads/

SHP_FILES=( \
    "http://www.ccea-ccae.org/wp-content/uploads/2021/01/Canada_Ecozones_V5_map_kml_v20140218.zip" \
    "http://www.ccea-ccae.org/wp-content/uploads/2021/01/Canada_Ecozones_V5b_15M_simplify.shp_v20140218.zip"
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
done

echo
echo done
echo

