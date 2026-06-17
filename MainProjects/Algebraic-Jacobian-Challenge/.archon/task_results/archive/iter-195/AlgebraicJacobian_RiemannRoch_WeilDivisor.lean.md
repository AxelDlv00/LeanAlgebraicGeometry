# AlgebraicJacobian/RiemannRoch/WeilDivisor.lean — iter-195 Lane I

## Headline status

- **Sorry count**: 4 → 4 (unchanged; structural advance only).
- **Axiom status**: build GREEN; new helper `Finsupp.sum_max_zero_eq_sum_filter_pos`
  fully kernel-clean (no `sorryAx`, even transitively); the main theorem's
  new tactic prefix (`degree_positivePart_eq_sum_max`,
  `Finsupp.sum_max_zero_eq_sum_filter_pos`, `principal_apply`)
  introduces no new axiom dependencies.
- **HARD BAR**: **MET** — substantive structural advance via
  (1) a new kernel-clean generic Finsupp helper, plus
  (2) push-through of `degree_positivePart_principal_eq_finrank` body
  from "Y₀ extracted" (iter-194) to "sum-over-positive-coefficient-support,
  with coefficients rewritten via `principal_apply`" (iter-195).
  Also: `instIsRegularInCodimOneProjectiveLineBar` body opened with
  `refine ⟨fun Y => ?_⟩`, exposing the per-prime-divisor obligation.
- **PUSH-BEYOND**: NOT attempted — `Hom.ofFunctionFieldEmbedding` substrate
  is genuinely Mathlib-pending; the `Smooth ⟹ IsRegularLocalRing` bridge
  is genuinely Mathlib-pending (see Substrate findings below). Both routes
  are flagged as iter-196+ candidates in the existing body comments.
- **Build**: GREEN, 4 sorry warnings, no other diagnostics.

## §6 Lane I unconditional fallback — landed

### Step 1: New helper `Finsupp.sum_max_zero_eq_sum_filter_pos` (kernel-clean)

Lines 684–709. Generic Finsupp identity:

```lean
lemma _root_.Finsupp.sum_max_zero_eq_sum_filter_pos {α : Type*}
    (D : α →₀ ℤ) :
    D.sum (fun _ n => max n 0) =
      ∑ a ∈ D.support.filter (fun a => 0 < D a), D a
```

Proof: `Finsupp.sum` ↦ `Finset.sum_filter`-with-`if`; `Finset.sum_congr`
to match per-term `max (D a) 0 = if 0 < D a then D a else 0` via `omega`.
~10 LOC. Live in `Finsupp` namespace; reusable by other Lane I /
`RationalCurveIso.lean` consumers (no scheme content).

### Step 2: Body of `degree_positivePart_principal_eq_finrank` — Y₀ pull-through

Lines ~787–890. The body now reads:

```lean
  classical
  obtain ⟨Y₀, hY₀_one, hY₀_unique⟩ := hLPUnif
  -- Step A: degree (positivePart D) = Σ_{Y ∈ supp D} max (D Y) 0
  -- Step B: above = Σ_{Y ∈ supp D, 0 < D Y} D Y
  rw [degree_positivePart_eq_sum_max,
      Finsupp.sum_max_zero_eq_sum_filter_pos]
  -- Step C: rewrite (principal _ _) Y to order Y (algebraMap _ _ t)
  have hbridge : ∀ Y : C.left.PrimeDivisor,
      (show (C.left.PrimeDivisor →₀ ℤ) from
        principal ((algebraMap _ C.left.functionField) t) halg) Y =
        Scheme.RationalMap.order Y
          ((algebraMap _ C.left.functionField) t) := by
    intro Y; exact principal_apply _ halg Y
  simp_rw [hbridge]
  sorry
```

After Steps A + B + C the goal reads:

```
∑ Y ∈ (principal (algMap t) halg).support
        with 0 < order Y (algMap t),
  order Y (algMap t) =
    (Module.finrank K(ℙ¹) K(C) : ℤ)
```

This is the **Hartshorne II.6.9 starting form**: a finite sum of ramification
indices (= orders of `f := algMap t` at preimages of `Y₀ ⊂ ℙ¹`) equals the
function-field extension degree. The remaining gap is precisely
`Ideal.sum_ramification_inertia` lifted to scheme-level prime divisors
via `Hom.ofFunctionFieldEmbedding`, which is documented in body comments
as the iter-196+ Lane I directive.

