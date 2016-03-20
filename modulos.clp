(deffacts Modulos
  (Modulo A)
  (Modulo B)
  (Modulo C)
)

(deffacts Cadena
  (Next A B)
  (Next B C)
  (Next C A)
)

(defrule AskModule
  =>
	(printout t "Seleccione el módulo a cargar" crlf)
  (bind ?Respuesta (read))
	(assert (ModuloProv ?Respuesta))
)

(defrule ConfirmModule
  (ModuloProv ?X)
  (Modulo ?X)
  =>
	(printout t "Quiere confirmar el módulo" ?X crlf)
  (bind ?Respuesta (read))
  (assert (Confirm ?Respuesta))
)

(defrule Confirm
  ?f1 <- (Confirm S)
  ?f2 <- (ModuloProv ?X)
  =>
  (retract ?f1)
  (retract ?f2)
  (assert (SelectedModule ?X))
)

(defrule Discard
  (Confirm N)
  ?f <- (ModuloProv ?X)
  (Next ?X ?Y)
  =>
  (retract ?f)
  (assert (ModuloProv ?Y))
)
