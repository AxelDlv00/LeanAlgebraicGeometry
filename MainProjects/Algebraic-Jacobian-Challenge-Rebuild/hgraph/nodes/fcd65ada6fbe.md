---
author: sync
content_type: theorem
created: '2026-08-01T13:18:07'
decl: Algebra.DescentDatum.schemeBaseChangeIso_hom_structureMap
file: AlgebraicJacobian/Descent/AffineSchemeDescent.lean
generated: lean
lean_status: lean_ok
title: Algebra.DescentDatum.schemeBaseChangeIso_hom_structureMap
type: lean
updated: '2026-08-01T13:18:07'
---
theorem schemeBaseChangeIso_hom_structureMap
    (D : Algebra.DescentDatum A B R) [Module.Flat A B] :
    D.schemeBaseChangeIso.hom ≫
        Spec.map (CommRingCat.ofHom (algebraMap B R)) =
      pullback.snd
        (Spec.map (CommRingCat.ofHom (algebraMap A D.descended)))
        (Spec.map (CommRingCat.ofHom (algebraMap A B))) := by
  rw [schemeBaseChangeIso, Iso.trans_hom, Iso.trans_hom, Category.assoc,
    Category.assoc, asIso_hom, ← Spec.map_comp]
  have hring :
      CommRingCat.ofHom (algebraMap B R) ≫
          D.descentEquiv.symm.toRingEquiv.toCommRingCatIso.hom =
        CommRingCat.ofHom (algebraMap B (B ⊗[A] D.descended)) := by
    ext b
    exact D.descentEquiv.symm.commutes b
  rw [hring, pullbackSpecIso_hom_fst', pullbackSymmetry_hom_comp_fst]