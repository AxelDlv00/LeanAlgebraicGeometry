# Lean ↔ Blueprint Check Report

## Slug
iter197-wd

## Iteration
197

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` (chapter: `def:prime_divisor`)
- **Lean target exists**: yes (line 93)
- **Signature matches**: yes — `structure` with `point : X` and `coheight : Order.coheight point = 1` exactly as blueprint §1 specifies
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present on statement block; consistent with axiom-clean body.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` (chapter: `def:codim1_cycles`)
- **Lean target exists**: yes (line 106)
- **Signature matches**: yes — `X.PrimeDivisor →₀ ℤ` as pinned
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` on statement block; `AddCommGroup` + `Inhabited` instances are helpers (lines 110–116), acceptable as unreferenced.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.order}` (chapter: `def:order_at_point`)
- **Lean target exists**: yes (line 153)
- **Signature matches**: yes — `[IsIntegral X] [IsLocallyNoetherian X] (Y : X.PrimeDivisor) [Ring.KrullDimLE 1 (...)] (f : X.functionField) : ℤ`, body `WithZero.log (Ring.ordFrac ... f)`, matching blueprint's iter-175 pin exactly
- **Proof follows sketch**: N/A (definition with explicit body)
- **notes**: `\leanok` on statement; blueprint §2 still notes the Stacks 02IZ gap (coheight-1 → KrullDimLE-1 bridge not in Mathlib) which is acknowledged and still open — not stale.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}` (chapter: `def:divisor_closed_point`)
- **Lean target exists**: yes (line 283)
- **Signature matches**: yes — `(P : C) (_hP : IsClosed ({P} : Set C)) : C.WeilDivisor` with junk-if-not-codim-1 body
- **Proof follows sketch**: yes
- **notes**: `\leanok` on statement.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_single}` (chapter: `lem:ofClosedPoint_eq_single`)
- **Lean target exists**: yes (line 291)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `by simp [ofClosedPoint, h]`
- **notes**: `\leanok` on statement. Proof block has no separate `\leanok` but proof is trivial/closed.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_zero}` (chapter: `lem:ofClosedPoint_eq_zero`)
- **Lean target exists**: yes (line 300)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `by simp [ofClosedPoint, h]`
- **notes**: `\leanok` on statement.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}` (chapter: `def:divisor_degree`)
- **Lean target exists**: yes (line 322)
- **Signature matches**: yes — `Finsupp.sum D (fun _ n => n)` as pinned
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` on statement.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}` (chapter: `thm:divisor_degree_hom`)
- **Lean target exists**: yes (line 337)
- **Signature matches**: yes — `X.WeilDivisor →+ ℤ` via `Finsupp.liftAddHom`, proving the group-hom claim by construction
- **Proof follows sketch**: yes (homomorphism property is in the type)
- **notes**: `\leanok` on statement. Helper lemmas `degree_hom_apply`, `degree_zero`, `degree_add` are unmarked in the blueprint — acceptable as helpers.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}` (chapter: `def:principal_divisor`)
- **Lean target exists**: yes (line 378)
- **Signature matches**: yes — `[IsIntegral X] [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X] (f : X.functionField) (_hf : f ≠ 0) : X.WeilDivisor` via `Finsupp.ofSupportFinite` with `rationalMap_order_finite_support`
- **Proof follows sketch**: yes — delegates to the private `rationalMap_order_finite_support`
- **notes**: `\leanok` on statement. The private helper `rationalMap_order_finite_support` has a sorry on the `f ≠ 0` branch (line 249) — see Red Flags. `principal` itself has no sorry.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}` (chapter: `thm:principal_hom`)
- **Lean target exists**: yes (line 441)
- **Signature matches**: yes — `(X.functionField)ˣ →* Multiplicative X.WeilDivisor` with explicit `map_one'` and `map_mul'` bodies
- **Proof follows sketch**: yes — each per-`Y` branch reduces to `Ring.ordFrac` multiplicativity + `WithZero.log_mul`/`log_one`, matching the blueprint's "per-DVR axioms" sketch
- **notes**: `\leanok` on statement. Body is axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}` (chapter: `thm:principal_deg_zero`)
- **Lean target exists**: yes (line 503)
- **Signature matches**: yes — full curve-layer typeclass set matches blueprint §1 "Curve layer" pin exactly
- **Proof follows sketch**: partial — constant branch (f ∈ k̄) is closed; non-constant branch remains `sorry` (line 538)
- **notes**: `\leanok` on statement (declaration present). Non-constant branch gated on Hartshorne I.6.12 function-field-determines-curve correspondence + II.6.9 degree-multiplicativity under finite pullback; these are explicitly flagged as sub-build in the blueprint proof. Sorry is expected and acknowledged.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.positivePart}` (chapter: `def:WeilDivisor_positivePart`)
- **Lean target exists**: yes (line 577)
- **Signature matches**: yes — `Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp) D`, matching the blueprint `mapRange` form
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` on statement.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank}` (chapter: `lem:degree_positivePart_principal_eq_finrank`)
- **Lean target exists**: yes (line 1004)
- **Signature matches**: yes — signature matches the iter-194 refactor v2 pin (`t ∈ (ProjectiveLineBar kbar).left.functionField`, `hLPUnif` uniformiser hypothesis) as described in the blueprint NOTE
- **Proof follows sketch**: partial — structural reductions (Steps A–C via `degree_positivePart_eq_sum_max`, `Finsupp.sum_max_zero_eq_sum_filter_pos`, `principal_apply`) are complete; final ramification-inertia bridge (Hartshorne II.6.9 / Stacks 0BE6) remains `sorry` (line 1108)
- **notes**: `\leanok` on statement. Blueprint proof body describes the full `Ideal.sum_ramification_inertia` + `Ideal.finrank_quotient_map` path and explicitly notes the Mathlib gap (`Scheme.Hom.ofFunctionFieldEmbedding` missing as of `b80f227`). Sorry is expected.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` (chapter: `def:linear_equivalence`)
- **Lean target exists**: yes (line 1127)
- **Signature matches**: yes — `∃ (f : X.functionField) (hf : f ≠ 0), D - D' = principal f hf`, matching blueprint definition
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` on statement.

---

## Directive-specific findings (iter-197 audit questions)

### Q1. Does `lem:isRegularInCodimOneProjectiveLineBar` describe the PID-transfer route? Should `hy_ne_bot` step be updated?

**Finding: the label `lem:isRegularInCodimOneProjectiveLineBar` does not exist in the blueprint chapter.**

A thorough search of `RiemannRoch_WeilDivisor.tex` finds no `\label{lem:isRegularInCodimOneProjectiveLineBar}`, no `\lean{...isRegularInCodimOneProjectiveLineBar}`, and no structured proof sketch for this theorem. The blueprint §2 prose (pp. 90–102 of the .tex) discusses the concept of `Scheme.IsRegularInCodimensionOne` as a future typeclass, but there is no blueprint block (`\begin{lemma}...\end{lemma}` + `\lean{...}` pin) for `isRegularInCodimOneProjectiveLineBar` itself.

Consequences:
- There is **no blueprint entry to update** regarding the `hy_ne_bot` step or the Stacks 02IZ route.
- The "now-closed `hy_ne_bot` step" discussion lives entirely in the Lean file's inline comments (lines 917–961); the generic-point-contradiction proof sketch is correctly documented there.
- `sync_leanok` cannot process `isRegularInCodimOneProjectiveLineBar` because there is no `\lean{...}` pin in the chapter.

### Q2. Is the blueprint's proof route for `hy_ne_bot` (Stacks 02IZ coheight bridge) stale?

Not applicable — there is no blueprint proof route to be stale. The Stacks 02IZ mention that appears in the blueprint (in `def:order_at_point`, §2, lines 335–352) is about the separate gap of bridging topological coheight-1 to algebraic `KrullDimLE 1` on the stalk (relevant to `Scheme.RationalMap.order`), not about the `isRegularInCodimOneProjectiveLineBar` proof. That gap remains open and the blueprint description is accurate (not stale).

### Q3. Are the three remaining sorries described with NEEDS_MATHLIB_GAP_FILL framing?

All three open sorries in the file are:
1. **`rationalMap_order_finite_support` (L249)**: `f ≠ 0` case is sorry. Blueprint `def:principal_divisor` (§5) says "Hartshorne's Lemma~6.1 asserts..." — the sub-build dependency is implicit but not explicitly flagged as a Mathlib gap. The Lean comment at L219–227 uses language "Mathlib-upstream-pending gap" and references Stacks 02RV. Blueprint is slightly under-explicit here but functionally OK.
2. **`principal_degree_zero` (L538)**: non-constant branch is sorry. Blueprint proof body says the two auxiliary statements are "slotted to be closed in a follow-up iteration" — gap framing is present but uses "sub-build" language rather than "NEEDS_MATHLIB_GAP_FILL". The Lean comment (L528–538) correctly describes the Hartshorne I.6.12 / Mathlib gap.
3. **`degree_positivePart_principal_eq_finrank` (L1108)**: final step is sorry. The blueprint NOTE (lines 701–726 of .tex) explicitly says "no `Scheme.Hom.ofFunctionFieldEmbedding` constructor ... ships in `b80f227`" — this is the strongest blueprint-side gap framing of the three.

The `NEEDS_MATHLIB_GAP_FILL` vocabulary is an analogist-verdict term from `analogies/` files; the blueprint uses equivalent but different phrasing. This vocabulary mismatch is **minor** and does not affect formalization guidance.

---

## Red flags

### Placeholder / suspect bodies

- `rationalMap_order_finite_support` at line 249: `sorry` on the `f ≠ 0` branch. The blueprint does not cite this private helper directly (it is `private`), but the finsupp construction of `principal` depends on it. The sorry is acknowledged by blueprint §5 sub-build note. **Expected, not a fabrication.**
- `principal_degree_zero` at line 538: `sorry` on non-constant branch. Acknowledged by blueprint proof sub-build note. **Expected.**
- `degree_positivePart_principal_eq_finrank` at line 1108: `sorry` on ramification-inertia bridge. Acknowledged by blueprint NOTE. **Expected.**

None of these rise to "placeholder body on a declaration the blueprint claims is substantive" — all three are acknowledged Mathlib-gap deferments.

### Excuse-comments

None found. The sorry-attached comments accurately describe the mathematical content of the gap and name the specific Mathlib deficiency (Stacks tags, missing constructors). These are appropriate documentation, not excuse-comments.

### Axioms / Classical.choice on non-trivial claims

No `axiom` declarations. `isRegularInCodimOneProjectiveLineBar` (line 750) was previously a typed-sorry theorem; per the directive, its `hy_ne_bot` sorry (the last open sorry in that theorem) was closed in iter-197 via the generic-point-contradiction route, and the theorem is now axiom-clean. No new `sorryAx` propagation through this path.

---

## Unreferenced declarations (informational)

The following Lean declarations have **no `\lean{...}` pin** in the blueprint. Most are helpers; two are substantive.

**Substantive — should be blueprint-pinned:**

| Declaration | Line | Nature |
|---|---|---|
| `Scheme.IsRegularInCodimensionOne` | 178 | Project-bespoke typeclass; used as a typeclass argument in every subsequent declaration in the file. Blueprint §2 prose references it but provides no `\lean{...}` pin. |
| `isRegularInCodimOneProjectiveLineBar` | 750 | Proof that `(ProjectiveLineBar kbar).left` satisfies `IsRegularInCodimensionOne`; now **fully axiom-clean** (iter-197). No blueprint entry exists. The iter-197 delta (closing `hy_ne_bot` via generic-point contradiction) is documented only in Lean inline comments. |
| `instIsLocallyNoetherianProjectiveLineBar` | 734 | Instance that `(ProjectiveLineBar kbar).left` is locally Noetherian; **axiom-clean** (uses only `IsProper.toLocallyOfFiniteType`). No blueprint entry. |

**Helper (acceptable as unreferenced):**

`Scheme.IsRegularInCodimensionOne.instIsDiscreteValuationRingStalk` (189), `instKrullDimLEStalk` (200), `rationalMap_order_finite_support` (227, private), `principal_apply` (392), `Scheme.RationalMap.order_one` (409), `principal_one` (420), `degree_hom_apply` (341), `degree_zero` (348), `degree_add` (353), `positivePart_zero` (582), `degree_positivePart_eq_sum_max` (597), `positivePart_single` (610), `degree_single` (622), `one_le_degree_positivePart_principal_of_order_one` (636), `Finsupp.sum_max_zero_eq_sum_filter_pos` (697).

---

## Blueprint adequacy for this file

- **Coverage**: 14/33 declarations have a `\lean{...}` pin. Of the 19 unreferenced, 16 are helpers (acceptable). The 3 substantive unreferenced items (`Scheme.IsRegularInCodimensionOne`, `isRegularInCodimOneProjectiveLineBar`, `instIsLocallyNoetherianProjectiveLineBar`) are flagged above.

- **Proof-sketch depth**: **adequate for the 14 pinned declarations.** The blueprint is notably detailed for `def:order_at_point` (full Mathlib API path, typeclasses), `lem:degree_positivePart_principal_eq_finrank` (step-by-step ramification-inertia recipe), and `thm:principal_deg_zero` (two-branch structure). The three open-sorry declarations match the blueprint's sub-build structure. **Under-specified / silent for `isRegularInCodimOneProjectiveLineBar`** — no blueprint entry at all, so a prover had zero blueprint guidance for this proof, which is now complete.

- **Hint precision**: **precise** for all 14 pinned declarations. The iter-174/175/176/177/190/194 plan-phase pins are correctly reflected in the Lean signatures.

- **Generality**: **matches need** for the 14 pinned items.

- **Recommended chapter-side actions (for a blueprint-writing subagent):**
  1. Add a `\begin{theorem}...\end{theorem}` block for `isRegularInCodimOneProjectiveLineBar` with `\lean{AlgebraicGeometry.isRegularInCodimOneProjectiveLineBar}`, referencing the PID-transfer route (steps A–D in the Lean inline comments) and the iter-197 generic-point-contradiction proof of `hy_ne_bot`. Since the theorem is now axiom-clean, the proof sketch should describe the closed proof, not a "pending" route.
  2. Add a `\begin{definition}` block for `Scheme.IsRegularInCodimensionOne` with `\lean{AlgebraicGeometry.Scheme.IsRegularInCodimensionOne}` — the §2 prose is already present conceptually; just needs a proper `\lean{...}` pin.
  3. Optionally add a `\begin{lemma}` block for `instIsLocallyNoetherianProjectiveLineBar` since its proof is now axiom-clean.
  4. For `rationalMap_order_finite_support`: consider adding a `\begin{lemma}` for "Hartshorne 6.1 (finite support)" with explicit Stacks 02RV attribution and `NEEDS_MATHLIB_GAP_FILL` annotation; currently only implicitly covered under `def:principal_divisor`.

---

## Severity summary

| Finding | Severity |
|---|---|
| `isRegularInCodimOneProjectiveLineBar` (now axiom-clean) has no blueprint entry; `lem:isRegularInCodimOneProjectiveLineBar` does not exist in chapter | **major** |
| `Scheme.IsRegularInCodimensionOne` class (used in every subsequent signature) has no `\lean{...}` pin | **major** |
| `instIsLocallyNoetherianProjectiveLineBar` (axiom-clean) has no blueprint entry | **minor** |
| Three sorries in `rationalMap_order_finite_support`, `principal_degree_zero`, `degree_positivePart_principal_eq_finrank` all correctly framed as Mathlib-gap sub-builds in the blueprint | no issue |
| Blueprint "Stacks 02IZ coheight bridge" description (in `def:order_at_point`) is not stale — it refers to the still-open `KrullDimLE` bridge, not the now-closed `hy_ne_bot` | no issue |
| NEEDS_MATHLIB_GAP_FILL vocabulary absent in blueprint (analogist-vocab term; blueprint uses equivalent language) | **minor** |

**Overall verdict**: 14 blueprint-pinned declarations are correctly formalized and match their chapter entries; the three open sorries are properly framed as acknowledged Mathlib gaps; the principal iter-197 delta (`hy_ne_bot` closure) is correctly documented in the Lean file but has no corresponding blueprint entry, creating two major blueprint-coverage gaps (`isRegularInCodimOneProjectiveLineBar` untracked; `Scheme.IsRegularInCodimensionOne` unpinned).
