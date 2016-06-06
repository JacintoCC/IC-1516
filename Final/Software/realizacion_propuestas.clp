(defrule VentaPeligrosos
  (Peligroso ?Nombre ?ExplicacionPeligroso)
  (Valor (Nombre ?Nombre) (VarMes ?VarMes) (Sector ?Sector) (RPD ?rpd))
  (test < ?VarMes 0)
  (Sector (Nombre ?Sector) (VarMes ?varSectorMes))
  (test < (- ?varSectorMes ?VarMes) -3)
  =>
  (bind ?RE (- 20 ?rdp))
  (Propuesta Vender ?Nombre ?RE
    (str-cat "La empresa es peligrosa porque "
              ?ExplicacionPeligroso
              ". Además, está entrando en tendencia bajista con respecto a su sector. Según mi estimación existe una probabilidad no despreciable de que pueda caer al cabo del año un 20%, aunque produzca"
              ?rdp
              "% por dividendos perderíamos un "
              ?RE
              "%."))
)

(defrule InversionInfravalorados
  (Infravalorado ?Nombre ?ExplicacionInfravalorado)
  (Valor (Nombre ?Nombre) (PER ?PER) (RPD ?RPD))
  (Sector (Nombre Ibex) (PER ?PERmedio))
  (Cartera Disponible ?Disponible)
  (test (> ?Disponible 0))
  =>
  (bind ?RE (+ (/ (*  (- ?PERmedio ?PER) 20) ?PER) ?RPD))
  (Propuesta Invertir ?Nombre ?RE
    (str-cat "Esta empresa está infravalorada y seguramente el PER tienda al PER medio en 5 años, con lo que se debería revalorizar un  "
              ?RE
              "% anual a lo que habría que sumar el "
              ?RPD
              "% de beneficios por dividendos"))
)

(defrule VentaSobrevalorados
  (Sobrevalorado ?Nombre ?ExplicacionSobrevalorado)
  (Cartera ?Nombre ?Cantidad)
  (Valor (Nombre ?Nombre) (PER ?PER) (RPD ?RPD) (Sector ?Sector) (VarAnual ?VarAnual))
  (Sector (Nombre ?Sector) (PER ?PERmedio))
  ; Falta saber cuál es el precio del dinero
  (test (< ?VarAnual (+ 5 ?PrecioDinero)))
  =>
  (bind ?RE (- (/ (- ?PER ?PERmedio) (* 5 ?PER)) ?RPD))
  (Propuesta Venta ?Nombre ?RE
    (str-cat "Esta empresa está sobrevalorada porque"
              ?ExplicacionSobrevalorado
              ", es mejor amortizar lo invertido, ya que seguramente el PER tan alto deberá bajar al PER medio del sector en unos 5 años, con lo que se debería devaluar un"
              (* ?RE 100)
              "% anual, así que aunque se pierda el "
              ?RPD
              " de beneficios por dividendos, saldría rentable"))
)


(defrule CambiarInversion
  ; Empresa 1
  (Valor (Nombre ?Nombre1) (RPD ?RPD1) (VarAnual ?VarAnual1))
  (not (Cartera ?Nombre1 ?Cantidad))
  (not (Sobrevalorado ?Nombre1 ?))

  ;Empresa 2
  (Valor (Nombre ?Nombre2) (RPD ?RPD2) (VarAnual ?VarAnual2))
  (Cartera ?Nombre2 ?Cantidad)
  (not (Infravalorado ?Nombre2 ?))

  ; Comprobación
  (test (> ?RPD1 (+ 1 ?RPD2 ?VaraAnual2)))
  =>
  (bind ?RE (- ?RPD1 (+ 1 ?RPD2 ?VaraAnual2)))
  (Propuesta IntercambiarValores (str-cat ?Nombre1 ?Nombre2)  ?RE
    (str-cat  ?Nombre1
              " debe tener una revalorización acorde con la evolución de la bolsa. Por dividendos se espera un "
              ?RPD2
              "%, que es más de lo que ofrece"
              ?Nombre2
              ". Por eso te propongo cambiar los valores por los de esta otra. Aunque se pague el 1% del coste del cambio saldŕia rentable."))
)
