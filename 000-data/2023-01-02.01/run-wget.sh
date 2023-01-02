#!/bin/bash

TARGET_FILES=( \
    "https://nfi.nfis.org/resources/general/summaries/t1/en/NFI/csv/NFI_T1_LC_AREA_en.csv" \
    "https://nfi.nfis.org/resources/general/summaries/t1/en/NFI/pdf/NFI_T1_LC_AREA_en.pdf" \
    "https://nfi.nfis.org/resources/general/summaries/t1/en/NFI/csv/NFI_T1_LC_AREA_SEP_en.csv" \
    "https://nfi.nfis.org/resources/general/summaries/t1/en/NFI/pdf/NFI_T1_LC_AREA_SEP_en.pdf"
    )

for tempzip in "${TARGET_FILES[@]}"
do
    echo downloading: ${tempzip}
    wget ${tempzip}
done

echo

# for tempzip in *.zip; do
#     echo unzipping: ${tempzip}
#     tempstem=`basename ${tempzip} .zip`
#     unzip ${tempzip} -d ${tempstem}
# done

echo
echo done
echo

