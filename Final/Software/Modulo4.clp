; MENÚ GENERAL
(deffacts OpcionesMenu
  (Menu 1 "Mostrar propuesta y valorar")
  (Menu 2 "Recalcular propuestas")
  (Menu 0 "Detener programa")
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
  (assert (PrintMenu)))


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
        (open "Datos/CarteraMod.txt" mydata "w")
        (assert (Guardar)))
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
)

; Mostrar mejor resultado
(defrule MostrarMejorResultado
  (Modulo Modulo4)
  ?fresp <- (Respuesta 1)
  ?fcont <- (Contador (Indice ?ind))
  (test (< ?ind 5))
  ?fprop <- (Propuesta (Operacion ?Op) (Empresa ?Emp) (RE ?RE1) (Explicacion ?Exp) (Empresa2 ?Emp2) (Presentada false))
  (not  (and (Propuesta (RE ?RE2) (Presentada false)) (test(> ?RE2 ?RE1))))
  =>
  (retract ?fresp)
  (printout t ?Exp crlf)
  (printout t "¿Desea llevar a cabo esta operación? S/N"  crlf)
  (bind ?Respuesta (read))
  (if (eq ?Respuesta S) then
    (assert (Operacion ?Op ?Emp ?Emp2))
    (retract ?fprop)
  else
    (modify ?fprop (Presentada true)))
  (modify ?fcont (Indice (+ ?ind 1)))
  (printout t "Pulse una de las siguientes teclas para acceder a las opciones del menú" crlf)
  (assert (PrintMenu))
)

; Mostrar un mensa
(defrule SinPropuestas
  (Modulo Modulo4)
  ?fresp <- (Respuesta 1)
  (Contador (Indice ?ind))
  (or (not (Propuesta (Presentada false)))
      (test (>= ?ind 5)))
  =>
  (printout t "Se han mostrado las 5 mejores propuestas existentes" crlf)
  (retract ?fresp)
  (assert (PrintMenu))
)

(defrule VentaAcciones
  (declare (salience 10))
  (Modulo Modulo4)
  ?f <- (Operacion Vender ?Empresa NA)
  ?modDisponible <- (Cartera (Nombre DISPONIBLE) (Valor ?Disponible))
  ?accionesVendidas <- (Cartera (Nombre ?Empresa) (Valor ?Valor))
  =>
  (retract ?f)
  (retract ?accionesVendidas)
  (modify ?modDisponible (Valor (+ ?Disponible (* 0.95 ?Valor))))
  (modify ?modDisponible (Acciones (+ ?Disponible (* 0.95 ?Valor))))
  (assert (Descartar Venta ?Empresa))
)

(defrule EfectuarInversion
  (declare (salience 10))
  (Modulo Modulo4)
  ?f <- (Operacion Invertir ?Empresa NA)
  ?modDisponible <- (Cartera (Nombre DISPONIBLE) (Valor ?Disponible))
  (Valor (Nombre ?Empresa) (Precio ?Precio))
  =>
  (retract ?f)
  (printout t "Introduzca la cantidad a invertir (<= " ?Disponible ") S/N"  crlf)
  (bind ?Respuesta (read))
  (bind ?NumAcciones (dive (* 0.95 ?Respuesta) ?Precio))
  (bind ?Valor (* ?Precio ?NumAcciones))
  (if (and (<= ?Respuesta ?Disponible) (> ?Respuesta 0)) then
    (modify ?modDisponible (Valor (- ?Disponible ?Valor)) (Acciones (- ?Disponible ?Valor)))
    (assert (Cartera (Nombre ?Empresa) (Valor ?Valor) (Acciones ?NumAcciones)))
    )
  (assert (Descartar Compra ?Empresa))
)

(defrule IntercambioValores
  (declare (salience 10))
  (Modulo Modulo4)
  ?f <- (Operacion IntercambiarValores ?Empresa1 ?Empresa2)
  ?accionesVendidas <- (Cartera (Nombre ?Empresa2) (Valor ?Valor))
  ?fdisponible <- (Cartera (Nombre DISPONIBLE) (Valor ?disponible))
  (Valor (Nombre ?Empresa1) (Precio ?Precio))
  =>
  (retract ?f)
  (retract ?accionesVendidas)
  (bind ?NumAcciones (dive (* 0.9 ?Valor) ?Precio))
  (bind ?ValorReal (* ?NumAcciones ?Precio))
  (assert (Cartera (Nombre ?Empresa1) (Valor ?ValorReal) (Acciones ?NumAcciones)))
  (modify ?fdisponible (Valor (+ ?disponible (- (* 0.9 ?Valor) ?ValorReal)))
                       (Acciones (+ ?disponible (- (* 0.9 ?Valor) ?ValorReal))))
  (assert (Descartar Venta ?Empresa2))
  (assert (Descartar Compra ?Empresa1))
)

(defrule DescartarVentaTrasOperacion
  (declare (salience 9))
  (Modulo Modulo4)
  (Descartar Venta ?Empresa)
  ?f <- (Propuesta  (Operacion Vender)
                    (Empresa ?Empresa))
  =>
  (retract ?f)
)

(defrule DescartarIntercambioTrasOperacion
  (declare (salience 9))
  (Modulo Modulo4)
  (Descartar Venta ?Empresa)
  ?f <- (Propuesta  (Operacion IntercambiarValores)
                    (Empresa2 ?Empresa))
  =>
  (retract ?f)
)

(defrule StopDescartarVenta
  (declare (salience 8))
  (Modulo Modulo4)
  ?f <- (Descartar Venta ?Empresa)
  (not (Propuesta (Operacion Vender) (Empresa ?Empresa)))
  (not (Propuesta  (Operacion IntercambiarValores) (Empresa2 ?Empresa)))
  =>
  (retract ?f)
  (assert (PrintMenu))
)

(defrule DescartarCompraTrasOperacion
  (declare (salience 9))
  (Modulo Modulo4)
  (Descartar Compra ?Empresa)
  ?f <- (Propuesta  (Operacion Invertir|IntercambiarValores)
                    (Empresa ?Empresa))
  =>
  (retract ?f)
)

(defrule StopDescartarCompra
  (declare (salience 8))
  (Modulo Modulo4)
  ?f <- (Descartar Compra ?Empresa)
  (not (Propuesta  (Operacion Invertir|IntercambiarValores)
                   (Empresa ?Empresa)))
  =>
  (retract ?f)
  (assert (PrintMenu))
)

(defrule RecalcularEliminarPropuestas
  (declare (salience 3))
  (Modulo Modulo4)
  (Respuesta 2)
  ?f <- (Propuesta)
  =>
  (retract ?f)
)

(defrule Recalcular
  (declare (salience 2))
  ?fmod <- (Modulo Modulo4)
  ?fresp <- (Respuesta 2)
  ?fcont <- (Contador (Indice ?))
  (not (Propuesta))
  =>
  (retract ?fmod)
  (retract ?fresp)
  (modify ?fcont (Indice 0))
  (assert (Modulo Modulo0))
)
