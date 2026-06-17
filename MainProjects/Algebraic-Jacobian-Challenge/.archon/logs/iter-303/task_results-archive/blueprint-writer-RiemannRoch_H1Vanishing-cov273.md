# Blueprint Writer Report

## Slug
RiemannRoch_H1Vanishing-cov273

## Status
COMPLETE — all 13 uncovered Lean declarations now have exactly one
`\lean{}`-pinned blueprint block, each wired into the chapter's
dependency cone (0 isolated nodes in chapter, 0 unknown_uses in chapter),
and both literal `REF` placeholders fixed.

## Target chapter
blueprint/src/chapters/RiemannRoch_H1Vanishing.tex

## Changes Made

Added a new `\section{Lean substrate helpers}`
(`\label{sec:H1Vanishing_substrate}`) before the existing
`\section{Lean encoding and dependencies}`, with three subsections.

### Group A — long-exact-sequence substrate for flasque vanishing
- **Added definition** `def:injectiveSES` / `\lean{AlgebraicGeometry.Scheme.injectiveSES}` — canonical injective-embedding short complex `F → Injective.under F → coker`.
- **Added lemma** `lem:injectiveSES_shortExact` / `\lean{AlgebraicGeometry.Scheme.injectiveSES_shortExact}` — that short complex is short exact.
- **Added lemma** `lem:ext_one_eq_zero_of_hom_surjective_of_injective` / `\lean{AlgebraicGeometry.ext_one_eq_zero_of_hom_surjective_of_injective}` — degree-1 Ext vanishing from Hom-surjectivity + injective middle term.
- **Added lemma** `lem:HModule_injective_finrank_eq_zero` / `\lean{AlgebraicGeometry.Scheme.HModule_injective_finrank_eq_zero}` — injective sheaves have zero finrank cohomology in degree ≥ 1.
- **Added lemma** `lem:HModule_flasque_subsingleton_aux` / `\lean{AlgebraicGeometry.Scheme.HModule_flasque_subsingleton_aux}` — strong-induction subsingleton carrier of the flasque-vanishing theorem.

### Group B — the forget₂ bridge to Mathlib flasqueness
- **Added definition** `def:sheafCompose_additive` / `\lean{AlgebraicGeometry.sheafCompose_additive}` — sheafCompose of an additive functor is additive (instance).
- **Added definition** `def:sheafCompose_preservesZero` / `\lean{AlgebraicGeometry.sheafCompose_preservesZero}` — preserves zero morphisms (instance).
- **Added definition** `def:sheafCompose_preservesFiniteLimits` / `\lean{AlgebraicGeometry.sheafCompose_preservesFiniteLimits}` — preserves finite limits (instance).
- **Added lemma** `lem:isFlasque_toAddCommGrpCat` / `\lean{AlgebraicGeometry.Scheme.IsFlasque.toAddCommGrpCat}` — project flasqueness transfers to Mathlib `TopCat.Sheaf.IsFlasque` via forget₂.
- **Added lemma** `lem:isFlasque_shortExact_app_surjective` / `\lean{AlgebraicGeometry.Scheme.IsFlasque.shortExact_app_surjective}` — Hartshorne II.1 Ex 1.16(b) sections-surjectivity.

### Group C — explicit presheaf maps for the one-point inner iso
- **Added definition** `def:alphaConstToSkyPUnit` / `\lean{AlgebraicGeometry.alphaConstToSkyPUnit}` — constant→skyscraper presheaf map on PUnit.
- **Added definition** `def:betaSkyToConstPUnit` / `\lean{AlgebraicGeometry.betaSkyToConstPUnit}` — skyscraper→constant presheaf map on PUnit.
- **Added lemma** `lem:alpha_beta_eq_toSheafify` / `\lean{AlgebraicGeometry.alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify}` — composite equals the sheafification unit.

Each new block carries a `\begin{proof} Proved directly in Lean. ... \end{proof}` body naming the parent result it sub-serves (no external citation — all are internal helpers, none restate a Mathlib result verbatim, so no `\mathlibok` anchor was warranted).

