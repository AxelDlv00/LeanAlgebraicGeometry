# Blueprint Review Report

## Slug
p3b-realign-recheck

## Iteration
011

## Top-level summaries

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:higher_direct_image_presheaf`: Proof ends (lines 1514–1516) with "the presheaf-level Čech δ-functor formalism over O_X-modules is developed as part of the chapter's content." The p3b-realign rewrite **removed** that formalism (lemmas `lem:presheaf_modules_enough_injectives`, `lem:cech_delta_functor_presheaves`, etc.). The sentence now refers to content that no longer exists. The actual proof argument (injective resolution → cohomology sheaf = sheafification of presheaf) is logically complete; the stale sentence is not part of the proof chain, but it is a broken cross-reference that a prover targeting this lemma will encounter. The sentence must be deleted (or replaced with the correct note that the direct route via `lem:injective_cech_acyclic` is all that is needed downstream).

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:injective_of_adjoint`: leandag shows isolated (0 deps, 0 impact). **Keep** — intentional standalone `\mathlibok` reference anchor used in proof-block `\uses{}` of `lem:injective_cech_acyclic`. Isolation is expected: `\mathlibok` nodes emit no outgoing `\uses{}` and leandag's impact metric excludes proof-block-only incoming edges.
- `Cohomology_CechHigherDirectImage.tex` / `lem:mod_pmod_adjunction`: same disposition. **Keep** — `\mathlibok` anchor used in proof of `lem:injective_cech_acyclic`.
- 28 `lean_aux` isolated nodes: uncovered Lean helpers, not blueprint concerns.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **must-fix** — `lem:higher_direct_image_presheaf` proof (lines 1514–1516): stale sentence references the removed δ-functor formalism. Delete or replace with a note that the downstream proof no longer requires it (the presheaf-level injectivity route is now self-contained in `lem:injective_cech_acyclic`).
  - **informational** — `lem:injective_of_adjoint` and `lem:mod_pmod_adjunction` show as "isolated" in leandag; see disposition above. No action needed.

## Detailed per-check results

### Check 1 — Formalization-readiness of the realigned §"Presheaf-level Čech machinery"

All five realigned declarations are complete and formalization-ready:

- **`def:cech_free_presheaf_complex`** (lines 637–713): Realizes each summand as `free(𝐲 U_{i₀…iₚ})` via the free–forgetful adjunction; no bespoke `j_!`. Complete statement and no proof obligation (definition). ✓
- **`def:section_cech_complex`** (NEW, lines 715–774): Correctly distinguished from the relative `CechComplex`; complete definition; source-quoted from Stacks Cohomology §Čech cohomology of presheaves (verbatim English). ✓
- **`lem:cech_complex_hom_identification`** (lines 776–861): Proof via free–forgetful adjunction + Yoneda gives the identification Hom(K(𝒰)_•, F) = Č•(𝒰,F); source-quoted verbatim from `lemma-cech-map-into`. ✓
- **`lem:cech_free_complex_quasi_iso`** (lines 863–961): Proof by objectwise homology (sectionwise exactness) and the contracting homotopy h(s)_{i₀…iₚ₊₁} = (i₀ = i_fix) · s_{i₁…iₚ}; source-quoted verbatim from `lemma-homology-complex`. ✓
- **`lem:injective_cech_acyclic`** (lines 994–1087): Proof split into two clean parts — Part 1 (injectivity transfer via adjoint: `lem:mod_pmod_adjunction` + `lem:injective_of_adjoint`) and Part 2 (vanishing: apply exact Hom(−,I) to the free resolution, use `lem:cech_complex_hom_identification` and `lem:cech_free_complex_quasi_iso`). No "developed as part of chapter content" placeholder. Drops enough-injectives and the δ-functor. Self-contained. Source-quoted verbatim from `lemma-injective-trivial-cech`. ✓

### Check 2 — No dangling `\uses{}` to removed labels

`leandag build --json` returns `"unknown_uses": []`. The four removed labels (`lem:presheaf_modules_enough_injectives`, `lem:cech_delta_functor_presheaves`, `lem:grothendieck_enough_injectives`, `lem:module_cat_grothendieck`) are not referenced anywhere in the blueprint. ✓

### Check 3 — `\mathlibok` faithfulness

Both new anchors confirmed against live Mathlib via loogle:

- **`CategoryTheory.Injective.injective_of_adjoint`** — exists in `Mathlib.CategoryTheory.Preadditive.Injective.Basic`.
  Mathlib type: `{L : Functor C D} {R : Functor D C} [L.PreservesMonomorphisms] (adj : L ⊣ R) (J : D) [Injective J] : Injective (R.obj J)`.
  Blueprint statement: "left adjoint L preserves monomorphisms → R carries injective J to injective R(J)." Faithful. ✓

- **`PresheafOfModules.sheafificationAdjunction`** — exists in `Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification`.
  Mathlib type: `(α : R₀ ⟶ R.val) [IsLocallyInjective J α] [IsLocallySurjective J α] ... : sheafification α ⊣ ...`
  Blueprint description: for the identity ring map α = 1, sheafification ⊣ inclusion of sheaves into presheaves; sheafification is exact, hence mono-preserving. Faithful. ✓

  Note for prover: to invoke `injective_of_adjoint`, the `PreservesMonomorphisms` instance for the sheafification functor is needed. This follows from sheafification being exact (a standard Mathlib instance for sheafification); no extra `\mathlibok` anchor is needed, but the prover should search for `PresheafOfModules.sheafification.preservesMonomorphisms` or a derived instance.

