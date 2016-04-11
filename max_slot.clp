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

(defrule FindMax
  (TemplateWithSlot (Name ?N1) (SSS ?S1))
  (not  (and (TemplateWithSlot (Name ?) (SSS ?S2)) (test(> ?S2 ?S1))))
  =>
  (assert (Max ?N1 ?S1))
)
