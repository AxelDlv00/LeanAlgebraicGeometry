# Lean ↔ Blueprint Check Report

## Slug
wd-iter200

## Iteration
200

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (1439 LOC)
- Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` (960 LOC)

---

## Per-declaration (existing `\lean{...}` pins)

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` (def:prime_divisor)
- **Lean target exists**: yes (L94)
- **Signature matches**: yes — `structure Scheme.PrimeDivisor (X : Scheme.{u}) where point : X; coheight : Order.coheight point = 1`
- **Proof follows sketch**: N/A (definition)
- **notes**: Blueprint pin and Lean structure are exact matches. `\leanok` marker present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` (def:codim1_cycles)
- **Lean target exists**: yes (L107)
- **Signature matches**: yes — `def Scheme.WeilDivisor (X : Scheme.{u}) : Type u := X.PrimeDivisor →₀ ℤ`
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present; no mismatch.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.order}` (def:order_at_point)
- **Lean target exists**: yes (L253)
- **Signature matches**: yes — blueprint §2 pins `{X : Scheme.{u}} [IsIntegral X] [IsLocallyNoetherian X] (Y : X.PrimeDivisor) [Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)] (f : X.functionField) : ℤ`; Lean body matches exactly.
- **Proof follows sketch**: yes — body is `WithZero.log (Ring.ordFrac (X.presheaf.stalk Y.point) f)` as pinned.
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}` (def:divisor_closed_point)
- **Lean target exists**: yes (L569)
- **Signature matches**: yes — `(P : C) (_hP : IsClosed ({P} : Set C)) : C.WeilDivisor`, junk-defined as described.
- **Proof follows sketch**: yes — dependent-if on `Order.coheight P = 1` matches blueprint description.
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_single}` (lem:ofClosedPoint_eq_single)
- **Lean target exists**: yes (L577)
- **Signature matches**: yes — `(h : Order.coheight P = 1) : ofClosedPoint P hP = Finsupp.single ⟨P, h⟩ 1`
- **Proof follows sketch**: yes — one-line simp on the positive branch.
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_zero}` (lem:ofClosedPoint_eq_zero)
- **Lean target exists**: yes (L586)
- **Signature matches**: yes — negative-branch counterpart.
- **Proof follows sketch**: yes.
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}` (def:divisor_degree)
- **Lean target exists**: yes (L608)
- **Signature matches**: yes — `(D : X.WeilDivisor) : ℤ := (D : X.PrimeDivisor →₀ ℤ).sum (fun _ n => n)`
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}` (thm:divisor_degree_hom)
- **Lean target exists**: yes (L623)
- **Signature matches**: yes — `X.WeilDivisor →+ ℤ` built via `Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)`.
- **Proof follows sketch**: yes — lifting the identity on ℤ is the canonical packaging of "sum of coefficients as a group hom."
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.rationalMap_order_finite_support}` (lem:rationalMap_order_finite_support)
- **Lean target exists**: yes, as `private theorem rationalMap_order_finite_support` (L477)
- **Signature matches**: yes — `(f : X.functionField) : (Function.support (fun Y : X.PrimeDivisor => Scheme.RationalMap.order Y f)).Finite`
- **Proof follows sketch**: partial — `f = 0` branch closed axiom-clean (L488–494); `f ≠ 0` branch has `sorry` at L535.
- **notes**: Declaration is `private`; blueprint already has a `% NOTE:` acknowledging this and that `sync_leanok` may not resolve private decls cleanly. The sorry is one of the 3 known open sorrys. Statement `\leanok` is correct (declaration exists with sorry). No new issue.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}` (def:principal_divisor)
- **Lean target exists**: yes (L683)
- **Signature matches**: yes — `[IsIntegral X] [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X] (f : X.functionField) (_hf : f ≠ 0) : X.WeilDivisor` via `Finsupp.ofSupportFinite`.
- **Proof follows sketch**: yes — uses `Finsupp.ofSupportFinite ... (rationalMap_order_finite_support f)` as described.
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}` (thm:principal_hom)
- **Lean target exists**: yes (L746)
- **Signature matches**: yes — `(X.functionField)ˣ →* Multiplicative X.WeilDivisor`
- **Proof follows sketch**: yes — closes coordinate-wise from `Ring.ordFrac` multiplicativity + `WithZero.log_mul` / `WithZero.log_one`, matching blueprint's "per-prime-divisor DVR identities" description.
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}` (thm:principal_deg_zero)
- **Lean target exists**: yes (L808)
- **Signature matches**: yes — curve-layer typeclass set matches blueprint §1 "Curve layer" pin exactly.
- **Proof follows sketch**: partial — constant branch closed axiom-clean; non-constant branch has `sorry` at L843 (known, documented).
- **notes**: `\leanok` present on statement block; proof block correctly unmarked.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.positivePart}` (def:WeilDivisor_positivePart)
- **Lean target exists**: yes (L882)
- **Signature matches**: yes — `Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp) D`
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank}` (lem:degree_positivePart_principal_eq_finrank)
- **Lean target exists**: yes (L1309)
- **Signature matches**: yes — uniformiser hypothesis `hLPUnif` matches iter-194 refactor v2 pin in blueprint.
- **Proof follows sketch**: partial — Steps A and B (finsupp reductions via `degree_positivePart_eq_sum_max` + `Finsupp.sum_max_zero_eq_sum_filter_pos`) and Step C (`principal_apply` bridge) are closed; main Hartshorne II.6.9 ramification-inertia chain has `sorry` at L1413 (known, documented).
- **notes**: Statement `\leanok` is correct.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` (def:linear_equivalence)
- **Lean target exists**: yes (L1432)
- **Signature matches**: yes — `∃ (f : X.functionField) (hf : f ≠ 0), D - D' = principal f hf`
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present.

