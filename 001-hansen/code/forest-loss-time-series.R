
forest.loss.time.series <- function(
    CSV.treecover2000  = "treecover2000_area_by_ecozone.csv",
    CSV.loss.by.year   = "forest_loss_by_ecozone_year.csv",
    CSV.nfi.standard   = "NFI_T1_LC_AREA_en.csv",
    CSV.nfi.customized = "nfi-customized-report.csv",
    colour.palette     = RColorBrewer::brewer.pal(name = "Dark2", n = 8)
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
    DF.nfi.standard <- forest.loss.time.series_nfi.standard(
        CSV.nfi.standard = CSV.nfi.standard
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    forest.loss.time.series_hansen.vs.nfi.standard(
        DF.hansen = DF.hansen.cumulative,
        DF.nfi    = DF.nfi.standard
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    group.01 <- c(
        'Arctic Cordillera',
        'Boreal Shield'
        );

    group.02 <- c(
        'Arctic Cordillera',
        'Atlantic Maritime',
        'Boreal Plain',
        'Montane Cordillera'
        );

    group.03 <- c(
        'Arctic Cordillera',
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
forest.loss.time.series_hansen.vs.nfi.standard <- function(
    DF.hansen      = NULL,
    DF.nfi         = NULL,
    colour.palette = RColorBrewer::brewer.pal(name = "Dark2", n = 8),
    PNG.output     = "plot-hansen-vs-nfi-standard.png"
    ) {

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\nstr(DF.hansen)\n");
    print( str(DF.hansen)   );

    colnames(DF.nfi) <- paste0("nfi.",colnames(DF.nfi));
    colnames(DF.nfi) <- gsub(
        x           = colnames(DF.nfi),
        pattern     = "^nfi\\.ZONE_NAME$",
        replacement = "ZONE_NAME"
        );
    cat("\nstr(DF.nfi)\n");
    print( str(DF.nfi)   );

    DF.merged <- merge(
        x     = DF.hansen,
        y     = DF.nfi,
        by    = "ZONE_NAME",
        all.x = TRUE
        );
    cat("\nstr(DF.merged)\n");
    print( str(DF.merged)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\nDF.merged[,c('ZONE_NAME','nfi.total','eeAREA','nfi.treed','treecover2000')]\n");
    print( DF.merged[,c('ZONE_NAME','nfi.total','eeAREA','nfi.treed','treecover2000')]   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my.ggplot <- initializePlot(my.palette = colour.palette);

    my.ggplot <- my.ggplot + geom_abline(
        slope     = 1,
        intercept = 0,
        colour    = "gray"
        );

    # my.ggplot <- my.ggplot + ggplot2::theme(
    #     legend.position = "bottom",
    #     legend.text     = ggplot2::element_text(size = 30, face = "bold"),
    #     axis.text.x     = ggplot2::element_text(size = 20, face = "bold", angle = 90, vjust = 0.5)
    #     );

    my.ggplot <- my.ggplot + geom_point(
        data    = DF.merged,
        mapping = aes(x = nfi.total, y = eeAREA),
        colour  = "black",
        size    = 3.00,
        alpha   = 0.99
        );

    my.ggplot <- my.ggplot + geom_point(
        data    = DF.merged,
        mapping = aes(x = nfi.treed, y = treecover2000),
        colour  = "red",
        size    = 3.00,
        alpha   = 0.99
        );

    my.ggplot <- my.ggplot + geom_point(
        data    = DF.merged,
        mapping = aes(x = nfi.treed, y = treecover2000),
        colour  = "red",
        size    = 6.00,
        alpha   = 0.20
        );

    # my.range  <- range(DF.temp[,'year']);
    # my.min    <- 2 * floor(  min(my.range)/2);
    # my.max    <- 2 * ceiling(max(my.range)/2);
    # my.limits <- c(my.min,my.max);
    # my.breaks <- seq(my.min,my.max,2);

    my.ggplot <- my.ggplot + scale_x_continuous(
        limits = c(  0,2.5e6),
        breaks = seq(0,2.5e6,0.5e6),
        labels = scales::scientific
        );

    my.ggplot <- my.ggplot + scale_y_continuous(
        limits = c(  0,2.5e6),
        breaks = seq(0,2.5e6,0.5e6),
        labels = scales::scientific
        );

    # my.ggplot <- my.ggplot + scale_x_continuous(
    #     limits = c(  0,7),
    #     breaks = seq(0,7,2)
    #     );
    #
    # my.ggplot <- my.ggplot + scale_y_continuous(
    #     limits = c(  0,7),
    #     breaks = seq(0,7,2)
    #     );

    ggsave(
        file   = PNG.output,
        plot   = my.ggplot,
        dpi    = 300,
        height =  16,
        width  =  17, # 24
        units  = 'in'
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( NULL );

    }

forest.loss.time.series_nfi.standard <- function(
    CSV.nfi.standard = NULL
    ) {

    DF.read <- read.csv(file = CSV.nfi.standard, skip = 1);
    # cat("\nstr(DF.read)\n");
    # print( str(DF.read)   );

    colnames(DF.read) <- tolower(colnames(DF.read));
    colnames(DF.read) <- gsub(
        x           = colnames(DF.read),
        pattern     = "terrestrial\\.ecozone",
        replacement = "ZONE_NAME"
        );

    rownames(DF.read) <- as.character(DF.read[,'ZONE_NAME']);
    DF.read <- DF.read[,setdiff(colnames(DF.read),'ZONE_NAME')];
    DF.read <- 10.0 * DF.read;
    DF.read[,'ZONE_NAME'] <- rownames(DF.read);
    DF.read <- DF.read[,c('ZONE_NAME',setdiff(colnames(DF.read),'ZONE_NAME'))];

    cat("\nstr(DF.read)\n");
    print( str(DF.read)   );

    return( DF.read );

    }

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

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.hansen.cumulative[,'ZONE_NAME'] <- gsub(
        x           = DF.hansen.cumulative[,'ZONE_NAME'],
        pattern     = "^Boreal PLain$",
        replacement =  "Boreal Plain",
        );

    DF.hansen.cumulative[,'ZONE_NAME'] <- gsub(
        x           = DF.hansen.cumulative[,'ZONE_NAME'],
        pattern     = "^Prairie$",
        replacement =  "Prairies",
        );

    DF.hansen.cumulative[,'ZONE_NAME'] <- gsub(
        x           = DF.hansen.cumulative[,'ZONE_NAME'],
        pattern     = "^Taiga Plain$",
        replacement =  "Taiga Plains",
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.hansen.cumulative <- DF.hansen.cumulative[,setdiff(colnames(DF.hansen.cumulative),c("PERIMETER","ZONE_ID"))];
    DF.hansen.cumulative <- stats::aggregate(
        data = DF.hansen.cumulative,
        x    = as.formula(". ~ ECOZONE + ZONE_NAME"),
        FUN  = sum
        );

    cat("\nstr(DF.hansen.cumulative)\n");
    print( str(DF.hansen.cumulative)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    arrow::write_parquet(
        x    = DF.hansen.cumulative,
        sink = "DF-hansen-cumulative.parquet"
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
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

    # DF.temp <- DF.input[,c("ECOZONE","ZONE_ID","ZONE_NAME",year.colnames)];
    DF.temp <- DF.input[,c("ECOZONE","ZONE_NAME",year.colnames)];
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
        mapping = aes(x = year, y = treecover, group = ZONE_NAME, colour = ZONE_NAME),
        size    = 1.00,
        alpha   = 0.50
        );

    my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp,
        mapping = aes(x = year, y = treecover, group = ZONE_NAME, colour = ZONE_NAME),
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
