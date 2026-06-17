# Blueprint Writer Report

## Slug
fbc-cov

## Status
COMPLETE — all three tasks (A: 15 FBCGlobal blocks + 2 sheaf-axiom `\mathlibok` anchors;
B: 2 conj-0 blocks + `_legs` wiring; C: 3 dead `_link_*` blocks removed) landed; `leandag` reports
`unknown_uses: []` and all 17 new Lean decls are now matched (no longer isolated `lean_aux`).

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made

### Task A — FBC-B globalization subsection (new `\subsection`, appended at chapter end)
New subsection "The $A$-module $\operatorname{eqLocus}$ globalization (FBC-B)" with an intro paragraph
and the following blocks (all namespace `AlgebraicGeometry`, project-bespoke — no SOURCE QUOTE):

- **Mathlib anchor** `lem:sheaf_eq_of_locally_eq_mathlib` / `\lean{TopCat.Sheaf.eq_of_locally_eq'}` / `\mathlibok` — sheaf separatedness (element-level).
- **Mathlib anchor** `lem:sheaf_existsUnique_gluing_mathlib` / `\lean{TopCat.Sheaf.existsUnique_gluing'}` / `\mathlibok` — sheaf gluing (element-level).
- **def** `def:fbcb_groundRing` / `groundRing` — ground ring `A = Γ(X,𝒪_X)`. (no deps)
- **def** `def:fbcb_rhoU` / `rhoU` — restriction ring map `A → Γ(U,𝒪_X)`. `\uses{def:fbcb_groundRing}`
- **lemma** `lem:fbcb_rhoU_comp` / `rhoU_comp` — transitivity of `rhoU`. `\uses{def:fbcb_rhoU}`
- **def** `def:fbcb_gammaModA` / `gammaModA` — `Γ(U,M)` as `A`-module by restriction of scalars. `\uses{def:fbcb_rhoU}`
- **def** `def:fbcb_gammaResAHom` / `gammaResAHom` — restriction as `A`-module morphism. `\uses{def:fbcb_gammaModA, lem:fbcb_rhoU_comp}`
- **def** `def:fbcb_gammaResA` / `gammaResA` — underlying `A`-linear restriction. `\uses{def:fbcb_gammaResAHom}`
- **lemma** `lem:fbcb_gammaResA_apply` / `gammaResA_apply` — `gammaResA = M.map` on elements. `\uses{def:fbcb_gammaResA}`
- **lemma** `lem:fbcb_gammaResA_comp` / `gammaResA_comp` — functoriality. `\uses{def:fbcb_gammaResA, lem:fbcb_gammaResA_apply}`
- **def** `def:fbcb_leftRes` / `leftRes` — left product leg. `\uses{def:fbcb_gammaResA}`
- **def** `def:fbcb_rightRes` / `rightRes` — right product leg. `\uses{def:fbcb_gammaResA}`
- **def** `def:fbcb_toCover` / `toCover` — global-section restriction to cover. `\uses{def:fbcb_gammaResA}`
- **lemma** `lem:fbcb_leftRes_toCover` / `leftRes_toCover` — restricted family is compatible. `\uses{def:fbcb_leftRes, def:fbcb_rightRes, def:fbcb_toCover, lem:fbcb_gammaResA_comp}`
- **def** `def:fbcb_toCoverEqLocus` / `toCoverEqLocus` — corestriction into the locus. `\uses{def:fbcb_toCover, lem:fbcb_leftRes_toCover}`
- **lemma (keystone)** `lem:fbcb_gammaTopEquivEqLocus` / `gammaTopEquivEqLocus` — `Γ(X,M) ≅ eqLocus(leftRes,rightRes)`. `\uses{def:fbcb_toCoverEqLocus, def:fbcb_gammaModA, def:fbcb_gammaResA, def:fbcb_leftRes, def:fbcb_rightRes, lem:sheaf_eq_of_locally_eq_mathlib, lem:sheaf_existsUnique_gluing_mathlib}`. Carries a `% NOTE:` recording that bijectivity is via the element-level sheaf axioms (separatedness = injectivity, gluing = surjectivity) and does NOT route through `gammaIsLimitSheafConditionFork`.
- **lemma (payoff)** `lem:fbcb_baseChangeGammaEquiv` / `baseChangeGammaEquiv` — `B ⊗_A Γ(X,M) ≅ eqLocus(B⊗leftRes, B⊗rightRes)` for flat `B`. `\uses{lem:fbcb_gammaTopEquivEqLocus, lem:flat_preserves_equalizer_mathlib}` (the existing `tensorEqLocusEquiv` anchor, confirmed present at its label).

### Task B — FBC-A conj-0 blocks (inserted after the Mathlib mate/CompositionIso anchors)
- **lemma** `lem:pullbackComp_inv_eq_leftAdjointCompIso_inv` / `pullbackComp_inv_eq_leftAdjointCompIso_inv` — `(pullbackComp f g).inv = (leftAdjointCompIso …).inv`. `\uses{lem:leftAdjointCompIso_mathlib, lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib, lem:conjugateEquiv_pullbackComp_inv_mathlib}`. Proof: both have the same image under the injective `conjugateEquiv`.
- **lemma** `lem:pullbackComp_eq_leftAdjointCompIso` / `pullbackComp_eq_leftAdjointCompIso` — iso-level form. `\uses{lem:pullbackComp_inv_eq_leftAdjointCompIso_inv}`. Proof: an iso is determined by its inverse.
- **Revised** `lem:base_change_mate_fstar_reindex_legs` — added `lem:pullbackComp_eq_leftAdjointCompIso` to both the statement and proof `\uses` lists (the conjugate route consumes it).
- The `\mathlibok` anchor for `leftAdjointCompIso` requested by the directive **already existed**
  (`lem:leftAdjointCompIso_mathlib` / `\lean{CategoryTheory.Adjunction.leftAdjointCompIso}`, `\mathlibok`),
  so I wired to it rather than duplicating it.

