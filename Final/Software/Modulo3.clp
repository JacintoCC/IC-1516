; Regla para la venta de valores peligrosos
(defrule VentaPeligrosos
  (Modulo Modulo3)
  (Peligroso ?Nombre ?ExplicacionPeligroso)
  (Valor (Nombre ?Nombre) (VarMes ?VarMes) (Sector ?Sector) (RPD ?RPD))
  (test (< ?VarMes 0))
  (Sector (Nombre ?Sector) (VarMes ?varSectorMes))
  (test (< (- ?VarMes ?varSectorMes) -3))
  =>
  (bind ?RE (- 20 (* ?RPD 100)))
  (assert (Propuesta Vender ?Nombre ?RE
    (str-cat "La empresa es peligrosa porque "
              ?ExplicacionPeligroso
              ". Además, está entrando en tendencia bajista con respecto a su sector. Según mi estimación existe una probabilidad no despreciable de que pueda caer al cabo del año un 20%, aunque produzca"
             (* 100 ?RPD)
              "% por dividendos perderíamos un "
              ?RE
              "%.")))
)

; Regla para proponer la inversión en infravalorados
(defrule InversionInfravalorados
  (Modulo Modulo3)
  (Infravalorado ?Nombre ?ExplicacionInfravalorado)
  (Valor (Nombre ?Nombre) (PER ?PER) (RPD ?RPD))
  (Sector (Nombre Ibex) (PER ?PERmedio))
  (Cartera (Nombre Disponible) (Valor ?Disponible))
  (test (> ?Disponible 0))
  =>
  (bind ?RE (+ (/ (*  (- ?PERmedio ?PER) 20) ?PER) (* 100 ?RPD)))
  (assert (Propuesta Invertir ?Nombre ?RE
    (str-cat "Esta empresa está infravalorada y seguramente el PER tienda al PER medio en 5 años, con lo que se debería revalorizar un  "
              ?RE
              "% anual a lo que habría que sumar el "
             (* 100 ?RPD)
              "% de beneficios por dividendos")))
)

; Regla para proponer la venta de valores sobrevalorados
(defrule VentaSobrevalorados
  (Modulo Modulo3)
  (Sobrevalorado ?Nombre ?ExplicacionSobrevalorado)
  (Cartera (Nombre ?Nombre) (Valor ?Valor))
  (Valor (Nombre ?Nombre) (Precio ?Valor) (PER ?PER) (RPD ?RPD) (Sector ?Sector) (VarAnual ?VarAnual))
  (Sector (Nombre ?Sector) (PER ?PERmedio))
  (PrecioDinero ?PrecioDinero)
  (test (< (+ ?RPD ?VarAnual) (+ 5 ?PrecioDinero)))
  =>
  (bind ?RE (- (/ (- ?PER ?PERmedio) (* 5 ?PER)) (* 100 ?RPD)))
  (assert (Propuesta Venta ?Nombre ?RE
    (str-cat "Esta empresa está sobrevalorada porque"
              ?ExplicacionSobrevalorado
              ", es mejor amortizar lo invertido, ya que seguramente el PER tan alto deberá bajar al PER medio del sector en unos 5 años, con lo que se debería devaluar un"
              (* ?RE 100)
              "% anual, así que aunque se pierda el "
             (* 100 ?RPD)
              "% de beneficios por dividendos, saldría rentable")))
)

; Regla para proponer el cambio de un valor por otro más rentable
(defrule CambiarInversion
  (Modulo Modulo3)
  ; Empresa 1
  (Valor (Nombre ?Nombre1) (RPD ?RPD1) (VarAnual ?VarAnual1))
  (not (Sobrevalorado ?Nombre1 ?))

  ;Empresa 2
  (Valor (Nombre ?Nombre2~?Nombre1) (RPD ?RPD2) (VarAnual ?VarAnual2))
  (Cartera (Nombre ?Nombre2) (Acciones ?Cantidad))
  (not (Infravalorado ?Nombre2 ?))

  ; Comprobación
  (test (> (* 100 ?RPD1) (+ 1 (* 100 ?RPD2) ?VarAnual2)))
  =>
  (bind ?RE (- (* 100 ?RPD1) (+ 1 (* 100 ?RPD2) ?VarAnual2)))
  (assert (Propuesta IntercambiarValores (str-cat ?Nombre1 "-" ?Nombre2) ?RE
    (str-cat  ?Nombre1
              " debe tener una revalorización acorde con la evolución de la bolsa. Por dividendos se espera un "
             (* 100 ?RPD2)
              "%, que es más de lo que ofrece"
              ?Nombre2
              ". Por eso te propongo cambiar los valores por los de esta otra. Aunque se pague el 1% del coste del cambio saldría rentable.")
              ))
)


(defrule SalirModulo3
  (declare (salience -1))
  ?f <- (Modulo Modulo3)
  =>
  (retract ?f)
  (assert (Modulo Modulo4))
)
