(defrule DeteccionPeligrosoInestable
  (Cartera (Nombre ?Nombre))
  (Valor (Nombre ?Nombre) (Perd3Consec true))
  (Estabilidad ?Nombre Inestable)
  =>
  (assert (Peligroso ?Nombre))
)

(defrule DeteccionPeligroso
  (Cartera (Nombre ?Nombre))
  (Valor (Nombre ?Nombre) (Perd3Consec true))
  (Estabilidad ?Nombre Inestable)
  =>
  (assert (Peligroso ?Nombre))
)

(defrule DeteccionSobrevaloradosGeneral
  (Valor (Nombre ?Nombre) (EtiqPER Alto) (EtiqRPD Bajo))
  =>
  (assert (Sobrevalorado ?Nombre))
)

(defrule DeteccionSobrevaloradosPeq1
  (Valor (Nombre ?Nombre) (EtiqPER Alto) (Tamano PEQUENIA))
  =>
  (assert (Sobrevalorado ?Nombre))
)

(defrule DeteccionSobrevaloradosPeq2
  (Valor (Nombre ?Nombre) (EtiqPER Mediano) (EtiqRPD Bajo) (Tamano PEQUENIA))
  =>
  (assert (Sobrevalorado ?Nombre))
)

(defrule DeteccionSobrevaloradosGrande1
  (Valor (Nombre ?Nombre) (EtiqPER Mediano) (EtiqRPD Bajo) (Tamano GRANDE))
  =>
  (assert (Sobrevalorado ?Nombre))
)

(defrule DeteccionSobrevaloradosGrande3
  (Valor (Nombre ?Nombre) (EtiqPER Alto) (EtiqRPD Mediano) (Tamano GRANDE))
  =>
  (assert (Sobrevalorado ?Nombre))
)

(defrule DeteccionInfravalorados1
  (Valor (Nombre ?Nombre) (EtiqPER Bajo) (EtiqRPD Alto))
  =>
  (assert (Infravalorado ?Nombre))
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
  (assert (Infravalorado ?Nombre))
)

(defrule DeteccionInfravalorados3
  (Valor (Nombre ?Nombre) (Tamano GRANDE) (EtiqRPD Alto) (EtiqPER Mediano)
          (Sector ?Sector) (VarDia ?var))
  (Sector (Nombre ?Sector) (VarDia ?varsector))
  (test (> ?var ?varsector))
  (test (> ?var 0))
  =>
  (assert (Infravalorado ?Nombre))
)
