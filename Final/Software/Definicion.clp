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
  (field RPA
    (default 'NA'))
)

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

(deftemplate Noticia
  (field Nombre)
  (field Tipo)
  (field Antiguedad)
)

(deftemplate Cartera
  (field Nombre)
  (field Acciones)
  (field Valor)
)

(deftemplate Propuesta
  (field Operacion)
  (field Empresa)
  (field RE)
  (field Explicacion)
  (field Empresa2
    (default NA))
  (field Presentada
    (default false))
)

(deftemplate Contador
  (field Indice)
)

(deffacts DeclaracionContador
  (Contador (Indice 0))
)

(deffacts PrecioDinero
  (PrecioDinero 0)
)

(deffunction dive (?a ?b)
   (div (/ ?a ?b) 1))
