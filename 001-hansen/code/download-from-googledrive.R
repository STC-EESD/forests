
download.from.googledrive <- function(
    google.drive.folder = "earthengine",
    patterns = c()
    ) {

    thisFunctionName <- "download.from.googledrive";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    options(
        gargle_oauth_email = Sys.getenv("GARGLE_OAUTH_EMAIL"),
        gargle_oauth_cache = Sys.getenv("GARGLE_OAUTH_CACHE")
        );

    require(googledrive);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.drive <- as.data.frame(googledrive::drive_find());

    saveRDS(
        object = DF.drive,
        file   = "DF-google-drive.RData"
        );

    # cat("\nstr(DF.drive)\n");
    # print( str(DF.drive)   );
    #
    # cat("\nDF.drive[,c('name','id')]\n");
    # print( DF.drive[,c('name','id')]   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    row.index <- which(DF.drive[,'name'] == google.drive.folder);
    google.drive.ID <- DF.drive[row.index[1],'id'];

    DF.earth.engine <- as.data.frame(googledrive::drive_ls(
        path    = googledrive::as_id(google.drive.ID),
        pattern = "."
        ));

    saveRDS(
        object = DF.earth.engine,
        file   = "DF-Drive-ls-folder.RData"
        );

    # cat("\nDF.earth.engine\n");
    # print( DF.earth.engine   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for ( temp.pattern in patterns ) {
        cat("\n### processing pattern:",temp.pattern,"\n");
        is.matched   <- grepl(
            x           = DF.earth.engine[,'name'],
            pattern     = temp.pattern,
            ignore.case = TRUE
            );
        n.is.matched <- sum(is.matched);
        cat("\n# ",n.is.matched,"object(s) found matching pattern:",temp.pattern,"\n")
        if ( sum(is.matched) > 0 ) {
            DF.temp <- DF.earth.engine[is.matched,];
            for ( row.index in seq(1,nrow(DF.temp)) ) {
                temp.id   <- DF.temp[row.index,'id'  ];
                temp.name <- DF.temp[row.index,'name'];
                cat("\n# downloading: ( ID:",temp.id,")",temp.name,"\n");
                googledrive::drive_download(file = googledrive::as_id(temp.id));
                }
            }
        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( NULL );

    }

##################################################
