###########################################################
# AUTOMATION DATA LOADING PROCCESSING FROM URL 
# Estatal de Emisiones y Fuentes Contaminantes (P.R.T.R)
###########################################################

###########################################################
#------ DATA LOADING INDUSTRIAL COMPLEXES-----------
###########################################################

#Donwloading the Industrial Complexes from PRTR
download.file(url = "http://www.prtr-es.es/informes/descargas/PRTR_Espana_MAPAMA_Complejos.zip",
              destfile = "./data/zip/PRTR_Espana_MAPAMA_Complejos.zip",
              method = "auto")
unzip("./data/zip/PRTR_Espana_MAPAMA_Complejos.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = "./data/Industry", unzip = "internal",
      setTimes = FALSE)


###########################################################
#-------EMISSIONS DATA LOADING----------------------------
###########################################################

#Data available from 2001 to 2016
for(i in 2001:2016){
  download.file(url=paste("http://www.prtr-es.es/informes/descargas/PRTR_Espana_MAPAMA_emisiones", i, ".zip", sep=""), 
                destfile=paste("data/zip/PRTR_Espana_MAPAMA_emisiones", i, ".zip", sep="") ,method = "auto")
  unzip(paste("./data/zip/PRTR_Espana_MAPAMA_emisiones", i ,".zip", sep=""), files = NULL, list = FALSE, overwrite = TRUE,
        junkpaths = FALSE, exdir = "./data/Emissions", unzip = "internal",
        setTimes = FALSE)
}

