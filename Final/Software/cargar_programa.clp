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
  (load "realizacion_propuestas.clp")
  (reset)
  (assert (ProgramaCargado))
)
