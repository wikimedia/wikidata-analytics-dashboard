## Quick start

Install System Dependencies (Ubuntu):
```
apt-get install libcurl4-openssl-dev
apt-get install libxml2-dev
```

Install the R dependencies:
=======
### Install R:

(Find instructions at https://cran.r-project.org/ for your OS)

### Install the dependencies:

```
$ R
> install.packages(c("curl", "stringi", "httpuv", "readr", "xts", "reshape2",
    "RColorBrewer", "shiny", "shinydashboard", "dygraphs", "markdown",
    "ggplot2", "toOrdinal", "plyr", "lubridate", "magrittr", "data.table", "XML", "DT"))
```

#### Install Oracle 8 JRE:

##### Ubuntu

```
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get update
apt-get install oracle-java8-installer
exit
```

##### Windows

Download from Oracle:
http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html

#### Configure R to use JRE:

```
R CMD javareconf
```

Note: this may not work and may not be needed for Windows

#### Install rJava:

```
$ R
> install.packages("rJava")
```

#### Download rrdf and rrdflibs from CRAN:

 - https://cran.r-project.org/src/contrib/Archive/rrdf/rrdf_2.0.2.tar.gz
 - https://cran.r-project.org/src/contrib/Archive/rrdflibs/rrdflibs_1.3.0.tar.gz

#### Install rrdflibs and rrdf:

```
R CMD INSTALL rrdflibs_1.3.0.tar.gz
R CMD INSTALL rrdf_2.0.2.tar.gz
```

#### Run the server:

```
$ R
> library(shiny)
> runApp(launch.browser = 0)
```
