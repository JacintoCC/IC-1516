; Definición de los valores a leer
(deffacts readAnalisis
  (ReadAnalisis "Datos/Analisis.txt")
)

; Ejemplo Leer datos de un fichero, procesarlos y actualizarlos en el fichero (CLIPS)
(defrule openAnalisis
  (declare (salience 50))
  (ReadAnalisis ?NameFile)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo))
)

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

(defrule closeFile
  (declare (salience 48))
  ?f <- (ReadAnalisis ?NameFile)
  =>
  (close mydata)
  (retract ?f)
  (assert (ReadSectores "Datos/AnalisisSectores.txt"))
)

(defrule openSectores
  (declare (salience 47))
  (ReadSectores ?NameFile)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo))
)

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

(defrule closefileSectores
  (declare (salience 48))
  ?f <- (ReadSectores ?NameFile)
  =>
  (close mydata)
  (retract ?f)
  (assert (ReadNoticias "Datos/Noticias.txt"))
)

; Lectura de Noticias
(defrule openNoticias
  (declare (salience 45))
  (ReadNoticias ?NameFile)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo))
)

(defrule readingNoticias
  (declare (salience 44))
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

(defrule closefileNoticias
  (declare (salience 48))
  ?f <- (ReadNoticias ?NameFile)
  =>
  (close mydata)
  (retract ?f)
  (assert (ReadCartera "Datos/Cartera.txt"))
)

; Lectura de Cartera
(defrule openCartera
  (declare (salience 43))
  (ReadCartera ?NameFile)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo))
)

(defrule readingCartera
  (declare (salience 42))
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

(defrule closefileCartera
  (declare (salience 48))
  ?f <- (ReadCartera ?NameFile)
  =>
  (close mydata)
  (retract ?f)
)
