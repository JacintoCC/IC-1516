(defrule name
  =>
  (assert (CargarPrograma))
)

(defrule CargarPrograma
  ?f <- (CargarPrograma)
  (not (ProgramaCargado))
  =>
  (reset)
  (load "practica.clp")
  (load "estabilidad.clp")
  (load "deteccion_valores.clp")
  (load "lectura_datos.clp")
  (reset)
  (assert (ProgramaCargado))
)
