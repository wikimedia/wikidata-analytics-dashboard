## Quick start

Install the dependencies:

```
$ R
> install.packages(c("curl", "httpuv", "readr", "xts", "reshape2",
    "RColorBrewer", "shiny", "shinydashboard", "dygraphs", "markdown",
    "ggplot2", "toOrdinal", "plyr", "lubridate", "magrittr"))
```

Run the server:

```
$ R
> library(shiny)
> runApp(launch.browser = 0)
```

