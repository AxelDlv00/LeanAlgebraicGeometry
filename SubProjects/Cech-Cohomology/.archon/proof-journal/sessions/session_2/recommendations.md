# Recommendations for iter-003 (from session_2 review)

## Headline
First real proof progress of the project landed: **`pushPullMap_comp` (P1) + `CechNerve` (P2)
both closed, axiom-clean.** Sorry 3 → 2. P2 (the whole push–pull functor + nerve construction)
is effectively done. The critical path now opens P3/P4/P5.

## MAJOR — act this iter

1. **Rewrite the `lem:push_pull_comp` proof sketch (blueprint-writer).**
   `Cohomology_CechHigherDirectImage.tex` / `lem:push_pull_comp`: the `\begin{proof}` describes a
   `conjugateEquiv_comp` + injectivity route that was found **infeasible** (kernel `whnf` blow-up)
   and was NOT used. I left a `% NOTE:` on the block. Replace the sketch with the route that
   actually landed: reduce `pushPullMap → rawPushPullMap` via the `rfl`-lemma `pushPullMap_eq_raw`,
   then `rawPushPullMap_comp` (which `subst`s the two over-triangle equalities to trivialise the
   `eqToHom` transports) using `pushPull_unit_comp` + `pushPull_pentagon` (wrapping
   `pseudofunctor_associativity`). Source: `task_results/lean-vs-blueprint-checker-cechhdi.md`.

2. **Stale comment cleanup in `CechHigherDirectImage.lean` (next prover / refactor — needs `.lean`
   edits, which review cannot do).** 5 clusters now describe a FALSE proof state — a next prover
   reading them will think `pushPullMap_comp`/`CechNerve` are still open and may waste effort or
   skip dependent work:
   - L84–88: "push-pull functor is the remaining gap" / "`CechNerve` … the single genuine hole" — both false now. (Also: dangling ref to `Picard/TensorObjSubstrate.lean`, not in this project.)
   - L161–183: `pushPullMap_comp` annotated `-- remaining`; proven at L627.
   - L245–293 and L410–449: TWO overlapping "not yet closed" / dead-end-inventory blocks for `pushPullMap_comp`; both stale.
   - L739–745: `CechComplex` body comment "The only remaining hole is `CechNerve` itself" — false.
   - L35: module header says "six main declarations", lists four (post-iter additions missing).
   Source: `task_results/lean-auditor-iter002.md`.

## 1-to-1 coverage debt (planner: author blueprint blocks — review does not write prose)

`archon dag-query unmatched` = **12 `lean_aux` nodes** with no blueprint entry (all in
`CechHigherDirectImage.lean`, all proved/axiom-clean). Most substantive first:
- `pushPullFunctor` (L640) — the assembled `(Over X)ᵒᵖ ⥤ X.Modules` functor `G`. Uses:
  `pushPullObj` (`def:push_pull_obj`), `pushPullMap` (`def:push_pull_map`), `pushPullMap_id`
  (`lem:push_pull_id`), `pushPullMap_comp` (`lem:push_pull_comp`). **Most worth a block.**
- `pushPull_pentagon` (L491) — the pullback pseudofunctor pentagon; key sub-lemma (wraps
  `pseudofunctor_associativity`). Worth an explicit `lem` block.
- `coverCechNerveOver` (L651) — backbone → `SimplicialObject (Over X)` via `Over.lift`.
- `coverCechNerveOverAug` (L660) — augmented form, point = terminal `Over.mk (𝟙 X)`.
- `cechNerveCosimplicial` (L670) — underlying cosimplicial object before augmentation.
- `rawPushPullMap` (L389), `rawPushPullMap_comp` (L536, holds the actual proof content),
  `rawPushPullMap_self` (L455), `rawPushPullMap_self_gen` (L472), `pushPullMap_eq_raw` (L406,
  `rfl`), `pushPull_unit_comp` (L358), `pushforwardComp_hom_app_id` (L377, `rfl`).
  (`def:cech_nerve`'s `\uses` could be refined to route through `coverCechNerveOverAug` +
  `pushPullFunctor` once these are blueprinted.)

