#!/bin/bash

# http://opendata.nfis.org/mapserver/nfis-change_eng.html

SHP_FILES=( \
    # CA Forest Fires 1985-2020
    "https://opendata.nfis.org/downloads/forest_change/CA_Forest_Fire_1985-2020.zip" \
    # CA Forest Harvest 1985-2020
    "https://opendata.nfis.org/downloads/forest_change/CA_Forest_Harvest_1985-2020.zip" \
    # Canada RGB 2015
    "https://opendata.nfis.org/downloads/forest_change/CA_RGB_2015_CC_LCC.zip" \
    # Tree Species 2019
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_lead_tree_species.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_Distance2Second.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_tree_species_probabilities.zip" \
    # Canada Forest Post-Disturbance Recovery Rate
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_fire_recovery_rate.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_harvest_recovery_rate.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_fire_years2recovery.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_harvest_years2recovery.zip" \
    # Land cover 1984-2019 Version 2
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1984.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1985.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1986.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1987.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1988.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1989.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1990.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1991.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1992.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1993.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1994.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1995.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1996.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1997.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1998.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_1999.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2000.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2001.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2002.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2003.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2004.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2005.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2006.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2007.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2008.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2009.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2010.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2011.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2012.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2013.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2014.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2015.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2016.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2017.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2018.zip" \
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2019.zip" \
    # Wetlands 2000-2016
    "https://opendata.nfis.org/downloads/forest_change/CA_wetlands_post2000.zip" \
    # Wetlands 84-16
    "https://opendata.nfis.org/downloads/forest_change/CA_wetland_year_sum.zip" \
    # Forest Elevation(Ht) Mean 2015
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_elev_mean_2015_NN.zip" \
    # Forest Basal Area 2015
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_basal_area_2015_NN.zip" \
    # Forest Elevation(Ht) Covariance 2015
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_elev_cv_2015_NN.zip" \
    # Forest Elevation(Ht) Stddev 2015
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_elev_stddev_2015_NN.zip" \
    # Forest Gross Stem Volume 2015
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_gross_stem_volume_2015_NN.zip" \
    # Forest Lorey's Height 2015
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_loreys_height_2015_NN.zip" \
    # Forest Percentage Above 2m 2015
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_percentage_first_returns_above_2m_2015.zip" \
    # Forest Percent Above Mean 2015
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_percentage_first_returns_above_mean_2015.zip" \
    # Forest Total Aboveground Biomass 2015
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_total_biomass_2015_NN.zip" \
    # Forest 95th Percentile Elevation(Ht) 2015
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_elev_p95_2015_NN.zip" \
    # Change 85-11
    "https://opendata.nfis.org/downloads/forest_change/C2C_change_no_change_1985_2011.zip" \
    # Change Type 85-11
    "https://opendata.nfis.org/downloads/forest_change/C2C_change_type_1985_2011.zip" \
    # Change Year 85-11
    "https://opendata.nfis.org/downloads/forest_change/C2C_change_year_1985_2011.zip" \
    # Change 12-15
    "https://opendata.nfis.org/downloads/forest_change/C2C_change_no_change_2012_2015.zip" \
    # Change Type 12-15
    "https://opendata.nfis.org/downloads/forest_change/C2C_change_type_2012_2015.zip" \
    # Change Year 12-15
    "https://opendata.nfis.org/downloads/forest_change/C2C_change_year_2012_2015.zip" \
    # Dynamic Habitat Index 2000 -- 2006
    "https://opendata.nfis.org/downloads/forest_change/CA_DHI_2000_2006.zip" \
    # Canadian Ecological Domain Classification
    "https://opendata.nfis.org/downloads/forest_change/CA_EcozoneDomain.zip" \
    # BC Tree Species Map/Likelihoods 2015
    "https://opendata.nfis.org/downloads/forest_change/BC_tree_species_2015.zip" \
    # Canada Harmonized Agriculture Forest Land Cover 2015
    "https://opendata.nfis.org/downloads/forest_change/CA_HLC_2015.zip" \
    # Canada Urban Greenness Score
    "https://opendata.nfis.org/downloads/forest_change/CA_Greenness_score_metric.zip" \
    # Landcover 2015 Version 1
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE_2015.zip" \
    # Wildfire Year/dNBR/Mask 1985-2015
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_wildfire_year_DNBR_Magnitude_1985_2015.zip" \
    # Harvest Year/Mask 1985-2015
    "https://opendata.nfis.org/downloads/forest_change/CA_forest_harvest_mask_year_1985_2015.zip"
    )

### ~~~~~~~~~~ ###
dataRepository=~/minio/standard/shared/randd-eesd/001-data-repository/001-acquired/nfis-change
if [ `uname` != "Darwin" ]
then
    cp $0 ${dataRepository}
fi

### ~~~~~~~~~~ ###
for tempzip in "${SHP_FILES[@]}"
do

    echo;echo downloading: ${tempzip}
    wget ${tempzip}
    sleep 5

    if [ `uname` != "Darwin" ]
    then
        tempstem=`basename ${tempzip} .zip`
        tempzip=${tempstem}.zip

        echo unzipping: ${tempzip}
        unzip ${tempzip} -d ${tempstem}
        sleep 5

        echo copying ${tempstem} to ${dataRepository}
        cp -r ${tempstem} ${dataRepository}
        sleep 5

        echo deleting ${tempzip} ${tempstem}
        rm -f ${tempzip} ${tempstem}
        sleep 5
    fi

done
echo

### ~~~~~~~~~~ ###
echo; echo done; echo

### ~~~~~~~~~~ ###
if [ `uname` != "Darwin" ]
then
    if compgen -G "std*" > /dev/null; then
        cp std* ${dataRepository}
    fi
fi
