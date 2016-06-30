; ------------------------------------
; FICHERO CON LAS REGLAS Y HECHOS PARA REALIZAR
; LA LECTURA DE LOS DATOS DE ENTRADA
; ------------------------------------

; Declaración del nombre del fichero de Análisis para su lectura
(deffacts readAnalisis
  (ReadAnalisis "Datos/Analisis.txt")
)

; Apertura e inicio de la lectura del fichero Análisis
(defrule openAnalisis
  (declare (salience 50))
  (ReadAnalisis ?NameFile)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo))
)

; Lectura del fichero Análisis y dotación de forma según el template Valor
(defrule readingAnalisis
  (declare (salience 49))
  (ReadAnalisis ?NameFile)
  ?f <- (SeguirLeyendo)
  =>
  (bind ?Name (read mydata))
  (retract ?f)
  (if (neq ?Name EOF) then
    (assert (Valor
      (Nombre ?Name)
      (Precio (read mydata))
      (VarDia (read mydata))
      (Capitalizacion (read mydata))
      (PER (read mydata))
      (RPD (read mydata))
      (Tamano (read mydata))
      (PorcIbex (read mydata))
      (EtiqPER (read mydata))
      (EtiqRPD (read mydata))
      (Sector (read mydata))
      (Var5Dias (read mydata))
      (Perd3Consec (read mydata))
      (Perd5Consec (read mydata))
      (VarRespSector5Dias (read mydata))
      (PerdRespSectorGrande (read mydata))
      (VarMes (read mydata))
      (VarTri (read mydata))
      (VarSem (read mydata))
      (VarAnual (read mydata))
      )
    )
    (assert (SeguirLeyendo)))
)

; Cierre del fichero Análisis
(defrule closeFile
  (declare (salience 48))
  ?f <- (ReadAnalisis ?NameFile)
  =>
  (close mydata)
  (retract ?f)
  (assert (ReadSectores "Datos/AnalisisSectores.txt"))
)

; Apertura e inicio de la lectura del fichero AnálisisSectores
(defrule openSectores
  (declare (salience 47))
  (ReadSectores ?NameFile)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo))
)

; Lectura del fichero AnálisisSectores y dotación de forma según el template Sector
(defrule readingSectores
  (declare (salience 46))
  (ReadSectores ?NameFile)
  ?f <- (SeguirLeyendo)
  =>
  (bind ?Name (read mydata))
  (retract ?f)
  (if (neq ?Name EOF) then
    (assert (Sector
      (Nombre ?Name)
      (VarDia (read mydata))
      (Capitalizacion (read mydata))
      (PER (read mydata))
      (RPD (read mydata))
      (PorcIbex (read mydata))
      (Var5Dias (read mydata))
      (Perd3Consec (read mydata))
      (Perd5Consec (read mydata))
      (VarMes (read mydata))
      (VarTri (read mydata))
      (VarSem (read mydata))
      (VarAnual (read mydata))
      )
    )
    (assert (SeguirLeyendo)))
)

; Cierre del fichero AnálisisSectores
(defrule closefileSectores
  (declare (salience 45))
  ?f <- (ReadSectores ?NameFile)
  =>
  (close mydata)
  (retract ?f)
  (assert (ReadNoticias "Datos/Noticias.txt"))
)

; Apertura e inicio de la lectura del fichero Noticias
(defrule openNoticias
  (declare (salience 44))
  (ReadNoticias ?NameFile)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo))
)

; Lectura del fichero Noticias y dotación de forma según el template Noticia
(defrule readingNoticias
  (declare (salience 43))
  (ReadNoticias ?NameFile)
  ?f <- (SeguirLeyendo)
  =>
  (bind ?Name (read mydata))
  (retract ?f)
  (if (neq ?Name EOF) then
    (assert (Noticia
      (Nombre ?Name)
      (Tipo (read mydata))
      (Antiguedad (read mydata)))
    )
    (assert (SeguirLeyendo)))
)

; Cierre del fichero Noticias
(defrule closefileNoticias
  (declare (salience 42))
  ?f <- (ReadNoticias ?NameFile)
  =>
  (close mydata)
  (retract ?f)
  (assert (ReadCartera "Datos/Cartera.txt"))
)

; Apertura e inicio de la lectura del fichero Cartera
(defrule openCartera
  (declare (salience 41))
  (ReadCartera ?NameFile)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo))
)

; Lectura del fichero Cartera y dotación de forma según el template Cartera
(defrule readingCartera
  (declare (salience 40))
  (ReadCartera ?NameFile)
  ?f <- (SeguirLeyendo)
  =>
  (bind ?Name (read mydata))
  (retract ?f)
  (if (neq ?Name EOF) then
    (assert (Cartera
      (Nombre ?Name)
      (Acciones (read mydata))
      (Valor (read mydata)))
    )
    (assert (SeguirLeyendo)))
)

; Cierre del fichero Cartera y entrada en el módulo 0
(defrule closefileCartera
  (declare (salience 39))
  ?f <- (ReadCartera ?NameFile)
  =>
  (close mydata)
  (assert (Modulo (Indice 0)))
  (retract ?f)
)
