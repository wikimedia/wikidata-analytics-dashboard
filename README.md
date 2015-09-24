## Quick start

Install the dependencies:

```
$ R
> install.packages(c("curl", "httpuv", "readr", "xts", "reshape2",
    "RColorBrewer", "shiny", "shinydashboard", "dygraphs", "markdown",
    "ggplot2", "toOrdinal", "plyr", "lubridate", "magrittr"))
```

Install RRDF Support:

Install Oracle 8 JRE:

```
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get update
apt-get install oracle-java8-installer
exit
```

then configure R to use it:
```
R CMD javareconf
```

Install rJava:
```
$ R
> install.packages("rJava")
```
Download rrdf and rrdflibs from CRAN:
```
wget https://cran.r-project.org/src/contrib/Archive/rrdf/rrdf_2.0.2.tar.gz
wget https://cran.r-project.org/src/contrib/Archive/rrdflibs/rrdflibs_1.3.0.tar.gz
```
Install rrdflibs and rrdf:
```
R CMD INSTALL rrdflibs_1.3.0.tar.gz
R CMD INSTALL rrdf_2.0.2.tar.gz
```

Run the server:

```
$ R
> library(shiny)
> runApp(launch.browser = 0)
```

