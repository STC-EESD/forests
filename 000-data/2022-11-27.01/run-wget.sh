#!/bin/bash

# https://open.canada.ca/data/en/dataset/7ad7ea01-eb23-4824-bccc-66adb7c5bdf8
# https://sis.agr.gc.ca/cansis/nsdb/ecostrat/gis_data.html

SHP_FILES=( \
    "https://sis.agr.gc.ca/cansis/nsdb/ecostrat/zone/ecozone_shp.zip"         \
    "https://sis.agr.gc.ca/cansis/nsdb/ecostrat/province/ecoprovince_shp.zip" \
    "https://sis.agr.gc.ca/cansis/nsdb/ecostrat/region/ecoregion_shp.zip"     \
    "https://sis.agr.gc.ca/cansis/nsdb/ecostrat/district/ecodistrict_shp.zip"
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

