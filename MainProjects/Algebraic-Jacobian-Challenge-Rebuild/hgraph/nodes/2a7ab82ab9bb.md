---
author: sync
content_type: theorem
created: '2026-07-30T02:30:06'
decl: AlgebraicGeometry.isLocallySurjective_of_bot
docstring: '**The `⊥` instance binder is not a cheap route** — it implies unrestricted
  coverage.


  `Pic0ChartRestrictedFibreSat.lean:93-98` records that at `V = ⊥` antecedent 1 is
  free, so the

  *instance* form of the assembly reduces to the `IsLocallySurjective` binder alone,
  and that

  `not_coverageContainment_bot` refutes the `hcov` *spelling* without touching the
  binder.  This

  closes that loophole from the other side: whoever inhabits the binder at `⊥` has
  thereby

  inhabited it for the unrestricted atlas, which is the full coverage obligation.


  Monotonicity at `U := ⊥` followed by `isLocallySurjective_unrestricted`.  Nothing
  about the Abel

  chart enters.'
file: AlgebraicJacobian/Picard/Pic0ChartVMonotone.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isLocallySurjective_of_bot
type: lean
updated: '2026-07-30T02:30:06'
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