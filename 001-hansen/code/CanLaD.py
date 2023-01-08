
import ee, os

##### ##### ##### ##### #####
def export_CanLaD_ecozone_year_loss(
    export_folder,
    export_fileNamePrefix,
    export_fileFormat,
    reduceRegion_scale,
    reduceRegion_maxPixels
    ):

    thisFunctionName = "export_forest_loss_by_ecozone_year"
    print( "\n\n\n### " + thisFunctionName + "() starts ..." )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    export_target = export_fileNamePrefix + "." + export_fileFormat.lower();
    if ( os.path.exists(export_target) ):
        print( "\n# export target (" + export_target + ") already exists; do nothing ..." );
        print( "\n### " + thisFunctionName + "() exits ..." );
        return( None ) # def export_forest_loss_by_ecozone_year():

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ecozones2017 = ee.FeatureCollection("users/paradisepilot/canada/ecozones2017");
    print("ecozones2017",ecozones2017);

    # ##### ##### ##### ##### #####
    CanLaD =     ee.Image("users/randd-eesd/canada/CanLaD_20151984_latest_type_modePyramiding").rename('losstype') \
       .addBands(ee.Image("users/randd-eesd/canada/CanLaD_20151984_latest_YRT2_modePyramiding").rename('lossyear'));
    print("CanLaD",CanLaD);

    # ##### ##### ##### ##### #####
    def calculateLossByZoneYear(feature):

        lossByYear = CanLaD.select('losstype').gt(0).multiply(ee.Image.pixelArea()) \
            .addBands(CanLaD.select('lossyear')) \
            .reduceRegion(
                reducer = ee.Reducer.sum().group(
                    groupField = 1,
                    groupName  = 'lossyear'
                    ),
                geometry  = feature.geometry(),
                scale     = reduceRegion_scale,
                maxPixels = reduceRegion_maxPixels
                );

        # lossByYear = treecover2000.select('treecover2000').multiply(ee.Image.pixelArea()) \
        #     .addBands(treecover2000.select('lossyear')) \
        #     .reduceRegion(
        #         reducer = ee.Reducer.sum().group(
        #             groupField = 1,
        #             groupName  = 'lossyear'
        #             ),
        #         geometry  = feature.geometry(),
        #         scale     = 50, # 75, # 100, # 500,
        #         maxPixels = 2e10
        #         );

        listLossByYear = ee.List(lossByYear.get('groups')).map(_rescale_area);
        result = ee.Dictionary(listLossByYear.flatten());

        ecozone        = feature.get('ECOZONE'  );
        zone_id        = feature.get('ZONE_ID'  );
        zone_name      = feature.get('ZONE_NAME');
        zone_area      = feature.get('AREA'     );
        zone_perimeter = feature.get('PERIMETER');
        zone_ee_area   = ee.Number(feature.geometry().area()).divide(1e6);

        outputFeature = ee.Feature(
            feature.geometry(),
            result \
              .set('ECOZONE',   ecozone       ) \
              .set('ZONE_ID',   zone_id       ) \
              .set('ZONE_NAME', zone_name     ) \
              .set('AREA',      zone_area     ) \
              .set('PERIMETER', zone_perimeter) \
              .set('eeAREA',    zone_ee_area  )
            );

        return outputFeature;

    CanLaDLossByZoneYear = ecozones2017.map(calculateLossByZoneYear);
    print("CanLaDLossByZoneYear",CanLaDLossByZoneYear);

    # ##### ##### ##### ##### #####
    leadingPropertyNames = ['ECOZONE','ZONE_ID','ZONE_NAME','AREA','PERIMETER','eeAREA'];

    years = CanLaDLossByZoneYear.first().propertyNames().getInfo();
    years = set(years) - set(leadingPropertyNames);
    years = list(years);
    years.remove('system:index');
    years.sort();
    years = ee.List(years);

    outputFields = ee.List(leadingPropertyNames).cat(years).getInfo();
    print("outputFields",outputFields);

    export_task = ee.batch.Export.table.toDrive(
      collection     = CanLaDLossByZoneYear,
      folder         = export_folder,         # 'earthengine/ken',
      description    = export_fileNamePrefix, # 'forest_loss_by_ecozone_year',
      fileNamePrefix = export_fileNamePrefix, # 'forest_loss_by_ecozone_year',
      fileFormat     = export_fileFormat,     # 'CSV',
      selectors      = outputFields
      );
    export_task.start();

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print( "\n### " + thisFunctionName + "() exits ..." )
    return( None ) # def export_forest_loss_by_ecozone_year():

##### ##### ##### ##### #####
def _rescale_area(item):
    areaDict = ee.Dictionary(item);
    classNumber = ee.Number(areaDict.get('lossyear')).format();
    area = ee.Number(areaDict.get('sum')).divide(1e6);
    return ee.List([classNumber,area]);
