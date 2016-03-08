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
(defrule InfRelDual
	(RelacionDual ?R1 ?R2)
	(Relacion ?R1 ?X ?Y & ~?X)
	=>
	(assert (AsignarGenero ?R2 ?Y ?X))
)
(defrule AsignarGenFem
	?fase <- (AsignarGenero ?R ?X ?Y)
	(Persona ?X Mujer)
	(RelacionGenero ?R ?RF)
	=>
	(assert (Relacion ?RF ?X ?Y))
	(retract ?fase)
)
(defrule AsignarGenHombre
	?fase <- (AsignarGenero ?R ?X ?Y)
	(Persona ?X Hombre)
	=>
	(assert (Relacion ?R ?X ?Y))
	(retract ?fase)
)

; Reglas para inferir una relación de composición concreta entre dos personas
(defrule InfRelComposicion
	(Relacion ?R1 ?X ?Y)
	(Relacion ?R2 ?Y & ~?X ?Z & ~?X & ~?Y)
	(Composicion ?R1 ?R2 ?R3)
	=>
	(assert (AsignarGenero ?R3 ?X ?Z))
)

; Reglas para leer e imprimr una búsqueda
(defrule LeerDatos
	=>
	(printout t "Introduzca el nombre de la primera persona" crlf)
	(bind ?Respuesta1 (read))
	(printout t "Introduzca el nombre de la segunda persona" crlf)
	(bind ?Respuesta2 (read))
	(assert (Buscado1 ?Respuesta1))
	(assert (Buscado2 ?Respuesta2))
)
(defrule ImprimirP
	?fase1 <- (Buscado1 ?X)
	?fase2 <- (Buscado2 ?Y)
	(Relacion ?R ?X ?Y)
	=>
	(printout t ?X " es " ?R " de " ?Y crlf)
	(retract ?fase1)
	(retract ?fase1)
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

(deffacts Prof
	(NivelProfundidad 10))
