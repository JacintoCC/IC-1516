; Definición de los valores a leer
(deffacts declareDateFile
  (Reading 0)
  (OrderReading "Datos/Análisis.txt" 0)
  (OrderReading "Datos/AnálisisSectores.txt" 1)
)

; Ejemplo Leer datos de un fichero, procesarlos y actualizarlos en el fichero (CLIPS)
(defrule openfile
  (declare (salience 30))
  (OrderReading ?NameFile ?Order)
  (Reading ?Order)
  =>
  (open ?NameFile mydata)
  (assert (SeguirLeyendo ))
)

(defrule LeerValoresCierreFromFile
  (declare (salience 29))
  (Reading ?Order)
  ?f <- (SeguirLeyendo)
  =>
  (bind ?Leido (read mydata))
  (retract ?f)
  (if (neq ?Leido EOF) then
    (assert (ValorCierre ?Leido (read mydata) ?Order))
    (assert (SeguirLeyendo)))
)

(defrule closefile
  (declare (salience 28))
  (Reading ?Order)
  =>
  (close mydata)
)

(defrule nextFile
  ?f <- (Reading ?Order)
  (test (< ?Order 5))
  =>
  (retract ?f)
  (assert (Reading (+ ?Order 1)))
)
