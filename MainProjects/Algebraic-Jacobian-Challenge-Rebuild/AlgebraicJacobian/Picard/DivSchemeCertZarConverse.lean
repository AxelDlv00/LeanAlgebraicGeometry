/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/

import AlgebraicJacobian.Picard.DivSchemeCertZarTransport

/-!
# (c1) forces leak-freeness — the converse the certificate verdict rested on

The DD-R lane's chart-confinement verdict (`DivSchemeCertZarConn.lean`) is stated for
adaptations that are *leak-free at every piece*, and its docstrings — together with memory
I-0209 and the roadmap — assert that certificate clause **(c1)** (`Module.Finite R
(A.colength j)`) *forces* leak-freeness.  Only the sufficient directions were ever proved
(`finite_colength_of_supportLeak_eq_empty`, `finite_colength_of_isClopen_trace`, …); the
converse was asserted nowhere-proved, which left the verdict a statement about one
*sufficient-condition assembler* rather than about `IsCertified` itself.

This file supplies the converse, so the verdict becomes a statement about the interface.

The route reverses the landed (c1) engine (`SupportTubeFinite.lean`) rather than adding
geometry.  `A.colength j = Γ(X, pieces j) ⧸ (eqn j)`, and `pieces j` is a basic open of an
affine pinned chart, so `Spec (colength j) ⟶ X` has range exactly
`supportLocus ∩ pieces j` (`range_specMap_quotient_mk_fromSpec`).  Finiteness of the colength
makes `Spec (colength j) ⟶ Spec R` a finite morphism, hence universally closed; the composite
*is* that morphism (`specMap_quotient_mk_fromSpec_over`), and the ambient structure morphism
is **separated** (the properness licence), so universal closedness cancels
(`UniversallyClosed.of_comp_of_isSeparated`) to give a closed map into `X`.  Its image is the
trace, which is therefore closed — i.e. nothing leaks.

## Main declarations

* `AlgebraicGeometry.IsAffineOpen.isClosed_zeroLocus_of_finite_quotient` — the abstract
  converse engine, ideal-valued.
* `AlgebraicGeometry.DivisorAdaptation.supportLeak_eq_empty_of_finite_colength` — (c1) at a
  piece forces leak-freeness at that piece.
* `AlgebraicGeometry.DivisorAdaptation.IsCertified.forall_supportLeak_eq_empty` — a certified
  adaptation is leak-free at every piece, with no extra hypothesis.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits TopologicalSpace Opposite

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

namespace IsAffineOpen

variable {X : Scheme.{u}} {V : X.Opens} (hV : IsAffineOpen V)
variable {R : Type u} [CommRing R] [X.Over (Spec (CommRingCat.of R))]

include hV in
/-- **The converse of the (c1) engine.** If the chart quotient `Γ(X, V) ⧸ I` is a finite
`R`-module, the vanishing set of `I` on `V` is closed in `X`.

