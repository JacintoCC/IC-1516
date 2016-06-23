; ------------------------------------
; FICHERO CON LAS REGLAS DEL MÓDULO 4: INTERACCIÓN CON EL USUARIO
; ------------------------------------

; ------------------------------------------------------------------------------
; Opciones generales del menú
; ------------------------------------------------------------------------------
(deffacts OpcionesMenu
  (Menu 1 "Mostrar propuesta y valorar")
  (Menu 2 "Recalcular propuestas")
  (Menu 0 "Detener programa")
  )

; Entrada en el módulo 4
(defrule Menu
  (Modulo (Indice 4))
  =>
	(printout t "Pulse una de las siguientes teclas para acceder a las opciones del menú" crlf)
  (assert (PrintMenu))
)

; Salida por pantalla de las opciones del menú
(defrule PrintOption
  (declare (salience 1))
  (PrintMenu)
  (Menu ?X ?Message)
  =>
	(printout t "Pulse " ?X " para " ?Message  crlf))

; Lectura de la opción escogida por el usuario
(defrule ReadAnswer
  (Modulo (Indice 4))
  ?p<- (PrintMenu)
  =>
  (retract ?p)
  (bind ?Respuesta (read))
	(assert (Respuesta ?Respuesta)))

; Opción incorrecta introducida por el usuario
(defrule NoOption
  (Modulo (Indice 4))
  ?f <- (Respuesta ?X)
  (not (Menu ?X ?))
  =>
  (retract ?f)
  (printout t "Opcion incorrecta" crlf)
  (printout t "Pulse una de las siguientes teclas para acceder a las opciones del menú" crlf)
  (assert (PrintMenu)))

; ------------------------------------------------------------------------------
; Salida del programa
; ------------------------------------------------------------------------------

; Confirmación para salir del programa y guardar o no la nueva cartera
(defrule Salir
  (Modulo (Indice 4))
  ?f <- (Respuesta 0)
  =>
  (printout t "Confirme que desea salir del programa Sí (S)/No (Cualquier otra tecla)" crlf)
  (bind ?Respuesta (read))
  (if (or (eq ?Respuesta S) (eq ?Respuesta s)) then
    (printout t "¿Desea guardar los cambios? Sí (S)/No (Cualquier otra tecla)" crlf)
    (bind ?Respuesta (read))
      (if (or (eq ?Respuesta S) (eq ?Respuesta s)) then
        (open "Datos/CarteraMod.txt" mydata "w")
        (assert (Guardar)))
  else
    (printout t "Pulse una de las siguientes teclas para acceder a las opciones del menú" crlf)
    (assert (PrintMenu)))
  (retract ?f)
)

; Guardar como primera línea en el fichero el dinero disponible
(defrule guardarDisponible
  (declare (salience 3))
  (Modulo (Indice 4))
  (Guardar)
  (Cartera
    (Nombre DISPONIBLE)
    (Acciones ?V))
  =>
  (printout mydata (str-cat "DISPONIBLE " ?V " " ?V))
)

; Guardar el resto de valores de la cartera en el fichero
(defrule guardarCartera
  (declare (salience 2))
  (Modulo (Indice 4))
  (Guardar)
  (Cartera
    (Nombre ?Nombre & ~DISPONIBLE)
    (Acciones ?Acciones)
    (Valor ?Valor))
  =>
  (printout mydata crlf (str-cat ?Nombre " " ?Acciones " " ?Valor))
)

; Cierre del fichero
(defrule cerrarCarteraSalir
  (declare (salience 1))
  (Modulo (Indice 4))
  ?f <- (Guardar)
  =>
  (retract ?f)
  (close mydata)
)

; ------------------------------------------------------------------------------
; Muestra de propuestas y su manejo
; ------------------------------------------------------------------------------

