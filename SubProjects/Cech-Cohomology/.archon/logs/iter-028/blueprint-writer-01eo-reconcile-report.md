# Blueprint Writer Report

## Slug
01eo-reconcile

## Status
COMPLETE — all 8 directive tasks executed; `archon dag-query unmatched` = 0, no broken `\uses`, acyclic, LaTeX balanced, no `\leanok` touched.

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### TASK 1 — `lem:cech_ses_of_basis` (L1) rewritten to landed cover-local form
- Removed the `% NOTE (iter-027 review)` block.
- Statement rewritten: fixes index family `U : ι → Opens X` and a short complex `P` of presheaves of
  modules; per-face hypothesis (`faceShortComplex` short exact for every `p,σ` over `V_σ = ⨅ₖ U(σk)`);
  conclusion = short-exactness of the section Čech short complex (Def `def:section_cech_short_complex`).
  Added the requested remark wiring the `(B,Cov)` instantiation to `lem:face_ses_of_sheaf_ses` /
  `lem:ses_cech_h1`.
- Proof rewritten to the degreewise-product argument (degreewise reduction → product of per-face short
  complexes → `lem:short_exact_pi_map`).
- Statement `\uses` extended to `{def:cech_complex, def:face_short_complex,
  def:section_cech_short_complex, lem:ses_cech_h1, lem:short_exact_pi_map}`; verbatim
  `% SOURCE QUOTE PROOF` preserved.

### TASK 2 — `lem:quotient_vanishing_cech` (L2) rewritten to landed form
- Removed the `% NOTE (iter-027 review)` block.
- Statement rewritten: `U`, `P` as in L1; enumerated hyps (1) section-Čech SES, (2) `Ȟ^{>0}(𝒰,P.X₂)=0`,
  (3) `Ȟ^{>0}(𝒰,P.X₁)=0` ⟹ `Ȟ^{>0}(𝒰,P.X₃)=0`. Noted hI←`injective_cech_acyclic`, hF←condition (3).
- Proof rewritten to factor through `lem:cech_homology_quotient_vanishing` (homology-LES δ-iso shift).
- Statement `\uses` extended with `def:cech_cohomology_accessor` and
  `lem:cech_homology_quotient_vanishing`; verbatim quote preserved.

### TASK 3 — Added `lem:short_exact_pi_map` (AB4*)
- New lemma, `\lean{AlgebraicGeometry.shortExact_piMap, AlgebraicGeometry.pi_π_map_apply}`,
  placed just before L1. Statement = product of SES in `Ab` is SES; one-line proof emphasizing the
  non-trivial epi half via componentwise preimages + product identification. `\uses{def:cech_complex}`.
  Archon-original infra (no fabricated source quote).

### TASK 4 — Added `lem:cech_homology_quotient_vanishing`
- New lemma, `\lean{AlgebraicGeometry.cechHomology_quotient_vanishing}`, placed just before L2.
  Abstract homological core (SES of cochain complexes in `Ab`, X₂/X₁ acyclic ⟹ X₃ acyclic) via the
  δ-iso `H^p(T₃)≅H^{p+1}(T₁)=0`. `\uses{lem:homology_long_exact_sequence}` (the existing cross-chapter
  Mathlib δ/LES anchor in `Cohomology_AcyclicResolution.tex` — already `\mathlibok`, so no new anchor
  needed).

### TASK 5 — Coverage for the unmatched `CechToCohomology.lean` helpers
- `def:cech_cohomology_accessor` (`cechCohomology`), `\uses{def:section_cech_complex}`.
- `def:section_cech_short_complex` (`sectionCechComplexShortComplex`),
  `\uses{def:section_cech_complex, def:section_cech_functoriality}`.
- `def:face_short_complex` (`faceShortComplex`) — made a thin def block (rather than bundling into L1)
  because `lem:face_ses_of_sheaf_ses` / L1 reference it by label, `\uses{def:section_cech_complex}`.
- `def:section_cech_functoriality` bundling all four functoriality helpers
  (`sectionCechCosimplicialMap/Functor`, `sectionCechComplexFunctor/Map`), `\uses{def:section_cech_complex}`.

### TASK 6 — Added `lem:face_ses_of_sheaf_ses`
- New scaffold lemma, `\lean{AlgebraicGeometry.faceShortComplex_shortExact_of_sheaf_ses}` with
  `% NOTE: target not yet formalized — scaffold this iter`. Statement: sheaf SES + per-face section
  surjectivity (from `ses_cech_h1`) ⟹ per-face presheaf short complex short exact. Proof = section
  left-exactness (right-adjoint inclusion + evaluation preserve limits) for mono/middle, `ses_cech_h1`
  for epi. `\uses{lem:ses_cech_h1, def:face_short_complex}`. Reuses the existing verbatim
  `% SOURCE QUOTE PROOF` `0 → F(U) → I(U) → Q(U) → 0` fragment (re-verified against
  `references/stacks-cohomology.tex` L1729–1734).

### TASK 7 — BasisCovSystem / HasVanishingHigherCech encoding + L3/L4/top reconcile
- `def:basis_cov_system` (`\lean{AlgebraicGeometry.BasisCovSystem}`, scaffold NOTE): basis `B`, cover
  set `Cov`, faces-in-basis (cond 1), cofinality (cond 2); explicitly no colimit machinery.
  `\uses{def:cech_complex}`.