### Task C — Stale `_link_*` pin cleanup
- **Removed** `lem:base_change_mate_fstar_reindex_legs_link_cancelEUnit` (statement + proof) — Lean decl gone.
- **Removed** `lem:base_change_mate_fstar_reindex_legs_link_cancelPullbackComp` (statement + proof) — Lean decl gone.
- **Removed** `lem:base_change_mate_fstar_reindex_legs_link_survivor` (statement + proof) — Lean decl gone.
- All `\uses{}`/`\ref{}` references to those three labels lived **only inside the removed blocks**
  themselves (verified by grep), so no external `\uses` edits were needed.
- **Kept** `lem:base_change_mate_fstar_reindex_legs_link_distributeCollapse` (Lean decl still live) and
  added a one-line `% NOTE:` recording it is the sole surviving fragment of the abandoned
  direct-on-sections route, retained because the current `_legs` body still references the Lean decl.
  Did not touch the `_legs`/`gstar_transpose`/affine proof bodies.

## Cross-references introduced
- `\uses{lem:flat_preserves_equalizer_mathlib}` in `lem:fbcb_baseChangeGammaEquiv` — verified present (the `tensorEqLocusEquiv` anchor, label confirmed in this chapter).
- `\uses{lem:leftAdjointCompIso_mathlib, lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib, lem:conjugateEquiv_pullbackComp_inv_mathlib}` in `lem:pullbackComp_inv_eq_leftAdjointCompIso_inv` — all three verified present in this chapter.
- `\uses{lem:pullbackComp_eq_leftAdjointCompIso}` added to `lem:base_change_mate_fstar_reindex_legs` — label defined in this chapter (this round).
- All intra-FBC-B `def:fbcb_*`/`lem:fbcb_*` edges are within this chapter.

## leandag verification
- `leandag build --json`: `unknown_uses: []`, `conflicts: []`. No broken/dangling references.
- `lean_aux_nodes` dropped from the prior FBCGlobal backlog to **4**, none of which are in this
  directive's scope (`Grassmannian.rotMid`, `Grassmannian.transitionInvImageMatrix`,
  `Grassmannian.transitionInvPair`, `isIso_unitToPushforwardObjUnit_of_isIso'`).
- All 17 new Lean decls (15 FBCGlobal + 2 conj-0) are matched to their blueprint blocks (0 hits in the
  isolated/`lean_aux` set).
- `leandag query --isolated --chapter Cohomology_FlatBaseChange`: **0 results** — none of my new blocks
  is isolated.

## References consulted
None — every block is project-bespoke (algebra/sheaf bookkeeping and a categorical mate identity); no
external SOURCE QUOTE was required, so no `references/` file was opened. (The two Mathlib anchors cite
Mathlib via their `\lean{}` targets, which is the citation for `\mathlibok` blocks.)

## Macros needed (if any)
None — only standard macros (`\Gamma`, `\operatorname`, `\mathrm`, `\otimes`, `\cong`, `\dashv`,
`\bigvee`, `\widetilde`, `\texorpdfstring`) were used.

## Notes for Plan Agent
- **Pre-existing isolated Mathlib anchor (not in my scope):** `lem:iterated_mateEquiv_conjugateEquiv_mathlib`
  (`CategoryTheory.iterated_mateEquiv_conjugateEquiv`, `\mathlibok`) is isolated in this chapter — it has
  no `\uses` and nothing uses it. It is a Beck--Chevalley conceptual anchor that predates this round; its
  effort is "done" (`\mathlibok`), so it is harmless, but if you want a clean DAG you could either wire it
  into the conjugate-route narrative (e.g. as a `\uses` of `lem:base_change_mate_fstar_reindex_legs`) or
  drop it. I left it untouched (outside the directive's scope).
- **Duplicate-ish FBC-B build-ahead blocks:** the older "build-ahead" subsection still contains
  `lem:gamma_amodule_restriction` / `lem:gamma_alinear_res_maps` / `lem:gamma_eqLocus_iso`, whose `\lean{}`
  pins name to-be-built decls (`Modules.gammaCoverRestrictScalars`, `gammaCoverResMapsALinear`,
  `gammaEqLocusIso`) that do NOT correspond to the decls that actually landed (`gammaModA`, `gammaResA`,
  `gammaTopEquivEqLocus`, …). They cover the same mathematics as the new FBC-B globalization subsection but
  via a different (forget₂-reflects-the-limit) route and different Lean names. They are not isolated (they
  carry edges), so `leandag` is quiet, but they are now partially redundant with the landed sub-lane. If
  the project has settled on the element-level `eqLocus` route, consider retiring or re-pinning those three
  build-ahead blocks in a future round (out of scope here — the directive only asked for the 15 new blocks).

## Strategy-modifying findings
None.
