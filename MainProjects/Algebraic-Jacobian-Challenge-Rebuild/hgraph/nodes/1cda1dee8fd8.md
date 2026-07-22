---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.JacobianData.homEquiv_uniqueUpToIso_hom
docstring: 'The intertwining property of `uniqueUpToIso`: composing with the canonical

  isomorphism commutes with the two universal properties.'
file: AlgebraicJacobian/Picard/JacobianData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.JacobianData.homEquiv_uniqueUpToIso_hom
type: lean
updated: '2026-07-17T08:41:25'
---
theorem homEquiv_uniqueUpToIso_hom (d d' : JacobianData C) {T : Over (Spec (.of k))}
    (f : T ⟶ d.J) :
    d'.homEquiv (f ≫ (d.uniqueUpToIso d').hom) = d.homEquiv f := by
  have h : (d.uniqueUpToIso d').hom = d'.rep.homEquiv.symm (d.rep.homEquiv (𝟙 d.J)) := rfl
  rw [homEquiv, homEquiv, h, Functor.RepresentableBy.comp_homEquiv_symm]
  exact (d'.rep.homEquiv.apply_symm_apply _).trans (d.rep.homEquiv_eq f).symm

end JacobianData

/-! ## η-defeq smoke tests (recon §5 lower-order unknown; `example`-level, nothing
registered)

The first test records that `Over.mk d.J.hom ≡ d.J` definitionally (structure eta); the
second that instance resolution crosses it — `smooth_of_grpObj`'s hypothesis
`[GrpObj (Over.mk f)]` at `f := d.J.hom` is discharged by `letI := d.grpObj`; the third
that mathlib's `IsClosedImmersion η[d.J].left` instance fires on `d.J` as-is.  T-chain
and S2 depend on these; if a mathlib bump ever breaks them, a transport lemma must be
added HERE, not in the consumers. -/

section EtaDefeqSmokeTests

open MonObj

variable {C : Over (Spec (.of k))}
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- Smoke test 1: `Over.mk d.J.hom` is definitionally `d.J` — the ascription
elaborates with no transport. -/
noncomputable example (d : JacobianData C) : GrpObj (Over.mk d.J.hom) := d.grpObj

/-- Smoke test 2: `smooth_of_grpObj` applies to `d.J.hom` with no transport lemma;
the group instance must be *keyed* at `Over.mk d.J.hom` (the ascribed `letI` below —