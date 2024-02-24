#' @title Constructing convex hulls

#' @description Studies that uses multiple coordinates to specifies its spatial extent can be aggregated by combining these coordinates into a single polygon described by the convex hull of these points. This function takes in data containing coordinate information and a grouping variable and computes a convex hull for each group.

#' @param data a tabular data that contains Lat/Long coordinate information
#' @param group the grouping variable in data that should be used to compute convex hulls
#' @param crs the coordinate system that data should be projected onto

#' @import dplyr
#' @import rlang
#' @import sf
#' @import purrr
#' @import tidyr

#' @return a grouped tibble with grouping variable, nested version of original data, and respective convex hull geometry information

#' @examples convex_hull(data = data, group = 'group')

convex_hull <- function(data, group, crs = 4269){

  g_sym <- rlang::ensym(group) # Ensure g is treated as a symbol

  #Project data
  project <- sf::st_as_sf(data, coords = c("Longitude", "Latitude"), crs = crs)

  #Nest data by group and calcuate convex hull by group
  out <- project%>%
    dplyr::group_by(!!g_sym) %>% # Dynamically group by the specified variable
    tidyr::nest()%>%
    mutate(ConvexHull = purrr::map(data, function(x)x%>%
                                     sf::st_union()%>%
                                     sf::st_convex_hull()))


  return(out)

}