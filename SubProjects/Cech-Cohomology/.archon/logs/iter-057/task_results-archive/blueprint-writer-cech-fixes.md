# Blueprint Writer Report

## Slug
cech-fixes

## Status
COMPLETE

All four must-fix items addressed. `leandag build` reports `unknown_uses: []`, `conflicts: []`,
`lean_aux_nodes` dropped 8 → 1, `isolated` 1. The single remaining isolated node is
`AlgebraicGeometry.CechAcyclic.affine`, the dead sorry-bearing sibling that item 4i instructed me to
document (not wire) as an intentional placeholder. No `% NOTE:` claiming a statement is false/mis-specified
remains in the chapter.

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Must-fix 1 — `lem:cechSection_complex_iso` re-stated to the AUGMENTED complex
- **Revised** `lem:cechSection_complex_iso` — replaced the stale "MIS-SPECIFIED / FALSE" `% NOTE:` with a
  `% NOTE: build target — augmented form` line. Statement now asserts `D ≅ D'_aug` where
  `D'_aug := (sectionCechComplex U'·).augment ε hε`, with `ε : Γ(V,F) → ∏_i Γ(U_i∩V,F)` the restriction
  product (evaluation of `def:cech_augmentation`) and `hε : ε·d⁰ = 0`. Augmentation node matched by the
  identity on `Γ(V,F)`; Čech-degree isos by `lem:pushPull_eval_prod_iso`. Proof extended with an explicit
  *augmentation differential* paragraph showing the lowest differential of `D` is `ε`.
  - `\uses{}` extended with `def:cech_augmentation, lem:cech_augmentation_comp_d`.

### Must-fix 2 — `lem:cechSection_contractible` re-stated + augmentation-node argument
- **Revised** `lem:cechSection_contractible` — replaced the stale "PROVABLY FALSE" `% NOTE:` with a build-
  target note. Statement now `Homotopy (𝟙 D'_aug) 0` (the augmented complex) under
  `V ≤ coverOpen 𝒰 i_fix`. Proof split into (a) positive degrees via the `dep*` engine of
  `lem:cech_acyclic_affine` and (b) an **explicit degree-0 / augmentation-node computation**: the homotopy
  component is the `i_fix`-th coordinate projection `π_{i_fix}` (well defined since `U'_{i_fix} = V`), and
  `ε∘π_{i_fix} + (engine deg-0 term) = id` is verified by hand. Added a verbatim `% SOURCE QUOTE:` of the
  Stacks projection homotopy `h(s)_{i_0…i_p} = s_{i_fix i_0…i_p}` (bottom node = projection onto
  `M_{f_{i_fix}} = M`).
  - `\uses{}` extended with `def:cech_augmentation, lem:cech_augmentation_comp_d`.
- **Revised** `lem:cechSection_isZero_homology` proof prose to track `D'_aug` (statement unchanged).

### Must-fix 3 — new change-of-ring seed + fixed general-open proof
- **Added lemma** `lem:affine_cech_vanishing_general_seed` / `\lean{AlgebraicGeometry.sectionCech_homology_exact_of_affineOpen}`
  (`% NOTE: build target`, co-located in CechAcyclic.lean). States positive-degree section-Čech vanishing
  for `~M` over `{D(g_i)}` when `V = ⨆ D(g_i)` is affine. Proof = route B1: change of ring to
  `S = Γ(V)` (`lem:isoSpec_scheme_mathlib`), `ḡ_i` span unit ideal of `S`, per-σ localised base-change iso
  `M_{g_σ} ≅ (M⊗_R S)_{ḡ_σ}`, then the full-span core (`lem:cech_acyclic_affine`, as used by
  `lem:affine_cech_vanishing_qcoh`) over `S`, transported back. Verbatim `% SOURCE QUOTE`s from Stacks
  01HV (item 4) and 02KE `lemma-cech-cohomology-quasi-coherent-trivial`.
  - `\uses{lem:isoSpec_scheme_mathlib, lem:cech_acyclic_affine, lem:affine_cech_vanishing_qcoh,
    lem:isAffineOpen_specBasicOpen}`. The localization base-change Mathlib facts are described in prose
    (no blueprint anchor authored — see Notes).
- **Revised** `lem:affine_serre_vanishing_general_open` proof: condition-(3) bullet no longer claims "the
  same quasi-coherent seed as in `lem:affine_serre_vanishing`"; it now explains why the `D(f)` seed fails
  for a general affine open and routes condition (3) through
  `lem:affine_cech_vanishing_general_of_tildeVanishing` → `lem:affine_cech_vanishing_general_seed`. The
  surj/faces bullets now cite the general-affine companions. `\uses{}` (statement + proof) re-pointed to
  the general-form lemmas + the new seed.

### Must-fix 4 — coverage debt blocks + wire-ups
- **Added definition** `def:affine_cover_system_general` / `\lean{AlgebraicGeometry.affineCoverSystemGeneral}`
  — `\uses{def:basis_cov_system, lem:affine_faces_mem, lem:isAffineOpen_specBasicOpen,
  lem:affine_surj_of_vanishing_affine, lem:injective_cech_acyclic}`.
- **Added lemma** `lem:standard_cover_cofinal_affine` / `\lean{…standard_cover_cofinal_affine}` — 009L
  verbatim quote; `\uses{def:standard_affine_cover, lem:primeSpectrum_isBasis_basicOpen, lem:affine_faces_mem}`.
- **Added lemma** `lem:affine_surj_of_vanishing_affine` / `\lean{…affine_surj_of_vanishing_affine}` —
  `\uses{lem:ses_cech_h1, lem:standard_cover_cofinal_affine, lem:to_sheaf_preserves_epi,
  lem:presheaf_is_locally_surjective, lem:sheaf_locally_surjective_iff_epi}`.
