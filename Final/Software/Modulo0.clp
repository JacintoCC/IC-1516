; Se introduce la inestabilidad por defecto de los valores
;   de la construcción
(defrule DefectoConstruccion
  (Modulo Modulo0)
  (Valor (Nombre ?Nombre) (Sector Construccion))
  (not (Noticia (Nombre Construcción) (Tipo Buena)))
  (not (Noticia (Nombre ?Nombre) (Tipo Buena)))
  =>
  (assert (Estabilidad ?Nombre Inestable))
)

; Se introduce la inestabilidad por defecto de los valores
;   del sector servicio si la economía va mal
(defrule DefectoServicios
  (Modulo Modulo0)
  (Sector (Nombre Ibex) (Perd5Consec true))
  (Valor (Nombre ?Nombre) (Sector Servicios))
  (not (Noticia (Nombre Servicios) (Tipo Buena)))
  (not (Noticia (Nombre ?Nombre) (Tipo Buena)))
  =>
  (assert (Estabilidad ?Nombre Inestable))
)

; Todos los valores pasan a ser inestables si hay
;   una noticia mala sobre la economía y no hay
;   noticias buenas sobre su sector o el propio valor
(defrule InestableEconomia
  (Modulo Modulo0)
  (Noticia (Nombre Economia) (Tipo Mala))
  (Valor (Nombre ?NombreValor) (Sector ?Sector))
  (not (Noticia (Nombre ?Sector) (Tipo Buena)))
  (not (Noticia (Nombre ?Nombre) (Tipo Buena)))
  =>
  (assert (Estabilidad ?NombreValor Inestable))
)

; Se declaran inestables los valores de cuyo sector
;   ha habido una noticia negativa a no ser que hubiera
;   una positiva del valor.
(defrule InestableSector
  (declare (salience 2))
  (Modulo Modulo0)
  (Noticia (Nombre ?Sector) (Tipo Mala))
  (Valor (Nombre ?NombreValor) (Sector ?Sector))
  (not (Noticia (Nombre ?Nombre) (Tipo Buena)))
  =>
  (assert (Estabilidad ?NombreValor Inestable))
)

; Elimina el hecho de que un valor sea inestable
;   por una noticia positiva sobre el sector
(defrule EstableSector
  (Modulo Modulo0)
  (Noticia (Nombre ?Sector) (Tipo Buena))
  (Valor (Nombre ?NombreValor) (Sector ?Sector))
  ?f <- (Estabilidad ?NombreValor Inestable)
  (not (Noticia (Nombre ?Nombre) (Tipo Mala)))
  =>
  (retract ?f)
)

; Se declara inestable un valor del que
;   ha habido una noticia negativa
(defrule InestableValor
  (Modulo Modulo0)
  (Noticia (Nombre ?NombreValor) (Tipo Mala))
  (Valor (Nombre ?NombreValor))
  =>
  (assert (Estabilidad ?NombreValor Inestable))
)

; Elimina el hecho de que un valor sea inestable
;   por una noticia positiva
(defrule EstableValor
  (Modulo Modulo0)
  (Noticia (Nombre ?NombreValor) (Tipo Buena))
  (Valor (Nombre ?NombreValor))
  ?f <- (Estabilidad ?NombreValor Inestable)
  =>
  (retract ?f)
)

; Termina el módulo 0 y da paso a la detección de
;   valores peligrosos y sobrevalorados
(defrule SalirModulo0
  (declare (salience -1))
  ?f <- (Modulo Modulo0)
  =>
  (assert (Modulo Modulo1))
  (retract ?f)
)