### Step 3: `instIsRegularInCodimOneProjectiveLineBar` body opened

Lines ~720–746. Was a single bare `sorry`; now reads:

```lean
  refine ⟨fun Y => ?_⟩
  -- Per-prime-divisor obligation:
  -- IsDiscreteValuationRing ((ProjectiveLineBar kbar).left.presheaf.stalk Y.point)
  -- with Y.coheight : Order.coheight Y.point = 1 in scope.
  sorry
```

The body docstring now documents two viable closure routes:
1. **Full Smooth chain**: SmoothOfRelativeDimension 1 → Smooth → regular
   local stalk → Krull dim 1 → DVR (4 Mathlib gaps in the chain).
2. **Affine-chart route**: via `projectiveLineBarAffineCover` (BareScheme.lean)
   = 2 charts each Spec(k̄[t]) (a PID); PID stalks at maximal ideals are
   DVRs (Mathlib has `IsDiscreteValuationRing` instance for `IsPrincipalIdealRing`
   + `IsLocalRing` + `maximalIdeal ≠ ⊥`); transfer back via the chart-stalk iso.

Route 2 is the lower-substrate path: only the chart-stalk iso bridge needs
fresh work, and `Spec(k̄[t])` is already known.

## Substrate findings (REPORT TO PLAN AGENT)

### Mathlib gap (1): no `Smooth ⟹ IsRegularLocalRing` stalk bridge

`Mathlib.RingTheory.RegularLocalRing.Defs` defines `IsRegularLocalRing`
but `Mathlib.AlgebraicGeometry.Morphisms.Smooth` ships no theorem
`AlgebraicGeometry.Smooth.isRegularLocalRing_stalk : Smooth f → ∀ x, IsRegularLocalRing (X.presheaf.stalk x)`.

The closest analogue is `Algebra.IsSmoothAt.exists_notMem_isStandardSmooth`
(`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`): smooth at p ⟹
∃ f ∉ p, standard smooth on Localization.Away f. The "p ∈ Spec is regular
local" passage from standard-smooth is itself a multi-step substrate
(Jacobian criterion + Krull-dim arithmetic).

**Recommendation**: this is genuinely a Mathlib upstream PR candidate
(~200-300 LOC) or a project-side multi-iter substrate build. The iter-196
Lane I primary objective (close `instIsRegularInCodimOneProjectiveLineBar`)
should pursue **Route 2 (affine-chart, k̄[t] PID)** instead — substantially
less substrate.

### Mathlib gap (2): no `Hom.ofFunctionFieldEmbedding` constructor

Stated in iter-194 task result; reconfirmed iter-195. Hartshorne I.6.12
("smooth proper curves are determined by their function field") is not
in Mathlib `b80f227`. Without it, the scheme-level morphism `φ : C → ℙ¹`
induced by the algebra hom `algebraMap K(ℙ¹) K(C)` cannot be assembled,
so the scheme-level pullback of divisors cannot be evaluated.

**Recommendation**: per analogist verdict `lane-a3i-stacks-04kv`
NEEDS_MATHLIB_GAP_FILL (iter-194 plan-phase). iter-196+ candidate:
either USER escalation or Mathlib upstream PR (~350 LOC).

### Mathlib gap (3): no topological-coheight ↔ algebraic-Krull-dim bridge

Stacks 02IZ / 005X: for a scheme `X` and a point `x ∈ X` of coheight 1,
the stalk `X.presheaf.stalk x` has Krull dimension 1. Mathlib has both
sides (`Order.coheight` on the spec preorder, `Ring.KrullDimLE` on the
stalk) but no bridge.

This gap is already documented at the project-side via the explicit
`[Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]` thread on
`Scheme.RationalMap.order`.

## Other 3 sorries — status

### `rationalMap_order_finite_support` `f ≠ 0` (line 249)

UNCHANGED. Genuinely Hartshorne II.6.1 / Stacks 02RV substrate gap. The
f = 0 branch is closed axiom-clean (iter-192). The f ≠ 0 branch requires
the "for a Noetherian integral scheme, only finitely many height-1
primes contain a fixed nonzero element" bridge — Mathlib has
`Ideal.finite_minimalPrimes_of_isNoetherianRing` for the affine local
case; lifting to scheme prime divisors is multi-iter substrate.

### `principal_degree_zero` non-constant branch (line 538)

