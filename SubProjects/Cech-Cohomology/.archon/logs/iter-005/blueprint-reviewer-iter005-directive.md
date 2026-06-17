# Blueprint Reviewer Directive

## Slug
iter005

## Strategy snapshot (concise)
Goal: prove `AlgebraicGeometry.cech_computes_higherDirectImage` (the protected target) — the
Čech computation of higher direct images — via Route A (acyclic-resolution comparison, Stacks
Tag 015E): build the relative Čech complex as an `f_*`-acyclic resolution and invoke one
abstract homological lemma "a `G`-acyclic resolution computes `G.rightDerived`".

Remaining phases:
- **P4 (ACTIVE)** — the abstract acyclic-resolution lemma, in
  `AlgebraicJacobian/Cohomology/AcyclicResolution.lean` ↔ chapter
  `Cohomology_AcyclicResolution.tex`. This is the chapter under active prover work THIS iter.
- **P3 (NEXT, blocked)** — affine Čech acyclicity (`CechAcyclic.affine`, in
  `CechHigherDirectImage.lean`); blocked by a standard-cover-vs-general-cover statement gap.
- **P5 (LAST, blocked)** — comparison assembly (the protected target); needs P3+P4.

## Focus this iter (the chapter feeding a live prover lane)
`blueprint/src/chapters/Cohomology_AcyclicResolution.tex`. This iteration an `effort-breaker`
decomposed the monolithic dual-Horseshoe lemma (`lem:injective_resolution_of_ses`,
`\lean{CategoryTheory.InjectiveResolution.ofShortExact}`) into a new subsection "The horseshoe
construction, step by step" with seven `\uses`-linked sub-lemmas:
`lem:horseshoe_biprod_injective` (\mathlibok `Injective.instBiprod`),
`lem:horseshoe_degree_split` (\mathlibok `ShortComplex.Splitting.ofHasBinaryBiproduct`),
`lem:horseshoe_stage_mono` (project decl `mono_biprod_lift_factorThru_of_exact`, already proven),
`lem:horseshoe_twist` (`…ofShortExact_twist`), `lem:horseshoe_dComp` (`…ofShortExact_dComp`),
`lem:horseshoe_chainMap` (`…ofShortExact_chainMap`), `lem:horseshoe_resolvesMiddle`
(`…ofShortExact_resolvesMiddle`). The four `…ofShortExact_*` are NEW provable obligations the
prover will build this iter (no Lean decl exists yet — they are build/scaffold targets, NOT
fill-the-sorry targets). Assess whether these seven sub-lemmas are mathematically complete and
correct, whether each proof sketch is detailed enough to formalize without guessing, and
whether the two `\mathlibok` anchors are faithful (verify the named Mathlib decls exist in the
stated form). Give an explicit per-chapter `complete:`/`correct:` verdict for this chapter — it
gates the prover dispatch.

## KNOWN ARTIFACT — do NOT treat as a content must-fix
`lem:injective_resolution_of_ses` currently carries `\leanok` on its statement and proof
blocks, even though `CategoryTheory.InjectiveResolution.ofShortExact` does not yet exist. This
is a KNOWN `sync_leanok` false-positive caused by a backtick code-fence in the `.lean` strategy
comment (the LSP read it as a real declaration). **It has been fixed at the root THIS iteration**
(a `refactor` reformatted the fence; the file compiles), and the next `sync_leanok` run — which
executes after this plan phase — will strip both false markers automatically. There is a
`% NOTE (iter-004 review)` comment on the block documenting this. So: note the false marker as a
will-auto-resolve artifact in your report, but do NOT count it as a live blueprint-content
must-fix that should defer the prover. The horseshoe is correctly UNFORMALIZED and is exactly
what the prover will build from the new sub-lemma chain.

## References (authoritative for this chapter)
`references/homological-acyclic-derived.tex` — Stacks Project Derived Categories, Tags 0157 /
015C / 015D / 015E (F-acyclic objects, Leray acyclicity). The horseshoe itself is the dual of
the projective Horseshoe Lemma (Weibel, *An Introduction to Homological Algebra*, Lemma 2.2.8);
it is the one genuinely-new structural construction and carries an inline citation rather than a
verbatim source quote (correct — do not flag the sub-lemmas for a missing `% SOURCE QUOTE`).
Full reference index: `references/summary.md`.

## Specific concerns to check
1. Is the `lem:horseshoe_twist` proof (the cocycle-identity induction — the construction's
   irreducible kernel) detailed enough to formalize, or does it need finer decomposition?
   (The effort-breaker noted a 3-way re-break (augmentation / inductive lift / cocycle) is
   available if needed — advise whether that is required now.)
2. Are the two `\mathlibok` anchors faithful (`Injective.instBiprod`,
   `ShortComplex.Splitting.ofHasBinaryBiproduct`)?
3. Carry-forward coverage debt (informational, non-gating): four iter-004 decls in
   `AcyclicResolution.lean` still lack `\lean{}` blueprint entries
   (`isZero_homology_mapHomologicalComplex_of_isRightAcyclic`,
   `shortExact_of_degreewise_splitting`,
   `shortExact_map_mapHomologicalComplex_of_degreewise_splitting`, and the substantive
   `rightDerivedShiftIsoOfSplitResolutionSES`). Note these but they do not gate the horseshoe
   prover (they are already-proven helpers; planner is deferring their coverage to next iter).