; Muestra del mejor resultado y decisión sobre su aplicación o no
(defrule MostrarMejorResultado
  (Modulo (Indice 4))
  ; Se ha introducido la opción correspondiente
  ?fresp <- (Respuesta 1)
  ; Se han realizado menos de cinco propuestas
  ?fcont <- (Contador (Indice ?ind))
  (test (< ?ind 5))
  ; Es la mejor propuesta no presentada aún
  ?fprop <- (Propuesta (Operacion ?Op) (Empresa ?Emp) (RE ?RE1) (Explicacion ?Exp) (Empresa2 ?Emp2) (Presentada false))
  (not  (and (Propuesta (RE ?RE2) (Presentada false)) (test(> ?RE2 ?RE1))))
  =>
  (retract ?fresp)
  (printout t ?Exp crlf)
  (printout t "¿Desea llevar a cabo esta operación? Sí (S)/ No (Cualquier otra tecla)"  crlf)
  (bind ?Respuesta (read))
  (if (or (eq ?Respuesta S) (eq ?Respuesta s)) then
    (assert (Operacion ?Op ?Emp ?Emp2))
    (retract ?fprop)
  else
    (modify ?fprop (Presentada true)))
  (modify ?fcont (Indice (+ ?ind 1)))
  (printout t "Pulse una de las siguientes teclas para acceder a las opciones del menú" crlf)
  (assert (PrintMenu))
)

; Muestra de un mensaje cuando se han realizado 5 propuestas o no hay más
(defrule SinPropuestas
  (Modulo (Indice 4))
  ?fresp <- (Respuesta 1)
  (Contador (Indice ?ind))
  (or (not (Propuesta (Presentada false)))
      (test (>= ?ind 5)))
  =>
  (printout t "Se han mostrado las 5 mejores propuestas existentes" crlf)
  (retract ?fresp)
  (assert (PrintMenu))
)

; ------------------------------------------------------------------------------
; Llevada a cabo de operaciones de bolsa
; ------------------------------------------------------------------------------

; Venta de acciones y modificación de la cartera
(defrule VentaAcciones
  (declare (salience 10))
  (Modulo (Indice 4))
  ?f <- (Operacion Vender ?Empresa NA)
  ?modDisponible <- (Cartera (Nombre DISPONIBLE) (Valor ?Disponible))
  ?accionesVendidas <- (Cartera (Nombre ?Empresa) (Valor ?Valor))
  =>
  (retract ?f)
  (retract ?accionesVendidas)
  (modify ?modDisponible (Valor (+ ?Disponible (* 0.995 ?Valor))))
  (modify ?modDisponible (Acciones (+ ?Disponible (* 0.995 ?Valor))))
  (assert (Descartar Venta ?Empresa))
)

; Compra de acciones
(defrule EfectuarInversion
  (declare (salience 10))
  (Modulo (Indice 4))
  ?f <- (Operacion Invertir ?Empresa NA)
  ?modDisponible <- (Cartera (Nombre DISPONIBLE) (Valor ?Disponible))
  (Valor (Nombre ?Empresa) (Precio ?Precio))
  =>
  (retract ?f)
  (printout t "Introduzca la cantidad a invertir (<= " ?Disponible ") Sí (S)/No (Cualquier otra tecla)"  crlf)
  (bind ?Respuesta (read))
  (bind ?NumAcciones (dive (* 0.995 ?Respuesta) ?Precio))
  (bind ?Valor (* ?Precio ?NumAcciones))
  (if (and (<= ?Respuesta ?Disponible) (> ?Respuesta 0)) then
    (modify ?modDisponible (Valor (- ?Disponible ?Valor)) (Acciones (- ?Disponible ?Valor)))
    (assert (Cartera (Nombre ?Empresa) (Valor ?Valor) (Acciones ?NumAcciones)))
    )
  (assert (Descartar Compra ?Empresa))
)

