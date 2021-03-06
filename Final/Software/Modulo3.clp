; ------------------------------------
; FICHERO CON LAS REGLAS DEL MÓDULO 3: REALIZACIÓN DE PROPUESTAS
; -----------------------------------

; Regla para la venta de valores peligrosos
(defrule VentaPeligrosos
  (Modulo (Indice 3))
  (Peligroso ?Nombre ?ExplicacionPeligroso)
  (Cartera (Nombre ?Nombre))
  (Valor (Nombre ?Nombre) (VarMes ?VarMes) (Sector ?Sector) (RPD ?RPD))
  (test (< ?VarMes 0))
  (Sector (Nombre ?Sector) (VarMes ?varSectorMes))
  (test (< (- ?VarMes ?varSectorMes) -3))
  =>
  (bind ?RE (- 20 (* ?RPD 100)))
  (assert (Propuesta
    (Operacion Vender)
    (Empresa ?Nombre)
    (RE ?RE)
    (Explicacion  (str-cat "La empresa es peligrosa porque "
                            ?ExplicacionPeligroso
                            ". Además, está entrando en tendencia bajista con respecto a su sector. Según mi estimación existe una probabilidad no despreciable de que pueda caer al cabo del año un 20%, aunque produzca"
                            (* 100 ?RPD)
                            "% por dividendos perderíamos un "
                             ?RE
                             "%."))
      ))
)

; Regla para proponer la inversión en infravalorados
(defrule InversionInfravalorados
  (Modulo (Indice 3))
  (Infravalorado ?Nombre ?ExplicacionInfravalorado)
  (Valor (Nombre ?Nombre) (Precio ?Precio) (PER ?PER) (RPD ?RPD))
  (Sector (Nombre Ibex) (PER ?PERmedio))
  (Cartera (Nombre DISPONIBLE) (Valor ?Disponible))
  (ValorTotal (Valor ?ValorTotal))
  (test (neq ?PER 0))
  (test (> (* 0.995 ?Disponible) ?Precio))
  (or (not (Cartera (Nombre ?Nombre)))
      (and (Cartera (Nombre ?Nombre) (Valor ?Valor))
           (test (< (/ ?Valor ?ValorTotal) 0.5))))
  =>
  (bind ?RE (+ (/ (*  (- ?PERmedio ?PER) 20) ?PER) (* 100 ?RPD)))
  (assert (Propuesta
      (Operacion Invertir)
      (Empresa  ?Nombre)
      (RE ?RE)
      (Explicacion (str-cat "Esta empresa "
                            ?Nombre
                            " está infravalorada y seguramente el PER tienda al PER medio en 5 años, con lo que se debería revalorizar un  "
                            ?RE
                            "% anual a lo que habría que sumar el "
                            (* 100 ?RPD)
                            "% de beneficios por dividendos"))
      ))
)

; Regla para proponer la venta de valores sobrevalorados
(defrule VentaSobrevalorados
  (Modulo (Indice 3))
  (Sobrevalorado ?Nombre ?ExplicacionSobrevalorado)
  (Cartera (Nombre ?Nombre) (Valor ?Valor))
  (Valor (Nombre ?Nombre) (Precio ?Valor) (PER ?PER) (RPD ?RPD) (Sector ?Sector) (RPA ?RPA))
  (Sector (Nombre ?Sector) (PER ?PERmedio))
  (PrecioDinero ?PrecioDinero)
  (ValorTotal (Valor ?ValorTotal))
  (test (< ?RPA (+ 5 ?PrecioDinero)))
  (test (neq ?PER 0))
  =>
  (bind ?RE (- (/ (*  (- ?PER ?PERmedio) 20) ?PER) (* 100 ?RPD)))
  (assert (Propuesta
    (Operacion Vender)
    (Empresa ?Nombre)
    (RE ?RE)
    (Explicacion (str-cat "Esta empresa está sobrevalorada porque"
                          ?ExplicacionSobrevalorado
                          ", es mejor amortizar lo invertido, ya que seguramente el PER tan alto deberá bajar al PER medio del sector en unos 5 años, con lo que se debería devaluar un"
                          (* ?RE 100)
                          "% anual, así que aunque se pierda el "
                          (* 100 ?RPD)
                          "% de beneficios por dividendos, saldría rentable"))
    ))
)

; Regla para proponer el cambio de un valor por otro más rentable
(defrule CambiarInversion
  (Modulo (Indice 3))
  (ValorTotal (Valor ?ValorTotal))

  ; Empresa 1
  (Valor (Nombre ?Nombre1) (RPD ?RPD1))
  (not (Sobrevalorado ?Nombre1 ?))
  (or (not (Cartera (Nombre ?Nombre1)))
      (and (Cartera (Nombre ?Nombre1) (Valor ?Valor))
           (test (< (/ ?Valor ?ValorTotal) 0.5))))

  ;Empresa 2
  (Valor (Nombre ?Nombre2 & ~?Nombre1) (RPA ?RPA2))
  (Cartera (Nombre ?Nombre2))
  (not (Infravalorado ?Nombre2 ?))

  ; Comprobación
  (test (> (* 100 ?RPD1) (+ 1 ?RPA2)))
  =>
  (bind ?RE (- (* 100 ?RPD1) (+ 1 ?RPA2)))
  (assert (Propuesta
    (Operacion IntercambiarValores)
    (Empresa ?Nombre1)
    (Empresa2 ?Nombre2)
    (RE ?RE)
    (Explicacion (str-cat  ?Nombre1
                        " debe tener una revalorización acorde con la evolución de la bolsa. Por dividendos se espera un "
                        (* 100 ?RPD1)
                        "%, que es más de lo que ofrece "
                         ?Nombre2
                         ". Por eso te propongo cambiar los valores por los de esta otra. Aunque se pague el 1% del coste del cambio saldría rentable."))
    ))
)


(defrule SalirModulo3
  (declare (salience -1))
  ?f <- (Modulo (Indice 3))
  =>
  (modify ?f (Indice 4))
)
