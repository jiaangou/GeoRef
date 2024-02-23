#' @title Subsetting polygons from shape files
#'
#' @param sf_object an sf object containing information of your shapefile
#' @param type the type of spatial information of your sf object; currently includes Parks, Watershed, and Cities
#' @param polygon_name the names of polygons in which you want to subset; if none included then the whole sf object is returned
#' @param view a logical arugment in which to specify whether the data should be visualized on a map

#' @import dplyr
#' @import sf
#' @import mapview


#' @return if view == TRUE, then a map of the polygons is returned. Otherwise an sf object is returned containing a subset of the original polygons

#' @examples
#' census <- here::here("tabular_shapefiles/KML_SHP/CensusSubdivisions_lcsd000b16a_e.shp")%>%
#' sf::st_read()
#' polygons <- census$CSDNAME%>%
#' sample(10)
#' subset_polygons(census, type = 'Cities', polygon_name = polygons, view = TRUE)





subset_polygons <- function(sf_object, type = c('Parks', 'Watershed', 'Cities'), polygon_name = NULL, view = FALSE){

  #Filter if names are supplied
  if (!is.null(polygon_name) || length(polygon_name) != 0) {

    if (type == "Parks"){

      sf_object <- sf_object%>%
        filter(Name %in% polygon_name)

    } else if (type == "Watershed"){

      sf_object <- sf_object%>%
        filter(NOM %in% polygon_name)

    } else {

      sf_object <- sf_object%>%
        filter(CSDNAME %in% polygon_name)

    }

  }

  #View
  if(view == TRUE){
    sf_object%>%
      sf::st_zm()%>%
      mapview::mapview()

  }

  #Return feature otherwise
  else{

    return(sf_object)
  }
}
