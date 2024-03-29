#'@title OSF updating

#' @description This function allows you to download and upload files directly from and to your remote OSF repository

#' @param project an osf_tbl object of the project
#' @param component the component in which files should be accessed from
#' @param type if "download" then all files on osf are downloaded ,if "upload",
#' @param files name of files to be uploaded to OSF; these could names of the file in the working directory or paths
#' @param overwrite logical argument specifying whether files should be overwritten

#' @import dplyr
#' @import here
#' @import mapview
#' @import osfr

#' @examples
#' project <- osf_setup(project_ID = "osf_setup")
#' osf_updating(project = project, component = "Data", type = 'download')

#' @export

osf_updating <- function(project, component, type = c('download','upload'), files = c('outdata','rawdata','tabular_shapefiles'), overwrite = TRUE){

  #Handling conflicts
  conf <- ifelse(overwrite == TRUE, 'overwrite', 'error')

  #Downloading
  if(type == 'download'){

    project%>%
      osfr::osf_ls_nodes()%>%
      dplyr::filter(name == component)%>%
      osfr::osf_ls_files()%>%
      osfr::osf_download(conflicts = conf, recurse = TRUE)

  }
  #Uploading
  else if(type == 'upload'){

    project%>%
      osfr::osf_ls_nodes()%>%
      dplyr::filter(name == component)%>%
      osfr::osf_upload(path = files, conflicts = conf, recurse = TRUE)

  }
  #Error message
  else{
    stop("type must be either download or upload")
  }


}

