
download.from.googledrive <- function(
    google.drive.folder = "earthengine",
    patterns = c()
    ) {

    thisFunctionName <- "download.from.googledrive";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    existing.filees <- as.character(unlist(sapply(
        X   = patterns,
        FUN = function(x) { return(list.files(pattern = x, ignore.case = TRUE)) }
        )));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    options(
        gargle_oauth_email = Sys.getenv("GARGLE_OAUTH_EMAIL"),
        gargle_oauth_cache = Sys.getenv("GARGLE_OAUTH_CACHE")
        );

    require(googledrive);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.googledrive.find <- as.data.frame(googledrive::drive_find());

    saveRDS(
        object =  DF.googledrive.find,
        file   = "DF-googledrive-find.RData"
        );

    # cat("\nstr(DF.googledrive.find)\n");
    # print( str(DF.googledrive.find)   );
    #
    # cat("\nDF.googledrive.find[,c('name','id')]\n");
    # print( DF.googledrive.find[,c('name','id')]   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    row.index <- which(DF.googledrive.find[,'name'] == google.drive.folder);
    google.drive.ID <- DF.googledrive.find[row.index[1],'id'];

    DF.googledrive.ls.folder <- as.data.frame(googledrive::drive_ls(
        path    = googledrive::as_id(google.drive.ID),
        pattern = "."
        ));

    saveRDS(
        object =  DF.googledrive.ls.folder,
        file   = "DF-googledrive-ls-folder.RData"
        );

    # cat("\nDF.googledrive.ls.folder\n");
    # print( DF.googledrive.ls.folder   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    for ( temp.pattern in patterns ) {
        cat("\n### processing pattern:",temp.pattern,"\n");
        is.matched   <- grepl(
            x           = DF.googledrive.ls.folder[,'name'],
            pattern     = temp.pattern,
            ignore.case = TRUE
            );
        n.is.matched <- sum(is.matched);
        cat("\n# ",n.is.matched,"object(s) found matching pattern:",temp.pattern,"\n")
        if ( sum(is.matched) > 0 ) {
            DF.temp <- DF.googledrive.ls.folder[is.matched,];
            for ( row.index in seq(1,nrow(DF.temp)) ) {
                temp.id   <- DF.temp[row.index,'id'  ];
                temp.name <- DF.temp[row.index,'name'];
                if ( temp.name %in% existing.filees ) {
                    cat("\n# already exists: ( ID:",temp.id,")",temp.name," (did NOT download)\n");
                } else {
                    cat("\n# downloading: ( ID:",temp.id,")",temp.name,"\n");
                    googledrive::drive_download(file = googledrive::as_id(temp.id));
                    }
                }
            }
        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( NULL );

    }

##################################################
