
import ee

def test_eeHansen(google_drive_folder):

    thisFunctionName = "test_eeHansen"
    print( "\n########## " + thisFunctionName + "() starts ..." )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

    ##### ##### ##### ##### #####
    ecozones2017 = ee.FeatureCollection("users/paradisepilot/canada/ecozones2017");
    print("ecozones2017",ecozones2017);

    hansen = ee.Image('UMD/hansen/global_forest_change_2021_v1_9');
    print("hansen",hansen);

    forest2000 = hansen.select('treecover2000').gt(50);
    print("forest2000",forest2000);

    ##### ##### ##### ##### #####
    objAreaByLandCover = ee.Image.pixelArea() \
        .addBands(forest2000) \
        .reduceRegion(
            reducer = ee.Reducer.sum().group(
                groupField = 1,
                groupName  = 'landcover'
                ),
            geometry  = ecozones2017.first().geometry(),
            scale     = 500,
            maxPixels = 1e10
        );
    print("objAreaByLandCover",objAreaByLandCover);

    eeListLandCoverAreas = ee.List(objAreaByLandCover.get('groups'));
    print("eeListLandCoverAreas",eeListLandCoverAreas);

    listLandCoverAreas = eeListLandCoverAreas.map(_getClassArea);
    print("listLandCoverAreas",listLandCoverAreas);

    result = ee.Dictionary(listLandCoverAreas.flatten());
    print("result",result);

    zone_name = ecozones2017.first().get('ZONE_NAME');
    print("zone_name",zone_name);

    outputFeature = ee.Feature(
        ecozones2017.first().geometry(),
        result.set('ZONE_NAME',zone_name)
        );
    print("outputFeature",outputFeature);

    ##### ##### ##### ##### #####
    forestAreaByEcozone = ecozones2017.map(_calculateClassArea);
    print("forestAreaByEcozone",forestAreaByEcozone);

    ##### ##### ##### ##### #####
    classes       = ee.List.sequence(0,1);
    propertyNames = ['ECOZONE','ZONE_ID','ZONE_NAME','AREA','PERIMETER'];
    outputFields  = ee.List(propertyNames).cat(classes).getInfo();

    ee.batch.Export.table.toDrive(
        collection     = forestAreaByEcozone,
        description    = 'class_area_by_ecozone',
        folder         = google_drive_folder,
        fileNamePrefix = 'class_area_by_ecozone',
        fileFormat     = 'CSV',
        selectors      = outputFields
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\n########## " + thisFunctionName + "() exits ..." )
    return( None )

##### ##### ##### ##### #####
def maskS2clouds(image):
  qa = image.select('QA60')
  cloudBitMask  = 1 << 10
  cirrusBitMask = 1 << 11
  mask = qa.bitwiseAnd(cloudBitMask).eq(0).And(
             qa.bitwiseAnd(cirrusBitMask).eq(0))
  return image.updateMask(mask) \
      .select("B.*") \
      .copyProperties(image, ["system:time_start"])

def addNDVI(image):
  ndvi = image.normalizedDifference(['B8','B4']).rename('ndvi')
  return image.addBands(ndvi)

def _getClassArea(item):
    areaDict = ee.Dictionary(item);
    classNumber = ee.Number(areaDict.get('landcover')).format();
    area = ee.Number(areaDict.get('sum')).divide(1e6).round();
    return ee.List([classNumber,area]);

def _calculateClassArea(feature):
    forest2000 = ee.Image('UMD/hansen/global_forest_change_2021_v1_9') \
        .select('treecover2000').gt(50);
    objAreaByLandCover = ee.Image.pixelArea() \
        .addBands(forest2000) \
        .reduceRegion(
            reducer = ee.Reducer.sum().group(
                groupField = 1,
                groupName  = 'landcover'
            ),
            geometry  = feature.geometry(),
            scale     = 500,
            maxPixels = 1e10
        );

    eeListLandCoverAreas = ee.List(objAreaByLandCover.get('groups'));
    listLandCoverAreas   = eeListLandCoverAreas.map(_getClassArea);
    result               = ee.Dictionary(listLandCoverAreas.flatten());

    ecozone        = feature.get('ECOZONE'  );
    zone_id        = feature.get('ZONE_ID'  );
    zone_name      = feature.get('ZONE_NAME');
    zone_area      = feature.get('AREA'     );
    zone_perimeter = feature.get('PERIMETER');

    outputFeature = ee.Feature(
        feature.geometry(),
        result
            .set('ECOZONE',   ecozone)
            .set('ZONE_ID',   zone_id)
            .set('ZONE_NAME', zone_name)
            .set('AREA',      zone_area)
            .set('PERIMETER', zone_perimeter)
        );

    return outputFeature;