**Overall: all 15 existing `\lean{...}` pins survive the 1318 → 1439 LOC structural growth. No broken pins.**

---

## Red flags

### Placeholder / suspect bodies
None beyond the 3 documented open sorrys (L535, L843, L1413). All sorrys are:
- Marked with detailed comments explaining the mathematical gap and resolution path.
- In declarations whose statement blocks are `\leanok`-marked.
- Not new this iter (3 → 3 unchanged).

### Excuse-comments
None. All comments are informative (explain mathematical gaps, Mathlib-upstream opportunities, resolution paths). None say "this is wrong but works for now."

### Axioms / Classical.choice on non-trivial claims
No `axiom` declarations in the file.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` blueprint pin.

### Substantive (should be in blueprint):

| Declaration | Line | Status |
|---|---|---|
| `Scheme.IsRegularInCodimensionOne` (class) | L278 | Blueprint prose says "Iter-173+ **may** introduce this predicate" — but it **was** introduced. Stale prose; missing pin. |
| `Scheme.PrimeDivisor.restrictToOpen` | L162 | One of 8 new iter-200 declarations. Core bijection construction; no pin. |
| `Scheme.PrimeDivisor.ofOpen` | L174 | One of 8 new iter-200 declarations. Inverse construction; no pin. |
| `Scheme.PrimeDivisor.equivOpen` | L195 | One of 8 new iter-200 declarations. Packages the bijection as an `Equiv`; no pin. |
| `Scheme.PrimeDivisor.stalkIso` | L210 | One of 8 new iter-200 declarations. Key stalk identification (Stacks 02IZ); no pin. |
| `Scheme.IsRegularInCodimensionOne.instOpen` | L305 | One of 8 new iter-200 declarations. DVR-descent along open immersion; no pin. |

### Helper-only (acceptable without blueprint block):

- `Scheme.IsRegularInCodimensionOne.instIsDiscreteValuationRingStalk` (L289) — bridge instance
- `Scheme.IsRegularInCodimensionOne.instKrullDimLEStalk` (L320) — bridge instance
- `Scheme.PrimeDivisor.ext` (L153) — ext lemma (boilerplate)
- `Scheme.PrimeDivisor.restrictToOpen_point` (L182, `@[simp]`) — simp unfolding
- `Scheme.PrimeDivisor.ofOpen_point` (L187, `@[simp]`) — simp unfolding
- `Scheme.RationalMap.order_zero`, `order_mul_of_ne_zero`, `order_inv`, `order_units_inv`, `order_neg`, `order_pow_of_ne_zero`, `order_one` (L354–L720) — algebraic identities for `order`; support `def:order_at_point` prose
- `Scheme.WeilDivisor.degree_hom_apply`, `degree_zero`, `degree_add`, `degree_neg`, `degree_sub` (L627–L662) — immediate consequences of `degree_hom`
- `principal_apply` (L697) — structural unfolding helper
- `principal_one` (L725) — direct consequence
- `positivePart_zero`, `degree_positivePart_eq_sum_max`, `positivePart_single`, `degree_single` (L887–L932) — helpers for lem:degree_positivePart_principal_eq_finrank
- `one_le_degree_positivePart_principal_of_order_one` (L941) — intermediate step helper
- `Finsupp.sum_max_zero_eq_sum_filter_pos` (L1002) — Mathlib-level finsupp identity
- `instIsLocallyNoetherianProjectiveLineBar` (L1039) — instance; derivable from properness
- `isRegularInCodimOneProjectiveLineBar` (L1055) — typed-sorry theorem (demoted from instance per iter-196 audit)

---

## Blueprint adequacy for this file

### Coverage
- 15 / 15 `\lean{...}`-referenced declarations have matching Lean targets.
- 6 declarations without `\lean{...}` pins are substantive enough to warrant blueprint coverage (`Scheme.IsRegularInCodimensionOne` class + 5 of the 8 new iter-200 declarations).
- 24+ helper declarations are acceptably unpin'd.

### Proof-sketch depth
**Adequate** for the original 9 pinned declarations (proof sketches in the blueprint are detailed enough to guide formalization). **Silent** for the 8 new iter-200 declarations — the blueprint chapter has no prose, no sketch, no `\lean{...}` pin for any of them. The prover used the analogies file (`wd-stacks02iz.md`) and task results rather than the blueprint chapter.

### Hint precision
**Precise** for existing 15 pins — all `\lean{...}` tags name the correct fully-qualified declaration.

One stale prose issue: blueprint §2 says "Iter-173+ *may* introduce a `Scheme.IsRegularInCodimensionOne` predicate to abbreviate this" — the class WAS introduced (L278), making this language stale. The `\lean{...}` pin was never added.

### Generality
**Matches need** for the original pinned declarations.

### Recommended chapter-side actions

A blueprint-writing subagent should add, before iter-201+ dispatches the prover for Sub-build 2:

1. **New section** (between §2 and the current §3): `\section{Open-immersion descent for prime divisors}` (citing Stacks 02IZ, iter-183 substrate in `AlgebraicJacobian/Albanese/CoheightBridge.lean`), covering:
   - `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.restrictToOpen}` with definition block
   - `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.ofOpen}` with definition block
   - `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.equivOpen}` with bijection statement block
   - `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.stalkIso}` with statement block (Stacks 02IZ stalk side)
   - `\lean{AlgebraicGeometry.Scheme.IsRegularInCodimensionOne.instOpen}` with descent instance block

2. **Update stale prose** in §2 "Standing hypothesis (*) in the Lean encoding": replace "Iter-173+ *may* introduce a `Scheme.IsRegularInCodimensionOne` predicate to abbreviate this" with a confirmed statement, add `\lean{AlgebraicGeometry.Scheme.IsRegularInCodimensionOne}` pin.

3. **Lean file header note** (informational only, read-only): the module header still says "## Status (iter-172 file-skeleton)" with a claim of 9 pinned declarations with sorry bodies — this is stale at iter-200, but it's in the Lean file (outside the checker's write domain).

---

## Severity summary

| Finding | Severity | Blocks |
|---|---|---|
| 5 substantive iter-200 declarations missing `\lean{...}` blueprint pins (`restrictToOpen`, `ofOpen`, `equivOpen`, `stalkIso`, `instOpen`) | **major** | blueprint not updated to reflect HARD BAR work |
| `Scheme.IsRegularInCodimensionOne` class missing `\lean{...}` pin (stale "may introduce" prose) | **major** | blueprint inconsistency since iter-173+ |
| No blueprint section for open-immersion descent; iter-201+ Sub-build 2 (`Ring.ordFrac` transport) will use these declarations | **soon** | iter-201+ prover guidance incomplete; Lean docstrings substitute but blueprint should be authoritative |
| 3 known open sorrys (L535, L843, L1413) | advisory (known) | documented; not new |
| All 15 existing `\lean{...}` pins resolve after 1318 → 1439 LOC growth | no issue | — |
| No axioms, no excuse-comments, no placeholder bodies outside documented sorrys | no issue | — |

**Overall verdict**: The existing 15 blueprint pins are clean and resolve correctly; the chapter is adequate for the original 9 pinned declarations. However, the 8 iter-200 open-immersion declarations are entirely absent from the blueprint — 5 of them are substantive (not helper-only) and require `\lean{...}` pins and prose; the missing section and stale "may introduce" language represent a **major** chapter gap that a blueprint-writing dispatch should address before iter-201+ sends the Sub-build 2 prover.
