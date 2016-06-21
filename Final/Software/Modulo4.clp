; MENÚ GENERAL
(deffacts OpcionesMenu
  (Menu 1 "Mostrar propuesta y valorar")
  (Menu 2 "Mostrar mejores propuestas")
  (Menu 0 "Salir")
  )

(defrule Menu
  (Modulo Modulo4)
  =>
	(printout t "Pulse una de las siguientes teclas para acceder a las opciones del menú" crlf)
  (assert (PrintMenu))
)

(defrule PrintOption
  (declare (salience 1))
  (PrintMenu)
  (Menu ?X ?Message)
  =>
	(printout t "Pulse " ?X " para " ?Message  crlf))

(defrule ReadAnswer
  (Modulo Modulo4)
  ?p<- (PrintMenu)
  =>
  (retract ?p)
  (bind ?Respuesta (read))
	(assert (Respuesta ?Respuesta)))

(defrule NoOption
  (Modulo Modulo4)
  ?f <- (Respuesta ?X)
  (not (Menu ?X ?))
  =>
  (retract ?f)
  (printout t "Opcion incorrecta" crlf)
  (printout t "Pulse una de las siguientes teclas para acceder a las opciones del menú" crlf)
  (assert (PrintOpciones)))


; Salir
(defrule Salir
  (Modulo Modulo4)
  ?f <- (Respuesta 0)
  =>
  (printout t "Confirme que desea salir del programa S/N" crlf)
  (bind ?Respuesta (read))
  (if (eq ?Respuesta S) then
    (printout t "¿Desea guardar los cambios? S/N" crlf)
    (bind ?Respuesta (read))
      (if (eq ?Respuesta S) then
        (open "Datos/Cartera.txt" mydata "w")
        (assert (Guardar))
      else
        (exit))
  else
    (printout t "Pulse una de las siguientes teclas para acceder a las opciones del menú" crlf)
    (assert (PrintMenu)))
  (retract ?f)
)

(defrule guardarDisponible
  (declare (salience 3))
  (Modulo Modulo4)
  (Guardar)
  (Cartera
    (Nombre DISPONIBLE)
    (Acciones ?V)
    (Valor ?V))
  =>
  (printout mydata (str-cat "DISPONIBLE " ?V " " ?V))
)

(defrule guardarCartera
  (declare (salience 2))
  (Modulo Modulo4)
  (Guardar)
  (Cartera
    (Nombre ?Nombre & ~DISPONIBLE)
    (Acciones ?Acciones)
    (Valor ?Valor))
  =>
  (printout mydata crlf (str-cat ?Nombre " " ?Acciones " " ?Valor))
)

(defrule cerrarCarteraSalir
  (declare (salience 1))
  (Modulo Modulo4)
  ?f <- (Guardar)
  =>
  (retract ?f)
  (close mydata)
  (exit)
)
