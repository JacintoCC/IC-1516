; ------------------------------------
; FICHERO CON LA CARGA DE LOS DIFERENTES MÓDULOS
; Y DEFINICIONES
; ------------------------------------

(deffunction Cargar()
  (clear)
  (load "Definicion.clp")
  (load "Lectura.clp")
  (load "Modulo0.clp")
  (load "Modulo12.clp")
  (load "Modulo3.clp")
  (load "Modulo4.clp")
  (reset)
  (run)
)
