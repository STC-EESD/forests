#!/bin/bash

wget http://www.ccea-ccae.org/wp-content/uploads/2021/01/Canada_Ecozones_V5_map_kml_v20140218.zip
wget http://www.ccea-ccae.org/wp-content/uploads/2021/01/Canada_Ecozones_V5b_15M_simplify.shp_v20140218.zip

unzip Canada_Ecozones_V5_map_kml_v20140218.zip           -d Canada_Ecozones_V5_map_kml_v20140218
unzip Canada_Ecozones_V5b_15M_simplify.shp_v20140218.zip -d Canada_Ecozones_V5b_15M_simplify.shp_v20140218

chmod -R ugo-w Canada*

