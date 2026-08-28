---
author: sync
content_type: lemma
created: '2026-08-01T05:12:59'
decl: AlgebraicGeometry.AffAdaptation.divisorGluedFamily_compatible
docstring: 'An element of the widened equalizer gives a compatible family of divisor-piece

  sections through the local quotient identifications.'
file: AlgebraicJacobian/Picard/DivisorSubschemeGlobal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.divisorGluedFamily_compatible
type: lean
updated: '2026-08-01T09:44:14'
---
lemma divisorGluedFamily_compatible [IsProper C.hom]
    (A : AffAdaptation D d) (x : ↑(gluedSubalgebra A)) :
    TopCat.Presheaf.IsCompatible A.divisorSubscheme.presheaf
      (fun i : D.index => A.divisorSubschemeι ⁻¹ᵁ D.pieces i)
      (fun i => (A.divisorSubschemePieceIso i).inv.hom (x.1 i)) := by
  intro i j
  apply (ConcreteCategory.bijective_of_isIso
    (A.divisorSubschemeOverlapIso i j).hom).injective
  change (A.divisorSubschemeOverlapIso i j).hom.hom
      ((A.divisorSubscheme.presheaf.map
        (homOfLE (show A.divisorSubschemeι ⁻¹ᵁ (D.pieces i ⊓ D.pieces j) ≤
          A.divisorSubschemeι ⁻¹ᵁ D.pieces i by
            intro y hy
            exact hy.1)).op).hom
        ((A.divisorSubschemePieceIso i).inv.hom (x.1 i))) =
    (A.divisorSubschemeOverlapIso i j).hom.hom
      ((A.divisorSubscheme.presheaf.map
        (homOfLE (show A.divisorSubschemeι ⁻¹ᵁ (D.pieces i ⊓ D.pieces j) ≤
          A.divisorSubschemeι ⁻¹ᵁ D.pieces j by
            intro y hy
            exact hy.2)).op).hom
        ((A.divisorSubschemePieceIso j).inv.hom (x.1 j)))
  have hleft := congrArg
    (fun f => f.hom ((A.divisorSubschemePieceIso i).inv.hom (x.1 i)))
    (A.divisorSubschemePieceIso_res_left i j)
  have hright := congrArg
    (fun f => f.hom ((A.divisorSubschemePieceIso j).inv.hom (x.1 j)))
    (A.divisorSubschemePieceIso_res_right i j)
  calc
    _ = A.toOvlLeft i j
        ((A.divisorSubschemePieceIso i).hom.hom
          ((A.divisorSubschemePieceIso i).inv.hom (x.1 i))) := hleft
    _ = A.toOvlLeft i j (x.1 i) := by rw [Iso.inv_hom_id_apply]
    _ = A.toOvlRight i j (x.1 j) :=
      (A.mem_gluedSubmodule_iff x.1).mp x.2 (i, j)
    _ = A.toOvlRight i j
        ((A.divisorSubschemePieceIso j).hom.hom
          ((A.divisorSubschemePieceIso j).inv.hom (x.1 j))) := by
      rw [Iso.inv_hom_id_apply]
    _ = _ := hright.symm