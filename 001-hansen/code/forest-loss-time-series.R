
forest.loss.time.series <- function(
    CSV.treecover2000 = "treecover2000_area_by_ecozone.csv",
    CSV.loss.by.year  = "forest_loss_by_ecozone_year.csv"
    ) {

    thisFunctionName <- "forest.loss.time.series";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.hansen.cumulative <- forest.loss.time.series_cumulative(
        CSV.treecover2000 = CSV.treecover2000,
        CSV.loss.by.year  = CSV.loss.by.year
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( NULL );

    }

##################################################
forest.loss.time.series_cumulative <- function(
    CSV.treecover2000 = NULL,
    CSV.loss.by.year  = NULL
    ) {

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.treecover2000 <- read.csv(CSV.treecover2000);

    cat("\nstr(DF.treecover2000)\n");
    print( str(DF.treecover2000)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.loss.by.year <- read.csv(CSV.loss.by.year );
    colnames(DF.loss.by.year) <- gsub(
        x           = colnames(DF.loss.by.year),
        pattern     = "^X",
        replacement = ""
        );

    year.colnames <- grep(
        x = colnames(DF.loss.by.year),
        pattern = "^[0-9]{,4}$"
        );

    DF.loss.by.year[is.na(DF.loss.by.year)] <- 0;
    DF.loss.by.year[,year.colnames] <- (-1) * DF.loss.by.year[,year.colnames];

    cat("\nstr(DF.loss.by.year)\n");
    print( str(DF.loss.by.year)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    retained.columns <- setdiff(
        colnames(DF.loss.by.year),
        colnames(DF.treecover2000)
        );
    retained.colnames <- c('ZONE_ID',retained.columns);

    DF.hansen <- dplyr::left_join(
        x  = DF.treecover2000,
        y  = DF.loss.by.year[,retained.colnames],
        by = "ZONE_ID"
        );

    cat("\nstr(DF.hansen)\n");
    print( str(DF.hansen)   );

    arrow::write_parquet(
        x    = DF.hansen,
        sink = "DF-hansen.parquet"
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.temp <- DF.hansen[,c("treecover2000",as.character(seq(2001,2021)))];
    colnames(DF.temp) <- gsub(
        x           = colnames(DF.temp),
        pattern     = "^treecover",
        replacement = ""
        );
    rownames(DF.temp) <- DF.hansen[,'ZONE_ID'];

    DF.temp <- as.data.frame(t(apply(
        X      = DF.temp,
        MARGIN = 1,
        FUN    = cumsum
        )));
    DF.temp[,'ZONE_ID'] <- as.integer(rownames(DF.temp));

    DF.hansen.cumulative <- dplyr::left_join(
        x  = DF.treecover2000,
        y  = DF.temp,
        by = "ZONE_ID"
        );

    cat("\nstr(DF.hansen.cumulative)\n");
    print( str(DF.hansen.cumulative)   );

    arrow::write_parquet(
        x    = DF.hansen.cumulative,
        sink = "DF-hansen-cumulative.parquet"
        );

    return( DF.hansen.cumulative );

    }
