# Lean ↔ Blueprint Check Report

## Slug
chartalgebra-iter152

## Iteration
152

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex`

## Summary of the iter-152 pivot verification

Primary directive task — confirm the rewritten chapter's `\lean{...}` blocks and
signatures match the new alg-closed Lean signatures, and that the KDM proof
sketch is consistent with the now-TRUE statement. **Result: the alg-closed
hypotheses are present on BOTH sides for every affected declaration, and the
KDM sketch is rewritten to the correct field-of-fractions argument with both
counterexamples documented.** No critical or must-fix findings.

Build state: `lean_diagnostic_messages` reports exactly two `sorry` warnings
(KDM `mem_range_algebraMap_of_D_eq_zero` at line 256/383; `constants_integral_over_base_field`
at line 468/485) and **no errors**. Both are open-by-design per the directive's
known-issues. All other declarations in the file are sorry-free.

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product}` (lem:chart_algebra_isPushout_of_affine_product)
- **Lean target exists**: yes (line 88).
- **Signature matches**: yes. `Algebra.IsPushout k B₁ B₂ (TensorProduct k B₁ B₂)` matches the chapter's pushout square `k → B₁ / B₂ → B = B₁ ⊗_k B₂`.
- **Proof follows sketch**: yes (informational). Lean closes by `inferInstance` under the locally re-enabled `Algebra.TensorProduct.rightAlgebra`; the chapter NOTE (iter-146/147) records exactly this collapse of the three-step scheme-level chain into one instance resolution.
- **notes**: unaffected by the iter-152 pivot; sorry-free.

### `\lean{AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero}` (lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero)
- **Lean target exists**: yes (line 256).
- **Signature matches**: **yes — alg-closed pivot confirmed on both sides.** Lean: `[Field k] [IsAlgClosed k] [CharZero k]` on `k`; `[CommRing B] [IsDomain B] [Algebra k B] [Algebra.FiniteType k B] [Algebra.IsStandardSmoothOfRelativeDimension n k B]` on `B`. Chapter statement block (lines 2341): "algebraically closed field of characteristic zero `[Field k] [IsAlgClosed k] [CharZero k]` … finite-type standard-smooth … integral domain `[Algebra.FiniteType k B] [Algebra.IsStandardSmoothOfRelativeDimension n k B] [IsDomain B]`". Both `[IsAlgClosed k]` and `[IsDomain B]` present on each side. Conclusion `D b = 0 ⟹ b ∈ range(algebraMap k B)` matches.
- **Proof follows sketch**: partial / open-by-design. The chapter rewrites the proof to the field-of-fractions chain (FT.1)–(FT.3), explicitly deleting the old (false) (C.d) "transfer step", retaining (C.a)–(C.c) as the reusable polynomial-ring layer (matching the in-tree `_mvPoly_*` helpers + `_hFunct`). The Lean body keeps (C.a)–(C.c) scaffolding (`_hFunct` etc.) and concentrates the residual at a single `sorry` (line 383) for the (FT) step. The inline Lean comment (lines 361–382) reproduces both counterexamples (CE1 `B = k×k` excluded by `[IsDomain B]`; CE2 `ℚ(√2)/ℚ` excluded by `[IsAlgClosed k]`) consistently with the chapter NOTE (lines 2322–2340). **The now-TRUE statement and its sketch are mutually consistent.**
- **notes**: open obligation, not unsoundness. The prose is honest about the residual: FT.3 is named "the single residual content of the lemma" (NOTE line 2365–2372), so there is **no** prose-vs-Lean status divergence — the prose does not claim a closed proof.

### `\lean{AlgebraicGeometry.constants_integral_over_base_field}` (lem:constants_integral_over_base_field)
- **Lean target exists**: yes (line 468).
- **Signature matches**: **yes — `[IsAlgClosed k]` confirmed on both sides.** Lean: `{k} [Field k] [IsAlgClosed k] {X} [X.Over (Spec (.of k))] [IsProper …] [Smooth …] [IsReduced X] [GeometricallyIrreducible …] : RingHom.range ((X ↘ Spec (CommRingCat.of k)).appTop.hom) = ⊤`. Chapter statement block carries the iter-152 alg-closed pivot note (line 2261) adding `[IsAlgClosed k]`; conclusion `RingHom.range (appTop.hom) = ⊤` matches. The explicit `[IsReduced X]` discipline is documented (chapter NOTE line 2220–2229; Lean docstring line 460–467).
- **Proof follows sketch**: open-by-design. Chapter gives the collapsed three-step alg-closed proof (integral ⟹ `Γ` is a field; `finite_appTop_of_universallyClosed`; `IsAlgClosed.algebraMap_bijective_of_isIntegral`). Lean body documents exactly this three-step alg-closed re-route (lines 475–484) and ends in `sorry` (line 485). Consistent.
- **notes**: open obligation. Lean comment states "the residual `sorry` is genuine" — honest, no prose-vs-Lean divergence.

