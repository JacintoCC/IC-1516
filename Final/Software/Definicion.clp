; ------------------------------------
; FICHERO CON LA DEFINICIÓN DE LOS TEMPLATES
; Y HECHOS GLOBALES AL PROBLEMA
; ------------------------------------

; ---------------------------------
; Template para un valor del IBEX35
; ---------------------------------
(deftemplate Valor
  (field Nombre)
  (field Precio)
  (field VarDia)
  (field Capitalizacion)
  (field PER)
  (field RPD)
  (field Tamano)
  (field PorcIbex)
  (field EtiqPER)
  (field EtiqRPD)
  (field Sector)
  (field Var5Dias)
  (field Perd3Consec)
  (field Perd5Consec)
  (field VarRespSector5Dias)
  (field PerdRespSectorGrande)
  (field VarMes)
  (field VarTri)
  (field VarSem)
  (field VarAnual)
  ; Rendimiento por año esperado
  (field RPA
    (default 'NA'))
)

; ---------------------------------
; Template para un sector del IBEX35
; ---------------------------------
(deftemplate Sector
  (field Nombre)
  (field VarDia)
  (field Capitalizacion)
  (field PER)
  (field RPD)
  (field PorcIbex)
  (field Var5Dias)
  (field Perd3Consec)
  (field Perd5Consec)
  (field VarMes)
  (field VarTri)
  (field VarSem)
  (field VarAnual)
)

; ---------------------------------
; Template para una noticia
; ---------------------------------
(deftemplate Noticia
  (field Nombre)
  (field Tipo)
  (field Antiguedad)
)

; ---------------------------------
; Template para la información de un valor de nuestra cartera
; ---------------------------------
(deftemplate Cartera
  (field Nombre)
  (field Acciones)
  (field Valor)
  (field Actualizado
    (default true))
)

; ---------------------------------
; Template para una propuesta que se realizará
; ---------------------------------
(deftemplate Propuesta
  ; Tipo de operación
  (field Operacion)
  ; Empresa implicada
  (field Empresa)
  ; Rendimiento esperado
  (field RE)
  ; Motivo por el que se realiza la propuesta
  (field Explicacion)
  ; Segunda empresa implicada
  (field Empresa2
    (default NA))
  ; Valor lógico que indica si la propuesta ya ha sido presentada
  (field Presentada
    (default false))
)

; ---------------------------------
; Template para almacenar el módulo actual
; ---------------------------------
(deftemplate Modulo
  (field Indice)
)

; ---------------------------------
; Template para un contador
; Se usará para llevar la cuenta del número de propuestas presentadas
; ---------------------------------
(deftemplate Contador
  (field Indice)
)

; ---------------------------------
; Template para llevar la suma del valor de las acciones
; ---------------------------------
(deftemplate Suma
  (field Suma)
)

; Declaración de las variables globales
(deffacts DeclaracionVariables
  (Contador (Indice 0))
  (Suma (Suma 0))
)

; Declaración de la constante Precio del dinero
;   según el precio establecido por el BCE
(deffacts PrecioDinero
  (PrecioDinero 0)
)

; Declaración del número de propuestas a realizar
(deffacts NumMaxPropuestas
  (NumMaxPropuestas 5)
)

; Función para obtener el cociente entero de una división
;   entre números reales.
(deffunction dive (?a ?b)
   (div (/ ?a ?b) 1))
