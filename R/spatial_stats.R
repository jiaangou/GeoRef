#'@title Calculating spatial statistics

#' @description The function takes in spatial information and calculates its area, centroid positions, and area bin class.

#' @param sf_object an sf object containing information of your shapefile
#' @param crs coordinate system in which Lat/Long coordinates are projected into
#' @param view a logical arugment specifying whether the processed data should be visualized on a map

#' @examples
#' spatial_statistics(sf_object)

#' @return if view == TRUE, then a map of data is returned. Otherwise a table of calculated statistics is returned

#' @import dplyr
#' @import sf
#' @import mapview
#' @import units
#' @import lwgeom

#' @export

spatial_stats <- function(sf_object, view = FALSE){

  #Turn spherical geometry off
  sf::sf_use_s2(FALSE)

  #Area
  Area <- sf::st_area(sf_object)


  #Centroids
  ct <- sf::st_centroid(sf_object)

  #Centroid cooridnates
  coordinates <- sf::st_coordinates(ct)%>%
    as.data.frame()%>%
    dplyr::rename(`Centroid_Latitude` = X)%>%
    dplyr::rename(`Centroid_Longitude` = Y)


  #Combine
  out <-  data.frame(Area_sqkm = units::set_units(Area, km^2))%>%
    dplyr::bind_cols(coordinates)%>%
    dplyr::mutate(Area_bin = case_when(
      Area_sqkm  < units::set_units(10, km^2) ~ '<10',
      Area_sqkm  < units::set_units(10^2, km^2) ~ '<10^2',
      Area_sqkm  < units::set_units(10^3, km^2) ~ '<10^3',
      Area_sqkm  < units::set_units(10^4, km^2) ~ '<10^4',
      Area_sqkm  < units::set_units(10^5, km^2) ~ '<10^5',
      TRUE ~ '10^6')
    )

  if(view == TRUE){
    mapview::mapview(ct)
  }else{
    return(out)

  }

}
