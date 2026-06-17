# iter-020 review

## Overall progress this iter
- **Total sorry: 2 → 2** (no regression). Both intentional: superseded relative-form
  `CechAcyclic.affine` (`CechAcyclic.lean:109`) + frozen P5b (`CechHigherDirectImage.lean:679`,
  shifted from 715 by the planner's stale-comment refactor).
- **Build GREEN** (3 touched files diagnostic-clean; `lake build` 8319 jobs).
- **+18 axiom-clean declarations** across 3 parallel lanes; **0 new sorries**;
  **5 named/sub-targets landed**:
  - `cechFreeEval_quasiIso_of_isEmpty` (`lem:cech_free_eval_empty`) — empty case of the per-`V`
    quasi-iso.
  - `cechFreeEval_X` (`lem:cech_free_eval_sectionwise`, entry point).
  - `qcohSectionsAwayLocalized` (P3 section-form step (b), tilde case).
  - `homCechComplexMapOpIso` + `sectionCechComplexMapOpIso` (P3b bridge transport) — these also
    resolved the iter-019 Probe `sorry` in CechBridge (file now 0 sorries).

## Branches advanced
- **P3b free (`FreePresheafComplex.lean`, +10)**: the **combinatorial homotopy engine
  `FreeCechEngine.*`** (the genuine per-`V` `dh+hd=id` content, a free-side port of the private
  `CombinatorialCech.*`), the empty-case quasi-iso, and all per-summand evaluation inputs
  (`freeYonedaEval_iso_of_le`/`_isZero_of_not_le`, `cechFreeEval_X`). The named target
  `cechFreeComplex_quasiIso` is **blocked on the nonempty case** — specifically the
  evaluated-differential ↔ `combDifferential` match on coproduct injections (step 1 of 5; the rest
  are mechanical given the engine). Not pinned as a sorry (all-or-nothing `def`).
- **P3 L1 (`CechAcyclic.lean`, +4)**: step (b) `qcohSectionsAwayLocalized` (tilde case) + the two
  step-(c) bricks `basicOpen_sprod`, `qcohRestriction_eq_comparison`. Step (c)
  `sectionCech_homology_exact` is **blocked** — `sectionCechComplex` is `Ab`-valued with `∏ᶜ`
  objects, so `moduleCat_exact_iff` is inapplicable; needs a 3-sub-lemma effort-break
  (`ab_exact_iff` + `Concrete.productEquiv`). Not new mathematics.
- **P3b bridge (`CechBridge.lean`, +4)**: the contravariant-transport bridge
  (`homCechComplexMapOpIso`, `sectionCechComplexMapOpIso`) + the resolved degreewise differential
  identity `homCechComplex_d_eq`. `injective_cech_acyclic` correctly **not built** (gated on
  Lane-1's quasi-iso); it is now a one-step assembly the moment that lands.

## This iter's analysis
- **The progress-critic's hard clock on Lane 1 was met in spirit but not in target.** The lane
  was required to ATTEMPT the per-`V` contracting homotopy this iter (not another infra round).
  It built the *entire* combinatorial engine + the empty case + the per-summand bridges — that IS
  the homotopy attempt, and it converted the named target into one well-scoped sub-step (the
  differential match). This is convergence, not churn: the residual genuinely shrank and the
  bottleneck is now a single identified lemma.
- **The dominant new blocker is blueprint-side and structural, not Lean-side.** lvb
  `freepresheafcomplex` returned 2 must-fix: the `FreeCechEngine` namespace is unblueprinted AND
  the blueprint sketches still reference the **private** `CombinatorialCech.*`. lean-auditor
  independently flagged that `FreeCechEngine` is a verbatim duplicate of those private lemmas. So
  the next iter's FreePresheafComplex work is gated on (a) a blueprint-writer pass against
  `FreeCechEngine`, and (b) a structural decision: de-privatize/share `CombinatorialCech` vs keep
  the duplicate. This is exactly the "expand/repair the blueprint before the prover" gate — caught
  before a wasted prover round.
- **No code-quality regressions.** lean-auditor: 0 must-fix, 0 excuse-comments, no new axioms; all
  18 decls `#print axioms`-clean. lvb ×3: Lean faithful to the `\lean{}`-named blocks; the one
  intent-gap (`cechFreeEval_X` realizes only the coproduct-iso, not the full `⊕O_X(V)` prose of
  `lem:cech_free_eval_sectionwise`) is a blueprint-annotation item, not a fake statement.
- **Two recipe-ready one-step assemblies are now queued:** `injective_cech_acyclic` (gated on
  Lane-1 quasi-iso) and `sectionCech_affine_vanishing` (gated on step (c)). Both have complete
  recipes in the task_results — the project's frontier is converging on a small set of named
  closures, not sprawling.

## Subagent skips
- _(none — all HIGHLY RECOMMENDED review subagents dispatched: lean-auditor `iter020`, and
  lean-vs-blueprint-checker on all 3 prover-touched files: cechacyclic, cechbridge,
  freepresheafcomplex.)_

## Markers
- No manual marker changes this iter (no new Mathlib re-export named in a block → no `\mathlibok`;
  no `\lean{}` rename flagged; no `\notready` to strip). `sync_leanok` added 7 deterministically.

## Blueprint doctor
- Clean (no orphan chapters, no broken `\ref`/`\uses`, no stray `axiom`).
