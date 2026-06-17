# Blueprint Writer Report

## Slug
injcech

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

Added a new `\subsection{Presheaf-level {\v C}ech machinery}` immediately before the
existing `lem:injective_cech_acyclic` block, containing the 5 directed declarations
plus the 2 Mathlib anchors, then made the two existing-block edits (A, B). Inserted
in dependency-before-use order: defs/lemmas 1–3, then the two anchors and the
enough-injectives lemma (5), then the δ-functor lemma (4) which consumes them, so
every `\uses{}` target is declared before it is referenced.

- **Added definition** `def:cech_free_presheaf_complex` / `\lean{AlgebraicGeometry.cechFreePresheafComplex}` — the chain complex \(K(\mathcal{U})_\bullet\) of presheaves, degree \(p\) = \(\bigoplus_{i_0\ldots i_p}(j_{i_0\ldots i_p})_!\,\mathcal{O}_X|_{U_{i_0\ldots i_p}}\) (shriek/extension-by-zero) with the alternating Čech differential; notes each summand is projective. Source: `lemma-cech-map-into`.
- **Added lemma** `lem:cech_complex_hom_identification` / `\lean{AlgebraicGeometry.cechComplex_hom_identification}` — \(\operatorname{Hom}_{\mathcal{O}_X}(K(\mathcal{U})_\bullet,\mathcal{F}) = \check{\mathcal{C}}^\bullet(\mathcal{U},\mathcal{F})\), natural in \(\mathcal{F}\). `\uses{def:cech_free_presheaf_complex, def:cech_complex}`. Proof sketch added (shriek–restriction adjunction termwise). Source: `lemma-cech-map-into` (stmt+proof).
- **Added lemma** `lem:cech_free_complex_quasi_iso` / `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}` — homology presheaves of \(K(\mathcal{U})_\bullet\) are \(\mathcal{O}_{\mathcal{U}}\) in degree 0, else 0; augmented complex exact. `\uses{def:cech_free_presheaf_complex}`. Proof sketch added (sectionwise contracting homotopy \(dh+hd=\mathrm{id}\)). Source: `lemma-homology-complex` (stmt+proof).
- **Added lemma (anchor)** `lem:grothendieck_enough_injectives` / `\lean{CategoryTheory.IsGrothendieckAbelian.enoughInjectives}` — `\mathlibok`. Grothendieck abelian ⇒ enough injectives.
- **Added lemma (anchor)** `lem:module_cat_grothendieck` / `\lean{instIsGrothendieckAbelianModuleCat}` — `\mathlibok`. `ModuleCat R` is Grothendieck abelian.
- **Added lemma** `lem:presheaf_modules_enough_injectives` / `\lean{AlgebraicGeometry.presheafModules_enoughInjectives}` — `PMod(O_X)` has enough injectives. `\uses{lem:grothendieck_enough_injectives, lem:module_cat_grothendieck}`. Proof states the Grothendieck route and names the single project-side obligation (the `IsGrothendieckAbelian (PresheafOfModules …)` instance, NOT yet in Mathlib); **not** marked `\mathlibok`. Source: opening sentence of `lemma-cech-cohomology-derived-presheaves` proof (verbatim quote that PMod has enough injectives).
- **Added lemma** `lem:cech_delta_functor_presheaves` / `\lean{AlgebraicGeometry.cech_delta_functor_presheaves}` — Čech functors \(\check H^p(\mathcal{U},-)\) form a δ-functor canonically iso to \(R^p\check H^0(\mathcal{U},-)\); injectives are positively acyclic. `\uses{lem:cech_complex_hom_identification, lem:cech_free_complex_quasi_iso, lem:presheaf_modules_enough_injectives}`. Proof sketch added (universal δ-functor / effaceability). Source: `lemma-cech-cohomology-delta-functor-presheaves` + `lemma-cech-cohomology-derived-presheaves`.