- **Added lemma** `lem:isAffineOpen_specBasicOpen` / `\lean{…isAffineOpen_specBasicOpen}` — authored as a
  normal short lemma (NOT `\mathlibok`): the Lean decl carries the project proof
  `IsAffine.of_isIso (basicOpenIsoSpecAway r).hom`. (I did not find an exact Mathlib re-export the decl
  literally *is*; it is a 2-line wrap, so a project block is correct.)
- **Added lemma** `lem:affine_cech_vanishing_general_of_tildeVanishing` /
  `\lean{…affine_cech_vanishing_qcoh_general_of_tildeVanishing}` —
  `\uses{lem:qcoh_iso_tilde_sections, lem:affine_cech_vanishing_general_seed}`.
- **Added lemma** `lem:affine_serre_vanishing_general_of_seed` / `\lean{…affine_serre_vanishing_general_of_seed}`
  — `\uses{lem:cech_to_cohomology_on_basis, def:affine_cover_system_general}`.
- **Added lemma** `lem:affine_serre_vanishing_general_of_tildeVanishing` /
  `\lean{…affine_serre_vanishing_general_of_tildeVanishing}` —
  `\uses{lem:affine_cech_vanishing_general_of_tildeVanishing, lem:affine_serre_vanishing_general_of_seed}`.
  All seven placed under a new subsection "The enlarged affine instantiation (general affine opens, Need #2)".
- **Wire-up** `lem:absolute_cohomology_zero_natural` — added `AlgebraicGeometry.jShriekOU_homEquiv_nat`
  to its `\lean{…}` list (private precursor of the already-pinned public `…_naturality`).
- **`% NOTE` (no block)** added after `lem:cech_acyclic_affine`'s proof documenting
  `AlgebraicGeometry.CechAcyclic.affine` as an intentional dead placeholder subsumed by the toSheaf bridge.

## Cross-references introduced
All new `\uses{}` target labels verified present in this chapter via grep + `leandag` (`unknown_uses: []`):
`def:basis_cov_system`, `def:standard_affine_cover`, `def:cech_augmentation`, `lem:cech_augmentation_comp_d`,
`lem:primeSpectrum_isBasis_basicOpen`, `lem:affine_faces_mem`, `lem:ses_cech_h1`, `lem:to_sheaf_preserves_epi`,
`lem:presheaf_is_locally_surjective`, `lem:sheaf_locally_surjective_iff_epi`, `lem:injective_cech_acyclic`,
`lem:isoSpec_scheme_mathlib`, `lem:cech_acyclic_affine`, `lem:affine_cech_vanishing_qcoh`,
`lem:qcoh_iso_tilde_sections`, `lem:cech_to_cohomology_on_basis`, `lem:cechCohomology_isZero_of_iso`.

## References consulted
- `references/summary.md` — source index.
- `references/stacks-schemes.tex` (L688–728) — verbatim Tag 01HV `lemma-spec-sheaves` (items 1–4) for the
  seed `Γ(D(f),~M)=M_f`.
- `references/stacks-coherent.tex` (L38–112) — verbatim `lemma-cech-cohomology-quasi-coherent-trivial`
  statement (L44–52) for the seed, and its projection-homotopy proof (L83–112) for the contractibility
  augmentation node.
- `references/stacks-sheaves.tex` (L3861–3879) — verbatim Tag 009L
  `lemma-cofinal-systems-coverings-standard-case` for `lem:standard_cover_cofinal_affine`.
- `analogies/genaffine-cech-seed.md` — route B1 decomposition and verified Mathlib names for the seed proof.

## Macros needed (if any)
None. All new prose uses existing macros (`\operatorname`, `\widetilde`, `\check`, `\mathcal`, etc.).

## Notes for Plan Agent
- **Stale `\leanok` on the two re-stated Sub-brick A blocks.** `lem:cechSection_complex_iso` and
  `lem:cechSection_contractible` still carry their pre-existing leading `\leanok` (I must not touch
  `\leanok`). Their statements are now re-specified to AUGMENTED build targets that the prover must
  re-sign in Lean; until then the `\leanok` is stale. The deterministic `sync_leanok` phase + the prover
  re-signing will reconcile this — no action needed beyond dispatching the prover with the corrected
  blueprint.
- **No Mathlib anchor authored for the localization base-change facts** (`isLocalization_basicOpen`,
  `isLocalization_of_eq_basicOpen`, `isLocalizedModule_iff_isBaseChange`, `IsBaseChange.comp`,
  `TensorProduct.isBaseChange`). The directive only authorized `\mathlibok` on item 4d (which it then
  ruled out). I described these facts in the seed proof prose instead of adding `\uses{}` to nonexistent
  labels (which would create `unknown_uses`). If the reviewer wants the route's Mathlib reliance visible as
  DAG nodes, a follow-up round could author anchors for `IsAffineOpen.isLocalization_basicOpen` and
  `isLocalizedModule_iff_isBaseChange` (both verified to exist in `analogies/genaffine-cech-seed.md`).
- **Build-target `\lean` names not yet in Lean:** `sectionCech_homology_exact_of_affineOpen` (seed, item 3)
  and the pre-existing `affine_serre_vanishing_general_open_TODO`. Both are legitimate prover targets;
  leandag reports `effort_remaining_unknown_nodes: 1`.
- The remaining single isolated `lean_aux` node `AlgebraicGeometry.CechAcyclic.affine` is the dead
  placeholder documented by my item-4i `% NOTE`; it is correctly left unwired.

## Strategy-modifying findings
None. The corrections align the prose with the existing Route-A strategy (the augmented complex resolves F;
general-affine Serre vanishing via change-of-ring seed). No strategy-level issue surfaced.
