#'@title Adding buffers to point-only data

#' @param data a tabular data that contains covariates and spatial informationf
#' @param crs Coordinate Reference System used for projection
#' @param buffer_radius radius in meters in which to create buffers
#' @param file_name the filename in which the exported object will be; if NULL then nothing is exported
#' @param view a logical argument to specify whether the resulting data should be visualized
#' @param output_dir directory name in which to export the file; "outdata" is set as the default

#' @import dplyr
#' @import sf
#' @import mapview

spatial_statistics <- function(sf_object, map = FALSE){

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

  if(map == TRUE){
    mapview::mapview(ct)
  }else{
    return(out)

  }

}