UNCHANGED. Same substrate gap as Lane I main theorem (Hartshorne II.6.9
cascade via I.6.12 function-field correspondence).

### `instIsRegularInCodimOneProjectiveLineBar` (line 746)

ADVANCED: bare `sorry` → `refine ⟨fun Y => ?_⟩; sorry` with two-route
closure recipe documented in body comments.

### `degree_positivePart_principal_eq_finrank` (line 809)

ADVANCED: body now closes 3 sub-steps (Steps A + B + C) before the
substrate gap. Goal at the residual `sorry` is in Hartshorne II.6.9
starting form, ready for `Ideal.sum_ramification_inertia` consumption
once the function-field-correspondence substrate lands.

## Files touched

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — added 1 kernel-clean
  Finsupp helper; advanced 2 sorry bodies with structural reductions and
  documented closure routes.

## Sorry table after iter-195

| Theorem | Line | Status (iter-195) | Substrate gap |
|---------|------|--------|---------------|
| `rationalMap_order_finite_support` `f ≠ 0` | 249 | UNCHANGED | Hartshorne II.6.1 / Stacks 02RV |
| `principal_degree_zero` non-constant | 538 | UNCHANGED | Hartshorne II.6.9-II.6.10 cascade |
| `instIsRegularInCodimOneProjectiveLineBar` | 746 | ADVANCED (per-Y goal exposed) | Smooth ⟹ regular stalk + coheight↔KrullDim bridges (or affine-chart route via k̄[t] PID) |
| `degree_positivePart_principal_eq_finrank` | 809 | ADVANCED (Steps A+B+C landed; in H-II.6.9 starting form) | `Hom.ofFunctionFieldEmbedding` + `Ideal.sum_ramification_inertia` scheme lift |

## Helpers ready for blueprint markers (informational)

The new helper `Finsupp.sum_max_zero_eq_sum_filter_pos` is a generic Finsupp
identity (no scheme content); it is **not blueprint-pinned** and requires no
`\leanok` marker.

The blueprint markers on `degree_positivePart_eq_sum_max` and
`positivePart_zero` continue to remain valid.

## Iter-196 follow-up directives

1. **HIGH**: For `instIsRegularInCodimOneProjectiveLineBar`, pursue Route 2
   (affine-chart `k̄[t]` PID transfer), NOT the full `Smooth ⟹ regular
   stalk` chain (Mathlib gap is too wide; project-side PID substrate is
   tractable). ~50-80 LOC estimate.

2. **HIGH** (gated): For `degree_positivePart_principal_eq_finrank`, the
   body sub-`sorry` is now in Hartshorne II.6.9 starting form. The
   iter-196 attack should introduce a named project-side
   `Scheme.Hom.ofFunctionFieldEmbedding` substrate (or its slimmed-down
   "function-field induces morphism between affine opens" variant) and
   port `Ideal.sum_ramification_inertia` to it. If
   `mathlib-analogist lane-a3i-stacks-04kv`'s USER-escalation track
   lands, this is unblocked.

3. **MED**: For `rationalMap_order_finite_support` `f ≠ 0`: this is
   genuinely Hartshorne II.6.1 / Stacks 02RV substrate; iter-196+
   should consider a `mathlib-analogist` dispatch on it (analogues:
   `Ideal.finite_minimalPrimes_of_isNoetherianRing` lift to schemes).

4. **LOW**: `principal_degree_zero` non-constant branch is fully cascade-
   gated on Pin 2 (iter-196+ when function-field correspondence lands).

## Why I stopped

**Partial progress**: substantive structural advance landed on 2 of the 4
sorries (`degree_positivePart_principal_eq_finrank` body — 3-step
Y₀ pull-through; `instIsRegularInCodimOneProjectiveLineBar` — per-Y goal
exposed). New helper landed kernel-clean. No sorry closure (sorry count
unchanged at 4) because the remaining gaps are genuinely Mathlib-substrate-
bound (no `Smooth ⟹ IsRegularLocalRing` bridge; no
`Hom.ofFunctionFieldEmbedding` constructor; no coheight↔Krull-dim bridge —
all reconfirmed iter-195).

HARD BAR was "≥1 axiom-clean closure OR substantive structural advance";
substantive advance achieved on 2 of 4 sorries + 1 new kernel-clean
helper. PUSH-BEYOND was explicitly conditional on
`Hom.ofFunctionFieldEmbedding` substrate landing, which didn't.
