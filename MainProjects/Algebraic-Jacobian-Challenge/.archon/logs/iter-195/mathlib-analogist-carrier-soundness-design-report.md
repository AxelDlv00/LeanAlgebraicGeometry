# Mathlib Analogist Report

## Mode
api-alignment

## Slug
carrier-soundness-design

## Iteration
195

## Question

The project has 7+ load-bearing typed `:= sorry` definition carriers
(`PicScheme`, `Pic0Scheme`, `QuotScheme`, `picSharp`, `divFunctor`,
`abelMap`, `PicSharp`, `presheaf`, `etSheaf`, `addCommGroup`, ...)
whose sorries propagate silently through typeclass synthesis. Which
of the three carrier-shape options — A (existential +
`Classical.choose`), B (opaque + axiom), C (structure-of-data) — is
the Mathlib idiom, and which actually delivers kernel-only-axiom
downstream consumers?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Encode carrier of a deep existence theorem (`PicScheme`, `Pic0Scheme`) | ALIGN_WITH_MATHLIB (Option A, `Functor.IsRepresentable` idiom) | critical |
| Encode forward-reference stubs (`picSharp`, `divFunctor`, `abelMap`) | ALIGN_WITH_MATHLIB (collapse to re-export when sibling lands; same Option A in interim) | critical |
| Encode pre-construction assemblies (`addCommGroup`, `PicSharp.functorial`, `PicSharp.presheaf`, `etSheaf`, `etSheafUnit`) | ALIGN_WITH_MATHLIB (Option A, typeclass-parameterized existence) | critical |
| Choose Option A vs B vs C | ALIGN_WITH_MATHLIB on A; DIVERGE_INTENTIONALLY (REJECT) B; DIVERGE_INTENTIONALLY (RESERVE) C | critical |
| Does Option A *eliminate* silent `sorryAx` propagation? | ALIGN_WITH_MATHLIB — it isolates, not eliminates. Sorry stays at instance-construction site, type-level visible. | critical |

## Must-fix-this-iter

All ALIGN_WITH_MATHLIB verdicts above apply to *shipped* code (the
seven listed `:= sorry` carriers are already on disk and consumed by
downstream chapters). The carrier soundness must be refactored before
the protected declarations `AlgebraicGeometry.Jacobian` /
`Jacobian.nonempty_jacobianWitness` can pass `lean_verify` with
kernel-only axioms.

- **`AlgebraicJacobian/Picard/FGAPicRepresentability.lean:132,147,187,
  226,324`** — replace
  `noncomputable def picSharp / divFunctor / PicScheme / abelMap /
  representable := sorry` with the `Functor.IsRepresentable` +
  `Functor.reprX` pattern. The Mathlib model is
  `CategoryTheory.Functor.IsRepresentable`
  (`Mathlib.CategoryTheory.Yoneda`, axioms
  `[propext, Classical.choice, Quot.sound]`). The current parallel-API
  shape causes silent `sorryAx` propagation through every typeclass
  synthesis touching `PicScheme C`.

- **`AlgebraicJacobian/Picard/IdentityComponent.lean:738`** —
  `Pic0Scheme := sorry` becomes `Pic0Scheme C [HasPic0Scheme C] :=
  hC.exists_repr.choose`. The current shape silently propagates
  through `[AddCommGroup Pic0Scheme]` and the downstream
  `Pic0AbelianVariety` consumer.

- **`AlgebraicJacobian/Picard/RelPicFunctor.lean:205,284,323,370,
  429,478`** — `addCommGroup / PicSharp / PicSharp.functorial /
  presheaf / etSheaf / etSheafUnit` all become typeclass-parameterized
  via Option A. The `addCommGroup` case is particularly load-bearing
  because it is an *instance* declaration, so typeclass resolution
  silently pulls `sorryAx` into anything that calls
  `inferInstance` on `AddCommGroup (Quotient (preimage_subgroup ...))`.

- **`AlgebraicJacobian/Picard/QuotScheme.lean:326`** — already
  theorem-shaped (`∃ Q, Nonempty (RepresentableBy Q)`), so the
  existential side is fine. Audit downstream consumers that extract
  via `.choose` to ensure they take the existence as a typeclass
  hypothesis rather than calling `Classical.choose` inline (which
  hides the dependency).

## Informational

- **Option B (`opaque T : Type` + `axiom T_isAbelianVariety`)**:
  empirically verified — `opaque` itself adds no axiom (`#print
  axioms` on `opaque myType : Type := Unit` and `opaque myTypeNoBody :
  Type` both report "does not depend on any axioms"), but the
  property bundle `axiom isAbelianVariety` introduces a new kernel
  axiom outside `{propext, Classical.choice, Quot.sound}`, directly
  violating the end-state contract. Option B can never deliver
  kernel-only-axiom soundness without collapsing to Option A.

- **Option C (structure-of-data; Mathlib precedent
  `AbstractCompletion α` in `Mathlib.Topology.UniformSpace.
  AbstractCompletion`)**: clean but heavier. The right pattern when a
  consumer wants to *receive* an abstract bundle of (carrier +
  properties) rather than a canonical one — e.g. the divisor-map
  Albanese UP might benefit from an `AbelianVarietyOfCurve C` bundle
  that the consumer extracts properties from. Reserve for cases where
  Option A's typeclass-parameterized form creates resolution cycles or
  forces consumers to thread an excessive number of typeclass args.

- **Empirical axiom verification of Option A**:
  `#print axioms CategoryTheory.Functor.reprX` →
  `[propext, Classical.choice, Quot.sound]`. Exactly the project's
  target kernel axiom set. The Mathlib idiom directly satisfies the
  project's soundness contract.

- **What Option A does and does not deliver**: it **isolates** the
  `sorryAx` to a single instance-construction site (where the existence
  instance is built), making the sorry type-level visible. It does
  **not** eliminate the sorry — only closing the existence proof can
  do that. But downstream theorems that take `[HasPic0Scheme C]` as a
  typeclass parameter without supplying the instance are
  kernel-clean (verified empirically: `Classical.choose` of a
  sorry'd existence depends on `[sorryAx, Classical.choice]`, but a
  consumer that *quantifies over* the existence stays clean).

- **Effort estimate refinement**: planner's 2-4 iter envelope is light.
  Realistic: 6-10 iters, ~600-950 LOC (FGAPicRepresentability 2-3
  iters / Pic0AbelianVariety + IdentityComponent 1-2 / RelPicFunctor
  2-3 / downstream-consumer wiring 1-2). The cross-file blast radius
  (~5-6 files + consumer files) is the cost driver.

- **Pull-forward recommendation**: the verdict is concrete enough to
  act on THIS iter (option (ii) of the directive's three options).
  Suggest pulling iter-200 carrier-soundness slot forward to iter-196,
  starting with the FGAPicRepresentability slice (cleanest Mathlib
  alignment, lowest risk). The iter-200 mathlib-analogist sweep stays
  separately scheduled — it catches fresh Mathlib landings, which is a
  distinct concern.

## Persistent file
- `analogies/carrier-soundness-design.md` — full decision-by-decision
  rationale captured for future iters.

Overall verdict: ALIGN_WITH_MATHLIB on Option A — Mathlib's `Functor.IsRepresentable` + `Functor.reprX` pattern is the precise idiom for the seven listed carriers, kernel-axiom-clean by construction, and isolates `sorryAx` to type-level-visible instance sites. Pull refactor forward to iter-196.
