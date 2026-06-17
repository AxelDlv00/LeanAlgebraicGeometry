# Blueprint Writer Report

## Slug
formb

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

- **Added covers line** — `% archon:covers AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean`
  at the chapter-top covers block.

- **Added definition** `\label{def:jshriek_ou}` / `\lean{AlgebraicGeometry.jShriekOU}` —
  the corepresenting object `j_!O_U := sheafification(free(yoneda U))` in `X.Modules`,
  built without the extension-by-zero functor. Project-original (no `% SOURCE`).
  `\uses{def:cech_free_presheaf_complex, lem:mod_pmod_adjunction, lem:cech_complex_hom_identification}`.

- **Added lemma + proof** `\label{lem:jshriek_corepr}` / `\lean{AlgebraicGeometry.jShriekOU_homEquiv}` —
  natural additive iso `Hom_{X.Modules}(j_!O_U, F) ≅ Γ(U,F) = F(U)`. One-line proof composes
  the sheafification adjunction homEquiv with `freeYonedaHomAddEquiv`. Project-original.
  `\uses{def:jshriek_ou, lem:mod_pmod_adjunction, lem:cech_complex_hom_identification}`.

- **Rewrote** `def:absolute_cohomology` to Form B — primary (and only) realization is now
  `H^p(U,F) := Ext^p_{X.Modules}(j_!O_U, F)`. Dropped the Form-A primary / Form-B-equivalently
  hedge and the `Ext^p_{Mod(O_U)}(O_U, F|_U)` formula. Added `\lean{AlgebraicGeometry.absoluteCohomology}`.
  The three structural clauses now read: (0) `Ext^0 ≅ Hom ≅ Γ(U,F)` via `Ext.homEquiv₀` then
  `lem:jshriek_corepr`; (inj) injective `I` in the SECOND argument so `Ext^{n+1}(j_!O_U,I)=0`
  directly with explicit "no restriction is taken / restriction-preserves-injectives not needed";
  (LES) covariant Ext LES at fixed first arg `j_!O_U`.
  `\uses{}` updated to `{def:jshriek_ou, lem:jshriek_corepr, lem:ext_bifunctor_mathlib,
  lem:ext_covariant_les_mathlib, lem:ext_eq_zero_of_injective_mathlib, lem:ext_homequiv_zero_mathlib,
  lem:hasext_standard_mathlib}` (removed `lem:modules_restrict_functor_mathlib`).

- **Removed** `lem:modules_restrict_functor_mathlib` (the `restrictFunctor` Mathlib anchor) —
  Form B takes no restriction anywhere, so the anchor and all `\uses` of it are gone (verified by
  grep: no `restrictFunctor` / `Mod(O_U)` / `F|_U` remain in the absolute-cohomology section).

- **Revised** section heading "as Ext of the structure sheaf" → "as Ext of the corepresenting
  object", and rewrote the section intro paragraph to state the Form-B realization.

- **Revised** `lem:ext_homequiv_zero_mathlib` prose — removed Form-A `Ext^0(O_U, F|_U)` /
  `Hom_{O_U}(O_U,F|_U)` instantiation, replaced with the `A = j_!O_U` first-argument instance
  composed with `lem:jshriek_corepr`. (`\lean`/`\mathlibok` unchanged.)

- **Revised** `lem:cech_to_cohomology_on_basis` proof (01EO) — the injective-vanishing /
  LES prose is now Form B: SES `0→F→I→Q→0` in `X.Modules`, `H^n(U,-)=Ext^n(j_!O_U,-)` covariant
  in the 2nd variable with fixed 1st arg, `I` is the 2nd argument so `H^n(U,I)=0` immediate, and
  `H^0=Γ` via `lem:jshriek_corepr`∘`Ext.homEquiv₀`. Stacks `% SOURCE QUOTE`/`% SOURCE QUOTE PROOF`
  verbatim comments left intact. Proof `\uses` extended with
  `{lem:jshriek_corepr, lem:ext_covariant_les_mathlib, lem:ext_eq_zero_of_injective_mathlib,
  lem:ext_homequiv_zero_mathlib}`.

