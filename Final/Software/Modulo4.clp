(defrule FindMaxRPD
  (Modulo Modulo5)
  (Propuesta ?Propuesta1 ?RPD1 ?Explicacion)
  (not  (and (Propuesta ?Propuesta2 ?RPD2 ?) (test (> ?RPD2 ?RPD1))))
  =>
  (Mostrar ?Propuesta1 ?Explicacion)
)

(defrule MostrarPropuesta
  (Modulo Modulo5)
  (Mostrar ?Propuesta1 ?Explicacion)
  =>
  (printout ?Propuesta1 ?Explicacion)
  (assert MenuAceptacionPropuesta)
)

(defrule Menu)
