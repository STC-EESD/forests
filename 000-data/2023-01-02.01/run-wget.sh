#!/bin/bash

# https://nfi.nfis.org/en/standardreports
# Statistical Summaries for Terrestrial Ecozones
# First Remeasurement Data Reports (2007--2017)

TARGET_FILES=( \
    # Land Cover: Area (1000 ha) of land cover by terrestrial ecozone in Canada
    "https://nfi.nfis.org/resources/general/summaries/t1/en/NFI/csv/NFI_T1_LC_AREA_en.csv" \
    "https://nfi.nfis.org/resources/general/summaries/t1/en/NFI/pdf/NFI_T1_LC_AREA_en.pdf" \
    # Land Cover: Area (1000 ha) of land cover by terrestrial ecozone in Canada, relative standard error
    "https://nfi.nfis.org/resources/general/summaries/t1/en/NFI/csv/NFI_T1_LC_AREA_SEP_en.csv" \
    "https://nfi.nfis.org/resources/general/summaries/t1/en/NFI/pdf/NFI_T1_LC_AREA_SEP_en.pdf"
    # Forest Area: Area (1000 ha) of forest and non-forest land by terrestrial ecozone in Canada
    "https://nfi.nfis.org/resources/general/summaries/t1/en/NFI/csv/NFI_T4_FOR_AREA_en.csv" \
    "https://nfi.nfis.org/resources/general/summaries/t1/en/NFI/pdf/NFI_T4_FOR_AREA_en.pdf" \
    # Forest Area: Area (1000 ha) of forest and non-forest land by terrestrial ecozone in Canada, relative standard error
    "https://nfi.nfis.org/resources/general/summaries/t1/en/NFI/csv/NFI_T4_FOR_AREA_SEP_en.csv" \
    "https://nfi.nfis.org/resources/general/summaries/t1/en/NFI/pdf/NFI_T4_FOR_AREA_SEP_en.pdf"
    )

echo
echo

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

