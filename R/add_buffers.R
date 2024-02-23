#' @title Adding buffers to point-only data

#' @param data a tabular data that contains covariates and spatial informationf
#'
#' @param crs Coordinate Reference System used for projection
#' @param buffer_radius radius in meters in which to create buffers
#' @param file_name the filename in which the exported object will be; if NULL then nothing is exported
#' @param view a logical argument to specify whether the resulting data should be visualized
#' @param output_dir directory name in which to export the file; "outdata" is set as the default

#' @examples
#' geo_data <- read_csv("my-spatial_data.csv")
#' add_buffers(data = geo_data, buffer_radius = 50000, view = TRUE)

#' @import dplyr
#' @import here
#' @import sf
#' @import mapview


add_buffers <- function(data, crs = 4269, buffer_radius = 500, file_name = NULL, view = FALSE, output_dir = "outdata"){

  #buffer_radius units are usually in meters but can depend on CRS
  #file_name is the filename to export the output, if NULL then no file is exported
  #view plots the buffers using mapview for visual inspection


  projected_data <- sf::st_as_sf(data, coords = c("Longitude", "Latitude"), crs = crs)
  buffers <- sf::st_buffer(projected_data, buffer_radius)

  if(view == TRUE){

    buffers%>%
      dplyr::select(geometry)%>%
      mapview::mapview()

  }else{

    out <- buffers%>%
      dplyr::select(ID, geometry)

    if(!is.null(file_name)){

      if(!is.character(file_name)){
        stop("file_name must be a charcater string")

      }
      #output directory
      out_dir <- paste0(here::here(output_dir), "/", file_name)

      #Write file
      sf::st_write(out, out_dir, driver = "ESRI Shapefile", append = FALSE)

    }else{

      #return buffers
      return(out)
    }

  }

}