- `def:has_vanishing_higher_cech` (`\lean{AlgebraicGeometry.HasVanishingHigherCech}`, scaffold NOTE):
  abstract per-module predicate; prose emphasizes it must stay abstract (Q=I/F not QCoh; QCoh F only as
  seed). `\uses{def:basis_cov_system, def:cech_cohomology_accessor}`.
- **L3** `lem:absolute_cohomology_one_vanishing`: statement rewritten to cover-local hypothesis-driven
  form (open `U`, sheaf SES `S`, `I` injective, section surjectivity `I(U)↠Q(U)` as hypothesis ⟹
  `H¹(U,F)=0`). Detailed Ext-LES proof kept; only the surjectivity-source sentence changed to "by
  hypothesis". `\uses` unchanged (already correct).
- **L4** `lem:absolute_cohomology_pos_vanishing`: statement rewritten to `BasisCovSystem` signature
  (`s`, `F` with `HasVanishingHigherCech s F`, `U ∈ s.B`, `p>0` ⟹ `H^p(U,F)=0`). Proof updated:
  induction over the abstract class; new paragraph deriving section surjectivity per `U ∈ s.B` via
  cond(1)+cond(2)+`ses_cech_h1`+`lem:face_ses_of_sheaf_ses`+`lem:cech_ses_of_basis`, then quotient
  closure via `lem:quotient_vanishing_cech`; base case = L3. `\uses` extended with
  `def:basis_cov_system, def:has_vanishing_higher_cech, lem:face_ses_of_sheaf_ses`.
- **top** `lem:cech_to_cohomology_on_basis`: proof rewritten to the thin assembly — conditions (1)–(2)
  assemble a `BasisCovSystem` instance `s`, condition (3) = `HasVanishingHigherCech s F`, then apply L4.
  Acyclicity note (no use of `lem:affine_serre_vanishing`) preserved. Statement + verbatim quotes
  untouched (its `\uses` was already correct).

### TASK 8 — Bundled the 4 private naturality helpers
- Appended `homEquiv₀_comp_mk₀, freeYonedaHomEquiv_naturality, sheafificationHomAddEquiv_naturality,
  jShriekOU_homEquiv_naturality` to the `\lean{}` list of `lem:absolute_cohomology_zero_natural`.

## Cross-references introduced
- `lem:cech_homology_quotient_vanishing` `\uses{lem:homology_long_exact_sequence}` — that label lives in
  `Cohomology_AcyclicResolution.tex` (verified present, `\mathlibok`); cross-chapter edge, resolves
  cleanly in leandag (`unknown_uses: []`).
- All other new `\uses` targets are in-chapter and verified.

## Verification
- `archon dag-query unmatched`: **0 of 0** (was 14).
- `leandag build`: `unknown_uses: []`, `conflicts: []`, `isolated: 0`, 99 nodes / 223 edges, build
  succeeded (acyclic).
- LaTeX environments balanced: lemma 53/53, definition 24/24, proof 44/44, enumerate 5/5.
- `\leanok` count unchanged (23); `\mathlibok` unchanged (8) — none added/removed by me.
- All 44 `SOURCE QUOTE` blocks preserved; both `% NOTE (iter-027 review)` lines removed; 3 scaffold
  `% NOTE: ... scaffold this iter` lines present (BasisCovSystem, HasVanishingHigherCech, face-SES).

## References consulted
- `references/stacks-cohomology.tex` (L1729–1734) — re-verified the verbatim
  `0 → F(U) → I(U) → Q(U) → 0` section-exactness fragment reused in `lem:face_ses_of_sheaf_ses`'s
  `% SOURCE QUOTE PROOF`.
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — target chapter (all existing verbatim
  quotes already transcribed there from the Stacks sources).
- `AlgebraicJacobian/Cohomology/CechToCohomology.lean`, `AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean`
  — confirmed the exact landed declaration names/signatures for the `\lean{}` hints.

## Macros needed
- None. All notation uses existing macros / standard math-mode commands.

## Notes for Plan Agent
- The three scaffold pins `AlgebraicGeometry.BasisCovSystem`, `AlgebraicGeometry.HasVanishingHigherCech`,
  `AlgebraicGeometry.faceShortComplex_shortExact_of_sheaf_ses` are tex-without-Lean by design (this
  iter's prover targets); they do not count as `unmatched`. The prover should create them at exactly
  these names/signatures.
- The effort-breaker flagged standard-open cofinality (Stacks `schemes-lemma-standard-open`) as a
  separable side-scaffold needed only at the 02KG `BasisCovSystem` instantiation (not by L1–L4); it has
  no blueprint block yet. Not in scope for this directive, but worth a future coverage entry.
- `lem:cech_homology_quotient_vanishing` leans on the cross-chapter `lem:homology_long_exact_sequence`
  anchor for the δ-iso; if that chapter's anchor is ever renamed, this edge must be updated.

## Strategy-modifying findings
None — the landed L1/L2 and the scaffolded L3/L4/top are mutually consistent and match the
effort-breaker's decomposition; no strategy-level issue surfaced.
