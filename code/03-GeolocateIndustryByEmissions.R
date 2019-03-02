############################################################################
##############  COMPLEJOS INDUSTRIALES Y EMISIONES #########################
############################################################################

#Instalación de las librerias necesarias para el proyecto
if(!require("XML")){
  install.packages("XML")
  library("XML")
}
if(!require("jpeg")){
  install.packages("jpeg")
  library("jpeg")
}
if(!require("devtools")){
  install.packages("devtools")
  library("devtools")
}
if(!require("ggmap")){
  install.packages("ggmap")
  library("ggmap")
}
if(!require("dplyr")){
  install.packages("dplyr")
  library("dplyr")
}
if(!require("tidyr")){
  install.packages("tidyr")
  library("tidyr")
}


#########################################################################
##### 1. Bloque de lectura y conversión ficheros XML ####################
#########################################################################

path_Complejos <- "./data/Industry/PRTR_Espana_MAPAMA_Complejos.xml"
path_Emisiones2001 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2001.xml")
path_Emisiones2002 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2002.xml")
path_Emisiones2003 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2003.xml")
path_Emisiones2004 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2004.xml")
path_Emisiones2005 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2005.xml")
path_Emisiones2006 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2006.xml")
path_Emisiones2007 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2007.xml")
path_Emisiones2008 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2008.xml")
path_Emisiones2009 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2009.xml")
path_Emisiones2010 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2010.xml")
path_Emisiones2011 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2011.xml")
path_Emisiones2012 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2012.xml")
path_Emisiones2013 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2013.xml")
path_Emisiones2014 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2014.xml")
path_Emisiones2015 <- paste0("./data/Emissions/PRTR_Espana_MARM_Emisiones2015.xml")


complejos_df=xmlToDataFrame(path_Complejos,stringsAsFactors = FALSE)
emisiones2001_df = xmlToDataFrame(path_Emisiones2001, stringsAsFactors=FALSE)
emisiones2002_df = xmlToDataFrame(path_Emisiones2002, stringsAsFactors=FALSE)
emisiones2003_df = xmlToDataFrame(path_Emisiones2003, stringsAsFactors=FALSE)
emisiones2004_df = xmlToDataFrame(path_Emisiones2004, stringsAsFactors=FALSE)
emisiones2005_df = xmlToDataFrame(path_Emisiones2005, stringsAsFactors=FALSE)
emisiones2006_df = xmlToDataFrame(path_Emisiones2006, stringsAsFactors=FALSE)
emisiones2007_df = xmlToDataFrame(path_Emisiones2007, stringsAsFactors=FALSE)
emisiones2008_df = xmlToDataFrame(path_Emisiones2008, stringsAsFactors=FALSE)
emisiones2009_df = xmlToDataFrame(path_Emisiones2009, stringsAsFactors=FALSE)
emisiones2010_df = xmlToDataFrame(path_Emisiones2010, stringsAsFactors=FALSE)
emisiones2011_df = xmlToDataFrame(path_Emisiones2011, stringsAsFactors=FALSE)
emisiones2012_df = xmlToDataFrame(path_Emisiones2012, stringsAsFactors=FALSE)
emisiones2013_df = xmlToDataFrame(path_Emisiones2013, stringsAsFactors=FALSE)
emisiones2014_df = xmlToDataFrame(path_Emisiones2014, stringsAsFactors=FALSE)
emisiones2015_df = xmlToDataFrame(path_Emisiones2015, stringsAsFactors=FALSE)


#########################################################################
##### 2. Bloque de unión de Dataframes  #################################
#########################################################################

# Generamos el dataframe total de emisiones.
totalEmi_df <- rbind (emisiones2001_df,emisiones2002_df,emisiones2003_df,
                      emisiones2004_df,emisiones2005_df, emisiones2006_df,
                      emisiones2007_df, emisiones2008_df, emisiones2009_df,
                      emisiones2010_df, emisiones2011_df, emisiones2012_df,
                      emisiones2013_df, emisiones2014_df, emisiones2015_df)

# Visualizamos el resultado.
View (totalEmi_df)

# Realizamos un merge entre el dataframe de Emisiones total y los Complejos.
# por el Código de industria PRTR. Sólo nos quedaremos con los complejos que figuren en el 
# listado de emisiones entre los años 2.001 y 2015 y hayan emitido a la atmosfera contaminanes.
comByEmi_df <- merge(x = totalEmi_df, y = complejos_df, by = "CodigoPRTR", all.x = TRUE)

# Seleccionamos sólo del dataframe resultado las columnas por las que nos interesa
# geocodificar más adelante y poder filtrar por elementos únicos.
comByEmiFil_df <- unique(subset(comByEmi_df, select = c("CodigoPRTR", 'EmpresaMatriz','ActividadEconomica','Direccion', 'Municipio', 'Provincia')))

# Generamos de nuevo el índice para geocodificar mas facilmente.
row.names(comByEmiFil_df) <- NULL


#########################################################################
##### 3. Bloque de revisión basica del dataset ##########################
#########################################################################

#Revisamos el dataframe:
str(comByEmiFil_df)

head(comByEmiFil_df)

summary(comByEmiFil_df)

#Visualizamos el numero de filas
nrow(comByEmiFil_df)

#Visualizamos los nombres de las columnas, vemos que podemos unificar por el código PRTR...
names (comByEmiFil_df)

# Viewing the dataframe
View (comByEmiFil_df)


##########################################################################
#### 4. Bloque tratamiento datos del dataframe Complejos Industriales ####
##########################################################################

# Tratamos la columna Direccion para la geocodificación posterior.
for (i in 1:nrow(comByEmiFil_df)){
  valor <- gsub('["]', "", as.character(comByEmiFil_df[i,"Direccion"]))
  valor2 <- gsub("[,();:\\]"," ", valor)
  valor3 <- gsub("L·", "", valor2)
  print (paste0("insertamos valor....", trimws(valor3)))
  comByEmiFil_df[i,"Direccion"] <- trimws(valor3)
}

