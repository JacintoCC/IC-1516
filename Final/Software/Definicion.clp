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
)

(deffacts PrecioDinero
  (PrecioDinero 0)
)
