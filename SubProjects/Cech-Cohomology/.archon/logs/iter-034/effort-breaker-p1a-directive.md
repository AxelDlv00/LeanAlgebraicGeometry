# Effort-breaker directive — decompose P1a (`lem:isQuasicoherent_restrict_basicOpen`)

## Target
`lem:isQuasicoherent_restrict_basicOpen` in
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated
Čech-higher-direct-image chapter, lemma block at ~L3993).

Lean pin: `AlgebraicGeometry.isQuasicoherent_restrict_basicOpen` (NOT yet built — this is a
project-to-build geometry lemma, the harder "P1a" half of the P1 decomposition feeding the
01I8 unconditional `qcoh_iso_tilde_sections`).

## Why break it
The single block bundles several distinct, individually-substantial pieces of
`SheafOfModules`/`(Spec R).Modules` infrastructure that are ABSENT from Mathlib (documented in
the block's own `% NOTE:`). A prover handed the whole lemma at once cannot make incremental
axiom-clean progress. Decomposing it into a `\uses`-linked chain of smaller infra sub-lemmas —
each with its own statement, informal proof, and `\uses` — exposes small ready pieces that a
mathlib-build prover lane can attack one at a time next iter.

## Granularity
**One level** — split along the proof's main mathematical steps (the seams listed below), each
becoming its own `\begin{lemma}` block with `\label`, a `\lean{AlgebraicGeometry.<name>}` pin
naming the to-be-built declaration, an accurate `\uses{}`, and a textbook-level informal proof.
Do NOT go sentence-by-sentence yet; we want ~3–5 substantial sub-lemmas, not a swarm of trivia.

## Proof structure (cut along these seams)
The existing informal proof (block proof at ~L4030–4051) and the SOURCE (Stacks Schemes,
`lemma-widetilde-pullback` / `lemma-quasi-coherent-affine`, Tag 01I8, in
`references/stacks-schemes.tex`) decompose naturally into:

1. **Restriction of an `(Spec R).Modules` object to a basic open `D(f)` as an
   `(Spec R_f).Modules` object.** The geometry primitive: `F|_{D(f)}` transported across the
   canonical open-immersion isomorphism of affine schemes `D(f) ≅ Spec R_f`. This is the
   load-bearing absent-from-Mathlib functor; name precisely what must be built (the restricted
   sheaf-of-modules and the transport iso).

2. **Transport of a `Presentation` (and of `IsQuasicoherent`) along that restriction.**
   Functoriality of presentations under open-immersion restriction: a presentation
   `O^{(J)} → O^{(I)} → F|_U → 0` over `U` restricts to a presentation of `F|_{D(g)}` over
   `D(g) ⊆ U`. State the presentation-restriction sub-lemma.

3. **Local `~`-identification over the basic-open cover.** On each `D(g_j f) = D(g_j) ∩ D(f)`,
   `F` is the associated sheaf of an away-localised module `(M_j)_f`
   (`lemma-widetilde-pullback`: restricting `~M` to a standard open gives `~(M_away)`); assemble
   the finitely many local presentations (over the finite affine cover of `Spec R_f` supplied by
   `lem:exists_finite_basicOpen_subcover`, DONE) into a presentation of `F|_{D(f)}`, then conclude
   `F|_{D(f)} ≅ ~(Γ(D(f),F))` over `R_f` via `lem:qcoh_iso_tilde_sections_of_presentation` (DONE).

Keep the final assembled statement `lem:isQuasicoherent_restrict_basicOpen` as the top block, now
with a short proof that just composes the new sub-lemmas via `\uses{}`. Preserve the existing
`% SOURCE:` / `% SOURCE QUOTE:` citations; copy the relevant fragment onto each sub-lemma that
uses it (re-read `references/stacks-schemes.tex` around L1271–1303 to quote verbatim — do not
fabricate). Do NOT add `\leanok`. You MAY add `\mathlibok` ONLY on a genuine Mathlib dependency
anchor (e.g. the open-immersion iso `D(f) ≅ Spec R_f` if it is a bare Mathlib re-export —
`AlgebraicGeometry.Scheme … basicOpen … Spec`); if unsure whether a piece is in Mathlib, leave it
unmarked with a `% NOTE:` rather than guessing.

## Out of scope
Do NOT touch the toSheaf blocks (`lem:toSheaf_preservesFiniteColimits`,
`lem:to_sheaf_preserves_epi`, `lem:affine_surj_of_vanishing`, `def:affine_cover_system`) or the
tilde block (`lem:tilde_preserves_kernels`) — those feed live prover lanes this iter and must stay
byte-stable. Only restructure the P1a block and insert new sub-lemma blocks immediately around it.
Report which child declarations you created (names + labels) so the planner can wire PROGRESS and
the next prover lane.