### `\lean{AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart}` (lem:chart_algebra_df_zero_factors_through_constant_on_chart)
- **Lean target exists**: yes (line 411).
- **Signature matches**: partial (see minor finding below). Lean carries `[IsAlgClosed k] [CharZero k]` on `k` and `[IsDomain B]` on `B` (propagated this iter so the one-line delegation to KDM typechecks). The chapter statement block prose and its NOTE history (iter-146→148) describe the simplified `(k, C-with-typeclasses, B finite-type, b, hDb)` shape but do **not** explicitly record the iter-152 `[IsAlgClosed k]` + `[IsDomain B]` propagation. Mathematically consistent (delegate to KDM forces them); documentation lag only.
- **Proof follows sketch**: yes for the committed disposition. Lean is a one-line delegate to KDM (line 429); chapter NOTE (lines 1905–1925) explicitly documents this thin-wrapper disposition with the four `C` typeclasses "decorative under the current commitment". Sorry-free.
- **notes**: the five-step recipe (Steps 1–5, chart-Čech MV) remains the load-bearing future target, correctly flagged as not-yet-formalized.

### `\lean{AlgebraicGeometry.Scheme.Over.ext_of_diff_zero}` (lem:Scheme_Over_ext_of_diff_zero)
- **Lean target exists**: yes (line 516).
- **Signature matches**: yes. Lean: `[Field k] {C A : Over (Spec (.of k))} [IsSeparated A.hom] [IsReduced C.left] [GeometricallyIrreducible C.hom] (f g) (U) (hU) (hUf) : f = g`. Matches the iter-146 lighter-hypothesis disposition documented in the chapter NOTE (lines 2448–2462). Not touched by the alg-closed pivot (correctly).
- **Proof follows sketch**: yes for the committed disposition — a thin renaming delegating to `Scheme.Over.ext_of_eqOnOpen`. Sorry-free. The substantive Steps 1–3 derivation remains a documented iter-147+ refinement.
- **notes**: consistent.

## Red flags

None of must-fix or major severity. No placeholder `:= True`/`:= rfl`-on-nontrivial bodies, no excuse-comments masking wrong code, no unauthorized `axiom`/`Classical.choice`. The two `sorry`s are open-by-design obligations whose accompanying prose is honest about their residual status.

## Unreferenced declarations (informational)

- `_finsupp_sub_single_eq_of_one_le` (line 117), `_mvPoly_coeff_pderiv_at_shifted` (line 133), `_mvPoly_mem_range_C_of_pderiv_eq_zero` (line 175), `_mvPoly_mem_range_C_of_D_eq_zero` (line 215): `private` FREE-CASE helpers. **Acceptable** — and in fact the chapter KDM proof block (C.a), lines 2354, names all four by their Lean identifiers, so they are effectively referenced. No `\lean{...}` block needed for `private` helpers.

## Blueprint adequacy for this file

- **Coverage**: 5/5 substantive public declarations have a `\lean{...}` block. The 4 `private` `_mvPoly_*`/`_finsupp_*` helpers are named in the KDM proof prose (C.a). Coverage is complete.
- **Proof-sketch depth**: adequate. The KDM block's (FT.1)–(FT.3) chain plus the retained (C.a)–(C.c) layer, and the constants block's three-step alg-closed proof, give a prover a faithful target. FT.3 (the `ker d_{K/k}` = relative algebraic closure fact) is explicitly flagged as the single residual Mathlib-search item — appropriate signposting.
- **Hint precision**: precise. All `\lean{...}` names resolve to the correct declarations; the alg-closed hypotheses are pinned in the statement-block prose for KDM and constants.
- **Generality**: matches need.
- **Recommended chapter-side actions** (minor, non-blocking):
  1. Add a one-line iter-152 NOTE to the `df_zero_factors_through_constant_on_chart` statement block recording that the Lean signature gained `[IsAlgClosed k]` + `[IsDomain B]` (propagated from KDM), so its NOTE history is not frozen at iter-148.
  2. `\leanok` reconciliation: the proof blocks for KDM (line 2348–2349) and `constants_integral_over_base_field` (line 2265), and their statement blocks, currently carry `\leanok` while the Lean bodies hold `sorry`s. `\leanok` is the deterministic `sync_leanok` phase's domain (not the plan/review agent's), so this should be auto-corrected when `sync_leanok` next walks the chapter; flagged here only so the discrepancy is on record. The *prose* itself is honest about the open residual, so this is a marker-sync lag, not a prose-vs-Lean status divergence.

## Severity summary

- must-fix-this-iter: **none**.
- major: **none**.
- minor:
  - `df_zero` statement block lacks an iter-152 NOTE documenting the `[IsAlgClosed k]`+`[IsDomain B]` propagation (documentation lag; signatures are mathematically consistent via the KDM delegation).
  - Stale `\leanok` on the KDM and constants proof/statement blocks vs. their `sorry`-bearing Lean bodies (deferred to `sync_leanok`; prose is honest).

Overall verdict: **The iter-152 alg-closed pivot is faithfully reflected — `[IsAlgClosed k]` and `[IsDomain B]` are present on both the Lean and blueprint sides for KDM and constants, the KDM sketch matches the now-TRUE field-of-fractions statement with both counterexamples documented, and the two `sorry`s are honest open obligations; only two minor documentation/marker-sync items remain.**
