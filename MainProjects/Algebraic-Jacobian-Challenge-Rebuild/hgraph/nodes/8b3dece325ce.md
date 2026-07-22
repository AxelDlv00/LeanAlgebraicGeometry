---
author: sync
content_type: theorem
created: '2026-07-20T02:31:15'
decl: AlgebraicGeometry.ThetaGeneratorSeed.hcolFin_of_forall_fibre
docstring: '**The ambient colength finiteness `hcolFin` from a fibrewise no-leak**:
  the fibrewise

  spelling of `hcolFin_of_forall_closure_subset`, in which the leak is controlled
  over each

  base point separately — the topological shadow of the finite fibre support of the
  divisor

  cut by `eqn z` (produced Zariski-locally on the base by the properness of the relative

  curve).  This is the slot the seed design fills (`d_p`''s finite fibre branch inside
  the

  piece `D(h z)`).'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivColFin.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.hcolFin_of_forall_fibre
type: lean
updated: '2026-07-20T02:31:15'
---
theorem hcolFin_of_forall_fibre
    (hfib : ∀ (z : relCurve C R) (s : Spec (CommRingCat.of R)),
      ((relCurve C R) ↘ Spec (CommRingCat.of R)).base ⁻¹' {s}
          ∩ closure ((D.piece z : Set (relCurve C R)) \
            ((relCurve C R).basicOpen (D.eqn z) : Set (relCurve C R)))
        ⊆ (D.piece z : Set (relCurve C R))) :
    ∀ z : relCurve C R,
      Module.Finite R (Γ(relCurve C R, D.piece z) ⧸ Ideal.span {D.eqn z}) :=
  D.hcolFin_of_forall_closure_subset
    (fun z x hx => hfib z (((relCurve C R) ↘ Spec (CommRingCat.of R)).base x) ⟨rfl, hx⟩)

end ThetaGeneratorSeed

end Seed

/-! ## `hcolFin` at `seedUniv`, reduced to the topological fibre no-leak -/

section SeedUnivColFin

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
variable {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]

noncomputable local instance instOverCleftColFin : C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))] [QuasiCompact (C.left ↘ Spec (.of k))]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g r₁ r₂ : ℕ)
variable (b₁ : Module.Basis (Fin r₁) k
  ↥(Scheme.divisorSections k (windowM_choice π hπ g • fiberWeilDivisor π) ⊤))
variable (b₂ : Module.Basis (Fin r₂) k
  ↥(Scheme.divisorSections k ((windowS_choice π hπ g • fiberWeilDivisor π)
    + (windowM_choice π hπ g • fiberWeilDivisor π)) ⊤))
variable (i : (glueData k g r₁).J) (j : (glueData k g r₂).J)
variable (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
  (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))

set_option maxHeartbeats 2400000 in
-- the seed structure fields carry the huge `DivCarveChartRing`/window/`relThetaSections`
-- types; the colength quotient over the `κ(p)` tower re-elaborates them (recorded hatch)
set_option synthInstance.maxHeartbeats 800000 in
set_option maxSynthPendingDepth 8 in
set_option maxRecDepth 8000 in
include hO hχ in
/-- **`hcolFin` at `seedUniv`, reduced to the topological fibre no-leak** (I-0283 residual):
the ambient colength `Γ(D(h z)) ⧸ (eqn z)` at `seedUniv` is a finite `R_Z`-module as soon
as, on every piece, the closure of the trace `piece z \ D(eqn z)` of the seed-equation
vanishing locus stays inside the piece.  This is exactly the `hcolFin` hypothesis of
`isGenerator_of_fibrewise_ker_span_of_field_vanishing` at `seedUniv`, with all the