
import ee

def export_treecover2000(google_drive_folder):

    thisFunctionName = "export_treecover2000"
    print( "\n########## " + thisFunctionName + "() starts ..." )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ecozones2017 = ee.FeatureCollection("users/paradisepilot/canada/ecozones2017");
    print("ecozones2017",ecozones2017);

    hansen = ee.Image('UMD/hansen/global_forest_change_2021_v1_9');
    print("hansen",hansen);

    treecover2000 = hansen.select('treecover2000') \
        .divide(ee.Image.constant(100));
    oneMinusTreecover2000 = treecover2000 \
        .multiply(ee.Image.constant(-1)) \
        .add(ee.Image.constant(1)) \
        .rename('oneMinusTreecover2000');
    isNULL  = hansen.select('datamask').eq(0).rename('isNULL' );
    isLand  = hansen.select('datamask').eq(1).rename('isLand' );
    isWater = hansen.select('datamask').eq(2).rename('isWater');
    treecover2000 = treecover2000.addBands([
        oneMinusTreecover2000,
        isNULL,
        isLand,
        isWater
        ]);
    print("treecover2000",treecover2000);

    # ##### ##### ##### ##### #####
    def calculateClassArea(feature):

        featureAreaTreeCover2000 = treecover2000.multiply(ee.Image.pixelArea()) \
            .reduceRegion(
                reducer   = ee.Reducer.sum(),
                geometry  = feature.geometry(),
                scale     = 500,
                maxPixels = 1e10
                );

        featureAreaTreeCover2000 = featureAreaTreeCover2000.set(
            'treecover2000',
            ee.Number(featureAreaTreeCover2000.get('treecover2000')).divide(1e6)
            );
        featureAreaTreeCover2000 = featureAreaTreeCover2000.set(
            'oneMinusTreecover2000',
            ee.Number(featureAreaTreeCover2000.get('oneMinusTreecover2000')).divide(1e6)
            );
        featureAreaTreeCover2000 = featureAreaTreeCover2000.set(
            'isNULL',
            ee.Number(featureAreaTreeCover2000.get('isNULL')).divide(1e6)
            );
        featureAreaTreeCover2000 = featureAreaTreeCover2000.set(
            'isLand',
            ee.Number(featureAreaTreeCover2000.get('isLand')).divide(1e6)
            );
        featureAreaTreeCover2000 = featureAreaTreeCover2000.set(
            'isWater',
            ee.Number(featureAreaTreeCover2000.get('isWater')).divide(1e6)
            );

        ecozone        = feature.get('ECOZONE'  );
        zone_id        = feature.get('ZONE_ID'  );
        zone_name      = feature.get('ZONE_NAME');
        zone_area      = feature.get('AREA'     );
        zone_perimeter = feature.get('PERIMETER');
        zone_ee_area   = ee.Number(feature.geometry().area()).divide(1e6);

        outputFeature = ee.Feature(
            feature.geometry(),
            featureAreaTreeCover2000 \
                .set('ECOZONE',   ecozone) \
                .set('ZONE_ID',   zone_id) \
                .set('ZONE_NAME', zone_name) \
                .set('AREA',      zone_area)
                .set('PERIMETER', zone_perimeter)
                .set('eeAREA',    zone_ee_area)
            );

        return outputFeature;
        # def calculateClassArea(feature):

    treecover2000ByEcozone = ecozones2017.map(calculateClassArea);
    print("treecover2000ByEcozone",treecover2000ByEcozone);

    # ##### ##### ##### ##### #####
    outputFields = [
      'ECOZONE',
      'ZONE_ID',
      'ZONE_NAME',
      'AREA',
      'PERIMETER',
      'eeAREA',
      'treecover2000',
      'oneMinusTreecover2000',
      'isNULL',
      'isLand',
      'isWater'
      ];

    export_task = ee.batch.Export.table.toDrive(
        collection     = treecover2000ByEcozone,
        folder         = google_drive_folder,
        description    = 'treecover2000_area_by_ecozone',
        fileNamePrefix = 'treecover2000_area_by_ecozone',
        fileFormat     = 'CSV',
        selectors      = outputFields
        );
    export_task.start();

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\n########## " + thisFunctionName + "() exits ..." )
    return( None )

##### ##### ##### ##### #####
# def maskS2clouds(image):
#   qa = image.select('QA60')
#   cloudBitMask  = 1 << 10
#   cirrusBitMask = 1 << 11
#   mask = qa.bitwiseAnd(cloudBitMask).eq(0).And(
#              qa.bitwiseAnd(cirrusBitMask).eq(0))
#   return image.updateMask(mask) \
#       .select("B.*") \
#       .copyProperties(image, ["system:time_start"])
#
# def addNDVI(image):
#   ndvi = image.normalizedDifference(['B8','B4']).rename('ndvi')
#   return image.addBands(ndvi)
#
# def _numberToString(number):
#     return ee.String(number);
#
# def _getClassArea(item):
#     areaDict = ee.Dictionary(item);
#     classNumber = ee.Number(areaDict.get('landcover')).format();
#     area = ee.Number(areaDict.get('sum')).divide(1e6).round();
#     return ee.List([classNumber,area]);
