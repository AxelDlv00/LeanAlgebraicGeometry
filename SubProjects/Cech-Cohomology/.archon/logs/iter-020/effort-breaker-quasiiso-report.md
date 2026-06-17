# Effort Breaker Report

## Slug
quasiiso

## Target
`lem:cech_free_complex_quasi_iso` (`\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}`)
in `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.

## Status
COMPLETE — target re-expressed as a `\uses`-linked chain of 6 sub-lemmas along
**route (a)** (direct sectionwise prepend homotopy at the ModuleCat level). Route (b)
(`ExtraDegeneracy`) is mentioned in one sentence as the documented fallback, not
decomposed.

## Effort before → after
- target `effort_local`: 2266 → 2399 (node-local; rose marginally because
  `dep_count` went 2 → 6 — the heuristic charges for assembling more deps. The
  *proving* difficulty genuinely dropped: the target proof is now a short glue
  argument — reduce-objectwise, identify-sectionwise, case-split — that delegates
  every hard step to a proved sub-lemma.)
- target `effort_total`: 2266 → 7118 (now spans the new cone, as expected).
- sub-lemmas added: 6.

## Chain added (target ← L1…L6)
Inserted, bottom-up, immediately before the target lemma (after
`def:cover_structure_presheaf`):

- `\label{lem:quasiIso_of_evaluation}` `\lean{AlgebraicGeometry.quasiIso_of_evaluation}`
  — **objectwise reduction** (already-built public helper, now given a block): a
  morphism of presheaf-of-module complexes is a quasi-iso if every evaluation
  `(evaluation V).mapHomologicalComplex .map φ` is. `effort_local = 0` (already
  proved). `\uses{def:cech_free_presheaf_complex}`.
- `\label{lem:cech_free_eval_sectionwise}` `\lean{AlgebraicGeometry.cechFreeEval_X}`
  — **sectionwise description**: for fixed `V`, `I₁ = {i : V ≤ U_i}`, the evaluated
  augmented complex is the augmented combinatorial Čech complex of the simplex on
  `I₁` with coefficients `O_X(V)`, augmentation target `O_𝒰(V)` (= `O_X(V)` if
  `I₁≠∅`, else `0`). Entry point named: `cechFreePresheafComplex_X` +
  `PresheafOfModules.evaluation`. `\uses{def:cech_free_presheaf_complex,
  def:cover_structure_presheaf}`. (effort ≈ 1276)
- `\label{lem:cech_free_eval_empty}`
  `\lean{AlgebraicGeometry.cechFreeEval_quasiIso_of_isEmpty}` — **case `I₁=∅`**:
  evaluated complex is `0` on both sides, hence quasi-iso. `\uses{lem:cech_free_eval_sectionwise}`.
  (effort ≈ 661)
- `\label{lem:cech_free_eval_prepend_homotopy}`
  `\lean{AlgebraicGeometry.cechFreeEvalPrependHomotopy}` — **prepend homotopy
  DEFINITION** (finer break, part 1): the degreewise `O_X(V)`-linear maps
  `h_p(s)_{i₀…i_{p+1}} = (i₀=i_fix)·s_{i₁…i_{p+1}}` as `Sigma.desc`; explicit pointer
  to `CombinatorialCech.combHomotopy` (CechAcyclic.lean) as the content to port.
  `\uses{lem:cech_free_eval_sectionwise}`. (effort ≈ 742)
- `\label{lem:cech_free_eval_prepend_homotopy_spec}`
  `\lean{AlgebraicGeometry.cechFreeEvalPrependHomotopy_spec}` — **prepend homotopy
  IDENTITY** (finer break, part 2): `d∘h + h∘d = id` on the augmented evaluated
  complex; explicit pointer to `CombinatorialCech.combHomotopy_spec` (+
  `cons_comp_succAbove_succ`, `combSign_flip`). `\uses{lem:cech_free_eval_prepend_homotopy}`.
  (effort ≈ 1105)
- `\label{lem:cech_free_eval_nonempty}`
  `\lean{AlgebraicGeometry.cechFreeEval_quasiIso_of_nonempty}` — **case `I₁≠∅`**:
  package `h` as `HomologicalComplex.Homotopy` (id ≃ 0) ⇒ `HomotopyEquiv` with
  `O_𝒰(V)[0]` ⇒ `QuasiIso` via `Homotopy.toQuasiIso` / `HomotopyEquiv.toQuasiIso` /
  `QuasiIso.ofHomotopyEquiv`. `\uses{lem:cech_free_eval_sectionwise,
  lem:cech_free_eval_prepend_homotopy, lem:cech_free_eval_prepend_homotopy_spec}`.
  (effort ≈ 935)
- **Target proof rewritten**: by `lem:quasiIso_of_evaluation` reduce to per-`V`
  evaluation; identify it via `lem:cech_free_eval_sectionwise`; case-split on `I₁`
  using `lem:cech_free_eval_empty` / `lem:cech_free_eval_nonempty`. Statement-level
  and proof-level `\uses` updated to
  `{lem:quasiIso_of_evaluation, lem:cech_free_eval_sectionwise,
  lem:cech_free_eval_empty, lem:cech_free_eval_nonempty}`. Statement and `\lean{}`
  of the target unchanged.

## Lean API pathway (must-fix addressed)
Each sub-lemma's informal proof names the relevant Lean tool as a prose pointer (no
tactic blocks): `quasiIso_of_evaluation` (objectwise entry), `cechFreePresheafComplex_X`
(degree-`p` unfolding), `PresheafOfModules.evaluation`, `HomologicalComplex.Homotopy`,
`Homotopy.toQuasiIso` / `HomotopyEquiv.toQuasiIso` / `QuasiIso.ofHomotopyEquiv`, and the
explicit `CombinatorialCech.combHomotopy` / `combHomotopy_spec` pointer in
`CechAcyclic.lean` for the combinatorial content to port.

## Graph verification
- All 6 new nodes resolve (`archon dag-query node`); no broken `\uses`
  (`dag-query gaps` shows no related gaps; ancestors enumerate cleanly).
- LaTeX balanced: 26 `\begin{lemma}`/26 `\end{lemma}`, 24 `\begin{proof}`/24
  `\end{proof}`.

## Still hard (re-break candidates)
- `lem:cech_free_eval_prepend_homotopy_spec` (effort ≈ 1105) — the `dh+hd=id`
  alternating-sum cancellation is the genuine combinatorial core. It is, however,
  a near-verbatim port of the already-proved `CombinatorialCech.combHomotopy_spec`
  (constant-coefficient case, coefficients `O_X(V)`), so it is a *transcription*
  task, not new mathematics. If the prover stalls, re-dispatch the breaker at
  sentence granularity on the three index-bookkeeping moves
  (`cons_comp_succAbove_succ`, sign flip, telescoping cancellation).
- `lem:cech_free_eval_sectionwise` (effort ≈ 1276) — the bulk here is the
  `evaluation`-commutes-with-`Sigma`-coproduct + per-summand collapse
  (`free(y W)(V) = O_X(V)` iff `V ≤ W`). Mechanical but multi-step; a finer break
  could separate the per-summand collapse lemma from the differential-identification
  lemma if needed.

## Could not decompose (strategy items)
- None. Every gap the original monolithic proof crossed is covered by a sub-lemma.

## References consulted
- `references/stacks-cohomology.tex` L1198–1285 (`lemma-homology-complex`) — verbatim
  `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` fragments attached per sub-lemma
  (sectionwise reduction L1220–1226; `I=I₁⨿I₂` description L1227–1252; empty case
  L1228–1230; homotopy `h` L1253–1271; `dh+hd=id` computation L1272–1285; homotopy-
  to-zero claim L1224–1245). No new citations invented; reused the chapter's existing
  source quotes.

## Notes for dispatcher
- `\lean{}` names assigned by convention (need Lean scaffolding by the prover/planner):
  `AlgebraicGeometry.cechFreeEval_X`,
  `AlgebraicGeometry.cechFreeEval_quasiIso_of_isEmpty`,
  `AlgebraicGeometry.cechFreeEvalPrependHomotopy`,
  `AlgebraicGeometry.cechFreeEvalPrependHomotopy_spec`,
  `AlgebraicGeometry.cechFreeEval_quasiIso_of_nonempty`. The sixth,
  `AlgebraicGeometry.quasiIso_of_evaluation`, **already exists** (public, proved) in
  `FreePresheafComplex.lean` — its block is the previously-unmatched helper now given
  a home; `sync_leanok` should mark it `\leanok` on the next pass.
- No `\mathlibok` added: `Homotopy.toQuasiIso` etc. are named only as prose pointers
  (kept inline rather than as separate anchor blocks), per the directive's "MAY".
- No macros needed; all notation (`\bigoplus`, `\operatorname`, `\mathrm{Fin}`) is
  already in use in the chapter.
- Protected signature `cech_computes_higherDirectImage` untouched; no other block's
  `\lean{}` list touched.