# Añadimos dos nuevas columnas con "tidyr" unión de Nombre del complejo o Actividad Económica
# Dirección, Municipio y Provincia para geolocalizar por una u otra dirección.
comByEmiFil_df <- unite(comByEmiFil_df, Dir_Codifi_1, c('ActividadEconomica','Direccion', 'Municipio', 'Provincia'), sep=",", remove = FALSE)
comByEmiFil_df <- unite(comByEmiFil_df, Dir_Codifi_2, c('EmpresaMatriz','Direccion', 'Municipio', 'Provincia'), sep=",", remove = FALSE)

# Volvemos a visualizar el resultado del dataframe, con las nuevas columnas.
View(comByEmiFil_df)

#########################################################################
####### 5. Bloque de geocodificación de los complejos  ##################
#########################################################################

# Para hacer pruebas tratamos solo unas filas del dataframe, utilizamos "dplyr"
#ubicaciones <- complejos_by_emisiones_df %>% select(Dir_Codifi_1, Dir_Codifi_2)

# Añadimos las columnas latitud y longitud para almacenar los pares de valores.
comByEmiFil_df$Latitud
comByEmiFil_df$Longitud 


# variable Pre-allocated intervalo de salida para luego escribir el csv temporal.
intervalo <- character(10)


### OJO: Aqui variamos el rango de Direcciones a geocodificar (2.500 maximo por día)

rangoFilas <- 1:2500

# Iteración para ir "Geocodificando" por la columna "Dir_Codifi_1" o "Dir_Codifi_2" e ir añadiendo
# Latitud y Longitud al dataframe comByEmiFil_df.
# Caso de que alguna de las dos Direcciones no devuelva resultado genera NA.

for (i in rangoFilas){
  print(i)
  intervalo <- paste0(as.character(min(rangoFilas)), "-", as.character(max(rangoFilas)))
  dc1 <- comByEmiFil_df[i, "Dir_Codifi_1"]
  dc2 <- comByEmiFil_df[i, "Dir_Codifi_2"]
  
  # Realizamos la primera llamada geocode por la dirección primera..
  lonlat <-  geocode(dc1)
  if (!is.na(lonlat[1]) || !is.na(lonlat[2])){
    print("Geocodificamos por la Dirección 1...")
    print(dc1)
    lon = as.numeric(lonlat[1])
    lat = as.numeric(lonlat[2])
    print(lon)
    print(lat)
    comByEmiFil_df[i,"Latitud"] <- lat
    comByEmiFil_df[i,"Longitud"] <- lon
  }
  else {
    print("Geocodificamos por la Dirección 2...")
    print(dc2)
    lonlat_dc2 <- geocode(dc2)
    lon= as.numeric(lonlat_dc2[1])
    lat = as.numeric(lonlat_dc2[2])
    print(lon)
    print(lat)
    comByEmiFil_df[i,"Latitud"] <- lat
    comByEmiFil_df[i,"Longitud"] <- lon
  }
}

# Seleccionamos sólo la selección de filas del dataframe comByEmiFil_df.
comByEmiSelection_df <- comByEmiFil_df[rangoFilas,]

View(comByEmiSelection_df)

#Vemos cuantas consultas quedan disponibles al API de google.
geocodeQueryCheck()

#####################################################################
##### 6. Bloque de generación de outputs y unión de ficheros ########
#####################################################################

# Generamos la ruta del fichero csv temporala guardar.
fichero <- paste0("./data/csv/Emissions/CompByEmissions_", intervalo, ".csv")

# Escribimos la salida a csv del dataframe com_by_emi_Selec, así haremos hasta llegar al 
# máximo de filas (complejos industriales)
write.csv(comByEmiSelection_df, file = fichero, sep=';')


# Concatenamos ficheros CSV temporales, generamos una función para ello, utilizamos Reduce.
multmerge = function(mypath){
  filenames=list.files(path=mypath, full.names=TRUE)
  print(filenames)
  datalist = lapply(filenames, function(x){read.csv2(file=x,header=T)})
  Reduce(function(x,y) {merge(x,y,all=TRUE)}, datalist)
}

#LLamamos a la función con la ruta y escribimos el CSV final.
mymergeddata = multmerge("./data/csv/Emissions/")
write.csv(mymergeddata, file="./data/csv/Emissions/Comp_by_Emi_total_short_unique.csv", row.names=FALSE, na="NA", append = FALSE, sep=';')

#######################################################################
##### 7. Bloque de reconstitución del dataframe y fichero final #######
#######################################################################

# Nota** En el bloque de geocodificación anterior hay complejos que no han podido ser georreferenciados
# por obtener NA en la llamada al API de google, estos se tratan por separado manualmente y 
# se añaden al fichero csv. Igualmente se tratan las coordenadas erróneas.

# Reconstituimos el dataframe final de Emisiones por Complejos Geocodificados realizando un merge.
compByEmiShortUnique_df <- read.csv("./data/csv/Emissions/Comp_by_Emi_total_short_unique.csv", sep=";")

comByEmiTotal_df <- merge(x = comByEmi_df, y = compByEmiShortUnique_df, by = "CodigoPRTR", all.x = TRUE)

View(comByEmiTotal_df)

# Escribimos el CSV final de Emisiones por Complejos Geocodificados. Este fichero será el utilizado en la 
# fase de análisis posterior.
write.csv(comByEmiTotal_df, file="./data/csv/Emissions/Comp_by_Emi_total_Geo_2001-2015.csv", row.names=FALSE, na="NA", append = FALSE, sep=';')