### Check 4 — P3 block unchanged and still cleared

- **`def:standard_affine_cover`** (lines 482–504): `\mathlibok`, `\lean{AlgebraicGeometry.Scheme.affineOpenCoverOfSpanRangeEqTop}`. Unchanged. ✓
- **`lem:cech_acyclic_affine`** (lines 506–610): `\leanok`, complete proof with prime-local contracting homotopy. Unchanged. ✓

The P3 prover lane (`CechAcyclic.lean`) depends only on these two declarations. Both are untouched.

### Check 5 — Non-circularity preserved

- `lem:injective_cech_acyclic` proof `\uses{}` (line 1053): lists `def:cech_complex`, `def:section_cech_complex`, `lem:cech_complex_hom_identification`, `lem:cech_free_complex_quasi_iso`, `lem:injective_of_adjoint`, `lem:mod_pmod_adjunction`. Does NOT reference `lem:affine_serre_vanishing`. ✓
- `lem:cech_to_cohomology_on_basis` proof (line 1331): uses `lem:injective_cech_acyclic`, `lem:ses_cech_h1`, `lem:cech_acyclic_affine`. Does NOT reference `lem:affine_serre_vanishing`. The proof text (lines 1382–1387) explicitly states "The argument never uses affine sheaf-cohomology vanishing." ✓
- `lem:affine_serre_vanishing` uses `lem:cech_to_cohomology_on_basis`: one-directional. ✓
- Non-circularity fully preserved.

### Check 6 — Source-quote spot-check of new/edited blocks

- `def:section_cech_complex` `% SOURCE QUOTE:` (lines 723–745): Verbatim from Stacks Cohomology §Čech cohomology of presheaves; English (correct language for Stacks Project); original Stacks notation used. ✓
- `lem:cech_complex_hom_identification` `% SOURCE QUOTE:` (lines 786–791): Verbatim from `lemma-cech-map-into`. ✓  
- `lem:cech_complex_hom_identification` `% SOURCE QUOTE PROOF:` (lines 809–831): Verbatim from the proof of `lemma-cech-map-into`. ✓
- `lem:cech_free_complex_quasi_iso` `% SOURCE QUOTE:` (lines 872–884): Verbatim from `lemma-homology-complex`. ✓
- `lem:injective_cech_acyclic` has **two** `% SOURCE QUOTE PROOF:` blocks (lines 1030–1051): both verbatim from Stacks Cohomology `lemma-injective-trivial-cech` and its companion `lemma-cech-cohomology-derived-presheaves`. ✓
- `lem:injective_of_adjoint` and `lem:mod_pmod_adjunction`: `\mathlibok` anchors with `\textit{Provided by Mathlib}` — no `% SOURCE:` required. ✓
- All new blocks have correct `\textit{Source: ...}` visible lines. ✓
- `references/stacks-cohomology.tex` and `references/stacks-cohomology.md` exist on disk. ✓

### Rendering lint (`archon blueprint-doctor --json`)

No issues: `"malformed_refs": []`, `"broken_refs": []`, `"orphan_chapters": []`, `"covers_problems": []`. ✓

## Severity summary

**Must-fix-this-iter (1):**
1. `Cohomology_CechHigherDirectImage.tex` / `lem:higher_direct_image_presheaf` proof (lines 1514–1516): delete the stale sentence "the presheaf-level Čech δ-functor formalism over O_X-modules is developed as part of the chapter's content." The referenced content was removed by p3b-realign. The actual proof is complete without it; the sentence is a dangling reference to non-existent content in a lemma that feeds an active prover route (`lem:open_immersion_pushforward_comp` → `lem:cech_term_pushforward_acyclic` → `lem:cech_computes_cohomology`).

**Soon (0).**

**Informational (1):**
- `lem:injective_of_adjoint` and `lem:mod_pmod_adjunction` isolated in leandag — expected for `\mathlibok` anchors referenced only in proof-block `\uses{}`; keep.

## HARD GATE determination

**For `CechAcyclic.lean` (P3): GATE CLEARS.** `def:standard_affine_cover` and `lem:cech_acyclic_affine` are untouched, complete, and correct (`\leanok` / `\mathlibok`). The P3 prover may dispatch.

**For P3b presheaf-machinery declarations** (`cechFreePresheafComplex`, `sectionCechComplex`, `cechComplex_hom_identification`, `cechFreeComplex_quasiIso`, `injective_cech_acyclic`): **GATE CLEARS** for a scoped prover lane targeting exactly these five declarations. The realigned subsection is complete and correct; both `\mathlibok` anchors are faithful; no dangling `\uses{}`; proofs are formalization-ready.

**For a prover targeting the full `CechHigherDirectImage.lean`** (including `lem:higher_direct_image_presheaf`, `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`, `lem:cech_computes_cohomology`): **GATE BLOCKED** by the must-fix in `lem:higher_direct_image_presheaf`. Dispatch a blueprint-writer (one-line fix: delete the stale sentence at lines 1514–1516) and, after the fix, re-confirm before dispatching that prover.

Overall verdict: `Cohomology_CechHigherDirectImage.tex` is `complete: true`, `correct: partial`. The realigned presheaf-machinery subsection is complete + correct and CLEARS the gate for P3 and the P3b scoped prover lane. One must-fix (stale sentence from removed δ-functor content) blocks the full-chapter prover — a single writer line-deletion resolves it.
