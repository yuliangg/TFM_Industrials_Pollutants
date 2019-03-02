library(readr)
require(xlsx)
library(dplyr)

### GEOLOCALIZAR MUNICPIOS
#Cargar fichero defuncioneas compelto 2012 a 1015
DfDefuncionesCompleto <- read.csv('../data/Deaths/DfDefuncionesSinGeo.csv', 
                                  sep = ';',
                                  row.names = NULL)

#Eliminamos las filas sin municipio en el fichero Defunciones, 
#INE este dato para municipios menores de 100000 habitantes 
DfDefuncionesCompleto <- subset(DfDefuncionesCompleto,!is.na(MunicipioReside))

head(DfDefuncionesCompleto)
summary.data.frame(DfDefuncionesCompleto)
View(DfDefuncionesCompleto)

# Fichero municipios con geolocalización
# install.packages("xlsx")
DfgeolocalizacionMunicipios <- read.xlsx('../data/Deaths/listado-longitud-latitud-municipios-espana.xls' 
                                         , sheetIndex = 1, as.data.frame = TRUE)

View(DfgeolocalizacionMunicipios)

# Fichero códigos de municipio y provincias
DfCodigoMunicipios <- read.xlsx('../data/Deaths/10codmun.xls' 
                                , sheetIndex = 1, as.data.frame = TRUE)

# Elimina código de control provincia y convierte a numérico
DfCodigoMunicipios$CMUN <- substring(DfCodigoMunicipios$CMUN,1,3)
DfCodigoMunicipios <- transform(DfCodigoMunicipios, CPRO = as.numeric(CPRO)) 

# DfCodigoMunicipios <- DfCodigoMunicipios[c('CPRO','CMUN','NOMBRE')]      
View(DfCodigoMunicipios)

DfCodigoProvincias <- read.xlsx('../data/Deaths/10codmun.xls' 
                                , sheetIndex = 2, as.data.frame = TRUE)

View(DfCodigoProvincias)

#recuperamos los códigos de provincia y municipio a partir del nombre
#para poder cruzar con fichero defunciones
DfgeolocalizacionMunicipios <- DfgeolocalizacionMunicipios %>% 
  merge(y=DfCodigoProvincias, 
        by.x = "Provincia", by.y = "nompro", 
        all.x = TRUE ) 

DfgeolocalizacionMunicipios <- DfgeolocalizacionMunicipios %>% 
  merge(y=DfCodigoMunicipios, 
        by.x = c("codpr","Población"), by.y = c("CPRO", "NOMBRE"), 
        all.x = TRUE ) 

DfgeolocalizacionMunicipios$codpostal <-paste(DfgeolocalizacionMunicipios$codpr,DfgeolocalizacionMunicipios$CMUN,sep="") 
DfgeolocalizacionMunicipios <- transform(DfgeolocalizacionMunicipios, CMUN = as.numeric(CMUN)) 
DfgeolocalizacionMunicipios <- transform(DfgeolocalizacionMunicipios, codpostal = as.numeric(codpostal)) 

### Guardar fichero de municipios y geolocalización para utilizar en complejos NA
write.table(DfgeolocalizacionMunicipios, file = "../data/Deaths/MunicipiosGeolocalizados.csv", 
            append = FALSE, sep = ';',
            row.names = FALSE) 

summary(DfgeolocalizacionMunicipios)
View(DfgeolocalizacionMunicipios)

### geolocalizar fichero Defunciones
DfDefuncionesCompleto <- DfDefuncionesCompleto %>% 
  merge(y=DfgeolocalizacionMunicipios, 
        by.x = c("ProvinciaReside","MunicipioReside"), by.y = c("codpr", "CMUN"), 
        all.x = TRUE ) 

# Summary.data.frame(DfDefuncionesCompleto)
View(DfDefuncionesCompleto)

# Guardar fichero defunciones geolocalizado
write.table(DfDefuncionesCompleto, file = "../data/Deaths/DfDefuncionesGeo.csv", 
            append = FALSE, sep = ';',
            row.names = FALSE) 
