
forest.loss.time.series <- function(
    CSV.treecover2000  = "treecover2000_area_by_ecozone.csv",
    CSV.loss.by.year   = "forest_loss_by_ecozone_year.csv",
    CSV.nfi.landcover  = "NFI_T1_LC_AREA_en.csv",
    CSV.nfi.forest     = "NFI_T4_FOR_AREA_en.csv",
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
        CSV.nfi.landcover = CSV.nfi.landcover,
        CSV.nfi.forest    = CSV.nfi.forest
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.hansen.nfi <- merge(
        x     = DF.hansen.cumulative,
        y     = DF.nfi.standard,
        by    = "ZONE_NAME",
        all.x = TRUE
        );
    cat("\nstr(DF.hansen.nfi)\n");
    print( str(DF.hansen.nfi)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    list.colname.pairs <- list(
        c(
            colname.hansen    = "hansen.2000",
            colname.nfi       = "nfi.landcover.treed",
            colname.nfi.total = "nfi.landcover.total"
            ),
        c(
            colname.hansen    = "hansen.2000",
            colname.nfi       = "nfi.forest.forest.land",
            colname.nfi.total = "nfi.landcover.total"
            ),
        c(
            colname.hansen    = "hansen.2017",
            colname.nfi       = "nfi.landcover.treed",
            colname.nfi.total = "nfi.landcover.total"
            ),
        c(
            colname.hansen    = "hansen.2017",
            colname.nfi       = "nfi.forest.forest.land",
            colname.nfi.total = "nfi.landcover.total"
            )
        );
    DF.colname.pairs <- t(as.data.frame(list.colname.pairs));
    rownames(DF.colname.pairs) <- NULL;

    for ( row.index in seq(1,nrow(DF.colname.pairs)) ) {
        forest.loss.time.series_hansen.vs.nfi.standard(
            DF.input          = DF.hansen.nfi,
            colname.hansen    = DF.colname.pairs[row.index,'colname.hansen'   ],
            colname.nfi       = DF.colname.pairs[row.index,'colname.nfi'      ],
            colname.nfi.total = DF.colname.pairs[row.index,'colname.nfi.total']
        );
        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    group.01 <- c(
        'Arctic Cordillera',
        'Boreal Shield'
        );

    group.02 <- c(
        'Arctic Cordillera',
        'Atlantic Maritime',
        'Boreal Plains',
        'Montane Cordillera'
        );

    group.03 <- c(
        'Arctic Cordillera',
        'Boreal Cordillera',
        'Hudson Plains',
        'Pacific Maritime',
        'Taiga Plains',
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
    DF.input          = NULL,
    colname.hansen    = NULL,
    colname.nfi       = NULL,
    colname.nfi.total = NULL,
    colour.palette    = RColorBrewer::brewer.pal(name = "Dark2", n = 8)
    ) {

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\nstr(DF.input)\n");
    print( str(DF.input)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    relevant.colnames <- c('ZONE_NAME',colname.nfi.total,'eeAREA',colname.nfi,colname.hansen);
    DF.temp           <- DF.input[,relevant.colnames];

    cat("\nstr(DF.temp)\n");
    print( str(DF.temp)   );

    colnames(DF.temp) <- gsub(
        x           = colnames(DF.temp),
        pattern     =  colname.nfi.total,
        replacement = "colname.nfi.total"
        );

    colnames(DF.temp) <- gsub(
        x           = colnames(DF.temp),
        pattern     =  colname.nfi,
        replacement = "colname.nfi"
        );

    colnames(DF.temp) <- gsub(
        x           = colnames(DF.temp),
        pattern     =  colname.hansen,
        replacement = "colname.hansen"
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    my.ggplot <- initializePlot(my.palette = colour.palette);

    my.ggplot <- my.ggplot + geom_abline(
        slope     = 1,
        intercept = 0,
        colour    = "gray"
        );

    my.ggplot <- my.ggplot + ggplot2::theme(
        axis.title.x = ggplot2::element_text(size = 50, face = "bold"),
        axis.title.y = ggplot2::element_text(size = 50, face = "bold"),
        axis.text.x  = ggplot2::element_text(size = 40, face = "bold"),
        axis.text.y  = ggplot2::element_text(size = 40, face = "bold")
        );

    my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp,
        mapping = aes(x = colname.nfi.total, y = eeAREA),
        colour  = "black",
        size    = 3.00,
        alpha   = 0.99
        );

    my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp,
        mapping = aes(x = colname.nfi, y = colname.hansen),
        colour  = "red",
        size    = 3.00,
        alpha   = 0.99
        );

    my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp,
        mapping = aes(x = colname.nfi, y = colname.hansen),
        colour  = "red",
        size    = 6.00,
        alpha   = 0.20
        );

    my.ggplot <- my.ggplot + xlab(label = colname.nfi   );
    my.ggplot <- my.ggplot + ylab(label = colname.hansen);

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

    PNG.output <- paste0(
        "plot_",
        gsub(x = colname.hansen, pattern = "\\.", replacement = "-"),
        "_vs_",
        gsub(x = colname.nfi,    pattern = "\\.", replacement = "-"),
        ".png"
        );

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
    CSV.nfi.landcover = NULL,
    CSV.nfi.forest    = NULL
    ) {

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.nfi.landcover <- read.csv(file = CSV.nfi.landcover, skip = 1);
    # cat("\nstr(DF.nfi.landcover)\n");
    # print( str(DF.nfi.landcover)   );

    colnames(DF.nfi.landcover) <- tolower(colnames(DF.nfi.landcover));
    colnames(DF.nfi.landcover) <- gsub(
        x           = colnames(DF.nfi.landcover),
        pattern     = "terrestrial\\.ecozone",
        replacement = "ZONE_NAME"
        );

    rownames(DF.nfi.landcover) <- as.character(DF.nfi.landcover[,'ZONE_NAME']);
    DF.nfi.landcover <- DF.nfi.landcover[,setdiff(colnames(DF.nfi.landcover),'ZONE_NAME')];
    DF.nfi.landcover <- 10.0 * DF.nfi.landcover;
    DF.nfi.landcover[,'ZONE_NAME'] <- rownames(DF.nfi.landcover);
    DF.nfi.landcover <- DF.nfi.landcover[,c('ZONE_NAME',setdiff(colnames(DF.nfi.landcover),'ZONE_NAME'))];

    colnames(DF.nfi.landcover) <- paste0("nfi.landcover.",colnames(DF.nfi.landcover));
    colnames(DF.nfi.landcover) <- gsub(
        x           = colnames(DF.nfi.landcover),
        pattern     = "nfi\\.landcover\\.ZONE_NAME",
        replacement = "ZONE_NAME"
        );

    cat("\nstr(DF.nfi.landcover)\n");
    print( str(DF.nfi.landcover)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.nfi.forest <- read.csv(file = CSV.nfi.forest, skip = 1);

    colnames(DF.nfi.forest) <- tolower(colnames(DF.nfi.forest));
    colnames(DF.nfi.forest) <- gsub(
        x           = colnames(DF.nfi.forest),
        pattern     = "terrestrial\\.ecozone",
        replacement = "ZONE_NAME"
        );

    rownames(DF.nfi.forest) <- as.character(DF.nfi.forest[,'ZONE_NAME']);
    DF.nfi.forest <- DF.nfi.forest[,setdiff(colnames(DF.nfi.forest),'ZONE_NAME')];
    DF.nfi.forest <- 10.0 * DF.nfi.forest;
    DF.nfi.forest[,'ZONE_NAME'] <- rownames(DF.nfi.forest);
    DF.nfi.forest <- DF.nfi.forest[,c('ZONE_NAME',setdiff(colnames(DF.nfi.forest),'ZONE_NAME'))];

    colnames(DF.nfi.forest) <- paste0("nfi.forest.",colnames(DF.nfi.forest));
    colnames(DF.nfi.forest) <- gsub(
        x           = colnames(DF.nfi.forest),
        pattern     = "nfi\\.forest\\.ZONE_NAME",
        replacement = "ZONE_NAME"
        );

    cat("\nstr(DF.nfi.forest)\n");
    print( str(DF.nfi.forest)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- merge(
        x     = DF.nfi.landcover,
        y     = DF.nfi.forest,
        by    = "ZONE_NAME",
        all.x = TRUE
        );

    cat("\nstr(DF.output)\n");
    print( str(DF.output)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( DF.output );

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
    # DF.temp <- DF.hansen[,c("treecover2000",as.character(seq(2001,2021)))];
    DF.temp <- DF.hansen[,c("treecover2000",as.character(year.colnames))];
    colnames(DF.temp) <- gsub(
        x           = colnames(DF.temp),
        pattern     = "^treecover",
        replacement = ""
        );
    colnames(DF.temp) <- paste0("hansen.",colnames(DF.temp));
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
        replacement =  "Boreal Plains",
        );

    DF.hansen.cumulative[,'ZONE_NAME'] <- gsub(
        x           = DF.hansen.cumulative[,'ZONE_NAME'],
        pattern     = "^Hudson Plain$",
        replacement =  "Hudson Plains",
        );

    DF.hansen.cumulative[,'ZONE_NAME'] <- gsub(
        x           = DF.hansen.cumulative[,'ZONE_NAME'],
        pattern     = "^Prairie$",
        replacement =  "Prairies",
        );

    DF.hansen.cumulative[,'ZONE_NAME'] <- gsub(
        x           = DF.hansen.cumulative[,'ZONE_NAME'],
        pattern     = "^MixedWood Plain$",
        replacement =  "Mixedwood Plains",
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

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    colnames(DF.input) <- gsub(
        x           = colnames(DF.input),
        pattern     = "^hansen\\.",
        replacement = ""
        );

    year.colnames <- as.character(grep(
        x       = colnames(DF.input),
        pattern = "^[0-9]{4,4}$",
        value   = TRUE
        ));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.temp <- DF.input[,c("ECOZONE","ZONE_NAME",year.colnames)];
    cat("\nstr(DF.temp)\n");
    print( str(DF.temp)   );
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
