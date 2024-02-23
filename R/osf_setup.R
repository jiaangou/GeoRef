#'@title OSF setup

#' @param project_ID a character string specifying the OSF identifier of the project
#' @param PAT OSF personal access token

#' @examples
#' project <- osf_setup(project_ID = "osf_setup")

#' @export



osf_setup <- function(project_ID, PAT = NULL){

  #Check argument
  if (!is.character(project_ID)) {
    stop("project_ID must be a character string.")
  }

  #Authenticate
  if(is.null(PAT)){

    pat <- readline(prompt = "Enter Personal Access Token (PAT):")
    osfr::osf_auth(pat)

  }else{
    osfr::osf_auth(PAT)
  }

  #Retrieve project info
  project <- osfr::osf_retrieve_node(project_ID)


  #Return project as an osf_tbl
  return(project)

}

