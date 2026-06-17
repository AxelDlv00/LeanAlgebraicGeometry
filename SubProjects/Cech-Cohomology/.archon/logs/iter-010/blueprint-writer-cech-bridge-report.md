# Blueprint Writer Report

## Slug
cech-bridge

## Status
COMPLETE

All required items (A)–(E) were written. The circular proof of
`lem:cech_to_cohomology_on_basis` is replaced by the torsor-free dimension-shift
bridge; `leandag build` reports no `unknown_uses`, no conflicts (no cycle), and none
of the new blocks isolated.

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### (A) Minimal Čech↔derived bridge — NEW blocks
- **Added lemma** `\label{lem:injective_cech_acyclic}` / `\lean{AlgebraicGeometry.injective_cech_acyclic}` — injective `O_X`-modules are Čech-acyclic (`Ȟ^p(𝒰,I)=0` for `p>0`, `=I(U)` for `p=0`). Statement + proof verbatim-quoted from Stacks `lemma-injective-trivial-cech` (L1407–1431) with a supporting verbatim quote from `lemma-cech-cohomology-derived-presheaves` (L1287–1398). Proof prose kept at the δ-functor level; explicitly flags the presheaf-level Čech machinery (`PMod(O_X)` enough injectives, Čech-complex-exact-as-a-functor) as a from-scratch formalisation gap. `\uses{def:cech_complex}`.
- **Added lemma** `\label{lem:ses_cech_h1}` / `\lean{AlgebraicGeometry.ses_cech_h1}` — SES + cofinal Čech-`H¹` vanishing ⟹ `G(U) → H(U)` surjective. Statement + proof verbatim from Stacks `lemma-ses-cech-h1` (L1593–1628). `\uses{def:cech_complex}`.

### (B) Repaired `lem:cech_to_cohomology_on_basis` (break the cycle)
- **Statement** kept as the genuine Stacks 01EO basis criterion; conclusion changed to the honest `H^p(U,F)=0 for p>0, U∈ℬ` (resolving the statement↔proof mismatch — previously it claimed a universal comparison iso that the proof did not establish).
- **Proof** rewritten as the Stacks `lemma-cech-vanish-basis` dimension shift: embed `F ↪ I` injective; `Ȟ^p(𝒰,I)=0` by `lem:injective_cech_acyclic`; `Q=I/F`; `lem:ses_cech_h1`+(2) ⟹ SES exact on sections ⟹ (via (1)) SES of Čech complexes ⟹ `Q` has vanishing higher Čech cohomology; sheaf-LES + `H^n(U,I)=0` bootstraps `H^1(U,F)=0`; induction gives all `p>0`.
- Proof `\uses{lem:injective_cech_acyclic, lem:ses_cech_h1, lem:cech_acyclic_affine}` — **does NOT** list `lem:affine_serre_vanishing`. Deleted all prior "term-acyclicity / affine vanishing follows from the contracting homotopy with no sheaf-cohomology input" prose and the acyclic-resolution-route argument. Added an explicit note that the only Čech-vanishing input is condition (3) (= `lem:cech_acyclic_affine` on the affine instantiation), so the edge `affine_serre_vanishing → this lemma` is one-directional.

### (C) P3 standard-cover Lean type
- **Added definition** `\label{def:standard_affine_cover}` / `\lean{AlgebraicGeometry.Scheme.affineOpenCoverOfSpanRangeEqTop}`, marked `\mathlibok` (verified the declaration exists in `Mathlib/AlgebraicGeometry/Cover/Open.lean:203`, returning `(Spec R).AffineOpenCover` with `f i = Spec.map (algebraMap R (Localization.Away (s i)))`). States the standard cover from a spanning family `s : ι → R`, `Ideal.span (Set.range s) = ⊤`, pieces `D(s_i)` with sections `R_{s_i}`.
- **Revised** `lem:cech_acyclic_affine`: added `def:standard_affine_cover` to `\uses{}`; statement prose now records the narrowed spanning-bundle signature `(s : ι → A) (hs : Ideal.span (Set.range s) = ⊤)`; proof prose gains a closing paragraph naming the Mathlib idioms (local-to-global `exact_of_isLocalized_span` localising at `Away (f_r)`, then `i_fix = r` contracts the localised complex). The existing contracting-homotopy SOURCE QUOTE PROOF was left untouched.