; Intercambio de valores
(defrule IntercambioValores
  (declare (salience 10))
  (Modulo (Indice 4))
  ?f <- (Operacion IntercambiarValores ?Empresa1 ?Empresa2)
  ?accionesVendidas <- (Cartera (Nombre ?Empresa2) (Valor ?Valor))
  ?fdisponible <- (Cartera (Nombre DISPONIBLE) (Valor ?disponible))
  (Valor (Nombre ?Empresa1) (Precio ?Precio))
  =>
  (retract ?f)
  (retract ?accionesVendidas)
  (bind ?NumAcciones (dive (* 0.99 ?Valor) ?Precio))
  (bind ?ValorReal (* ?NumAcciones ?Precio))
  (assert (Cartera (Nombre ?Empresa1) (Valor ?ValorReal) (Acciones ?NumAcciones)))
  (modify ?fdisponible (Valor (+ ?disponible (- (* 0.99 ?Valor) ?ValorReal)))
                       (Acciones (+ ?disponible (- (* 0.99 ?Valor) ?ValorReal))))
  (assert (Descartar Venta ?Empresa2))
  (assert (Descartar Compra ?Empresa1))
)

; Eliminar propuestas de ventas de acciones tras quedarnos sin ellas
(defrule DescartarVentaTrasOperacion
  (declare (salience 9))
  (Modulo (Indice 4))
  (Descartar Venta ?Empresa)
  ?f <- (Propuesta  (Operacion Vender)
                    (Empresa ?Empresa))
  =>
  (retract ?f)
)

; Eliminar propuestas de intercambiar acciones tras quedarnos sin ellas
(defrule DescartarIntercambioTrasOperacion
  (declare (salience 9))
  (Modulo (Indice 4))
  (Descartar Venta ?Empresa)
  ?f <- (Propuesta  (Operacion IntercambiarValores)
                    (Empresa2 ?Empresa))
  =>
  (retract ?f)
)

; Eliminar la regla que descarta propuestas de ventas
(defrule StopDescartarVenta
  (declare (salience 8))
  (Modulo (Indice 4))
  ?f <- (Descartar Venta ?Empresa)
  (not (Propuesta (Operacion Vender) (Empresa ?Empresa)))
  (not (Propuesta  (Operacion IntercambiarValores) (Empresa2 ?Empresa)))
  =>
  (retract ?f)
  (assert (PrintMenu))
)

; Eliminar propuestas de comprar acciones tras haberlas comprado
(defrule DescartarCompraTrasOperacion
  (declare (salience 9))
  (Modulo (Indice 4))
  (Descartar Compra ?Empresa)
  ?f <- (Propuesta  (Operacion Invertir|IntercambiarValores)
                    (Empresa ?Empresa))
  =>
  (retract ?f)
)

; Eliminar la regla que descarta propuestas de compras
(defrule StopDescartarCompra
  (declare (salience 8))
  (Modulo (Indice 4))
  ?f <- (Descartar Compra ?Empresa)
  (not (Propuesta  (Operacion Invertir|IntercambiarValores)
                   (Empresa ?Empresa)))
  =>
  (retract ?f)
  (assert (PrintMenu))
)

; ------------------------------------------------------------------------------
; Con las modificaciones realizadas en la cartera, nuevo cálculo de propuestas
; ------------------------------------------------------------------------------

; Eliminar propuestas basadas en el anterior estado de la cartera
(defrule RecalcularEliminarPropuestas
  (declare (salience 3))
  (Modulo (Indice 4))
  (Respuesta 2)
  ?f <- (Propuesta)
  =>
  (retract ?f)
)

; Vuelta al módulo 1 para recalcular propuestas
(defrule Recalcular
  (declare (salience 2))
  ?fmod <- (Modulo (Indice 4))
  ?fresp <- (Respuesta 2)
  ?fcont <- (Contador (Indice ?))
  (not (Propuesta))
  =>
  (retract ?fresp)
  (modify ?fcont (Indice 0))
  (modify ?fmod (Indice 1))
)
