# Blueprint Writer Report

## Slug
comparison

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### (A) Rewrote the proof of `lem:cech_computes_cohomology` to the acyclic-resolution route
- **Added lemma** `\lemma`/`\label{lem:cech_augmented_resolution}`/`\lean{AlgebraicGeometry.cechAugmented_exact}`
  — the augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` on `X` is exact (a resolution
  of `F` in `X.Modules`). `\uses{def:cech_nerve, lem:cech_acyclic_affine}`.
  - Proof sketch added: Y — exactness is local; on each affine intersection it is the
    standard-cover extended-complex exactness of `lem:cech_acyclic_affine` (the
    prime-local contracting homotopy). SOURCE QUOTE = the "extended complex … is
    exact … after localizing at a prime" passage from
    `lemma-cech-cohomology-quasi-coherent-trivial` (proof).
- **Added lemma** `\lemma`/`\label{lem:cech_term_pushforward_acyclic}`/`\lean{AlgebraicGeometry.cechTerm_pushforward_acyclic}`
  — each Čech term `Cᵖ = ∏ (j_s)_*(F|_{U_s})` is right `f_*`-acyclic:
  `(f_*).rightDerived k (Cᵖ) = 0` for `k ≥ 1`. `\uses{lem:affine_serre_vanishing, def:cech_nerve}`.
  - Proof sketch added: Y — reduce to `S` affine (`R^k f_*` local on `S`); `j_s` is the
    inclusion of an affine open into separated `X`, hence affine, so `R^q(j_s)_* = 0`
    and the Grothendieck composition gives `R^k f_*((j_s)_*G) = R^k(g_s)_*G` for
    `g_s = f∘j_s`; locally over affine `V ⊆ S`, `g_s` restricts to a morphism of
    affine schemes, hence affine, so relative affine vanishing kills `R^k(g_s)_*`; that
    relative vanishing is itself a consequence of Serre vanishing
    (`lem:affine_serre_vanishing`). SOURCE QUOTE = `lemma-relative-affine-vanishing`
    (statement + proof).
- **Revised** `lem:cech_computes_cohomology` (statement block) — updated ONLY its
  `\uses{}` to `{lem:cech_augmented_resolution, lem:cech_term_pushforward_acyclic,
  lem:acyclic_resolution_computes_derived, def:cech_complex, def:higher_direct_image}`.
  Statement prose, `\label`, and `\lean{}` pin left EXACTLY as is (frozen signature).
- **Rewrote the proof body** of `lem:cech_computes_cohomology` — replaced the
  two-spectral-sequence (Čech-to-cohomology + Leray degeneration) argument with the
  acyclic-resolution application: apply `lem:acyclic_resolution_computes_derived` with
  `G = f_*`, `A = F`, `J• = C•`; hypotheses (1) resolution and (2) termwise acyclicity
  are the two new sub-lemmas; conclude `(f_*).rightDerived i (F) ≅ Hⁱ(f_* C•) =
  Hⁱ(CechComplex) ≅ R^i f_* F`, taken in `Nonempty` form. Updated proof `\uses{}`
  accordingly. Replaced the old "absent infrastructure: two spectral sequences" closing
  paragraph with an accurate note: the only off-the-shelf-absent ingredients are now the
  abstract `lem:acyclic_resolution_computes_derived` plus the affine acyclicity
  `lem:cech_acyclic_affine` / `lem:affine_serre_vanishing`.
- **Trimmed citation comments**: kept the genuine Tag 02KE proof verbatim
  (`% SOURCE QUOTE PROOF:` "In view of … this is a special case of …
  cech-spectral-sequence-application") since that is the actual source proof of the
  lemma; **removed** the Leray-degeneration `% SOURCE QUOTE PROOF:` block (the proof of
  `lemma-quasi-coherence-higher-direct-images-application`), since the acyclic-resolution
  route does not use Leray and keeping that quote would misrepresent the proof. The
  relative-vanishing verbatim quote now lives in the A.2 block where it is actually used.

### (B) Split `lem:cech_acyclic_affine` into Čech-complex vanishing + Serre vanishing
- **Revised** `lem:cech_acyclic_affine` (`\lean{AlgebraicGeometry.CechAcyclic.affine}`
  unchanged) — statement is now ONLY the standard-cover **Čech-complex vanishing**
  `Ȟ^p(U,F) = 0` (`p>0`) / exactness of the extended complex of localisations; the
  former trailing "consequently `H^p(U,F)=0`" was removed and forwarded to the new
  Serre block. Its `% SOURCE QUOTE:` is now only the `lemma-cech-cohomology-quasi-coherent-trivial`
  statement, and its proof keeps the prime-local contracting-homotopy argument (citing
  `algebra-lemma-cover-module`, `algebra-lemma-characterize-zero-local`); the second
  (Serre) source quote was moved out to the new block.
- **Added lemma** `\lemma`/`\label{lem:affine_serre_vanishing}`/`\lean{AlgebraicGeometry.affine_serre_vanishing}`
  — Serre vanishing `H^p(U,F)=0` (`p>0`) on affine `U`. `\uses{lem:cech_acyclic_affine,
  lem:cech_to_cohomology_on_basis}`. SOURCE QUOTE = Tag 02KG
  `lemma-quasi-coherent-affine-cohomology-zero` (statement). Proof = the basis argument
  (affine opens as basis, standard covers, conditions (1)–(3)); SOURCE QUOTE PROOF =
  the verbatim basis-checking paragraph (L157–173).
- **Added lemma (to-build dependency)** `\lemma`/`\label{lem:cech_to_cohomology_on_basis}`/`\lean{AlgebraicGeometry.cech_eq_cohomology_of_basis}`
  — the basis-comparison vehicle `cohomology-lemma-cech-vanish-basis` that upgrades
  Čech-complex vanishing to sheaf-cohomology Serre vanishing. **Not** marked
  `\mathlibok` (see Notes). `\uses{def:cech_complex}` (+ proof `\uses{lem:cech_acyclic_affine}`).

The A.2 termwise-acyclicity lemma `\uses{lem:affine_serre_vanishing}` (the **Serre**
half), not `lem:cech_acyclic_affine` — i.e. the split was used to wire the relative
vanishing to the correct source, as the directive anticipated.

## Cross-references introduced
- `\uses{lem:acyclic_resolution_computes_derived}` in the statement and proof of
  `lem:cech_computes_cohomology` — **cross-chapter**; this label is being created this
  same iteration in `Cohomology_AcyclicResolution.tex`. `leandag` reports it under
  `unknown_uses` until the sibling chapter lands (expected).
- `\uses{lem:cech_augmented_resolution}`, `\uses{lem:cech_term_pushforward_acyclic}` —
  both defined in this chapter (new).
- `\uses{lem:affine_serre_vanishing}`, `\uses{lem:cech_to_cohomology_on_basis}` — both
  defined in this chapter (new).
- `lem:cech_augmented_resolution` additionally `\uses{lem:cech_acyclic_affine}` (beyond
  the directive's `def:cech_nerve`): its local exactness IS the standard-cover
  extended-complex exactness that `lem:cech_acyclic_affine` proves, so the edge is real.

`leandag build --json` after edits: `unknown_uses` = only `lem:acyclic_resolution_computes_derived`
(cross-chapter, expected); `isolated` = 4, all `lean_aux` nodes (none of my blueprint
blocks); `unmatched_lean` = the four new to-build `\lean{}` names (expected — those Lean
declarations do not exist yet). No broken intra-chapter edges.

## References consulted
- `references/summary.md` — index confirming `stacks-coherent.tex` backs this chapter.
- `references/stacks-coherent.tex` — verbatim quotes for:
  - `lemma-cech-cohomology-quasi-coherent-trivial` statement (L44–52) and proof
    (L54–82, the extended-complex exactness + contracting homotopy) →
    `lem:cech_acyclic_affine`, `lem:cech_augmented_resolution`.
  - `lemma-quasi-coherent-affine-cohomology-zero` statement (L145–155) and proof
    (L157–173, the basis argument) → `lem:affine_serre_vanishing`,
    `lem:cech_to_cohomology_on_basis`.
  - `lemma-relative-affine-vanishing` statement + proof (L180–199) →
    `lem:cech_term_pushforward_acyclic`.
  - `lemma-cech-cohomology-quasi-coherent` (Tag 02KE) statement (L245–256) and its
    one-line proof (L258–264) → comparison lemma SOURCE QUOTE PROOF.
  - `lemma-quasi-coherence-higher-direct-images-application` (L843–868) — read to
    confirm the removed Leray quote is no longer used by the route.

## Macros needed (if any)
None. All new prose uses existing macros / standard LaTeX.

## Reference-retriever dispatches (if any)
None dispatched. See Notes regarding `cohomology-lemma-cech-vanish-basis`.

## Notes for Plan Agent
- **`lem:cech_to_cohomology_on_basis` (`cohomology-lemma-cech-vanish-basis`)**: I made
  this a to-build dependency rather than a `\mathlibok` anchor. Reason: the chapter's
  own premise is that the Čech-to-cohomology comparison for `Scheme.Modules` is absent
  from Mathlib, so I am not confident a faithful Mathlib declaration exists; per the
  anti-hallucination rule a wrong `\mathlibok` is worse than an ∞ hole, so I left it
  unmarked. The block's standalone statement lives in the Stacks **Cohomology** chapter,
  which is NOT in the local `references/` (only its *application* is, L157–173). I
  therefore cited the application verbatim as `% SOURCE QUOTE PROOF:` and stated openly
  in the `% SOURCE:` line that the standalone statement is not yet retrieved. If you want
  a statement-level verbatim quote (or a verified Mathlib pin), dispatch a
  reference-retriever for Stacks `cohomology-lemma-cech-vanish-basis`, or have review
  verify a Mathlib declaration and convert the block to `\mathlibok`.
- The four new `\lean{}` targets (`cechAugmented_exact`, `cechTerm_pushforward_acyclic`,
  `affine_serre_vanishing`, `cech_eq_cohomology_of_basis`) are expected names; a
  lean-scaffolder will need to create the corresponding declarations. `CechAcyclic.affine`
  (existing, protected-adjacent) was untouched.
- Pre-existing `lem:push_pull_comp` shows in `unmatched_lean` (`pushPullMap_comp`); out
  of my scope (push–pull blocks), flagged only for completeness.

## Strategy-modifying findings
None. The directive flagged the A.2 termwise-acyclicity step for strategic validation:
on close reading it **does** reduce cleanly to the affine vanishing already planned, but
the precise grounding is worth recording:
- The relative vanishing each Čech term needs is supplied by **Serre vanishing on
  affines** (`lem:affine_serre_vanishing`), via the source's `lemma-relative-affine-vanishing`
  (`f` affine ⟹ `R^i f_* = 0`, `i>0`), **not** directly by the standard-cover
  Čech-complex vanishing (`lem:cech_acyclic_affine`). This is exactly why the directive's
  split of `lem:cech_acyclic_affine` was needed; A.2 is wired to the Serre half.
- The reduction is clean only after first localising the question to an **affine base**
  `S` (legitimate: `R^k f_*` is local on `S`). Over affine `S` with `f` separated, `X`
  is separated, each `U_s` is affine, the inclusion `j_s : U_s ↪ X` is an affine
  morphism (`R^q(j_s)_* = 0`), and `g_s = f∘j_s` restricts to a morphism of affine
  schemes (hence affine). Two off-the-shelf geometric facts are consumed: (i)
  `R^q(j_s)_* = 0` for the affine open immersion `j_s` (Grothendieck composition
  degeneration), and (ii) relative affine vanishing `lemma-relative-affine-vanishing`.
  Neither is a new strategy ingredient; both are downstream of the affine Serre
  vanishing the plan already targets. No STRATEGY.md change required.