### (D) `lem:higher_direct_image_presheaf`
- Statement prose now carries the instance hypothesis `[HasInjectiveResolutions X.Modules]` (cross-referencing the NOTE on `def:higher_direct_image`).
- Proof gains a from-scratch caveat: the `rightDerived ↔ sheafification-of-cohomology-presheaf` comparison must be built directly for `X.Modules` (Mathlib provides it only for `Sheaf J AddCommGrpCat`), keeping the existing Stacks 01XJ SOURCE QUOTE.

### (E) Citation + `\uses` hygiene
- Moved the `% SOURCE QUOTE PROOF:` of `lem:cech_to_cohomology_on_basis` to sit immediately before `\begin{proof}` (was inside the lemma env). Replaced the old application-context quote with the verbatim Stacks `lemma-cech-vanish-basis` proof text (L1716–1776, including the long-exact-sequence xymatrix). Updated the `% SOURCE:` pointer to `references/stacks-cohomology.tex, L1695–1776`.
- `lem:open_immersion_pushforward_comp`: removed `lem:acyclic_resolution_computes_derived` from the **statement** block `\uses{}`; it remains in the proof block `\uses{}`.

## Cross-references introduced
- Proof of `lem:cech_to_cohomology_on_basis` now `\uses{lem:injective_cech_acyclic, lem:ses_cech_h1, lem:cech_acyclic_affine}` — all in this chapter; verified resolved by leandag.
- `lem:cech_acyclic_affine` `\uses{def:cech_complex, def:standard_affine_cover}` — both in this chapter.
- `lem:injective_cech_acyclic`, `lem:ses_cech_h1` each `\uses{def:cech_complex}` (this chapter).
- leandag: `unknown_uses: []`, `conflicts: []` (acyclic), 0 isolated among new blocks.

## References consulted
- `references/stacks-cohomology.tex` — verbatim quotes: `lemma-injective-trivial-cech` statement+proof (L1407–1431); `lemma-cech-cohomology-derived-presheaves` δ-functor statement + injective-acyclicity proof excerpt (L1287–1398); `lemma-ses-cech-h1` statement+proof (L1593–1628); `lemma-cech-vanish-basis` (01EO) statement+proof (L1695–1776).
- `references/summary.md` — source index.
- Mathlib source (read directly, not under `references/`, for the `\mathlibok` anchor verification): `.lake/packages/mathlib/Mathlib/AlgebraicGeometry/Cover/Open.lean` (`affineOpenCoverOfSpanRangeEqTop`), `.lake/packages/mathlib/Mathlib/RingTheory/LocalProperties/Exactness.lean` (`exact_of_isLocalized_span`).

## Macros needed (if any)
- None. `\mathlibok` is defined (`blueprint/src/macros/print.tex:17`); `cases` env is provided by amsmath (web build) and mathtools (print build), both already loaded.

## Reference-retriever dispatches (if any)
- None. All required source text was present in `references/stacks-cohomology.tex`.

## Notes for Plan Agent
- The directive's References section names `analogies/p3-localisation.md`, which does **not** exist (the present analogies are `cech-koszul-precedent.md` and `finite-product-localisation-and-cech-r-linearity.md`). The (C) prose for `def:standard_affine_cover` and the `exact_of_isLocalized_span` naming were written from the directive's own description and verified directly against the Mathlib source, so no content was guessed. Consider renaming the analogy in future directives or adding the file.
- `def:higher_direct_image` and `lem:acyclic_resolution_computes_derived` live in sibling chapters (`Cohomology_HigherDirectImage.tex`, `Cohomology_AcyclicResolution.tex`); the `\uses{}` edges to them resolve cleanly but I did not edit those chapters (out of scope).
- The new `lem:injective_cech_acyclic` / `lem:ses_cech_h1` are honest project obligations (no `\mathlibok`): both rest on presheaf-level Čech δ-functor machinery that is a genuine from-scratch Mathlib build, flagged in their prose. The prover should budget for this — it is the irreducible Čech↔derived crossing the strategy identified.
- `lem:cech_to_cohomology_on_basis` keeps its `\lean{AlgebraicGeometry.cech_eq_cohomology_of_basis}` hint, but the statement now concludes vanishing (`H^p=0`) rather than an equality of cohomologies. If the mathematician wants the Lean signature to mirror the vanishing form, the name may warrant a follow-up `% NOTE:` / rename by the review agent — not done here (the name is unprotected but renaming was not in scope).

## Strategy-modifying findings
None. The repair is exactly the strategy's prescribed torsor-free dimension-shift bridge; it breaks the `affine_serre_vanishing ↔ cech_to_cohomology_on_basis` cycle without altering the Route-A arc or any protected signature.
