# Lean ↔ Blueprint Check Report

## Slug
chartalgebra-iter153

## Iteration
153

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product}` (chapter: `lem:chart_algebra_isPushout_of_affine_product`)
- **Lean target exists**: yes (ChartAlgebra.lean:92).
- **Signature matches**: yes — `Algebra.IsPushout k B₁ B₂ (TensorProduct k B₁ B₂)`; blueprint prose pins the algebra-level pushout square `k → B₁, k → B₂, → B = B₁ ⊗_k B₂`.
- **Proof follows sketch**: yes (informational) — blueprint documents the honest 3-step scheme-level chain (`pullbackSpecIso` / `isPullback_SpecMap_of_isPushout` / `CommRingCat.isPushout_iff_isPushout`) but the iter-146 NOTE correctly records that the algebra-level lemma collapses to `inferInstance` after re-enabling `Algebra.TensorProduct.rightAlgebra`. Lean body is `inferInstance`. Consistent.
- **notes**: not in this iter's changed set; included for coverage.

### `\lean{AlgebraicGeometry.constants_integral_over_base_field}` (chapter: `lem:constants_integral_over_base_field`)
- **Lean target exists**: yes (ChartAlgebra.lean:508).
- **Signature matches**: **yes**. Lean: `[Field k] [IsAlgClosed k] {X} [X.Over (Spec (.of k))] [IsProper (X ↘ Spec (.of k))] [Smooth (X ↘ Spec (.of k))] [IsReduced X] [GeometricallyIrreducible (X ↘ Spec (.of k))]`, concluding `RingHom.range (appTop.hom) = ⊤`. Blueprint prose ("smooth proper geometrically irreducible scheme over a field k"), the iter-152 alg-closed pivot block (`[IsAlgClosed k]`), and the explicit-`[IsReduced X]` statement-block NOTE together pin exactly these hypotheses and this conclusion.
- **Proof follows sketch**: **yes** — the blueprint's three-step proof (under `[IsAlgClosed k]`) maps step-for-step onto the Lean body:
  - (1) `GeometricallyIrreducible.irreducibleSpace_of_subsingleton` → `isIntegral_of_irreducibleSpace_of_isReduced` → `isField_of_universallyClosed` (Lean L525–529).
  - (2) `finite_appTop_of_universallyClosed` ⇒ `Module.Finite` ⇒ `Algebra.IsIntegral` (Lean L532–539).
  - (3) `IsAlgClosed.algebraMap_bijective_of_isIntegral` ⇒ surjective ⇒ `range = ⊤` via `RingHom.range_eq_top` + `Surjective.of_comp` (Lean L542–551).
- **notes**: Axiom-verified **clean** this iter — `lean_verify` reports `{propext, Classical.choice, Quot.sound}`, **no `sorryAx`**. Statement-block + proof-block `\leanok` are both CORRECT (formalized; body sorry-free). The blueprint correctly prunes the descoped (S3.sep/pi) base-change-to-`\bar k` chain via the iter-152 pivot NOTE; no stale "live" recipe presented.

### `\lean{AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart}` (chapter: `lem:chart_algebra_df_zero_factors_through_constant_on_chart`)
- **Lean target exists**: yes (ChartAlgebra.lean:455).
- **Signature matches**: yes — one-line delegate; carries `[IsAlgClosed k] [CharZero k] [IsDomain B]` propagated from KDM. The iter-152 statement-block NOTE (L1925–1941) documents this propagation and that the four scheme-level typeclasses on `C` are currently decorative.
- **Proof follows sketch**: N/A (live body) — the body is `... mem_range_algebraMap_of_D_eq_zero (n := n) hDb`. The blueprint's full 5-step recipe is the *target*; the proof-block `\leanok` + NOTE honestly state the body is sorry-free in itself but transitively depends on KDM's open `sorry`. Honest, not laundered.
- **notes**: not one of the two directive-named lemmas, but lives in this file; verified consistent.

### `\lean{AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero}` (chapter: `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`)
- **Lean target exists**: yes (ChartAlgebra.lean:270).
- **Signature matches**: **yes**. Lean: `[Field k] [IsAlgClosed k] [CharZero k] {B} [CommRing B] [IsDomain B] [Algebra k B] [Algebra.FiniteType k B] {n} [Algebra.IsStandardSmoothOfRelativeDimension n k B] (hDb : D k B b = 0) : b ∈ (algebraMap k B).range`. Blueprint prose (L2355) names exactly `[Field k] [IsAlgClosed k] [CharZero k]` + `[Algebra.FiniteType k B] [Algebra.IsStandardSmoothOfRelativeDimension n k B] [IsDomain B]` and the same conclusion. The corrective statement-block NOTE (L2336–2354) enumerates the two counterexamples (CE1 `k×k`, CE2 `ℚ(√2)/ℚ`) and which hypothesis kills each — matching the in-Lean counterexample note (L378–404). Full agreement on both sides.
- **Proof follows sketch**: partial-by-design — the blueprint's live route is the reusable polynomial-ring layer (C.a)–(C.c) + the field-of-fractions closer (FT.1)–(FT.3). The Lean body realizes (C.a)–(C.c) (the `_mvPoly_*` helpers L121–229, the `SubmersivePresentation` extraction + `_hFunct` functoriality L354–374) and stops at a single `sorry` (L427) standing in for FT.3. The Lean bright-line note (L398–426) and the blueprint NOTE (L2378–2385) agree that FT.3 (`ker d_{K/k}` = relative algebraic closure of `k` for a separable field extension) is the single residual content and is ABSENT from Mathlib `b80f227`.
- **notes**: Axiom-verified — `lean_verify` reports `sorryAx` present, confirming the open obligation. Statement-block `\leanok` (formalized) CORRECT; proof-block has **no** `\leanok` (L2361 `\begin{proof}` bare) — CORRECT, reflecting the open `sorry`.

## Red flags

None of must-fix or major severity.

### Axioms / sorry (informational, expected)
- `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` at L427: single structured `sorry` (FT.3 Mathlib gap). This is an *expected, documented* open obligation, correctly reflected by the absence of a proof-block `\leanok` in the blueprint. Not a placeholder/laundering pattern: the surrounding ~190 LOC of (C.a)–(C.c) helpers are genuine, and the `sorry` carries a precise bright-line stop note.

## Unreferenced declarations (informational)

- `_finsupp_sub_single_eq_of_one_le`, `_mvPoly_coeff_pderiv_at_shifted`, `_mvPoly_mem_range_C_of_pderiv_eq_zero`, `_mvPoly_mem_range_C_of_D_eq_zero` — `private` helpers for KDM (C.a). The blueprint explicitly names them in (C.a) prose (L2367) as "`private`, not in Mathlib". Correctly scoped; no `\lean{...}` block needed.
- `Scheme.Over.ext_of_diff_zero` (L582) — `\lean`-referenced by `lem:Scheme_Over_ext_of_diff_zero`; thin rename of iter-125 `ext_of_eqOnOpen`, matches blueprint. (Not directive-named; verified consistent in passing.)

## Blueprint adequacy for this file

- **Coverage**: 5/5 substantive theorems have a `\lean{...}` block (`algebra_isPushout_of_affine_product`, `df_zero_factors_through_constant_on_chart`, `constants_integral_over_base_field`, `mem_range_algebraMap_of_D_eq_zero`, `ext_of_diff_zero`). 4 `private` `_mvPoly_*`/`_finsupp_*` helpers are unreferenced but explicitly described as private building blocks in the (C.a) prose. Acceptable.
- **Proof-sketch depth**: **adequate**. For the two directive lemmas the blueprint is more than detailed enough: the `constants_integral_over_base_field` three-step block names every Mathlib lemma the Lean body uses; the KDM block names the (C.a)–(C.c) helpers and the FT.3 residual precisely. A prover could (and did) formalize from this prose.
- **Hint precision**: **precise**. `\lean{...}` targets resolve to the exact declarations; hypotheses on both sides agree class-for-class, including the load-bearing `[IsAlgClosed k]` + `[IsDomain B]` + `[CharZero k]` triple on KDM and `[IsAlgClosed k]` + explicit `[IsReduced X]` on `constants_integral_over_base_field`.
- **Generality**: **matches need**. The iter-152 alg-closed pivot is reflected consistently in both Lean signatures and blueprint prose.
- **Recommended chapter-side actions**: none required this iter. (Optional minor housekeeping noted below.)

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor** (optional, non-blocking):
  - The KDM proof block retains very large SUPERSEDED prose bodies — the (p2) `Differential.ContainConstants` (BR.1)–(BR.5) bridge and the (p1) char-`p` Cartier chain (p1.a)–(p1.f). These are *explicitly* labeled "Superseded … retained as an auditable record only" and the "Closure end state" paragraph (L2434) confirms they are off the critical path, so they are NOT stale-presented-as-live. Still, the live route (FT) is now ~5 lines buried under ~70 lines of provenance; a future blueprint pass could relegate (p1)/(p2)/(BR.*) to an appendix or comment block to keep the live recipe legible. Informational only.
  - Lean body retains `_hFree`/`_basis`/`_hCoordVanish` (BR.2/BR.3) scaffolding as unused `have`/`let`. The blueprint's (p2) NOTE (L2396–2401) already states "(BR.3) … documented but NOT used; (BR.4) instance NOT registered", so this matches the documented disposition — no divergence, just dead scaffolding a future golf pass may prune.

Overall verdict: **PASS** — both directive-named lemmas match their blueprint blocks bidirectionally (signatures, hypotheses, and proof structure all agree), `constants_integral_over_base_field` is verified axiom-clean and its `\leanok` markers are correct, and the KDM lemma's open FT.3 `sorry` is faithfully reflected as an unmarked-proof open obligation with matching `[IsAlgClosed k]`+`[IsDomain B]`+`[CharZero k]` hypotheses on both sides; no must-fix or major findings.