### Edit A — `lem:injective_cech_acyclic` proof
- Replaced the closing placeholder sentence ("…developed as part of the chapter's foundational content") with prose explicitly chaining the four new sub-lemmas + the enough-injectives lemma.
- Updated proof `\uses{def:cech_complex}` → `\uses{def:cech_complex, lem:cech_complex_hom_identification, lem:cech_free_complex_quasi_iso, lem:cech_delta_functor_presheaves, lem:presheaf_modules_enough_injectives}`.
- The verbatim `% SOURCE QUOTE PROOF:` blocks were left untouched, as directed.

### Edit B — `lem:cech_to_cohomology_on_basis` statement
- Added one sentence to the statement body clarifying the formal target is the positive-degree **vanishing** \(H^p(U,\mathcal{F})=0\) under (1)–(3), not an explicit iso \(\check H^p\cong H^p\). `\lean{}` hint left as `cech_eq_cohomology_of_basis` (rename is a scaffolder/review decision, not touched).

## Cross-references introduced
- `def:cech_complex` (item 2 `\uses`) — exists, this chapter (`\label` at the `CechComplex` definition).
- `lem:grothendieck_enough_injectives`, `lem:module_cat_grothendieck` — new anchors in this chapter.
- All other new `\uses` edges point at the new blocks in this same chapter.
- `leandag build --json`: `unknown_uses = []`, `conflicts = []`. `leandag query --isolated --chapter Cohomology_CechHigherDirectImage` → 0 results; none of the new labels appear in `show isolated`. The new `\lean{}` targets appear under `unmatched_lean` (expected — these Lean declarations do not yet exist; they are the `[expected]` formalization targets).

## References consulted
- `references/stacks-cohomology.tex` — verbatim source quotes for all 5 new blocks:
  - L1095–1135 (`j_{p!}` description) + L1142–1162 (`lemma-cech-map-into`, the complex) → `def:cech_free_presheaf_complex`.
  - L1163–1196 (`lemma-cech-map-into`, the iso + proof) → `lem:cech_complex_hom_identification`.
  - L1198–1284 (`lemma-homology-complex`, stmt + homotopy proof) → `lem:cech_free_complex_quasi_iso`.
  - L1065–1074 (`lemma-cech-cohomology-delta-functor-presheaves`) + L1286–1356 (`lemma-cech-cohomology-derived-presheaves`) → `lem:cech_delta_functor_presheaves`.
  - L1317–1319 (PMod enough-injectives sentence) → `lem:presheaf_modules_enough_injectives`.
- `references/summary.md` — index; confirmed `stacks-cohomology.tex` is the source for this chapter's Čech/abstract-cohomology material.

## Macros needed (if any)
None. New prose uses only existing macros (`\operatorname{Hom}`, `\check{\mathcal{C}}`, `\mathcal`, `\mathrm`, `\bigoplus`, `\widehat`). The two Mathlib anchors carry no `% SOURCE` block (the `\lean{}` target is the citation), per anchor convention.

## Reference-retriever dispatches (if any)
None — all required source material was already present in `references/stacks-cohomology.tex`.

## Notes for Plan Agent
- The Mathlib anchor `\lean{}` targets (`CategoryTheory.IsGrothendieckAbelian.enoughInjectives`, `instIsGrothendieckAbelianModuleCat`) were taken as `[verified]` from the directive; I did not independently grep Mathlib. Worth a one-line confirm by the reviewer against the live Lean/Mathlib snapshot before relying on `\mathlibok`.
- `lem:presheaf_modules_enough_injectives` deliberately carries a genuine proof obligation (the `IsGrothendieckAbelian (PresheafOfModules …)` instance), is NOT `\mathlibok`, and is the single project-side gap the enough-injectives route reduces to — flagging so it is scaffolded as a real to-prove node, not assumed done.
- All seven new `\lean{}` names are `[expected]` (no matching Lean decl yet); they surface in `leandag`'s `unmatched_lean`. The lean-scaffolder will need to create these declarations.
- Non-circularity preserved: no new `\uses` edge from `lem:cech_to_cohomology_on_basis` (or sub-lemmas) back to `lem:affine_serre_vanishing`. Edit B is statement-prose only.

## Strategy-modifying findings
None.
