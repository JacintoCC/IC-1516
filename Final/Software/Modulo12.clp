; ------------------------------------
; FICHERO CON LAS REGLAS DE LOS MÓDULOS 1 Y 2: DETECCIÓN DE VALORES RELEVANTES
; ------------------------------------

; Regla para detectar los valores peligrosos inestables
(defrule DeteccionPeligrosoInestable
  (Modulo (Indice 1))
  (Cartera (Nombre ?Nombre))
  (Valor (Nombre ?Nombre) (Perd3Consec true))
  (Inestable ?Nombre ?Explicacion)
  =>
  (assert (Peligroso ?Nombre (str-cat "es inestable porque "
                                      ?Explicacion
                                      " y ha tenido pérdidas durante tres días")))
)

; Regla para detectar valores peligrosos
(defrule DeteccionPeligroso
  (Modulo (Indice 1))
  (Cartera (Nombre ?Nombre))
  (Valor (Nombre ?Nombre) (Perd5Consec true))
  (not (Inestable ?Nombre ?))
  =>
  (assert (Peligroso ?Nombre "ha tenido pérdidas durante cinco días"))
)

; Regla para salir del módulo 1
;   y entrar en el módulo 2
(defrule SalirModulo1
  (declare (salience -1))
  ?f <- (Modulo (Indice 1))
  =>
  (modify ?f (Indice 2))
)

; Regla general para detectar valores sobrevalorados
(defrule DeteccionSobrevaloradosGeneral
  (Modulo (Indice 2))
  (Valor (Nombre ?Nombre) (EtiqPER Alto) (EtiqRPD Bajo))
  (not (Sobrevalorado ?Nombre ?))
  =>
  (assert (Sobrevalorado ?Nombre " tiene un PER alto y un RPD bajo"))
)

; Regla para detectar sobrevalorados de tamaño pequeño
(defrule DeteccionSobrevaloradosPeq1
  (Modulo (Indice 2))
  (Valor (Nombre ?Nombre) (EtiqPER Alto) (Tamano PEQUENIA))
  (not (Sobrevalorado ?Nombre ?))
  =>
  (assert (Sobrevalorado ?Nombre " tiene un PER alto siendo pequeña"))
)

; Segunda regla para detectar sobrevalorados de tamaño pequeño
(defrule DeteccionSobrevaloradosPeq2
  (Modulo (Indice 2))
  (Valor (Nombre ?Nombre) (EtiqPER Mediano) (EtiqRPD Bajo) (Tamano PEQUENIA))
  =>
  (assert (Sobrevalorado ?Nombre " tiene un PER mediano y un RPD bajo siendo pequeña"))
)

; Regla para detectar sobrevalorados de tamaño grande
(defrule DeteccionSobrevaloradosGrande1
  (Modulo (Indice 2))
  (Valor (Nombre ?Nombre) (EtiqPER Mediano) (EtiqRPD Bajo) (Tamano GRANDE))
  =>
  (assert (Sobrevalorado ?Nombre " tiene un PER mediano y un RPD bajo siendo grande"))
)

; Segunda regla para detectar sobrevalorados de tamaño grande
(defrule DeteccionSobrevaloradosGrande2
  (Modulo (Indice 2))
  (Valor (Nombre ?Nombre) (EtiqPER Alto) (EtiqRPD Mediano) (Tamano GRANDE))
  =>
  (assert (Sobrevalorado ?Nombre " tiene un PER alto y un RPD mediano siendo grande"))
)

; Regla para detectar valores infravalorados
(defrule DeteccionInfravalorados1
  (Modulo (Indice 2))
  (Valor (Nombre ?Nombre) (EtiqPER Bajo) (EtiqRPD Alto))
  (not (Infravalorado ?Nombre ?))
  =>
  (assert (Infravalorado ?Nombre " tiene un PER bajo y un RPD Alto"))
)

; Segunda regla para detectar valores infravalorados
(defrule DeteccionInfravalorados2
  (Modulo (Indice 2))
  (Valor  (Nombre ?Nombre) (EtiqPER Bajo) (VarMes ?vmes) (VarTri ?vtri)
          (VarSem ?vsem) (VarAnual ?vanual))
  (not (Infravalorado ?Nombre ?))
  ; Ha bajado más de un 30% en el último año, semestre o trimestre
  (test (or (< ?vtri -30) (< ?vsem -30) (< ?vanual -30)))
  ; Está creciendo actualmente, pero no mucho
  (test (and (> ?vmes 0) (< ?vmes 10)))
  =>
  (assert (Infravalorado ?Nombre " la empresa ha caído en los últimos meses y ahora está subiendo y el PER es bajo"))
)

; Regla para detectar valores infravalorados de tamaño grande
(defrule DeteccionInfravalorados3
  (Modulo (Indice 2))
  (Valor (Nombre ?Nombre) (Tamano GRANDE) (EtiqRPD Alto) (EtiqPER Mediano)
          (Sector ?Sector) (Var5Dias ?Var5Dias) (VarRespSector5Dias ?VarSector))
  (test (> ?Var5Dias 0))
  (test (> ?Var5Dias ?VarSector))
  =>
  (assert (Infravalorado ?Nombre " la empresa es grande, el RPD es alto y el PER mediano, no está bajando y funciona mejor que su sector."))
)

; Regla para salir del módulo 2
;   y entrar en el módulo 3
(defrule SalirModulo2
  (declare (salience -1))
  ?f <- (Modulo (Indice 2))
  =>
  (modify ?f (Indice 3))
)