## `\leanok` sync anomaly (planner: confirm next sync clears it)

`lem:push_pull_id`, `lem:push_pull_comp`, `lem:push_pull_unit_mate`, `lem:push_pull_transport_cancel`
have verified-complete axiom-clean proofs but no `\leanok`. `sync_leanok-state.json` is
`iter: 2, added: 0, removed: 0, chapters_touched: []` with `sha: c42d466 ≠ HEAD 62a7d82` (prover
edits uncommitted). Almost certainly a sync-vs-commit timing mismatch — NOT a proof gap (proofs
compile) and NOT laundering. Expect next `sync_leanok` to add the four; if it doesn't, inspect the
loop's sync ordering relative to the prover-commit point. Review did not touch `\leanok`.

## Blueprint doctor (carry-forward)
- `Cohomology_AcyclicResolution.tex` covers `AcyclicResolution.lean`, which does not exist.
  Expected forward reference — resolve by scaffolding the file in iter-003 (per below). No orphan
  chapters / broken refs otherwise.

## Critical path now open — parallelisable next

P2 done ⇒ the `pushPullMap_comp`/push–pull stack and `CechNerve` are no longer the pole. Suggested
iter-003 shape (matches the planner's own carry-forward in `iter/iter-002/plan.md`):
1. **Fix the P4 anchor must-fix** (`Cohomology_AcyclicResolution.tex` /
   `lem:homology_long_exact_sequence` names only `homology_exact₃`; expand to all three
   `homology_exact₁/₂/₃` + `.δ`) → scoped re-review → **scaffold `AcyclicResolution.lean`** →
   `[prover-mode: mathlib-build]` on the horseshoe (`lem:injective_resolution_of_ses`) + the LES
   kernel. This also clears the doctor finding above.
2. **File-split refactor**: now that the push–pull stack + `CechNerve` are proved, split them (and
   P3 `CechAcyclic.affine`) out of `CechHigherDirectImage.lean` into own files (refactor subagent;
   keep protected `cech_computes_higherDirectImage` signature + path frozen) so P3/P4 run as
   parallel prover lanes. Fold the stale-comment cleanup (MAJOR #2) into this refactor.
3. **`lem:cech_to_cohomology_on_basis`** (`cech_eq_cohomology_of_basis`) and
   **`lem:higher_direct_image_presheaf`** are now on the frontier — candidate prover lanes once
   their chapters pass the HARD GATE.

## Do NOT re-assign without a structural change
- `CechAcyclic.affine` (P3, L774): blocked on from-scratch module-level localisation +
  contracting-homotopy infra (absent from Mathlib for `Scheme.Modules`). **Decompose with
  effort-breaker first** (planner already flagged this); do not send a blind "prove" dispatch.
- `cech_computes_higherDirectImage` (P5, L811, protected): blocked behind P3/P4. Unblocks only
  after the acyclic-resolution kernel + Čech-acyclicity land.

## Reusable proof patterns discovered this iter (added to Knowledge Base)
- **Syntactic object-form alignment for iso cancellation**: inside a long `SheafOfModules`
  composite, `reassoc_of%` / `rw` fail when hypotheses carry `(F ⋙ G).obj` but the goal carries
  `G.obj (F.obj _)` (defeq, not syntactic). Lever: `simp only [Functor.comp_obj] at h1 h2 ⊢`
  FIRST, then `reassoc_of%`. Not stronger rewrite tactics.
- **`subst` over-triangle equalities to kill `eqToHom` transports**: stating a coherence lemma
  (`rawPushPullMap_comp`) with the over-triangle equalities as *free hypotheses* lets `subst` make
  every `eqToHom` an identity (kernel-cheap), bypassing the `conjugateEquiv` whnf blow-up entirely.
- **Functoriality via off-the-shelf transport**: build a functor (`pushPullFunctor`) and let
  `.rightOp` + `CosimplicialObject.Augmented.whiskeringObj` carry both the (co)simplicial structure
  AND its augmentation — augmentation coherence becomes automatic via the terminal object
  (`Over.mkIdTerminal.hom_ext`), no manual diagram chase.
