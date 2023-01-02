
forest.loss.time.series <- function(
    CSV.treecover2000 = "treecover2000_area_by_ecozone.csv",
    CSV.loss.by.year  = "forest_loss_by_ecozone_year.csv",
    colour.palette    = RColorBrewer::brewer.pal(name = "Dark2", n = 8)
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
    group.01 <- c(
        'Boreal Shield',
        'Arctic Cordillera'
        );

    group.02 <- c(
        'Atlantic Maritime',
        'Boreal Plain',
        'Montane Cordillera'
        );

    group.03 <- c(
        'Boreal Cordillera',
        'Hudson Plain',
        'Pacific Maritime',
        'Taiga Plain',
        'Taiga Shield'
        );

    is.selected <- (DF.hansen.cumulative[,'ZONE_NAME'] %in% group.01);
    forest.loss.time.series_time.plot(
        DF.input       = DF.hansen.cumulative[is.selected,],
        PNG.output     = "plot-forest-loss-time-plot-01.png",
        colour.palette = colour.palette
        );

    is.selected <- (DF.hansen.cumulative[,'ZONE_NAME'] %in% group.02);
    forest.loss.time.series_time.plot(
        DF.input       = DF.hansen.cumulative[is.selected,],
        PNG.output     = "plot-forest-loss-time-plot-02.png",
        colour.palette = colour.palette
        );

    is.selected <- (DF.hansen.cumulative[,'ZONE_NAME'] %in% group.03);
    forest.loss.time.series_time.plot(
        DF.input       = DF.hansen.cumulative[is.selected,],
        PNG.output     = "plot-forest-loss-time-plot-03.png",
        colour.palette = colour.palette
        );

    is.selected <- !(DF.hansen.cumulative[,'ZONE_NAME'] %in% c(group.01,group.02,group.03));
    forest.loss.time.series_time.plot(
        DF.input       = DF.hansen.cumulative[is.selected,],
        PNG.output     = "plot-forest-loss-time-plot-04.png",
        colour.palette = colour.palette
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

    DF.treecover2000[,'ZONE_NAME'] <- gsub(
        x           = DF.treecover2000[,'ZONE_NAME'],
        pattern     = "Boreal PLain",
        replacement = "Boreal Plain",
        );

    cat("\nstr(DF.treecover2000)\n");
    print( str(DF.treecover2000)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.loss.by.year <- read.csv(CSV.loss.by.year );
    colnames(DF.loss.by.year) <- gsub(
        x           = colnames(DF.loss.by.year),
        pattern     = "^X",
        replacement = ""
        );

    DF.loss.by.year[,'ZONE_NAME'] <- gsub(
        x           = DF.loss.by.year[,'ZONE_NAME'],
        pattern     = "Boreal PLain",
        replacement = "Boreal Plain",
        );

    year.colnames <- grep(
        x       = colnames(DF.loss.by.year),
        pattern = "^[0-9]{,4}$",
        value   = TRUE
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

forest.loss.time.series_time.plot <- function(
    DF.input       = NULL,
    PNG.output     = "plot-forest-loss-time-plot.png",
    colour.palette = RColorBrewer::brewer.pal(name = "Dark2", n = 8)
    ) {

    year.colnames <- grep(x = colnames(DF.input), pattern = "^[0-9]{,4}$", value = TRUE);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    year.colnames <- as.character(grep(
        x       = colnames(DF.input),
        pattern = "^[0-9]{,4}$",
        value   = TRUE
        ));

    DF.temp <- DF.input[,c("ECOZONE","ZONE_ID","ZONE_NAME",year.colnames)];
    DF.temp <- as.data.frame(tidyr::pivot_longer(
        data      = DF.temp,
        cols      = year.colnames,
        names_to  = "year",
        values_to = "treecover"
        ));
    DF.temp[,'year'] <- as.integer(DF.temp[,'year']);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my.ggplot <- initializePlot(my.palette = colour.palette);

    my.ggplot <- my.ggplot + ggplot2::theme(
        legend.position = "bottom",
        legend.text     = ggplot2::element_text(size = 30, face = "bold"),
        axis.text.x     = ggplot2::element_text(size = 20, face = "bold", angle = 90, vjust = 0.5)
        );

    my.ggplot <- my.ggplot + geom_line(
        data    = DF.temp,
        mapping = aes(x = year, y = treecover, group = ZONE_ID, colour = ZONE_NAME),
        size    = 1.00,
        alpha   = 0.50
        );

    my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp,
        mapping = aes(x = year, y = treecover, group = ZONE_ID, colour = ZONE_NAME),
        size    = 3.00,
        alpha   = 0.99
        );

    my.range  <- range(DF.temp[,'year']);
    my.min    <- 2 * floor(  min(my.range)/2);
    my.max    <- 2 * ceiling(max(my.range)/2);
    my.limits <- c(my.min,my.max);
    my.breaks <- seq(my.min,my.max,2);

    my.ggplot <- my.ggplot + scale_x_continuous(
        limits = my.range,
        breaks = my.breaks
        );

    ggsave(
        file   = PNG.output,
        plot   = my.ggplot,
        dpi    = 300,
        height =   8,
        width  =  16, # 24
        units  = 'in'
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( NULL );

    }
