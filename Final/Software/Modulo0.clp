; ------------------------------------
; FICHERO CON LAS REGLAS DEL MÓDULO 0: DEDUCCIÓN DE VALORES INTESTABLES
; ------------------------------------

; Estimación del rendimiento por año siguiendo la regla descrita
;   en el informe.
(defrule RPA
  (Modulo (Indice 0))
  ?mod <- (Valor
    (Nombre ?Nombre)
    (RPA 'NA')
    (RPD ?RPD)
    (VarAnual ?VarAnual)
    (VarSem ?VarSem)
    (VarTri ?VarTri)
    (VarMes ?VarMes))
  =>
  (bind ?RPA (+ (* 100 ?RPD) (max ?VarAnual ?VarSem ?VarTri ?VarMes)))
  (modify ?mod (RPA ?RPA))
)


; Se introduce la inestabilidad por defecto de los valores
;   de la construcción
(defrule DefectoConstruccion
  (Modulo (Indice 0))
  (Valor (Nombre ?Nombre) (Sector Construccion))
  (not (and (Noticia (Nombre Economia) (Tipo Mala) (Antiguedad ?A))
            (test (< ?A 2))))
  (not (and (Noticia (Nombre ?Nombre) (Tipo Mala) (Antiguedad ?A))
            (test (< ?A 2))))
  (not (and (Noticia (Nombre Construccion) (Tipo Mala) (Antiguedad ?A))
            (test (< ?A 2))))
  =>
  (assert (Inestable ?Nombre " pertenece al sector de la construcción "))
)

; Se introduce la inestabilidad por defecto de los valores
;   del sector servicio si la economía va mal
(defrule DefectoServicios
  (Modulo (Indice 0))
  (Sector (Nombre Ibex) (Perd5Consec true))
  (Valor (Nombre ?Nombre) (Sector Servicios))
  (not (and (Noticia (Nombre Economia) (Tipo Mala) (Antiguedad ?A))
            (test (< ?A 2))))
  (not (and (Noticia (Nombre ?Nombre) (Tipo Mala) (Antiguedad ?A))
            (test (< ?A 2))))
  (not (and (Noticia (Nombre Servicios) (Tipo Mala) (Antiguedad ?A))
            (test (< ?A 2))))
  =>
  (assert (Inestable ?Nombre " pertenece al sector servicios y la economía está bajando "))
)

; Todos los valores pasan a ser inestables si hay
;   una noticia mala sobre la economía
(defrule InestableEconomia
  (Modulo (Indice 0))
  (Noticia (Nombre Economia) (Tipo Mala))
  (Valor (Nombre ?NombreValor) (Sector ?NombreSector))
  (not (and (Noticia (Nombre ?Nombre) (Tipo Mala) (Antiguedad ?A))
            (test (< ?A 2))))
  (not (and (Noticia (Nombre ?NombreSector) (Tipo Mala) (Antiguedad ?A))
            (test (< ?A 2))))
  =>
  (assert (Inestable ?NombreValor " ha habido una noticia mala sobre la economía "))
)

; Se declaran inestables los valores de cuyo sector
;   ha habido una noticia negativa
(defrule InestableSector
  (Modulo (Indice 0))
  (Noticia (Nombre ?Sector) (Tipo Mala))
  (Valor (Nombre ?NombreValor) (Sector ?Sector))
  (not (and (Noticia (Nombre ?Nombre) (Tipo Mala) (Antiguedad ?A))
            (test (< ?A 2))))
  =>
  (assert (Inestable ?NombreValor (str-cat " ha habido una noticia mala sobre el sector " ?Sector)))
)

; Elimina el hecho de que un valor sea inestable
;   si hay una noticia buena sobre el sector
(defrule EstableSector
  (Modulo (Indice 0))
  (Noticia (Nombre ?Sector) (Tipo Buena))
  (Valor (Nombre ?NombreValor) (Sector ?Sector))
  ?f <- (Inestable ?NombreValor ?)
  (not (and (Noticia (Nombre ?Nombre) (Tipo Mala) (Antiguedad ?A))
            (test (< ?A 2))))
  =>
  (retract ?f)
)

; Se declara inestable un valor del que
;   ha habido una noticia negativa
(defrule InestableValor
  (Modulo (Indice 0))
  (Noticia (Nombre ?NombreValor) (Tipo Mala) (Antiguedad ?A))
  (test (< ?A 2))
  (Valor (Nombre ?NombreValor))
  =>
  (assert (Inestable ?NombreValor " ha habido una noticia negativa sobre el valor"))
)

; Elimina el hecho de que un valor sea inestable
;   por una noticia positiva
(defrule EstableValor
  (Modulo (Indice 0))
  (Noticia (Nombre ?NombreValor) (Tipo Buena) (Antiguedad ?A))
  (test (< ?A 2))
  (Valor (Nombre ?NombreValor))
  ?f <- (Inestable ?NombreValor ?)
  =>
  (retract ?f)
)

; Termina el módulo 0 y da paso a la detección de
;   valores peligrosos y sobrevalorados
(defrule SalirModulo0
  (declare (salience -1))
  ?f <- (Modulo (Indice 0))
  =>
  (modify ?f (Indice 1))
)
