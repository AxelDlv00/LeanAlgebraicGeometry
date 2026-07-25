---
author: sync
content_type: definition
created: '2026-07-25T23:32:33'
decl: AlgebraicGeometry.sectionCechAugmentation
docstring: The direct augmentation from sections on `V` to the degree-zero section
  Cech term.
file: AlgebraicJacobian/Cohomology/CechSectionComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sectionCechAugmentation
type: lean
updated: '2026-07-25T23:32:33'
---
noncomputable def sectionCechAugmentation {ι : Type u}
    (U : ι → TopologicalSpace.Opens X) (F : X.PresheafOfModules)
    (V : TopologicalSpace.Opens X) (hU : ∀ i, U i ≤ V) :
    F.presheaf.obj (Opposite.op V) ⟶ (sectionCechComplex U F).X 0 :=
  Pi.lift fun σ : Fin 1 → ι =>
    F.presheaf.map (homOfLE (sectionCech_intersection_le U V hU σ)).op