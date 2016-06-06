(defrule DeteccionPeligrosoInestable
  (Cartera (Nombre ?Nombre))
  (Valor (Nombre ?Nombre) (Perd3Consec true))
  (Estabilidad ?Nombre Inestable)
  =>
  (assert (Peligroso ?Nombre "es inestable y ha tenido pérdidas durante tres días"))
)

(defrule DeteccionPeligroso
  (Cartera (Nombre ?Nombre))
  (Valor (Nombre ?Nombre) (Perd5Consec true))
  (not (Peligroso ?Nombre ?))
  =>
  (assert (Peligroso ?Nombre "ha tenido pérdidas durante cinco días"))
)

(defrule DeteccionSobrevaloradosGeneral
  (Valor (Nombre ?Nombre) (EtiqPER Alto) (EtiqRPD Bajo))
  =>
  (assert (Sobrevalorado ?Nombre " tiene un PER alto y un RPD bajo"))
)

(defrule DeteccionSobrevaloradosPeq1
  (Valor (Nombre ?Nombre) (EtiqPER Alto) (Tamano PEQUENIA))
  =>
  (assert (Sobrevalorado ?Nombre " tiene un PER alto siendo pequeña"))
)

(defrule DeteccionSobrevaloradosPeq2
  (Valor (Nombre ?Nombre) (EtiqPER Mediano) (EtiqRPD Bajo) (Tamano PEQUENIA))
  =>
  (assert (Sobrevalorado ?Nombre " tiene un PER mediano y un RPD bajo siendo pequeña"))
)

(defrule DeteccionSobrevaloradosGrande1
  (Valor (Nombre ?Nombre) (EtiqPER Mediano) (EtiqRPD Bajo) (Tamano GRANDE))
  =>
  (assert (Sobrevalorado ?Nombre " tiene un PER mediano y un RPD bajo siendo grande"))
)

(defrule DeteccionSobrevaloradosGrande3
  (Valor (Nombre ?Nombre) (EtiqPER Alto) (EtiqRPD Mediano) (Tamano GRANDE))
  =>
  (assert (Sobrevalorado ?Nombre " tiene un PER alto y un RPD mediano siendo grande"))
)

(defrule DeteccionInfravalorados1
  (Valor (Nombre ?Nombre) (EtiqPER Bajo) (EtiqRPD Alto))
  =>
  (assert (Infravalorado ?Nombre " tiene un PER bajo y un RPD Alto"))
)

(defrule DeteccionInfravalorados2
  (Valor  (Nombre ?Nombre) (EtiqPER Bajo) (VarMes ?vmes) (VarTri ?vtri)
          (VarSem ?vsem) (VarAnual ?vanual))
  (test (or (< ?vtri -30)
            (or (< ?vsem -30) (< ?vanual -30)))
  )
  (test (> ?vmes 0))
  (test (< ?vmes 30))
  =>
  (assert (Infravalorado ?Nombre " la empresa ha caído en los últimos meses y ahora está subiendo y el PER es bajo"))
)

(defrule DeteccionInfravalorados3
  (Valor (Nombre ?Nombre) (Tamano GRANDE) (EtiqRPD Alto) (EtiqPER Mediano)
          (Sector ?Sector) (VarDia ?var))
  (Sector (Nombre ?Sector) (VarDia ?varsector))
  (test (> ?var ?varsector))
  (test (> ?var 0))
  =>
  (assert (Infravalorado ?Nombre " la empresa es grande, el RPD es alto y el PER mediano, no está bajando y funciona mejor que su sector."))
)
