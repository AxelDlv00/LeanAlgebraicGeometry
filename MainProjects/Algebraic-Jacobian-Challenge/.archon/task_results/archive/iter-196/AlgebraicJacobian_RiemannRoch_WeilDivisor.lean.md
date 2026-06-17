# AlgebraicJacobian/RiemannRoch/WeilDivisor.lean — iter-196 Lane I

## isRegularInCodimOneProjectiveLineBar (L750)

### Attempt 1 (iter-196): Route 2 PID-transfer via affine chart cover

- **Approach**: Decompose the per-`Y : PrimeDivisor` DVR claim through the
  2-chart cover `projectiveLineBarAffineCover`, the open-immersion
  stalk-iso, the `Spec.stalkIso` reduction to `Localization.AtPrime`, and
  the PID/Dedekind structure on `Away (projectiveLineBarGrading kbar) (X i)`
  (transported via `homogeneousLocalizationAwayIso kbar i` + Mathlib's
  `pUnitAlgEquiv`).
- **Result**: PARTIAL (substantial structural advance, build GREEN, 0 new
  axioms). The proof body now:
  1. Selects the chart `i := 𝒰.idx Y.point` from the affine cover and
     extracts the chart-side witness `y` with `(𝒰.f i).base y = Y.point`.
  2. Establishes the open-immersion stalk-iso
     `(𝒰.f i).stalkMap y : ProjStalk(Y.point) ⟶ ChartStalk(y)` via
     `IsOpenImmersion.iff_isIso_stalkMap`.
  3. Transports `IsDomain` to the chart stalk via the inverse iso
     (`MulEquiv.isDomain _ hiso.symm.commRingCatIsoToRingEquiv.toMulEquiv`).
  4. Reduces the goal to DVR on `Localization.AtPrime y.asIdeal` via
     `Spec.stalkIso`.
  5. Establishes `IsDomain`, `IsPrincipalIdealRing`, and
     `IsDedekindDomain` on the chart ring
     `HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (X i)`
     via the chain of iso's `Away 𝒜 X_i ≃+* MvPolynomial Unit kbar
     ≃+* Polynomial kbar` (Mathlib `Polynomial.instEuclideanDomain` +
     `EuclideanDomain.to_principal_ideal_domain` +
     `IsPrincipalIdealRing.isDedekindDomain`).
  6. Bridges the `(![X 0, X 1]) i = X i` identity (defeq but typeclass
     synthesis doesn't unfold through it without the universal-quantifier
     `intro`+`fin_cases` route).
  7. Applies
     `IsLocalization.AtPrime.isDiscreteValuationRing_of_dedekind_domain`
     with a single named residual `hy_ne_bot : y.asIdeal ≠ ⊥` (the
     topological-to-algebraic Mathlib gap).
  8. Transports the resulting DVR back along `hspecstalk.symm` and `hiso.symm`
     to the original Proj stalk via
     `IsDiscreteValuationRing.RingEquivClass.isDiscreteValuationRing`.
- **Net residual** (named, isolated sorry): `hy_ne_bot : y.asIdeal ≠ ⊥` —
  the bridge from the coheight-1 hypothesis on `Y.point` to the algebraic
  non-zero-prime claim on the chart's `y.asIdeal`. This is precisely the
  Stacks 02IZ / 005X "topological coheight ↔ algebraic Krull dimension"
  gap, isolated cleanly. Estimated closure cost once the bridge lands:
  ~5-10 LOC.
- **Key insights**:
  - The `(![X 0, X 1] : Fin 2 → ...) i = MvPolynomial.X i` defeq does
    NOT auto-elaborate; must prove the universal `∀ j : Fin 2, ...` and
    apply at `i` (the `𝒰.I₀` ↔ `Fin 2` unfolding is invisible to
    `fin_cases`).
  - `CommRingCat.of R` does NOT unfold for typeclass synthesis; need
    `haveI hChartIsDomain : IsDomain ((projectiveLineBarAffineCover kbar).X i)
    := hAwayIsDomain` as an explicit bridge.
  - `IsLocalization.isDomain_of_atPrime` (not `Localization.AtPrime.isDomain`)
    is the correct lemma name for inferring IsDomain on the localization.
  - `IsDiscreteValuationRing.RingEquivClass.isDiscreteValuationRing`
    (not the unqualified `RingEquivClass.isDiscreteValuationRing`) is the
    fully-qualified name inside the `IsDiscreteValuationRing` namespace.

## degree_positivePart_principal_eq_finrank (L1067)

### Status (iter-196 carry-over, no advance this iter)

- **Existing iter-195 structural reduction**: body pushes through
  `degree_positivePart_eq_sum_max` + `Finsupp.sum_max_zero_eq_sum_filter_pos`
  + `principal_apply` (via `hbridge`) to bring the goal to the canonical
  Hartshorne II.6.9 starting form
  `∑ Y ∈ supp(div_f) with 0 < ord_Y f, ord_Y f = (Module.finrank K(ℙ¹) K(C) : ℤ)`.
- **Iter-196 attempt**: surveyed the goal state via `lean_goal` after
  `simp_rw [hbridge]`; the remaining content requires the function-field-
  determines-curve correspondence (Hartshorne I.6.12) to construct the
  scheme morphism `φ : C → ℙ¹` from the function-field embedding, then the
  ramification-inertia formula `Ideal.sum_ramification_inertia +
  Ideal.finrank_quotient_map`. The scheme→ring bridge
  `Scheme.Hom.ofFunctionFieldEmbedding` does NOT ship in Mathlib `b80f227`.
- **Verdict**: substrate gap unchanged; deferred until the function-field
  correspondence lands (iter-197+).

## rationalMap_order_finite_support (L249) — Hartshorne II.6.1 gap

### Status

- **Existing**: f = 0 branch closed axiom-clean (iter-192).
- **Iter-196 attempt**: none. The f ≠ 0 case requires Stacks 02RV "for a
  Noetherian integral scheme, only finitely many height-1 primes can
  divide the numerator or denominator of a nonzero rational function" —
  not in Mathlib `b80f227`. Off-critical-path for the Lane I objective.

## principal_degree_zero (L538) — Hartshorne II.6.10 gap

### Status

- **Existing**: constant branch closed axiom-clean (iter-178+).
- **Iter-196 attempt**: none. Non-constant branch requires the same
  function-field correspondence as `degree_positivePart_principal_eq_finrank`
  (the morphism `φ : C → ℙ¹` from a non-constant rational function). Off
  the Lane I directive's hard bar.

## Summary

- **Sorry count**: 4 → 4 (no net change in count, substantial
  structural advance in the body of `isRegularInCodimOneProjectiveLineBar`).
- **Axioms**: 0 → 0 (kernel-clean).
- **Lines added**: ~150 LOC inside `isRegularInCodimOneProjectiveLineBar`
  proof body.
- **Sorries closed**: none (all 4 remain, but L750's body is now an
  elaborate 8-step structured proof bottoming out at a single,
  named, topological-to-algebraic Mathlib gap).
- **Sorries still open**:
  - L249 `rationalMap_order_finite_support` (Hartshorne II.6.1 substrate)
  - L538 `principal_degree_zero` non-constant (function-field correspondence)
  - L920 `isRegularInCodimOneProjectiveLineBar`'s `hy_ne_bot` residual
    (Stacks 02IZ / 005X)
  - L1067 `degree_positivePart_principal_eq_finrank`
    (Hartshorne II.6.9 + function-field correspondence)
- **Adjacent sorries attempted beyond assignment**: yes — surveyed the
  `degree_positivePart_principal_eq_finrank` body (L1067) but identified
  the residual as the same function-field correspondence gap as
  `principal_degree_zero`, not closable this iter.

## Why I stopped

`Partial progress`: closed 0 sorries but made a **substantial structural
advance** on `isRegularInCodimOneProjectiveLineBar`. The original sorry
(vague "PID transfer ~50-80 LOC owed") is now a precise, named,
single-line `hy_ne_bot : y.asIdeal ≠ ⊥` sorry. The advance:
- Decomposed the per-Y DVR claim into 8 explicit Lean tactic steps.
- Established 3 typeclass-level facts (`IsDomain`, `IsPrincipalIdealRing`,
  `IsDedekindDomain` on `Away (projectiveLineBarGrading kbar) (X i)`) via
  iso-transport, all axiom-clean.
- Set up the chart-stalk identification via `Spec.stalkIso` and
  `IsOpenImmersion.iff_isIso_stalkMap`.
- Reduced the proof obligation to the precise Mathlib gap (Stacks
  02IZ / 005X topological-coheight ↔ algebraic-prime-non-zero).

This is genuine partial progress on the Lane I HARD BAR: the Route 2
recipe has been ported and the residual mathematical content has been
isolated to ~5-10 LOC.

The informal-agent route was unavailable this iter (Kimi/Moonshot API
key returned 401 Invalid Authentication on test); analysis was carried
out via direct Lean LSP exploration.

## Iter-197+ closure path for `hy_ne_bot`

The named residual `y.asIdeal ≠ ⊥` is the bridge:
- The point `y : Spec(Away 𝒜 X_i)` corresponds to `Y.point` of
  `(ProjectiveLineBar kbar).left` via the open immersion `𝒰.f i`. The
  `Y.coheight = 1` hypothesis is the coheight of `Y.point` in the
  projective topology.
- Step A: open immersion preserves coheight at points within its image
  (Stacks 02IZ — opens of locally Noetherian schemes preserve codimension
  data).
- Step B: in a 1-dim integral affine scheme (= `Spec(k̄[t])`), coheight-1
  points are precisely the closed points, i.e. maximal ideals (Stacks
  005X — height/coheight reflect Krull dimension).
- Step C: maximal ideals are non-zero (trivial in a non-field).

Estimated closure: ~5-10 LOC plus the Stacks 02IZ bridge (which may
itself be a small Mathlib upstream PR).
