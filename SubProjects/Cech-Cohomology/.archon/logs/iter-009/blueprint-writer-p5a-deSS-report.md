# Blueprint Writer Report

## Slug
p5a-deSS

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

Three proof blocks de-spectral-sequenced to Route-A (acyclic-resolution / Cartan–Leray)
arguments. No statement, `\lean{}`, `\leanok`, or `\mathlibok` was touched.

### (1) `lem:cech_to_cohomology_on_basis` — proof rewritten
- **Removed** the "Čech-to-derived-functor spectral sequence … collapses … edge map is
  an isomorphism" argument and the self-flagged "not yet available in Mathlib … to-build
  dependency" sentence.
- **New proof** (the reduced-scope direct argument for the affine/standard-cover instance
  actually consumed downstream): augmented Čech complex of a standard cover of an affine
  `B = Spec A` is an exact resolution of `F` (via `lem:cech_augmented_resolution`); each
  Čech term `C^p` is `Γ(B,-)`-acyclic via the contracting homotopy of
  `lem:cech_acyclic_affine` applied one step down to each affine `U_σ` (no sheaf-cohomology
  / SS input); then `lem:acyclic_resolution_computes_derived` with `G = Γ(B,-)` gives
  `H^k(B,F) ≅ H^k(Γ(B,C^•)) = Čech-H^k(𝒰,F) = 0` for `k ≥ 1`.
- Prose is explicit that this is the affine/standard-cover special case, and that it is
  **non-circular**: it consumes narrowed standard-cover Čech vanishing
  (`lem:cech_acyclic_affine`, the P3 output) and lifts it to affine sheaf vanishing as
  output, with **no** use of `lem:affine_serre_vanishing`.
- **New proof `\uses{}`**:
  `\uses{lem:cech_acyclic_affine, lem:cech_augmented_resolution, lem:acyclic_resolution_computes_derived}`
  (was `\uses{lem:cech_acyclic_affine}`).
- **Statement `\uses{}` unchanged** (`\uses{def:cech_complex}`) — the in-statement
  dependency set did not change (the new lemmas are proof-level).
- **Added `% SOURCE QUOTE PROOF:`** before `\begin{proof}` — verbatim Stacks 01EO proof
  (the SS-free embed-into-injective + dimension-shift form), read from
  `references/stacks-cohomology.tex` L1716–1776, quoted in full including the long-exact
  xymatrix. The prose notes that the source proves 01EO this way and that we reorganise it
  as the lighter acyclic-resolution reduction.

### (2) `lem:open_immersion_pushforward_comp` — part (2) proof rewritten
- **Part (1) left untouched** (`R^q j_* H = 0`, already Route-A-clean).
- **Removed** the relative-Leray-spectral-sequence argument for part (2)
  (`E_2^{p,q} = R^p f_*(R^q j_* H) ⇒ R^{p+q} g_* H`, degenerates).
- **New part (2)** (injective-resolution / `f_*`-acyclicity): inject resolution
  `H → I^•` in `U.Modules`; `j_* I^•` is a resolution of `j_* H` (each `I^n` is
  `j_*`-acyclic by part (1)); each `j_* I^n` is `f_*`-acyclic because, by the presheaf
  description (`lem:higher_direct_image_presheaf`), `R^k f_*(j_* I^n)` is the
  sheafification of `V ↦ H^k(U ∩ f⁻¹(V), I^n|_{…})`, which vanishes for `k ≥ 1` on affine
  `V` (with `U ∩ f⁻¹(V)` affine) by `lem:affine_serre_vanishing`; then
  `lem:acyclic_resolution_computes_derived` with `G = f_*` gives
  `R^k f_*(j_* H) ≅ H^k((f∘j)_* I^•) = R^k g_* H`.
- **New proof `\uses{}`**:
  `\uses{lem:affine_serre_vanishing, lem:higher_direct_image_presheaf, lem:acyclic_resolution_computes_derived}`
  (added `lem:acyclic_resolution_computes_derived`; dropped the relative-Leray reference,
  which was prose-only, not a `\uses`).
- **Statement `\uses{}` updated**: added `lem:acyclic_resolution_computes_derived` (now a
  genuine dependency of the block) →
  `\uses{lem:affine_serre_vanishing, lem:higher_direct_image_presheaf, lem:acyclic_resolution_computes_derived}`.
- **Citation apparatus updated**: dropped the `lemma-relative-Leray` `% SOURCE:` clause,
  the relative-Leray `% SOURCE QUOTE:`, and the relative-Leray mention in the
  `\textit{Source: …}` line. Kept the `lemma-relative-affine-vanishing` `% SOURCE:` +
  `% SOURCE QUOTE:`.
