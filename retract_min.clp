(deftemplate TemplateWithSlot
  (field SSS)
  (field Name)
)

(deffacts name
    (TemplateWithSlot
      (Name template1)
      (SSS 1))
    (TemplateWithSlot
     (Name template2)
     (SSS 2))
    (TemplateWithSlot
      (Name template3)
      (SSS 3))
)

(defrule RetractMin
  (Eliminar TTT menor ?SSS)
  (and (TemplateWithSlot (Name ?N1) (SSS ?S1)) (test (< ?S1 ?SSS)))
  ?f1 <- (TemplateWithSlot (Name ?N1) (SSS ?S1))
  =>
  (retract ?f1)
)
