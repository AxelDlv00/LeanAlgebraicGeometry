# Mathlib Analogist Report

## Mode
api-alignment

## Slug
tensoraway

## Iteration
170

## Question

Does `TensorProduct kbar (HomogeneousLocalization.Away 𝒜 (X i)) (Localization.Away (X ()))`
admit a `CommRing` instance via `inferInstance`? If not, is the missing hop a
real Mathlib gap (i), synthesis-friction with a Mathlib-canonical fix (ii), or
a mistake (iii)? Plus: chart-target alternative? `projGm_isReduced` via same
idiom?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1: existence of CommRing-of-tensor | case (ii) synthesis-friction | high-stakes |
| Q2: canonical fix via `Algebra.compHom` | PROCEED | high-stakes |
| Q3: upstream PR for general `Algebra R` instance | NEEDS_MATHLIB_GAP_FILL (optional) | informational |
| Q4: alternative Localization.Away chart target | DIVERGE_INTENTIONALLY (rejected) | informational |
| Q5: projGm_isReduced via chart-cover | DOWNSTREAM-OF-gmscaling-deep-Q2 | informational |

## Must-fix-this-iter

- **Q1+Q2 (chart-glue blocker)**: declare the 3-line `Algebra.compHom` instance
  in `AlgebraicJacobian/Genus0BaseObjects.lean` immediately after the
  `projectiveLineBarGrading_gradedRing` instance (around L84). Verified
  end-to-end via `lean_run_code`: with this instance in scope, both
  `CommRing (TensorProduct kbar (Away 𝒜 (X i)) (GmRing kbar))` and
  `Algebra kbar (TensorProduct kbar (Away 𝒜 (X i)) (GmRing kbar))` synthesize.

  Exact form:

  ```lean
  /-- `kbar`-algebra structure on `HomogeneousLocalization.Away 𝒜 f` via the
  composition `kbar →+* ↥(𝒜 0) →+* Away 𝒜 f`. -/
  noncomputable instance algebraKbarAway
      (f : MvPolynomial (Fin 2) kbar) :
      Algebra kbar
        (HomogeneousLocalization.Away (projectiveLineBarGrading kbar) f) :=
    Algebra.compHom _ (algebraMap kbar ((projectiveLineBarGrading kbar) 0))
  ```

  The iter-169 prover's note ("likely already there via
  `HomogeneousLocalization.instCommRing` — to verify") was wrong about the
  missing hop. `CommRing (Away 𝒜 _)` IS shipped; what's missing is
  `Algebra kbar (Away 𝒜 _)` because Mathlib only ships
  `Algebra (𝒜 0) (HomogeneousLocalization 𝒜 x)` (no general-base
  `Algebra R` generalization).

## Informational

- **Q3 (upstream PR)**: Mathlib `HomogeneousLocalization.lean:509` ships
  `instance : Algebra (𝒜 0) (HomogeneousLocalization 𝒜 x)`. A ~5-LOC
  generalization to
  `instance [Algebra R (𝒜 0)] : Algebra R (HomogeneousLocalization 𝒜 x)`
  (+ `IsScalarTower` companion) would close the gap for any consumer. Not on
  the iter-170 critical path; file as a follow-up.

- **Q4 (alternative chart target)**: rejected as 10x more expensive than the
  Q2 fix. Once the instance is filled, the `pullbackSpecIso`-based tensor route
  is straightforward; routing through `Localization.Away (X 0 · X 1 · t :
  MvPoly (Fin 3) kbar)` would need a ~30-50-LOC custom iso to identify with the
  shape `pullbackSpecIso` consumes.

- **Q5 (`projGm_isReduced`)**: The chart-cover strategy needs
  `Away 𝒜 (X i) ⊗_{kbar} GmRing` to be a domain (or at least reduced). Mathlib
  does **not** ship "tensor of two `IsDomain` `kbar`-algebras over an
  alg-closed `kbar` is `IsDomain`" as an instance — all such results in
  `Mathlib.RingTheory.LinearDisjoint` and `Mathlib.FieldTheory.LinearDisjoint`
  require `LinearDisjoint` hypotheses. The viable route uses
  `homogeneousLocalizationAwayIso` (see `analogies/gmscaling-deep.md` Q2) to
  identify the chart ring with `kbar[u]`, then `kbar[u] ⊗ kbar[t, t⁻¹] =
  kbar[u, t, t⁻¹]` is a localization of a polynomial ring (hence a domain).
  ~50-80 LOC AFTER `homogeneousLocalizationAwayIso` lands. Keep
  `projGm_isReduced` as scaffold-sorry until then.

## Persistent file
- `analogies/tensoraway-instance.md` — design-rationale captured for future iters.

Overall verdict: chart-glue route (a) for `gmScalingP1` is unblocked by a
3-line `Algebra.compHom` instance — case (ii) synthesis-friction, no upstream PR
required for iter-170; `projGm_isReduced` stays gated on
`homogeneousLocalizationAwayIso`.
