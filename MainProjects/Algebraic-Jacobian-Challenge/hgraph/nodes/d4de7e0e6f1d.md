---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.ZariskiDescent.classifyInv
docstring: Inverse comparison to `classifyHom` (the identity on total spaces).
file: AlgebraicJacobian/Picard/ZariskiDescentRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ZariskiDescent.classifyInv
type: lean
updated: '2026-07-24T03:02:12'
---
noncomputable def classifyInv {T : Scheme.{0}} (a : T ⟶ S) (i : ι) :
    (Over.map (U i).ι).obj (Over.mk (preRes U a i)) ⟶
      overRes (Over.mk a) (pre U a i) :=
  Over.homMk (𝟙 (pre U a i).toScheme)
    (by simp only [overRes, Over.mk_hom, Over.map_obj_hom]
        exact (Scheme.Hom.resLE_comp_ι _ _).symm)