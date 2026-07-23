---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.homCechSectionIsoAppFam
docstring: '**Per-degree component of the Čech hom-identification** (family form).'
file: AlgebraicJacobian/Cohomology/CechBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.homCechSectionIsoAppFam
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def homCechSectionIsoAppFam (F : X.PresheafOfModules) (n : SimplexCategory) :
    (homCechCosimplicialFam U F).obj n ≅ (sectionCechCosimplicial U F).obj n :=
  (preadditiveYoneda.obj F).mapIso
      (opCoproductIsoProduct
        (fun σ : Fin (n.len + 1) → ι => freeYoneda.obj (coverInterOpenFam U σ)))
    ≪≫ asIso (piComparison (preadditiveYoneda.obj F)
        (fun σ : Fin (n.len + 1) → ι => Opposite.op (freeYoneda.obj (coverInterOpenFam U σ))))
    ≪≫ Limits.Pi.mapIso (fun σ : Fin (n.len + 1) → ι =>
        (freeYonedaHomAddEquiv (coverInterOpenFam U σ) F).toAddCommGrpIso)