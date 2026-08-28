---
author: sync
content_type: theorem
created: '2026-07-30T02:30:06'
decl: AlgebraicGeometry.isLocallySurjective_of_bot
docstring: '**The `⊥` instance binder implies unrestricted coverage — and the binder
  is UNINHABITABLE, so

  this theorem is vacuous.**


  `Pic0ChartRestrictedFibreSat.lean:93-98` records that at `V = ⊥` antecedent 1 is
  free, so the

  *instance* form of the assembly reduces to the `IsLocallySurjective` binder alone,
  and that

  `not_coverageContainment_bot` refutes the `hcov` *spelling* without touching the
  binder.  The

  statement below approaches that loophole from the other side: whoever inhabits the
  binder at `⊥`

  has thereby inhabited it for the unrestricted atlas.


  **The honest reading, added after the binder was refuted.**  `Pic0ChartBotRefute.lean`
  proves the

  hypothesis below is false for *every* chart family, so nothing will ever be fed
  to this theorem.

  It is not "the `⊥` route costs the full coverage obligation" — there is no `⊥` route.  Keep
  the

  theorem: the implication is what makes the refutation''s *consequence* for larger
  `V` immediate, and

  `isLocallySurjective_unrestricted` (its non-vacuous sibling, hypothesis at an arbitrary
  `V`) is

  unaffected.


  Monotonicity at `U := ⊥` followed by `isLocallySurjective_unrestricted`.  Nothing
  about the Abel

  chart enters.'
file: AlgebraicJacobian/Picard/Pic0ChartVMonotone.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isLocallySurjective_of_bot
type: lean
updated: '2026-08-01T09:44:16'
---
theorem isLocallySurjective_of_bot {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (h : Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc fun i => restrictChart (f i) (⊥ : (X i).Opens))) :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f) :=
  isLocallySurjective_unrestricted (C := C) f (fun _ => ⊥) h

/-! ## The nested-open assembly, and why it buys nothing

The two monotonicities make a *two-open* form of the seam stateable: certify `hf` at the larger
open, coverage at the smaller.  That form is a genuine generalisation of
`pic0RepresentableBy_of_restrictedChartFibre` — and it is *equivalent* to it, which is the
point of stating both. -/

variable (C π) in