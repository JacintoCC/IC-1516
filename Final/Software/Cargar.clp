(defrule CargarPrograma
  (not (ProgramaCargado))
  =>
  (reset)
  (load "Definicion.clp")
  (load "Lectura.clp")
  (load "Modulo0.clp")
  (load "Modulo12.clp")
  (load "Modulo3.clp")
  (load "Modulo4.clp")
  (reset)
  (assert (ProgramaCargado))
)
