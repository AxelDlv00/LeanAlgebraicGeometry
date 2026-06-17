# Blueprint Writer Report

## Slug
iter019

## Status
COMPLETE — with one **directive correction** (Edit 3 was factually wrong; see below and
"Notes for Plan Agent"). All other edits applied exactly as directed; DAG is clean
(0 isolated, 0 unknown_uses, 0 conflicts, none of the added names unmatched).

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Edit 1 — Re-signed `lem:higher_direct_image_presheaf` to the resolution form (P5a)
- **`\lean{}`** changed from `AlgebraicGeometry.higherDirectImage_isSheafify_presheafCohomology`
  to `AlgebraicGeometry.higherDirectImage_iso_sheafify_presheafHomology`, and
  `AlgebraicGeometry.pushforwardResolutionPresheafComplex` bundled in (Edit 4d).
- **Deleted** the stale `% NOTE (review iter-018): … PLANNER DECISION PENDING …` block.
- **Rewrote the statement prose** to the resolution form: choosing an injective resolution
  `G → I^•` in `X.Modules`, `Rⁿf_*G = (f_*).rightDerived n (G) ≅ sheafify(V ↦ Hⁿ((f_*I^•)(V)))`.
  Kept the affine-local vanishing corollary as the closing remark (this is what
  `lem:open_immersion_pushforward_comp` / `lem:cech_term_pushforward_acyclic` consume), and
  added an honest paragraph that the last-mile identification
  `Hⁿ((f_*I^•)(V)) = Hⁿ(f⁻¹V, G)` (needs the restricted resolution acyclic over `f⁻¹V`) is
  supplied at point of use and is **not** part of this lemma's Lean content.
- **Kept** the `% SOURCE` / `% SOURCE QUOTE` (Stacks 01XJ, `lemma-describe-higher-direct-images`)
  and the visible `\textit{Source: …}` line verbatim.
- **`\uses{}`** updated to `\uses{def:higher_direct_image, def:cohomology_sheaf_is_sheafify_homology}`.
- **Proof prose** realigned to reference the engine block
  (`def:cohomology_sheaf_is_sheafify_homology`) and `pushforwardResolutionPresheafComplex`;
  stops at the resolution-internal form; explicitly "no δ-functor". Proof `\uses{}` extended to
  include the engine block.

### Edit 2 — Added the reusable 01XJ engine block (NEW)
- **Added lemma** `\label{def:cohomology_sheaf_is_sheafify_homology}` (placed immediately
  before `lem:higher_direct_image_presheaf`), statement: for a cochain complex `K` of presheaves
  of modules over a site with `HasSheafify`, `(sheafify K).homology i ≅ sheafify(K.homology i)`
  (sheafification commutes with homology). One-paragraph informal proof: sheafification is exact
  (left adjoint preserving finite limits), hence commutes with kernels/cokernels; chase through
  the counit complex iso. Project-bespoke engine ⇒ no `% SOURCE QUOTE` (Tag 01XJ named in prose
  as the application context, per directive latitude).
- **`\lean{}` list** = `PresheafOfModules.homologyIsoSheafify`,
  `PresheafOfModules.counitComplexIso`, `PresheafOfModules.sheafificationAdditive`,
  `CategoryTheory.Functor.mapHomologyIso'`.

### Edit 3 — `depDiff_exact` references — **DIRECTIVE WAS FACTUALLY WRONG; corrected to reality**
- The directive said the decl is "in the `Dependent` namespace" and to rename both occurrences to
  `AlgebraicGeometry.CombinatorialCech.Dependent.depDiff_exact`. **This is false.**
  - `Dependent` is a Lean **`section`** (`CechAcyclic.lean:289`), not a `namespace` — confirmed:
    `grep -rn "namespace Dependent"` returns nothing repo-wide. A `section` contributes **no**
    name-prefix.
  - The true fully-qualified name is `AlgebraicGeometry.CombinatorialCech.depDiff_exact` (the
    original), used verbatim at `CechAcyclic.lean:776`.
  - The **committed** `.leandag/dag.json` shows the original name `…CombinatorialCech.depDiff_exact`
    **was already matched** by leandag (it indexes the private decl under its source name).
    Applying the directed `Dependent.` rename broke that match (it appeared in `unmatched_lean`).
- **Action taken:** I did NOT inject the non-existent `Dependent.` name. Both occurrences read
  `AlgebraicGeometry.CombinatorialCech.depDiff_exact` (the correct, DAG-matched name). This fulfils
  the directive's stated *goal* ("point at the actual declaration") without inserting a false name.
- **On the real blueprint-doctor finding:** the doctor's complaint ("a raw Lean name appears in a
  `\uses{}` list" — the genuine occurrence is the proof `\uses{}` at the old line 767) is a
  *label-vs-Lean-name* issue, not a namespace issue. The proper fix is for `\uses{}` to carry a
  blueprint label rather than a raw Lean name; but `depDiff_exact` has no dedicated label (it is
  bundled into `lem:cech_acyclic_affine`'s own `\lean{}` list, and that proof is the proof OF
  `lem:cech_acyclic_affine`, so the raw-name `\uses{}` is internal/redundant). I left it as the
  correct raw name (leandag accepts it as a lean-use edge: `unknown_uses` is empty). Removing it
  or minting a label is a planner call — flagged below, not done unilaterally to stay in scope.

