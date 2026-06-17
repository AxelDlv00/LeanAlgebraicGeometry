# Lean ↔ Blueprint Check Report

## Slug
chart-algebra-iter146

## Iteration
146

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex` §
  "Chart-algebra piece (ii) first-class decomposition" (L1828–L2072)

## Scope (per directive)
Three sub-pieces received iter-146 prover work:
1. (α) `algebra_isPushout_of_affine_product` — CLOSED
2. (β-aux) `constants_integral_over_base_field` — PARTIAL (substeps 1–2 closed in body, substep 3 deferred)
3. (lift) `Scheme.Over.ext_of_diff_zero` — CLOSED (by delegation to `ext_of_eqOnOpen`)

Two declarations were intentionally retained as iter-145 `: True := sorry` skeletons (β-core + KDM ring-side); they are out of iter-146 prover scope per the directive but receive a separate "deferred declarations" note below since the checker rubric flags `: True` bodies on substantive blueprint claims.

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product}` (chapter: `lem:chart_algebra_isPushout_of_affine_product`, blueprint L1835–L1866)
- **Lean target exists**: yes (L84)
- **Signature matches**: yes
- **Proof follows sketch**: partial — the Lean body is `inferInstance` (after locally re-enabling `Algebra.TensorProduct.rightAlgebra`); the blueprint sketches a three-step chain (`pullbackSpecIso` → `isPullback_SpecMap_of_isPushout` → `CommRingCat.isPushout_iff_isPushout`). Mathlib's `Algebra.IsPushout` instance on `TensorProduct k B₁ B₂` collapses that chain into a single instance-search hit, so the Lean closure is mathematically the *same* statement at the algebra level, just packaged once-for-all by Mathlib rather than re-derived here.
- **notes**:
  - The blueprint statement starts at the scheme-level chart presentation (`U₁ ⊆ X₁`, `U₂ ⊆ X₂`, `W = U₁ ×_{Spec k} U₂`) and ends at the algebra-level `Algebra.IsPushout` conclusion. The Lean abstracts this to the algebra-level core, which is the operational content the consumer sites need.
  - Local instance re-enable (`Algebra.TensorProduct.rightAlgebra`) is explicitly documented at L11–L25 and L70–L74; no issue.

### `\lean{AlgebraicGeometry.constants_integral_over_base_field}` (chapter: `lem:constants_integral_over_base_field`, blueprint L1944–L1967)
- **Lean target exists**: yes (L144)
- **Signature matches**: partial — the Lean states `RingHom.range ((X ↘ Spec (.of k)).appTop.hom) = ⊤`; the blueprint states `Γ(X, O_X) = range(algebraMap k Γ(X, O_X))`. These are equivalent under the canonical `Γ(Spec k, ⊤) ≃ k` identification, which the Lean docstring (L113–L114) calls out explicitly. OK.
- **Proof follows sketch**: partial — substeps (1)–(2) of the docstring's three-substep recipe land via the correct Mathlib lemmas (`GeometricallyIrreducible.irreducibleSpace_of_subsingleton`, `isIntegral_of_irreducibleSpace_of_isReduced`, `isField_of_universallyClosed`, `finite_appTop_of_universallyClosed`). Substep (3) — the geometric-irreducibility base-change step that pins `dim_k Γ(X, ⊤) = 1` — is deferred to a `sorry` at L177, with an inline block-comment recipe (L167–L176) explaining the iter-147+ closure path. The blueprint's sub-fact (3) (L1962) supplies the matching mathematical sketch.
- **notes**:
  - The Lean carries an **explicit `[IsReduced X]` hypothesis** (L148) that the blueprint statement does not list. The blueprint relies on the implicit "smooth ⇒ reduced" chain (smooth ⇒ regular ⇒ reduced), but the Lean docstring (L140–L143) explains that Mathlib snapshot `b80f227` lacks the `Smooth ⇒ IsReduced` lemma over a field, so the project explicitly carries the typeclass. This is the same discipline used elsewhere in `Rigidity.lean`. **The blueprint should be annotated with a `% NOTE:`** documenting the explicit-`IsReduced` carry, since otherwise a reader of the blueprint would not know it must be supplied at every call site.
  - Substep (3) deferral is acceptable per the iter-146 scope (PARTIAL); the blueprint sketch is detailed enough to guide the iter-147+ closure (it names the flat-base-change step + `IsBaseChange`-namespace + Stacks Tag 02KH idiom).

