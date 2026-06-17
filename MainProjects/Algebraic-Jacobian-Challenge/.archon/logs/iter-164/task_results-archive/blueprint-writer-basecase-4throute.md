# Blueprint Writer Report

## Slug
basecase-4throute

## Status
COMPLETE — genus-0 base case rewritten to the direct ℙ¹×𝔾 rigidity ("4th") route; Thm 3.2
demoted to Route-A-only. Two strategy-modifying findings surfaced (see last section).

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Changes Made
- **Rewrote chapter intro prose** (the chain overview): now describes the 4th route — compose
  `h := σ ≫ f` with the total translation action `σ : ℙ¹×𝔾_a → ℙ¹`, apply the proven additive
  decomposition (Cor 1.5, first-factor-only-complete), get `f|_{𝔾_a}` an additive hom, kill it
  with `Hom(𝔾_a,A)=0`. States Thm 3.2 / Cor 1.2 are retained only as Route-A inputs, off the
  genus-0 path.
- **Rewrote the §I.3 section intro** similarly (load-bearing ingredients = Cor 1.5 + def:gaTranslationP1).
- **Added definition** `\definition`/`\label{def:genus0_base_objects}`/`\lean{AlgebraicGeometry.ProjectiveLineBar}` [expected] — concrete ℙ¹, 𝔾_a (=AffineSpace 𝔸(1) + GrpObj), 𝔾_m over k̄, with their distinguished points, charts, and finiteness/properness. Expected Lean names `Ga`, `Gm` noted in prose.
- **Added definition** `\definition`/`\label{def:gaTranslationP1}`/`\lean{AlgebraicGeometry.gaTranslationP1}` — the translation action `σ(x,y)=x+y` with the explicit two-chart total-morphism computation (`1/(x+y)=u/(1+uy)` regular at `u=0`), plus the **𝔾_m-scaling companion** `σ_× : ℙ¹×𝔾_m → ℙ¹`, `(x,λ)↦λx` (expected Lean name `gmScalingP1`).
- **Added lemma** `\lemma`/`\label{lem:hom_Ga_to_av_trivial}`/`\lean{AlgebraicGeometry.hom_Ga_to_av_trivial}` — `Hom(𝔾_a,A)=0`: an additive-group homomorphism `𝔾_a → A` into an abelian variety is the constant `η[A]`. Proof sketch added: primary = completeness/image argument (image is closed subgroup ⇒ complete; quotient of affine ⇒ affine; connected complete+affine = point via the Γ=k̄ collapse already in `lem:eq_comp_of_isAffine_of_properIntegral`); plus Milne's elementary 𝔾_a/𝔾_m incompatibility (full algebra given) for the case where φ extends to ℙ¹.
- **Added remark** `\label{rmk:base_case_fourth_route}` — frames the 4th route AND records the **scaling-shortcut** (strategy finding): `σ_× ≫ f = pr₁ ≫ f` because `0` is a scaling fixed point, hence `f|_{𝔾_m}` constant, hence `f` constant by density — bypassing 𝔾_a-additivity and `lem:hom_Ga_to_av_trivial` entirely.
- **Rewrote** `lem:hom_from_Ga_trivial` (statement + proof, same `\lean{AlgebraicGeometry.morphism_Ga_to_av_const}`): now the 4th-route proof (σ ≫ f → Cor 1.5 → additive hom → `Hom(𝔾_a,A)=0`). `\uses` updated to `{thm:rigidity_lemma, lem:hom_additivity_over_product, def:gaTranslationP1, lem:hom_Ga_to_av_trivial}`; **removed** the `lem:rational_map_to_av_extends` edge. Appended the scaling-shortcut as recommended simplification.
- **Demoted** `lem:rational_map_to_av_extends` (Thm 3.2): added a "Route-A-only (iter-164)" paragraph to its statement; reframed `rmk:thm32_codim1_mathlib_gap` from "IS on the genus-0 critical path" to "is NOT on the genus-0 path — confined to Route A".
- **Updated** `rmk:cube_not_needed` to the σ-action derivation (was: "via … Theorem 3.2 … then 𝔾_a/𝔾_m incompatibility").
- **Updated** `prop:morphism_P1_to_AV_constant` proof: base point `0` (not `∞`), 4th-route argument, Thm 3.2 not invoked; removed the old additive-defect/𝔾_a-𝔾_m prose and the `lem:av_regular_map_is_hom` aside.

## Cross-references introduced
- `\uses{def:genus0_base_objects}` in `def:gaTranslationP1` — both new, this chapter.
- `\uses{def:genus0_base_objects, def:gaTranslationP1, lem:hom_additivity_over_product, lem:eq_comp_of_isAffine_of_properIntegral}` in `lem:hom_Ga_to_av_trivial` — all earlier in this chapter. ✓
- `\uses{thm:rigidity_lemma, lem:hom_additivity_over_product, def:gaTranslationP1, lem:hom_Ga_to_av_trivial}` in `lem:hom_from_Ga_trivial` — all earlier. ✓
- Verified: no genus-0 block `\uses` `lem:rational_map_to_av_extends` any longer (all remaining mentions are prose `\cref`). Environment begin/end counts balanced (lemma 12/12, definition 2/2, proof 15/15, remark 6/6). Graph is forward-acyclic.

