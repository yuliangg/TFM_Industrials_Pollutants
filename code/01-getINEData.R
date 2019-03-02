#########################################################################################
#
# --------------DATOS DEFUNCIONES POBLACIÓN ESPAÑOLA 2012-2015---------------------------
# ESTOS DATOS ESTÁN SUJETOS A RESTRICCIONES DE CONFIDENCIALIDAD BAJO CONTRATO CON EL INE
# ficheros proporcionados por INE con causa de muerte informada
#
#########################################################################################

#Instalación de las librerias necesarias para el proyecto
if(!require("readxl")){
  install.packages("readxl")
  library("readxl")
}
if(!require("readr")){
  install.packages("readr")
  library("readr")
}

unzip("./data/Deaths/fichero_anonimizado_defunciones_2012_estudios.zip", exdir = "./data/Deaths")
unzip("./data/Deaths/fichero_anonimizado_defunciones_2013_estudios.zip", exdir = "./data/Deaths")
unzip("./data/Deaths/fichero_anonimizado_defunciones_2014_estudios.zip", exdir = "./data/Deaths")
unzip("./data/Deaths/fichero_anonimizado_defunciones_2015_estudios.zip", exdir = "./data/Deaths")


#FUNCION PARA FORMATEAR FICHEROS ENTRADA Y CREAR DF
Df <- function (FDefunciones)
         data.frame(
                ProvinciaInscri= substr(FDefunciones, 1, 2),  
                MunicipioInscri= substr(FDefunciones, 3, 5),
                MesNacimiento  = substr(FDefunciones, 6, 7),
                AnioNacimiento = substr(FDefunciones, 8, 11),
                Sexo           = substr(FDefunciones, 12, 12),
                MesDefuncion   = substr(FDefunciones, 13, 14),
                AnioDefuncion  = substr(FDefunciones, 15, 18),
                Nacionalidad   = substr(FDefunciones, 19, 19),
                PaisNacimiento = substr(FDefunciones, 20, 22),
                LugarNacimiento= substr(FDefunciones, 23, 23),
                ProvNacimiento = substr(FDefunciones, 24, 25),
                MunicipioNacimi= substr(FDefunciones, 26, 28),
                PaisNacimiento = substr(FDefunciones, 29, 31),
                LugarResidencia= substr(FDefunciones, 32, 32),
                ProvinciaReside= substr(FDefunciones, 33, 34),
                MunicipioReside= substr(FDefunciones, 35, 37),
                PaisResidencia = substr(FDefunciones, 38, 40),
                EstadoCivil    = substr(FDefunciones, 41, 41),
                Ocupacion      = substr(FDefunciones, 42, 43),
                AnioCumplidos  = substr(FDefunciones, 44, 46),
                MesesCumplidos = substr(FDefunciones, 47, 48),
                DiasCunmplidos = substr(FDefunciones, 49, 50),
                TamanioMuniInsc= substr(FDefunciones, 51, 51),
                TamanioMuniNaci= substr(FDefunciones, 52, 52),
                TamanioMuniResi= substr(FDefunciones, 53, 53),
                TamanioPaisNaci= substr(FDefunciones, 54, 54),
                TamanioPaisResi= substr(FDefunciones, 55, 55),
                TamanioPaisNdad= substr(FDefunciones, 56, 56),
                CausaMuertebas1= substr(FDefunciones, 57, 57),
                CausaMuertebas2= substr(FDefunciones, 58, 58),
                CausaMuertebas3= substr(FDefunciones, 59, 59),
                CausaMuertebas4= substr(FDefunciones, 60, 60),
                CausaMortaReduc= substr(FDefunciones, 61, 63),
                CausaMortaperin= substr(FDefunciones, 64, 65),
                CausaMortaInfan= substr(FDefunciones, 66, 67),
                NivelEstudios  = substr(FDefunciones, 68, 69)
                )


#LEER, FORMATEAR Y ESCRIBIR FICHEROS EN .CSV
FDefunciones <- readLines('./data/Deaths/fichero_anonimizado_defunciones_2012_estudios.txt')
DfDefunciones <- Df(FDefunciones)
write.table(DfDefunciones, file = "./data/Deaths/DfDefuncionesSinGeo.csv", 
            append = FALSE, sep = ';',
            row.names = FALSE) 

FDefunciones <- readLines('./data/Deaths/fichero_anonimizado_defunciones_2013_estudios.txt')
DfDefunciones <- Df(FDefunciones)
write.table(DfDefunciones, file = "./data/Deaths/DfDefuncionesSinGeo.csv", 
            append = TRUE, 
            sep = ';',
            row.names = FALSE,
            col.names = FALSE ) #eliminamos nombre de columnas

FDefunciones <- readLines('./data/Deaths/fichero_anonimizado_defunciones_2014_estudios.txt')
DfDefunciones <- Df(FDefunciones)
write.table(DfDefunciones, file = "./data/Deaths/DfDefuncionesSinGeo.csv", 
            append = TRUE, 
            sep = ';',
            row.names = FALSE,
            col.names = FALSE ) #eliminamos nombre de columnas

FDefunciones <- readLines('./data/Deaths/defunciones_anonimizado_2015.txt')
DfDefunciones <- Df(FDefunciones)
write.table(DfDefunciones, file = "./data/Deaths/DfDefuncionesSinGeo.csv", 
            append = TRUE, 
            sep = ';',
            row.names = FALSE,
            col.names = FALSE ) #eliminamos nombre de columnas
