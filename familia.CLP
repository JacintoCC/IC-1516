; Relaciones de género para asignar según el sexo
(deffacts RelacionGenero
	(RelacionGenero Casados Casados)
	(RelacionGenero Hijo Hija)
	(RelacionGenero Padre Madre)
	(RelacionGenero Hermano Hermana)
	(RelacionGenero Tio Tia)
	(RelacionGenero Primo Prima)
	(RelacionGenero Abuelo Abuela)
	(RelacionGenero Nieto Nieta)
	(RelacionGenero Suegro Suegra)
	(RelacionGenero Yerno Nuera)
	(RelacionGenero "Cuñado" "Cuñada")
	(RelacionGenero Sobrino Sobrina)
)

; Relaciones duales para asignar los recíprocos
(deffacts RelacionesDuales
	(RelacionDual Casados Casados)
	(RelacionDual Padre Hijo)
	(RelacionDual Hermano Hermano)
	(RelacionDual Tio Sobrino)
	(RelacionDual Abuelo Nieto)
	(RelacionDual Suegro Yerno)
	(RelacionDual "Cuñado" "Cuñado")
)

; Composición de relaciones para extender las relaciones
(deffacts Composiciones
	(Composicion Hijo Padre Hermano)
	(Composicion Padre Padre Abuelo)
	(Composicion Hermano Padre Tio)
	(Composicion Hijo Tio Primo)
	(Composicion Hijo Casados Hijo)
	(Composicion Padre Casados Suegro)
	(Composicion Casados Hermano "Cuñado")
)

; Regla para completar las relaciones duales
(defrule RelDual
	(RelacionDual ?R1 ?R2)
	=>
	(assert (RelacionDual ?R2 ?R1))
)

; Reglas para inferir una relación dual concreta entre dos personas
(defrule InfRelDualHH
	(RelacionDual ?R1 ?R2)
	(Relacion ?R1 ?X ?Y & ~?X)
	(Persona ?X Hombre)
	(Persona ?Y Hombre)
	=>
	(assert (Relacion ?R2 ?Y ?X))
)
(defrule InfRelDualHM
	(RelacionDual ?R1 ?R2)
	(Relacion ?R1 ?X ?Y & ~?X)
	(Persona ?X Hombre)
	(Persona ?Y Mujer)
	(RelacionGenero ?R2 ?RR2)
	=>
	(assert (Relacion ?RR2 ?Y ?X))
)
(defrule InfRelDualMH
	(RelacionDual ?R1 ?R2)
	(RelacionGenero ?R1 ?RR1)
	(Relacion ?RR1 ?X ?Y & ~?X)
	(Persona ?X Mujer)
	(Persona ?Y Hombre)
	=>
	(assert (Relacion ?R2 ?Y ?X))
)
(defrule InfRelDualMM
	(RelacionDual ?R1 ?R2)
	(RelacionGenero ?R1 ?RR1)
	(RelacionGenero ?R2 ?RR2)
	(Relacion ?RR1 ?X ?Y & ~?X)
	(Persona ?X Mujer)
	(Persona ?Y Mujer)
	=>
	(assert (Relacion ?RR2 ?Y ?X))
)

; Reglas para inferir una relación de composición concreta entre dos personas
(defrule InfRelComposicionHH
	(Composicion ?R1 ?R2 ?R3)
	(Relacion ?R1 ?X ?Y)
	(Relacion ?R2 ?Y & ~?X ?Z & ~?X & ~?Y)
	(Persona ?X Hombre)
	(Persona ?Y Hombre)
	=>
	(assert (Relacion ?R3 ?X ?Z))
)
(defrule InfRelComposicionHM
	(Composicion ?R1 ?R2 ?R3)
	(Relacion ?R1 ?X ?Y)
	(RelacionGenero ?R2 ?R4)
	(Relacion ?R4 ?Y & ~?X ?Z & ~?X & ~?Y)
	(Persona ?X Hombre)
	(Persona ?Y Mujer)
	=>
	(assert (Relacion ?R3 ?X ?Z))
)
(defrule InfRelComposicionMH
	(Composicion ?R1 ?R2 ?R3)
	(RelacionGenero ?R1 ?R4)
	(Relacion ?R4 ?X ?Y)
	(Relacion ?R2 ?Y & ~?X ?Z & ~?X & ~?Y)
	(RelacionGenero ?R3 ?R5)
	(Persona ?X Mujer)
	(Persona ?Y Hombre)
	=>
	(assert (Relacion ?R5 ?X ?Z))
)
(defrule InfRelComposicionMM
	(Composicion ?R1 ?R2 ?R3)
	(RelacionGenero ?R1 ?RR1)
	(RelacionGenero ?R2 ?RR2)
	(Relacion ?RR1 ?X ?Y)
	(Relacion ?RR2 ?Y & ~?X ?Z & ~?X & ~?Y)
	(RelacionGenero ?R3 ?RR3)
	(Persona ?X Mujer)
	(Persona ?Y Mujer)
	=>
	(assert (Relacion ?RR3 ?X ?Z))
)

; Reglas para leer e imprimr una búsqueda
(defrule LeerDatos
	=>
	(printout t "Introduzca el nombre de la primera persona" crlf)
	(bind ?Respuesta1 (read))
	(printout t "Introduzca el nombre de la segunda persona" crlf)
	(bind ?Respuesta2 (read))
	(assert (Imprimir ?Respuesta1 ?Respuesta2))
)
(defrule ImprimirP
	?fase <- (Imprimir ?X ?Y)
	(Relacion ?R ?X ?Y)
	=>
	(printout t ?X " es " ?R " de " ?Y crlf)
	(retract ?fase)
)

; Datos
(deffacts Personas
	(Persona Diego Hombre)
	(Persona Jacinto Hombre)
	(Persona Jacin Hombre)
	(Persona Joaquin Hombre)
	(Persona Juani Mujer)
	(Persona Nuria Mujer)
	(Persona Virtu Mujer)
	(Persona "Maria Rodríguez" Mujer)
	(Persona "María Carrasco" Mujer)
	(Persona "María García" Mujer)
	(Persona Almudena Mujer)
	(Persona Erika Mujer)
	(Persona Antonio Hombre)
	(Persona Mario Hombre)
	(Persona Alberto Hombre)
	(Persona Andres Hombre)
	(Persona Sergio Hombre)
)

(deffacts Relaciones
	(Relacion Padre Diego Juani)
	(Relacion Padre Diego Jacinto)
	(Relacion Padre Jacinto Jacin)
	(Relacion Madre Juani Nuria)
	(Relacion Madre Juani Sergio)
	(Relacion Madre Juani Erika)
	(Relacion Casados Juani Joaquin)
	(Relacion Casados Jacinto Virtu)
	(Relacion Casados Diego "Maria Rodríguez")
	(Relacion Madre "María García" Virtu)
	(Relacion Casados "María García" Andres)
	(Relacion Padre Jacinto "María Carrasco")
	(Relacion Madre "María García" Almudena)
	(Relacion Casados Almudena Antonio)
	(Relacion Madre Almudena Mario)
	(Relacion Madre Almudena Alberto)
)
