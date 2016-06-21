; Definición del primer fichero que se va a leer
(deffacts readAnalisis
  (ReadAnalisis "Datos/Analisis.txt")
)

; Regla con una alta prioridad para leer el fichero con el análisis
(defrule openAnalisis
  (declare (salience 50))
  (ReadAnalisis ?NameFile)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo))
)

; Lectura del fichero con el análisis y dotación de forma en templates
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

; Cierre del fichero de análisis
(defrule closeFile
  (declare (salience 48))
  ?f <- (ReadAnalisis ?NameFile)
  =>
  (close mydata)
  (retract ?f)
  (assert (ReadSectores "Datos/AnalisisSectores.txt"))
)

; Lectura del análisis de los sectores
(defrule openSectores
  (declare (salience 47))
  (ReadSectores ?NameFile)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo))
)

; Lectura del análisis de los sectores y dotación de forma
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

; Cierre del fichero de sectores
(defrule closefileSectores
  (declare (salience 45))
  ?f <- (ReadSectores ?NameFile)
  =>
  (close mydata)
  (retract ?f)
  (assert (ReadNoticias "Datos/Noticias.txt"))
)

; Lectura de Noticias
(defrule openNoticias
  (declare (salience 44))
  (ReadNoticias ?NameFile)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo))
)

; Lectura de las noticias y dotación de forma
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

; Cierre del archivo de noticias
(defrule closefileNoticias
  (declare (salience 42))
  ?f <- (ReadNoticias ?NameFile)
  =>
  (close mydata)
  (retract ?f)
  (assert (ReadCartera "Datos/Cartera.txt"))
)

; Lectura de Cartera
(defrule openCartera
  (declare (salience 41))
  (ReadCartera ?NameFile)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo))
)

; Lectura de los valores en la cartera y dotación de forma
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

; Estimación del rendimiento por año
(defrule RPA
  ?mod <- (Valor
    (Nombre ?Nombre)
    (RPA 'NA')
    (RPD ?RPD)
    (VarAnual ?VarAnual)
    (VarSem ?VarSem)
    (VarTri ?VarTri))
  =>
  (bind ?RPA (+ (* 100 ?RPD) (max ?VarAnual ?VarSem ?VarTri)))
  (modify ?mod (RPA ?RPA))

)

; Cierre del archivo de la cartera y entrada en el módulo 0
(defrule closefileCartera
  (declare (salience 39))
  ?f <- (ReadCartera ?NameFile)
  =>
  (close mydata)
  (retract ?f)
  (assert (Modulo Modulo0))
)
