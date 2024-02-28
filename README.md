
# GeoRef <img src="man/figures/logo.png" align="right" height="200"/>

<!-- badges: start -->
<!-- badges: end -->

GeoRef is a workflow package for georeferencing biodiversity datasets. It includes useful functions for processing spatial data and includes functionalities for integrating with OSF. 

## Installation

You can install the development version of GeoRef from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jiaangou/GeoRef")
```

## Example

Below are some examples of how you might use each of the functions contained in the package:

**1. Linking with OSF**

- The `osf_setup()` function takes your OSF project ID and Personal Access Token as arguments and connects your current R session to your OSF project. This allows you to read and write directly through R 
``` r
library(GeoRef)
library(dplyr)
project_ID <- "mjvwh" #project ID
PAT_KEY = "#######" #Personal Access Token
project <- osf_setup(project_ID = project_ID, PAT = PAT_KEY) #Connection

```

**2. Downloading files from OSF**

- the `osf_updating()` function provides a way to download and upload files from and to your OSF repository. Direct read and write means no data files need to be stored on Github. 

``` r
osf_updating(project = project, component = "Data", type = 'download')

```
**3. Subsetting polygons**

- Sometime additional information are acquired from external sources, `subset_polygons()` provides a flexibe way to extract the relevant spatial information from these sources.
- Current version supports subsetting `Cities`, `Parks`, and `Watershed` shapefiles. Since the naming variable may differ between files, users may need to make small adjustments in the source code. 

``` r
#Read your shape file
shp_file <- read.csv("MyShapeFile.shp")%>%
sf::st_read()
#Visually inspect the subset of polygons selected with view = TRUE
subset_polygons(shp_file, type = 'Cities', polygon_name = names, view = TRUE)
#Store the subsetted data as a new variable with view = FALSE
shp_subset <- subset_polygons(shp_file, type = 'Cities', polygon_name = rand_names, view = FALSE)
```

**4. Adding buffers**

- Buffers can be added to point-only data (containing Lat/Long coordinate information) using the `add_buffers()` function. The buffer radius is specified in units of meters (m) and the resulting buffers can be visualized with `view = TRUE`.
- NOTE: there may be projection errors due to package incompatibilities which could generate erroneous buffers created (need resolving). Use with caution!

``` r
#Example coordinate data
cities <- data.frame(
    name = c("Toronto", "Montreal", "Vancouver", "Calgary", "Edmonton", "Ottawa"),
    Latitude = c(43.65107, 45.50884, 49.28273, 51.044733, 53.546124, 45.42153),
    Longitude = c(-79.347015, -73.58781, -123.120735, -114.071883, -113.493823, -75.697193))

add_buffers(cities, buffer_radius = 50000, view = TRUE)
```

**5. Creating new polygons from multiple coordinates **

- Certain data sets will contain only point-coordinates. To get a measure of spatial extent, we can use the `multiple_coordinates()` function to generate a polygon based on the convex hull of those point-coordinates. A grouping variable should be supplied here so that the function knows which points should belong in the same convex hull. 

```r
convexhull_polygons <- cities%>%
  mutate(group = rep(c(1,2), times = 3))%>% #Create a grouping variable named "group"
  GeoRef::multiple_coordinates(group = group)
```


**6. Calculating spatial statistics**

- Basic statistics (i.e., Centroid Latitude , Centroid Longitude,  Area (km$^2$), Area size class) of polygons can be calculated using the `spatial_stats()` function. 

``` r
convexhull_polygons$ConvexHull%>%
  lapply(function(x)GeoRef::spatial_stats(x))%>%
  bind_rows()

```




