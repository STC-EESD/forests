#!/usr/bin/env python

import os, sys, shutil, getpass, time
import pprint, logging, datetime
import stat

dir_data            = os.path.realpath(sys.argv[1])
dir_code            = os.path.realpath(sys.argv[2])
dir_output          = os.path.realpath(sys.argv[3])
google_drive_folder = sys.argv[4]

if not os.path.exists(dir_output):
    os.makedirs(dir_output)

os.chdir(dir_output)

myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( "\n" + myTime + "\n" )

print( "\ndir_data: "            + dir_data            )
print( "\ndir_code: "            + dir_code            )
print( "\ndir_output: "          + dir_output          )
print( "\ngoogle_drive_folder: " + google_drive_folder )

print( "\nos.environ.get('GEE_ENV_DIR'):")
print(    os.environ.get('GEE_ENV_DIR')  )

print( "\n### python module search paths:" )
for path in sys.path:
    print(path)

print("\n####################")

logging.basicConfig(filename='log.debug',level=logging.DEBUG)

##################################################
##################################################
# import seaborn (for improved graphics) if available
# import seaborn as sns

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
from wrapper_eeAuthenticate import wrapper_eeAuthenticate
from hansen import export_Hansen_ecozone_treecover2000
from hansen import export_Hansen_ecozone_year_loss
from CanLaD import export_CanLaD_ecozone_year_loss

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
wrapper_eeAuthenticate()

n_exported_files = 0

return_value = export_Hansen_ecozone_treecover2000(
    export_folder          = google_drive_folder,
    export_fileNamePrefix  = 'Hansen_ecozone_year_treecover2000',
    export_fileFormat      = 'CSV',
    reduceRegion_scale     = 75, # 100, # 500,
    reduceRegion_maxPixels = 1e10
    )
n_exported_files += return_value

return_value = export_Hansen_ecozone_year_loss(
    export_folder         = google_drive_folder,
    export_fileNamePrefix = 'Hansen_ecozone_year_loss',
    export_fileFormat     = 'CSV',
    reduceRegion_scale     = 50, # 75, # 100, # 500,
    reduceRegion_maxPixels = 2e10
    )
n_exported_files += return_value

return_value = export_CanLaD_ecozone_year_loss(
    export_folder          = google_drive_folder,
    export_fileNamePrefix  = 'CanLaD_ecozone_year_loss',
    export_fileFormat      = 'CSV',
    reduceRegion_scale     = 50, # 75, # 100, # 500,
    reduceRegion_maxPixels = 2e10
    )
n_exported_files += return_value

print("\n\n# number of exported files: " + str(n_exported_files) + "\n")
if ( n_exported_files > 0 ):
    print("\n\n# number of exported files > 0 ; sleeping ...\n\n")
    time.sleep( 600 ); # sleep duration in seconds

# ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

##################################################
##################################################
print("\n####################\n")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime + "\n" )