## References consulted
- `references/abelian-varieties.md` — Milne contents map; confirmed Prop 3.9/3.10 location (§I.3, doc p.19–20, PDF p.25–26) and the page-offset convention.
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` — the prior-session-verified verbatim Milne Prop 3.9 statement + proof quotes (reused; see PDF-renderer note below).
- (Attempted) `references/abelian-varieties.pdf` pages 25–26 — **could not render**: `pdftoppm` / poppler-utils not installed on this host, so the Read tool refused the PDF pages. I therefore did NOT author any new verbatim `% SOURCE QUOTE` from the PDF this session; the Prop 3.9 quotes on the new `lem:hom_Ga_to_av_trivial` are copied from the verified in-tree copy already on `lem:hom_from_Ga_trivial`, with an explicit `% NOTE (iter-164)` flagging this. No fabricated citations.

## Macros needed (if any)
- None new. `\fatsemi` (already locally defined, line 8) is reused; ℙ¹/𝔸¹/𝔾_a/𝔾_m use standard `\mathbb`.

## Notes for Plan Agent
- The new `\lean{...}` targets needing Lean scaffolds: `AlgebraicGeometry.ProjectiveLineBar`, `AlgebraicGeometry.Ga`, `AlgebraicGeometry.Gm` (expected), `AlgebraicGeometry.gaTranslationP1`, `AlgebraicGeometry.gmScalingP1` (expected), `AlgebraicGeometry.hom_Ga_to_av_trivial`. `morphism_Ga_to_av_const` keeps its name (proof body changes).
- `lem:av_regular_map_is_hom` (Cor 1.2) is now genuinely unused on the genus-0 path; it remains in-chapter as a Route-A input. Its `\uses{lem:hom_additivity_over_product}` is its own real dependency, untouched.
- If the plan agent adopts the scaling shortcut (see findings), `lem:hom_Ga_to_av_trivial` and `def:gaTranslationP1`'s additive part become optional for genus-0 — they could be left to Route A / deleted from the critical path.

## Strategy-modifying findings
**FINDING 1 — the directive's additive route has a hidden hard dependency.** The abstract lemma
`Hom(𝔾_a,A)=0` (`lem:hom_Ga_to_av_trivial`), stated standalone for an arbitrary homomorphism
`φ : 𝔾_a → A`, cannot be proved by Milne's 𝔾_a/𝔾_m argument as-is: that argument runs Cor 1.5,
which needs the **complete** factor, so it requires an extension of `φ` to ℙ¹ — which the abstract
statement does not provide. The only extension-free proof is the **completeness/image argument**,
whose load-bearing step "the image of a homomorphism of algebraic groups is a closed subgroup" is a
genuine Mathlib gap (group-scheme image theory is thin) — arguably as deep as the Thm 3.2 / Lemma 3.3
gap the 4th route was meant to avoid. So the additive route as directed does not, by itself, escape
a hard sub-build.

**FINDING 2 — a strictly cleaner close: the 𝔾_m-scaling shortcut (recommend adopting).** The
multiplicative scaling action `σ_× : ℙ¹×𝔾_m → ℙ¹`, `(x,λ)↦λx`, is a total morphism fixing `0`.
Normalising `f(0)=η[A]` and applying the **already-proven** Cor 1.5 (`lem:hom_additivity_over_product`)
with `V=ℙ¹`, `W=𝔾_m`, base points `0,1`: because `0` is a scaling **fixed point**, the W-axis
restriction `λ ↦ f(λ·0) = f(0) = η[A]` collapses, so the decomposition degenerates to
`σ_× ≫ f = pr₁ ≫ f` (i.e. `f(λx)=f(x)`). Precomposing with `λ ↦ (1,λ)` gives `f|_{𝔾_m} = const f(1)`;
density of 𝔾_m in ℙ¹ + separatedness of A (the `ext_of_isDominant` handle already used by
`rigidity_core`) yields `f` constant. This closes the **entire** genus-0 base case using only
(i) the proven Cor 1.5, (ii) the total morphism `σ_×`, (iii) density — with **no** 𝔾_a-additivity,
**no** `Hom(𝔾_a,A)=0`, **no** "image is a closed subgroup", **no** Thm 3.2, **no** 𝔾_a/𝔾_m algebra,
**no** cube. It is char-free and the least-Mathlib-blocked realisation.

Both findings are written into the chapter (Finding 1 inside `lem:hom_Ga_to_av_trivial`'s proof and
its completeness caveat; Finding 2 as the primary content of `rmk:base_case_fourth_route` and as the
"recommended simplification" tail of `lem:hom_from_Ga_trivial`'s proof). I kept the directive's
additive route as the **stated** proof of `lem:hom_from_Ga_trivial` (per the directive's exact `\uses`
set) rather than unilaterally swapping the primary route; the plan agent should decide whether to
promote the scaling shortcut to the prover's primary target and demote/retire `lem:hom_Ga_to_av_trivial`.
Recommended: adopt the scaling shortcut as the prover's primary genus-0 target.