- **Added `% SOURCE QUOTE PROOF:`** before `\begin{proof}` — verbatim
  `lemma-relative-affine-vanishing` proof, read from `references/stacks-coherent.tex`
  L187–198. This is exactly the presheaf-description + affine-vanishing template our part
  (2) restates.

### (3) `lem:cech_term_pushforward_acyclic` — one sentence de-contaminated
- **Replaced** "consequently the Grothendieck composition spectral sequence for `f ∘ j_s`
  degenerates and `R^k f_*((j_s)_* F|_{U_s}) = R^k (g_s)_* F|_{U_s}`" with "By
  Lemma~\ref{lem:open_immersion_pushforward_comp} part (2),
  `R^k f_*((j_s)_* F|_{U_s}) ≅ R^k (g_s)_* F|_{U_s}`." (The preceding clause
  "`R^q (j_s)_*` vanish for `q ≥ 1`" is retained — still accurate, part (1).)
- No other change to this block. Its `\uses{}` already listed
  `lem:open_immersion_pushforward_comp`; unchanged.

## Cross-references introduced
- `\uses{lem:acyclic_resolution_computes_derived}` added in the proofs of
  `lem:cech_to_cohomology_on_basis` and `lem:open_immersion_pushforward_comp`, and in the
  statement `\uses{}` of `lem:open_immersion_pushforward_comp`. Target verified to exist:
  `\label{lem:acyclic_resolution_computes_derived}` in
  `blueprint/src/chapters/Cohomology_AcyclicResolution.tex:928`.
- `\uses{lem:cech_augmented_resolution}` added in the proof of
  `lem:cech_to_cohomology_on_basis` — target is in this same chapter.
- `leandag build --json`: `unknown_uses: []`, `conflicts: []`. `leandag query --isolated
  --chapter Cohomology_CechHigherDirectImage`: 0 results. No broken or isolated edges
  introduced.

## References consulted
- `references/stacks-cohomology.tex` — L1695–1714 (statement of `lemma-cech-vanish-basis`,
  Tag 01EO; already-present statement quote) and L1716–1776 (its SS-free
  embed-into-injective proof, copied verbatim as the new `% SOURCE QUOTE PROOF:` for
  rewrite (1)).
- `references/stacks-coherent.tex` — L180–199 (`lemma-relative-affine-vanishing`: statement
  L182–184 retained as `% SOURCE QUOTE:`; proof L187–198 copied verbatim as the new
  `% SOURCE QUOTE PROOF:` for rewrite (2)).

## Macros needed
- None. All commands used already exist / are standard.

## Reference-retriever dispatches
- None. Both Stacks results needed (Tag 01EO, `lemma-relative-affine-vanishing`) were
  already present in the local reference files with the required line ranges.

## Notes for Plan Agent
- The **statement** of `lem:cech_to_cohomology_on_basis` is still phrased as the *general*
  basis-comparison criterion (ringed space, basis `B`, abstract conditions (1)–(3)), per
  the freeze. The rewritten **proof** establishes only the affine/standard-cover instance
  (and says so explicitly). This is the intended Route-A scope per the directive, but the
  general statement is now strictly stronger than what its proof argues. If a future phase
  wants statement↔proof parity, the statement should be narrowed to the affine/standard
  case (the form the Lean `cech_eq_cohomology_of_basis` and the sole consumer
  `affine_serre_vanishing` actually need) — flagged here since I may not edit the frozen
  statement.
- The `% SOURCE QUOTE PROOF:` added to (1) is the source's embed-into-injective proof,
  which is *not* the argument the project body uses (the body uses the lighter
  acyclic-resolution route built from project lemmas). The prose bridges this explicitly.
  If the reviewer prefers the SOURCE QUOTE PROOF to mirror the body, the block could
  instead stand as project-bespoke (its inputs `lem:cech_augmented_resolution`,
  `lem:cech_acyclic_affine`, `lem:acyclic_resolution_computes_derived` each already carry
  their own citations) and the 01EO proof quote be dropped. I included it for maximal
  citation safety.

## Strategy-modifying findings
None. Each of the three Route-A rewrites went through cleanly with the inputs the directive
named; no step secretly still required a spectral sequence. The acyclic-resolution lemma
`lem:acyclic_resolution_computes_derived` and the two geometric inputs
(`lem:cech_augmented_resolution`, `lem:cech_acyclic_affine`, `lem:affine_serre_vanishing`,
`lem:higher_direct_image_presheaf`) suffice for all three. The non-circularity of rewrite
(1) (standard-cover Čech vanishing → affine sheaf vanishing, no use of
`lem:affine_serre_vanishing`) holds as the directive stated.
