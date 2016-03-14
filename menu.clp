(deffacts Options
  (Opcion A "Opcion A")
  (Opcion B "Opcion B")
  (Opcion C "Opcion C"))

(defrule Menu
  =>
	(printout t "Pulse una de las siguientes teclas para acceder a las opciones del menú" crlf)
  (assert (PrintOpciones)))

(defrule PrintAllOptions
  (declare (salience 2))
  (PrintOpciones)
  (Opcion ?X ?)
  =>
  (assert (Print ?X)))

(defrule NotPrint
  ?p<- (PrintOpciones)
  (not (Print ?X))
  =>
  (retract ?p)
  (bind ?Respuesta (read))
	(assert (Respuesta ?Respuesta)))

(defrule PrintOption
  (declare (salience 1))
  ?f <- (Print ?X)
  (Opcion ?X ?Message)
  =>
	(printout t "Pulse " ?X " para " ?Message  crlf)
  (retract ?f))

(defrule PrintChosenOption
  (Respuesta ?X)
  (exists (Opcion ?X ?Message))
  =>
  (assert (OpcionElegida ?X)))

(defrule NoOption
  (declare (salience -1))
  ?f <- (Respuesta ?X)
  (not (Opcion ?X ?))
  =>
  (retract ?f)
  (printout t "Opcion incorrecta" crlf)
  (printout t "Pulse una de las siguientes teclas para acceder a las opciones del menú" crlf)
  (assert (PrintOpciones)))