## `\lean{}` names pinned (for the prover to scaffold in AbsoluteCohomology.lean)
- `AlgebraicGeometry.jShriekOU` — the corepresenting object.
- `AlgebraicGeometry.jShriekOU_homEquiv` — the corepresentability natural additive iso.
- `AlgebraicGeometry.absoluteCohomology` — the `H^p(U,-)` realization.

## Cross-references introduced
- `def:jshriek_ou` → `def:cech_free_presheaf_complex` (free presheaf on representable, existing),
  `lem:mod_pmod_adjunction` (sheafificationAdjunction anchor, existing),
  `lem:cech_complex_hom_identification` (carries `freeYonedaHomEquiv`/`freeYonedaHomAddEquiv`, existing).
- `lem:jshriek_corepr` → `def:jshriek_ou`, `lem:mod_pmod_adjunction`, `lem:cech_complex_hom_identification`.
- `def:absolute_cohomology` → `def:jshriek_ou`, `lem:jshriek_corepr` (+ existing Ext anchors).
All verified present via `leandag build --json`: `isolated: 0`, `unknown_uses: []`, `conflicts: []`.

## `\uses` changed
- `def:absolute_cohomology` — dropped `lem:modules_restrict_functor_mathlib`; added
  `def:jshriek_ou`, `lem:jshriek_corepr`.
- `lem:cech_to_cohomology_on_basis` (proof) — added four Form-B lemmas (above).

## References consulted
None — all edited/added blocks in this round are either project-original (corepresentability /
realization, no external source) or reuse of existing in-chapter Mathlib anchors and existing
verbatim Stacks quotes (left byte-for-byte intact). No `references/` files were opened and no
new `% SOURCE`/`% SOURCE QUOTE` lines were authored.

## Macros needed
None new. (`j_!`, `\mathbf{y}`, `\operatorname{free}`, `\operatorname{sheafification}` are all
already used elsewhere in the chapter.)

## Flags / uncertainties on Mathlib anchors
- The two anchors the new blocks lean on already exist in the chapter and were not re-authored:
  `lem:mod_pmod_adjunction` (`PresheafOfModules.sheafificationAdjunction`) and
  `lem:cech_complex_hom_identification` (carries `freeYonedaHomEquiv`/`freeYonedaHomAddEquiv`).
- There is no standalone Mathlib anchor for the bare `PresheafOfModules.free` functor; the directive
  said to `\uses` the `free` anchor, and the closest existing blueprinted home for `free`/`freeYoneda`
  is `def:cech_free_presheaf_complex` (its `\lean{}` covers `AlgebraicGeometry.freeYoneda`), which I
  used. If a dedicated `PresheafOfModules.free` `\mathlibok` anchor is wanted, it would be a one-line
  add — flagging for the reviewer, but not blocking (the dependency edge is honest as wired).
- `def:absolute_cohomology`'s new `\lean{AlgebraicGeometry.absoluteCohomology}`, plus `jShriekOU`
  and `jShriekOU_homEquiv`, name Lean declarations that do not yet exist (the new
  `AbsoluteCohomology.lean`); this is expected blueprint-ahead-of-Lean and the prover scaffolds them.

## Notes for Plan Agent
- The 02KG `affine_serre_vanishing` block and its proof reference `def:absolute_cohomology` via
  `\uses` and prose "the Ext realization of Def~\ref{def:absolute_cohomology}" — no Form-A language;
  left as-is per directive.
- Remaining `\mathcal{O}_U` occurrences in the chapter are unrelated to the realization: the Serre
  statement (U an affine scheme), the `\mathcal{O}_{\mathcal{U}}` cover structure presheaf
  (`lem:cech_free_complex_quasi_iso`), and `R^if_*` quasi-coherent-module phrasings. None reconciled
  because none are Form-A.

## Strategy-modifying findings
None.