### REF placeholders fixed (2)
- Line ~28 (intro): `chapter~REF` → `\cref{chap:Cohomology_StructureSheafModuleK}`.
- Out-of-scope §, H⁰-half bullet: dangling `sibling substrate lemma REF of \cref{chap:RiemannRoch_RRFormula}` rephrased to `a sibling substrate lemma of \cref{chap:RiemannRoch_RRFormula}` (no concrete label for the H⁰-half lemma was identifiable in this chapter, so the dangling reference was removed per directive rule 4; also dropped the bare `iter-188` history clause in the same sentence to keep the prose standalone).

## Cross-references introduced (wiring edges)
Into existing blocks:
- `thm:H1_vanishing_flasque` statement `\uses{}` += `lem:HModule_flasque_subsingleton_aux, lem:HModule_injective_finrank_eq_zero`.
- `lem:skyscraperSheaf_iso_constantSheaf_punit` proof `\uses{}` += `def:alphaConstToSkyPUnit, def:betaSkyToConstPUnit, lem:alpha_beta_eq_toSheafify`.

Within/between new blocks (matching the real Lean call graph):
- `lem:HModule_flasque_subsingleton_aux` `\uses` `def:isFlasque_sheaf, lem:injectiveSES_shortExact, lem:ext_one_eq_zero_of_hom_surjective_of_injective, lem:ext_succ_zero_of_injective_lower_zero, lem:isFlasque_shortExact_app_surjective, lem:flasque_cokernel_short_exact, lem:isFlasque_injective`.
- `lem:injectiveSES_shortExact` `\uses` `def:injectiveSES`.
- `lem:isFlasque_shortExact_app_surjective` `\uses` `def:isFlasque_sheaf, lem:isFlasque_toAddCommGrpCat, def:sheafCompose_additive, def:sheafCompose_preservesZero, def:sheafCompose_preservesFiniteLimits`.
- `def:sheafCompose_preservesZero` `\uses` `def:sheafCompose_additive`.
- `lem:isFlasque_toAddCommGrpCat`, `def:sheafCompose_additive`, `def:sheafCompose_preservesFiniteLimits` `\uses` `def:isFlasque_sheaf`.
- `lem:alpha_beta_eq_toSheafify` `\uses` `def:alphaConstToSkyPUnit, def:betaSkyToConstPUnit`.
- `def:alphaConstToSkyPUnit`, `def:betaSkyToConstPUnit` `\uses` `lem:isFlasque_constant_irreducible`.
- `def:injectiveSES`, `lem:ext_one_eq_zero_of_hom_surjective_of_injective`, `lem:HModule_injective_finrank_eq_zero` `\uses` `def:Scheme_HModule` (cross-chapter anchor already referenced by `lem:ext_succ_zero_of_injective_lower_zero` in this chapter).

Verification: `leandag build --json` → 0 unknown_uses in this chapter; `leandag query --isolated --chapter RiemannRoch_H1Vanishing` → none. All 13 new `\lean{}` pins confirmed unique project-wide. LaTeX begin/end balanced (definition 7/7, lemma 16/16, theorem 2/2, proof 22/22).

## References consulted
None opened this session — all 13 blocks are internal project-bespoke helper declarations (no `% SOURCE:`/`% SOURCE QUOTE:` citation blocks were written; their external lineage, where any, already lives in the parent headline blocks via existing verbatim quotes).

## Macros needed
None. All blocks reuse existing macros (`\Module`, `\HModule`, `\Ext`, `\PUnit`, `\cref`).

## Notes for Plan Agent
- The cross-chapter label `def:Scheme_HModule` (used by three of the new blocks, and pre-existing in `lem:ext_succ_zero_of_injective_lower_zero`) lives outside this chapter; it resolves cleanly in `leandag` (no unknown_uses), but if it is ever relabeled the new blocks here will need updating.
- The `lem:isFlasque_injective` (`Scheme.IsFlasque.injective_flasque`) it `\uses` is, per the existing chapter NOTE, still a typed sorry pending a Mathlib `j_!` construction; `lem:HModule_flasque_subsingleton_aux` therefore transitively depends on that open gap — this is unchanged by the present coverage pass (the new blocks themselves are all sorry-free).

## Strategy-modifying findings
None.