Only **separatedness** of the ambient structure morphism is used (not universal closedness):
finiteness makes `Spec (Γ(X, V) ⧸ I) ⟶ Spec R` universally closed, and separatedness of
`X ⟶ Spec R` lets that be cancelled to a closed map `Spec (Γ(X, V) ⧸ I) ⟶ X`, whose image is
the vanishing set. -/
theorem isClosed_zeroLocus_of_finite_quotient
    [IsSeparated (X ↘ Spec (CommRingCat.of R))]
    (I : Ideal Γ(X, V)) (hfin : Module.Finite R (Γ(X, V) ⧸ I)) :
    IsClosed (X.zeroLocus (I : Set Γ(X, V)) ∩ (V : Set X)) := by
  -- the structure map of the chart quotient is finite, so its `Spec` is universally closed
  haveI hfinSpec : IsFinite (Spec.map
      (CommRingCat.ofHom (algebraMap R (Γ(X, V) ⧸ I)))) := by
    rw [IsFinite.SpecMap_iff]
    exact RingHom.finite_algebraMap.mpr hfin
  -- that `Spec` factors as `Spec (Γ/I) ⟶ X ⟶ Spec R`
  have hfactor := hV.specMap_quotient_mk_fromSpec_over (R := R) I
  haveI huc : UniversallyClosed
      ((Spec.map (CommRingCat.ofHom (Ideal.Quotient.mk I)) ≫ hV.fromSpec) ≫
        (X ↘ Spec (CommRingCat.of R))) := by
    rw [Category.assoc, hfactor]
    infer_instance
  -- cancel the separated structure morphism of `X`
  haveI : UniversallyClosed
      (Spec.map (CommRingCat.ofHom (Ideal.Quotient.mk I)) ≫ hV.fromSpec) :=
    UniversallyClosed.of_comp_of_isSeparated _ (X ↘ Spec (CommRingCat.of R))
  -- a universally closed morphism is a closed map, and the range is the vanishing set
  have hrange := hV.range_specMap_quotient_mk_fromSpec I
  rw [← hrange, ← Set.image_univ]
  exact Scheme.Hom.isClosedMap _ _ isClosed_univ

end IsAffineOpen

/-! ## The adaptation form: (c1) forces leak-freeness -/

namespace DivisorAdaptation

variable {k : Type u} [Field k] {C : Over (Spec (.of k))} [IsProper C.hom]
variable {R : Type u} [CommRing R] [Algebra k R]
variable {pi : C.left ⟶ P1 k} [IsFinite pi]
variable {d : (relCurve C R).LocalEquations}
variable (A : DivisorAdaptation C R pi d)

/-- **(c1) at a piece forces leak-freeness at that piece.** The converse the chart-confinement
verdict rested on: a finite colength makes the piece trace of the support closed, i.e. the
leak locus empty.

This is what turns `DivSchemeCertZarConn.lean`'s verdict from a statement about the
sufficient-condition assembler into a statement about `IsCertified` itself. -/
theorem supportLeak_eq_empty_of_finite_colength (j : A.index)
    (hfin : Module.Finite R (A.colength j)) :
    d.supportLeak (A.pieces j) = ∅ := by
  refine (d.isClosed_supportLocus_inter_iff_supportLeak_eq_empty (A.pieces j)).mp ?_
  rw [A.supportLocus_inter_pieces j]
  have hclosed := (A.toFinCoverData.isAffineOpen_pieces j).isClosed_zeroLocus_of_finite_quotient
    (R := R) (Ideal.span {A.eqn j}) hfin
  -- the vanishing set of `(eqn j)` on the piece is the piece minus the basic open
  have heq : (relCurve C R).zeroLocus
        (U := A.pieces j)
        ((Ideal.span {A.eqn j} : Ideal Γ(relCurve C R, A.pieces j)) :
          Set Γ(relCurve C R, A.pieces j))
      ∩ (A.pieces j : Set (relCurve C R))
      = (A.pieces j : Set (relCurve C R))
        \ ((relCurve C R).basicOpen (A.eqn j) : Set (relCurve C R)) := by
    rw [Scheme.zeroLocus_span, Scheme.zeroLocus_singleton]
    ext x
    simp only [Set.mem_inter_iff, Set.mem_sdiff, SetLike.mem_coe, Set.mem_compl_iff]
    exact ⟨fun h => ⟨h.2, h.1⟩, fun h => ⟨h.2, h.1⟩⟩
  rwa [heq] at hclosed

/-- **A certified adaptation is leak-free at every piece.** Clause (c1) of `IsCertified` is
exactly the per-piece finiteness, so the verdict machinery applies to any certified
adaptation with no additional hypothesis. -/
theorem IsCertified.forall_supportLeak_eq_empty {n : ℕ} (hc : A.IsCertified n) :
    ∀ j : A.index, d.supportLeak (A.pieces j) = ∅ :=
  fun j => A.supportLeak_eq_empty_of_finite_colength j (hc.finite_colength j)

end DivisorAdaptation

end AlgebraicGeometry
