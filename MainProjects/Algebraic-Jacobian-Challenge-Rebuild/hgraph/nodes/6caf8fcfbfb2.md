---
author: sync
content_type: theorem
created: '2026-07-25T22:22:04'
decl: AlgebraicGeometry.IsAffineOpen.isClosed_zeroLocus_inter_of_finite_quotient
docstring: '**The converse of the abstract (c1) engine.** If the chart-local quotient
  `Γ(X, V) ⧸ I` is

  a finite `R`-module then the closed subscheme it cuts has closed image in `X`.


  The forward direction (`finite_quotient_of_isClosed`) turns closedness into finiteness
  through

  `Spec (Γ(X, V) ⧸ I) ⟶ X ⟶ Spec R`; this runs the same triangle backwards.  Finiteness
  makes

  the composite universally closed, separatedness of `X ⟶ Spec R` transfers that to
  the first

  leg, and a universally closed morphism has closed range.'
file: AlgebraicJacobian/Picard/DivSchemeCertZarC1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.IsAffineOpen.isClosed_zeroLocus_inter_of_finite_quotient
type: lean
updated: '2026-07-25T22:22:04'
---
theorem isClosed_zeroLocus_inter_of_finite_quotient
    [IsSeparated (X ↘ Spec (CommRingCat.of R))]
    (I : Ideal Γ(X, V)) (h : Module.Finite R (Γ(X, V) ⧸ I)) :
    IsClosed (X.zeroLocus (I : Set Γ(X, V)) ∩ (V : Set X)) := by
  have hfin : IsFinite ((Spec.map (CommRingCat.ofHom (Ideal.Quotient.mk I)) ≫ hV.fromSpec)
      ≫ (X ↘ Spec (CommRingCat.of R))) := by
    rw [Category.assoc, hV.specMap_quotient_mk_fromSpec_over]
    exact (IsFinite.SpecMap_iff _).mpr (RingHom.finite_algebraMap.mpr h)
  haveI : UniversallyClosed (Spec.map (CommRingCat.ofHom (Ideal.Quotient.mk I))
      ≫ hV.fromSpec) :=
    UniversallyClosed.of_comp_of_isSeparated _ (X ↘ Spec (CommRingCat.of R))
  rw [← hV.range_specMap_quotient_mk_fromSpec I, ← Set.image_univ]
  exact (Spec.map (CommRingCat.ofHom (Ideal.Quotient.mk I))
    ≫ hV.fromSpec).isClosedMap _ isClosed_univ

end IsAffineOpen

/-! ## Clause (c1) and leak-freeness are the same condition -/

namespace DivisorAdaptation

variable {k : Type u} [Field k] {C : Over (Spec (.of k))} [IsProper C.hom]
variable {R : Type u} [CommRing R] [Algebra k R]
variable {π : C.left ⟶ P1 k} [IsFinite π]
variable {d : (relCurve C R).LocalEquations}
variable (A : DivisorAdaptation C R π d)