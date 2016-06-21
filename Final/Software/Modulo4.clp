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

; Mostrar mejor resultado
(defrule MostrarMejorResultado
  (Modulo Modulo4)
  ?f1 <- (Respuesta 1)
  ?f2 <- (Propuesta (Operacion ?Op) (Empresa ?Emp) (RE ?RE1) (Explicacion ?Exp) (Empresa2 ?Emp2))
  (not  (and (Propuesta (RE ?RE2)) (test(> ?RE2 ?RE1))))
  =>
  (retract ?f1)
  (printout t ?Exp crlf)
  (printout t "¿Desea llevar a cabo esta operación? S/N"  crlf)
  (bind ?Respuesta (read))
  (if (eq ?Respuesta S) then
    (Operacion ?Op ?Empresa ?Empresa2)
    (retract ?f2))
  (printout t "Pulse una de las siguientes teclas para acceder a las opciones del menú" crlf)
  (assert (PrintMenu))
)

(defrule VentaAcciones
  (Modulo Modulo4)
  ?f <- (Operacion Vender ?Empresa NA)
  ?modDisponible <- (Cartera (Nombre DISPONIBLE) (Valor ?Disponible))
  ?accionesVendidas <- (Cartera (Nombre ?Empresa) (Valor ?Valor))
  =>
  (retract ?f)
  (retract ?accionesVendidas)
  (modify ?modDisponible (Valor (+ ?Disponible ?Valor)) (Acciones (+ ?Disponible ?Valor)))
)

(defrule EfectuarInversion
  (Modulo Modulo4)
  ?f <- (Operacion Invertir ?Empresa NA)
  ?modDisponible <- (Cartera (Nombre DISPONIBLE) (Valor ?Disponible))
  (Valor (Nombre ?Empresa) (Precio ?Precio))
  =>
  (retract ?f)
  (printout t "Introduzca la cantidad a invertir (<=" " ?Disponible ") S/N"  crlf)
  (bind ?Respuesta (read))
  (if (and (<= ?Respuesta ?Disponible) (> ?Respuesta 0)) then
    (modify ?modDisponible (Valor (- ?Disponible ?Respuesta)) (Acciones (- ?Disponible ?Respuesta)))
    (assert (Cartera (Nombre ?Empresa) (Valor ?Respuesta) (Acciones (/ ?Respuesta ?Precio))))
    )
)

(defrule IntercambioValores
  (Modulo Modulo4)
  ?f <- (Operacion IntercambiarValores ?Empresa1 ?Empresa2)
  ?accionesVendidas <- (Cartera (Nombre ?Empresa1) (Valor ?Valor))
  (Valor (Nombre ?Empresa2) (Precio ?Precio))
  =>
  (retract ?f)
  (retract ?accionesVendidas)
  (assert (Cartera (Nombre ?Empresa2) (Valor ?Valor) (Acciones (/ ?Valor ?Precio))))
)
