(deffacts RelacionesEstabilidad
  (NoticiaEstabilidad Buena Estable)
  (NoticiaEstabilidad Mala Inestable)
  (Contrario Estable Inestable)
  (Contrario Inestable Estable)
)

(defrule NoticiaValor
  (declare (salience 40))
  (Noticia (Nombre ?Nombre) (Tipo ?Tipo))
  (Valor (?Nombre))
  (NoticiaEstabilidad ?Tipo ?Estabilidad)
  =>
  (assert (Estabilidad ?Nombre ?Estabilidad))
)

(defrule NoticiaSector
  (declare (salience 39))
  (Noticia (Nombre ?NombreSector) (Tipo ?Tipo))
  (Sector (Nombre ?NombreSector))
  (Valor (Nombre ?NombreValor) (Sector ?NombreSector))
  (NoticiaEstabilidad ?Tipo ?Estabilidad)
  (Contrario ?Estabilidad ?ContEst)
  (not (Estabilidad ?NombreValor ?ContEst))
  =>
  (assert (Estabilidad ?NombreValor ?Estabilidad))
)

(defrule NoticiaSector
  (declare (salience 38))
  (Noticia (Nombre Economia) (Tipo ?Tipo))
  (Valor (Nombre ?NombreValor) (Sector ?NombreSector))
  (NoticiaEstabilidad ?Tipo ?Estabilidad)
  (Contrario ?Estabilidad ?ContEst)
  (not (Estabilidad ?NombreValor ?ContEst))
  =>
  (assert (Estabilidad ?NombreValor ?Estabilidad))
)

(defrule DefectoConstruccion
  (declare (salience 37))
  (Valor (Nombre ?Nombre) (Sector Construccion))
  (not (Estabilidad ?Nombre Estable))
  =>
  (Estabilidad ?Nombre Inestable)
)

(defrule DefectoServicios
  (declare (salience 37))
  (Sector (Nombre Ibex) (VarDia ?Var))
  (test (< ?Var 0))
  (Valor (Nombre ?Nombre) (Sector Servicios))
  (not (Estabilidad ?Nombre Estable))
  =>
  (Estabilidad ?Nombre Inestable)
)