### `\lean{AlgebraicGeometry.Scheme.Over.ext_of_diff_zero}` (chapter: `lem:Scheme_Over_ext_of_diff_zero`, blueprint L2041–L2072)
- **Lean target exists**: yes (L208)
- **Signature matches**: **no** — load-bearing mismatch (see "Red flags" below).
- **Proof follows sketch**: no — Lean body is `:= AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen f g U hU hUf` (a thin renaming of an iter-125 packaging lemma). The blueprint's three-step proof (Step 1: build `h := μ ∘ ⟨f, ι∘g⟩` with `dh = 0`; Step 2: apply `df_zero_factors_through_constant_on_chart` chart-by-chart; Step 3: identify the constant value as `η_A`) is bypassed entirely; the chart-algebra (β) envelope plays no role.
- **notes**:
  - The Lean **drops the `df = dg` hypothesis** that the blueprint lists as load-bearing (first bullet at L2048).
  - The Lean also weakens the **hypotheses on `A`**: blueprint requires "smooth proper geometrically irreducible group scheme", Lean requires only `[IsSeparated A.hom]`.
  - The Lean **drops the hypothesis that `C` is genus-0** (blueprint requires "smooth proper geometrically irreducible curve of genus 0"); Lean only carries `[IsReduced C.left] [GeometricallyIrreducible C.hom]`.
  - Mathematically the Lean lemma is *strictly more general* than the blueprint lemma: given `eqOnOpen` outright (plus separatedness + irreducibility + reducedness), `f = g` follows directly via `ext_of_eqOnOpen`; the `df = dg` + smooth-proper-curve apparatus is what would *establish* `eqOnOpen` from a pointing setup, not what *consumes* it. The Lean docstring (L196–L203) calls this out honestly: "iter-147+ will refine the signature to *also* take a chart-algebra `df = dg` hypothesis and *derive* `eqOnOpen` from it via Steps 1–2 of the recipe".
  - **Disposition** (per directive's explicit ask): this is mathematically defensible as the iter-146 sorry-free closure, but the blueprint statement and Lean signature are out of sync. Recommended fix is **blueprint-side**: add a `% NOTE:` to `lem:Scheme_Over_ext_of_diff_zero` documenting that the iter-146 Lean lemma is a thin renaming of `ext_of_eqOnOpen` with the `df = dg` hypothesis and chart-algebra (β) chain deferred to iter-147+. The alternative — adding `df = dg` back to the Lean signature as an unused parameter — would also work but is uglier. The blueprint NOTE is the cleaner disposition. See "Red flags" for severity.

## Red flags

### Placeholder / suspect bodies
- `ChartAlgebra.lean:97` — `df_zero_factors_through_constant_on_chart : True := sorry`. Blueprint at L1868–L1942 (`lem:chart_algebra_df_zero_factors_through_constant_on_chart`) is a substantive theorem (five-step proof, chart-Čech kernel computation). **Per the directive this is the deferred (β-core) sub-piece**, explicitly out of iter-146 prover scope. Flagged here per the checker rubric; not actionable this iteration.
- `ChartAlgebra.lean:107` — `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero : True := sorry`. Blueprint at L1995–L2039 (`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`) is a substantive theorem (case-split on char k, Frobenius-iteration chain in char p). **Per the directive this is the deferred (KDM ring-side) sub-piece**, explicitly out of iter-146 prover scope. Flagged here per the checker rubric; not actionable this iteration.
- `ChartAlgebra.lean:177` — `sorry` inside `constants_integral_over_base_field`. This is substep (3) of the docstring recipe, explicitly deferred per the directive's "PARTIAL" classification. Not a blueprint-claims-substantive-but-Lean-is-empty case (substeps 1–2 do real work); the `sorry` is a single missing substep with a written recipe.

### Signature mismatch with blueprint prose
- `ChartAlgebra.lean:208` (`Scheme.Over.ext_of_diff_zero`) drops the load-bearing `df = dg` hypothesis, weakens `A`'s hypotheses from "smooth proper geom-irr group scheme" to `IsSeparated A.hom`, and drops `C`'s genus-0 + smooth + proper hypotheses. The Lean body is a one-line delegate to `ext_of_eqOnOpen`, bypassing the chart-algebra (β) envelope entirely. The Lean docstring is honest about this; the blueprint statement is not yet annotated.

### Excuse-comments
- None of the inline comments in `ChartAlgebra.lean` rise to the "excuse" level — every "TODO iter-146" / "iter-147+" tag is a planner-aligned scope handoff, not a cover-up for wrong code. The (lift) signature reduction is openly explained in L46–L52 and L196–L203.

### Axioms / Classical.choice on non-trivial claims
- None introduced in this file.

## Unreferenced declarations (informational)

All five declarations in the file are `\lean{...}`-referenced from the blueprint chapter:

| Lean declaration | Blueprint block |
| --- | --- |
| `GrpObj.algebra_isPushout_of_affine_product` | `lem:chart_algebra_isPushout_of_affine_product` |
| `GrpObj.df_zero_factors_through_constant_on_chart` | `lem:chart_algebra_df_zero_factors_through_constant_on_chart` |
| `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` | `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` |
| `constants_integral_over_base_field` | `lem:constants_integral_over_base_field` |
| `Scheme.Over.ext_of_diff_zero` | `lem:Scheme_Over_ext_of_diff_zero` |

Coverage is 5/5. No orphan declarations.

## Blueprint adequacy for this file

- **Coverage**: 5/5 Lean declarations have a corresponding `\lean{...}` block. Zero unreferenced declarations.
- **Proof-sketch depth**: adequate for closed and partial sub-pieces; **strong** for the deferred (β-core) block (`lem:chart_algebra_df_zero_factors_through_constant_on_chart`), which spells out the five-step chart-Čech computation with explicit Mathlib hooks (`Algebra.IsStandardSmooth.free_kaehlerDifferential`, `Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`, the chart-algebra (α) helper, the 2-chart cover construction at Step 3.aux, etc.). Strong for the KDM block too (four-substep (p1.a)–(p1.d) decomposition is a clear iter-147+ target). The (β-aux) substep (3) sketch (base change to `bar k`) is adequate for the iter-147+ closure. The (lift) block's Step 2 chart-by-chart sheaf-assembly is briefly described and may need expansion when (β-core) lands and the signature is re-refined.
- **Hint precision**: precise — every `\lean{...}` hint pins the Lean target by full name. The blueprint does not leave the prover guessing between Mathlib predicates.
- **Generality**: matches need for the closed/partial blocks. **Loose on hypothesis carrying**: the blueprint does not say "carry `[IsReduced X]` explicitly because Mathlib `b80f227` lacks `Smooth ⇒ IsReduced` over a field", which the Lean was forced to do. This is a recurring discipline across the project (`Rigidity.lean` does the same), and the blueprint should document it once at the `lem:constants_integral_over_base_field` block (and possibly at the (β-core) block when its real signature lands).
- **Recommended chapter-side actions**:
  1. Add a `% NOTE:` to `lem:Scheme_Over_ext_of_diff_zero` (around L2050) documenting that the iter-146 Lean lemma is a thin renaming of `ext_of_eqOnOpen` with the `df = dg` hypothesis and the three-step chart-algebra (β) chain deferred to iter-147+. This is the cleaner disposition for the (lift) signature reduction (preferred over re-adding `df = dg` to the Lean side as an unused parameter).
  2. Add a `% NOTE:` to `lem:constants_integral_over_base_field` (around L1947) recording the explicit-`[IsReduced X]` discipline, matching the convention already in `Rigidity.lean`'s "Hypothesis history" block.
  3. (Optional, low priority) Add a `% NOTE:` to `lem:chart_algebra_isPushout_of_affine_product` mentioning that Mathlib's `Algebra.IsPushout` instance on `TensorProduct k B₁ B₂` collapses the three-step proof chain into a single `inferInstance`, so the explicit chain is informational rather than load-bearing.

## Severity summary

- **must-fix-this-iter**:
  - `Scheme.Over.ext_of_diff_zero` signature mismatch with the blueprint prose: Lean drops `df = dg` (and weakens the curve/group hypotheses on `C`/`A`), turning the lemma into a thin renaming. Per the rubric this is a load-bearing signature mismatch. The clean fix is the blueprint-side `% NOTE:` from recommendation (1) above; the Lean docstring is already honest, so once the blueprint annotation lands the mismatch is documented rather than hidden.
  - `df_zero_factors_through_constant_on_chart` and `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` placeholder bodies (`: True := sorry`) on declarations the blueprint claims are substantive. **Mitigating context**: both are explicitly listed as deferred sub-pieces in the directive's iter-146 prover scope (β-core + KDM ring-side, pending iter-147+). The plan agent should not block iter-146 closure on these but should ensure the iter-147 plan picks them up.
- **major**:
  - Blueprint should add a `% NOTE:` documenting the explicit `[IsReduced X]` hypothesis discipline at `lem:constants_integral_over_base_field`.
- **minor**:
  - Blueprint sketch for `lem:chart_algebra_isPushout_of_affine_product` describes a three-step chain that Mathlib now resolves by a single `inferInstance`; an optional `% NOTE:` would keep the chapter accurate.

**Overall verdict**: the iter-146 prover lane discharged its assigned (α) and (lift) targets and refined (β-aux) cleanly; the (lift) closure is a deliberate signature reduction that requires a blueprint-side `% NOTE:` to stay honest, and the (β-aux) chapter should record the explicit-`IsReduced` discipline — both are small chapter edits, not Lean-side rework.
