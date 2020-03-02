ui <- fluidPage(

    # Application title
    titlePanel(windowTitle="CREA - Air Quality Monitoring", title=div(img(src="crea_logo.svg", width=220))),

    tabsetPanel(
        # Measurements
        tabPanel("Measurements", fluid = TRUE,
            sidebarLayout(
                sidebarPanel(
                    width = 2,
                    selectInput("country",
                                "Country:",
                                choices = unique(locations$country),
                                multiple=T,
                                selected = "IN"
                    ),
                    uiOutput("selectInputCity"),
                    selectInput("poll",
                                "Pollutant:",
                                choices = polls,
                                selected = creadb::PM25
                    ),
                    selectInput("averaging",
                                "Time averaging:",
                                choices = averagings,
                                selected = "day"
                    ),
                    sliderInput("running_width", "Rolling average (day)", min=1, max=30, value=1, step=1, sep = ""
                    ),
                    sliderInput("years", "Year", min=2015, max=2020, value=c(2018, 2020), step=1, sep = "", ticks = F
                    ),
                    selectInput("plot_type",
                                "Plot type",
                                choices = plot_types,
                                selected = plot_types[2]
                    ),
                    conditionalPanel( condition = "input.plot_type=='ts'",
                                      checkboxInput("overlayCities", "Overlay cities", value=FALSE)),

                    uiOutput("selectInputTarget"),
                    uiOutput("selectInputScale"),
                    downloadButton("download_csv", "Download (.csv)"),
                    downloadButton("download_rds", "Download (.rds)"),

                ),
                # Show a plot of the generated distribution
                mainPanel(
                   width=10,
                   plotOutput("meas_plot", height = 800)
                )
            )
        ),

        tabPanel("Exceedances", fluid = TRUE,
             sidebarLayout(
                 sidebarPanel(
                     width = 2,
                     selectInput("exc_country",
                                 "Country:",
                                 choices = unique(locations$country),
                                 multiple=T,
                                 selected = "IN"
                     ),
                     uiOutput("selectInputExcCity"),


                     sliderInput("exc_year",
                                 "Year:",
                                 min=2015, max=2020, value=2020, sep="", step=1, ticks = F
                     ),

                     pickerInput("exc_status",
                                 "Status",
                                 choices = exc_status_labels,
                                 options = list(`actions-box` = TRUE,
                                                `selected-text-format` = "count > 3"),
                                 multiple = T,
                                 selected = exc_status_labels),

                     pickerInput("exc_poll",
                                 "Pollutant",
                                 choices = polls,
                                 options = list(`actions-box` = TRUE,
                                                `selected-text-format` = "count > 3"),
                                 multiple = T,
                                 selected = polls),

                     pickerInput("exc_aggregation_period",
                                 "Aggregation period:",
                                 choices = unique(standards$aggregation_period),
                                 options = list(`actions-box` = TRUE,
                                                `selected-text-format` = "count > 3"),
                                 multiple = T,
                                 selected = unique(standards$aggregation_period)
                     ),

                     pickerInput("exc_standard_org",
                                 "Standard source:",
                                 choices = unique(standards$organization),
                                 multiple = T,
                                 options = list(`actions-box` = TRUE),
                                 selected = c("EU","WHO","NAAQS")
                     ),
                     downloadButton("exc_download_csv", "Download (.csv)"),
                     downloadButton("exc_download_rds", "Download (.rds)")

                 ),

                 mainPanel(
                     width=10,
                    # plotOutput("exc_status_map"),
                    # DT::dataTableOutput("exc_status_table")
                    DT::dataTableOutput("exc_table")
                 )
            )
        )
    )
)