### Edit 4 — Cleared the 44-node coverage debt (helpers bundled into `\lean{…}` lists)
- **`lem:section_cech_homology_exact`** — appended the 22 localisation-algebra helpers
  (`AwayComparison.*` ×11, `CechLocalized.*` ×11).
- **`def:cover_structure_presheaf`** — appended the 10 O_𝒰-augmentation helpers
  (`cechFreeAug`, `cechFreeComplexAug`, `cechFreeComplexAug_f_zero`,
  `cechFreeSimplicial_δ_comp_aug`, `cechFree_d_comp_aug`, `cechFree_d_comp_factorThruImage`,
  `freeYonedaAug`, `freeYonedaAug_app_freeMk`, `freeYonedaHomEquiv_freeYonedaAug`,
  `freeYoneda_map_comp_aug`).
- **`lem:cech_complex_hom_identification`** — appended the 6 bridge-core helpers
  (`homCechComplex`, `homCechCosimplicial`, `homCechSectionIsoApp`,
  `homCechSectionIsoApp_hom_π`, `pi_mapIso_hom_eq`, `freeYonedaHomAddEquiv_naturality`).
- **`lem:higher_direct_image_presheaf`** — appended `pushforwardResolutionPresheafComplex` (1).
- The other 4 P5a helpers (`homologyIsoSheafify`, `counitComplexIso`, `sheafificationAdditive`,
  `mapHomologyIso'`) live in the new engine block (Edit 2). All 6 P5a decls from
  `HigherDirectImagePresheaf.md` are accounted for (4 in engine block + 1 pushforward bundled +
  1 main resolution-form pin). Total newly placed: 22 + 10 + 6 + 1 + 4 + 1(main pin) = 44.

## Cross-references introduced
- `lem:higher_direct_image_presheaf` now `\uses{def:cohomology_sheaf_is_sheafify_homology}` (the
  new engine block, same chapter) and keeps `\uses{def:higher_direct_image}` (lives in
  `Cohomology_HigherDirectImage.tex` — verified present).
- Statement prose of the re-signed lemma `\ref{}`s `lem:open_immersion_pushforward_comp` and
  `lem:cech_term_pushforward_acyclic` (both verified present in this chapter).
- Verified with `leandag build --json`: `isolated: 0`, `unknown_uses: []`, `conflicts: []`,
  and none of the 44 added/touched names is unmatched (the engine + re-sign also removed the
  one previously-isolated node).

## References consulted
- `references/stacks-cohomology.tex` — confirmed Tag 01XJ (`lemma-describe-higher-direct-images`,
  L591–603) for the retained SOURCE/QUOTE on `lem:higher_direct_image_presheaf` and the in-prose
  01XJ pointer in the engine block. (No new verbatim quote authored; the engine block is
  project-bespoke and the existing 01XJ quote was kept as-is.)
- `.archon/task_results/HigherDirectImagePresheaf.md`, `CechAcyclic.md`, `CechBridge.md`,
  `FreePresheafComplex.md` — read the "Needs blueprint entry" sections for the precise helper
  roles bundled in Edit 4 and the engine block in Edit 2.
- `AlgebraicJacobian/Cohomology/CechAcyclic.lean` (lines 289, 431, 776) — verified the true
  qualified name of `depDiff_exact` and that `Dependent` is a `section` (the basis for the Edit 3
  correction).

## Macros needed (if any)
- None. All commands used (`\operatorname`, `\mathrm`, `\bigl/\bigr`, `\cong`, `{\v C}`, etc.)
  are standard / already in use in the chapter.

## Notes for Plan Agent
- **Edit 3 directive error (action required next iter).** `Dependent` is a `section`, not a
  `namespace`; the real decl is `AlgebraicGeometry.CombinatorialCech.depDiff_exact` and it was
  already DAG-matched. The blueprint-doctor's actual finding is "raw Lean name in a `\uses{}`
  list", i.e. a label-vs-Lean-name lint, not a namespace lint. Two clean ways to silence it:
  (a) remove the raw `\uses{AlgebraicGeometry.CombinatorialCech.depDiff_exact}` from the proof of
  `lem:cech_acyclic_affine` (it is redundant — `depDiff_exact` is in that lemma's own `\lean{}`
  list); or (b) decide whether `depDiff_exact` deserves its own blueprint sub-label and have a
  writer mint one. I left the correct raw name in place (leandag's `unknown_uses` is empty) rather
  than guess the planner's preference. The decl is also `private`; if any cross-file blueprint
  consumer is ever needed it must be de-`private`'d (already flagged in `CechAcyclic.md`).
- The new engine block uses the label prefix `def:` on a `\begin{lemma}` (per directive, so the
  `\uses{}` resolves). Cosmetic only; flagging in case a future tidy wants prefix/environment
  consistency.
- `lem:cech_free_complex_quasi_iso` (`AlgebraicGeometry.cechFreeComplex_quasiIso`) remains
  legitimately unmatched in the DAG — the decl is not yet built (per `FreePresheafComplex.md`).
  Not in my edit scope; noted so it is not mistaken for fallout of these edits.

## Strategy-modifying findings
None. The Edit 3 issue is a directive/naming inaccuracy, not a mathematics- or strategy-level
problem; the resolution-form re-sign (Edit 1) matches the validated P5a design (option 1 in
`HigherDirectImagePresheaf.md`).
