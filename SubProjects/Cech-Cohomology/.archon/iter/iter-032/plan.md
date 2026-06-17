# Iter-032 plan — Lane A (CechBridge family) COMPLETE ⟹ AffineSerreVanishing UNBLOCKED; Route B CHURNING → P1 split; 01I8 promoted to own phase

## Entering state (verified)
iter-031's two mathlib-build lanes processed:
- **Lane A `CechBridge.lean` COMPLETE (+10 `…Fam` decls).** Family-parameterized Čech bridge over a raw
  finite family `{ι}[Finite ι](U : ι → Opens X)`, NO covering hypothesis; both NAMED targets
  `sectionCechComplexMapOpIsoFam` + `injective_cech_acyclicFam` axiom-clean (mechanical mirror of the iter-025
  X.OpenCover chain). **`injective_cech_acyclicFam` discharges `BasisCovSystem.injective_acyclic` over covers
  of ANY open D(f) directly** — the 02KG ⊤-vs-D(f) design fork is fully dissolved on both free + bridge sides.
- **Lane B `QcohTildeSections.lean` PARTIAL (+1).** P0 `exists_finite_basicOpen_subcover` (pure topology).
  P1 `qcoh_localized_sections` NOT added (no sorry); prover located the genuine blocker as two missing
  pieces and recommended P1 = P1a (affine-restriction infra) + P1b (pure-algebra patching) + sheaf condition.
- Project sorry = 2 (both frozen/superseded). Build green. lean-auditor iter031: 0 must-fix.

## What I did this iter (plan phase)
1. Processed both lanes (task_done += 11 decls; task_pending header refreshed; PROGRESS rewritten).
2. **STRATEGY.md** — acted on the strategy-critic CHALLENGE (see Decision D2): split the 02KG row, **promoted
   01I8 globalisation to its own honest phase row** (~5–8 iters / ~500–900 LOC, Hartshorne-II.5-scale), and
   stripped per-iter tags from `## Open strategic questions`. Recorded the P1→P1a/P1b decomposition.
3. **progress-critic `iter032`:** Route A **CONVERGING** (dispatch AffineSerreVanishing = correct next step);
   Route B **CHURNING** (PARTIAL×3) — must-fix corrective = structural P1→P1a/P1b split + dispatch ONLY the
   independent P1b, with the blueprint decomposition done BEFORE the prover. Dispatch sanity OK (2 files).
4. **strategy-critic `iter032` CHALLENGE** (1) — effort under-count: the 02KG row silently absorbed the whole
   01I8 globalisation. Addressed in STRATEGY.md (D2). Four directive questions all resolved in strategy's
   favour (P1a/P1b sound + non-circular; Stacks fidelity OK; gating correct; EnoughInjectives acceptable).
5. **blueprint-writer `iter032`:** JOB1 decomposed `lem:qcoh_localized_sections` → P1a
   `lem:isQuasicoherent_restrict_basicOpen` (blueprint-only/project-to-build) + P1b
   `lem:isLocalizedModule_of_span_cover` (pure algebra, dispatch-ready); JOB2 wrote the stalkwise-flatness
   informal proof for `lem:tilde_preserves_kernels` (off the ∞-source list); JOB3 bundled the 9 CechBridge
   `…Fam` helpers into existing `\lean{}` lists (coverage debt cleared, leandag `unknown_uses: []`).
6. **blueprint-clean `iter032`** (P1b Lean field-labels stripped; all iter-032 source quotes verbatim against
   `references/stacks-schemes.tex`).
7. **blueprint-reviewer `iter032` HARD GATE CLEARS** for both this-iter targets (AffineSerreVanishing 7 blocks
   formalize-ready + acyclic `\uses`; P1b statement correct + self-contained). One minor "soon" finding:
   spurious `\uses{def:basis_cov_system}` on `lem:to_sheaf_preserves_epi` — **fixed by me** (removed from both
   the statement and proof blocks; it is a pure category-theory gap-fill independent of the cover system).
8. Wrote PROGRESS.md (two parallel mathlib-build lanes, scaffold keywords on both path lines), task ledgers,
   this sidecar, objectives.md, TO_USER.md.

## Decisions made

### D1 — This iter's two lanes: AffineSerreVanishing cover-system (convergence) + QcohTilde P1b (independent).
**Chosen.** Lane A's completion unblocks the AffineSerreVanishing cover-system chain
(`toSheaf_preservesEpimorphisms`, `standard_cover_cofinal`, `affine_surj_of_vanishing`, `affineCoverSystem`
with `injective_acyclic` discharged via the family form). This is the high-value convergence lane. In
parallel, the CHURNING-corrective for Route B is the structural split: dispatch ONLY the algebraically
independent, dispatch-ready P1b, not P1 whole and not the harder geometry P1a. Both files 0-sorry → scaffold
keywords on path lines. **Why not also P1a this iter:** P1a needs SheafOfModules-restriction-to-`D(f)`
machinery absent from Mathlib; it is blueprint-only and likely needs its own effort-breaker sub-decomposition
next iter. Sending a prover at it blind would reproduce the churn.

### D2 — Promote 01I8 globalisation to its own STRATEGY phase row (strategy-critic CHALLENGE).
**Chosen** over rebutting. The strategy-critic correctly observed that the 02KG row's ~4–5 iter / ~350–600 LOC
estimate silently folded in the entire Hartshorne-II.5-scale 01I8 Route-P chain (P1a + P1b + P2 + P3 +
`tilde_preserves_kernels` left-exactness + P4), comparable to completed phases P3 (~1200 LOC/~14 iters) and
P3b (~1500 LOC/~9 iters). Hiding that is dishonest effort accounting. New split: 02KG cover-system + affine
instantiation = ACTIVE ~2–3 iters / ~200–350 LOC; 01I8 `F≅~(ΓF)` global generation = ACTIVE ~5–8 iters /
~500–900 LOC, with `tilde_preserves_kernels` (absent from Mathlib) called out as a from-scratch build. The
top `affine_serre_vanishing` is honestly gated on BOTH rows.

### D3 — P1b pinned in the over-`R` form (writer flag #1).
**Chosen.** The blueprint-writer flagged whether P1b's per-`j` hypothesis should be stated over `R` (powers
`s_j` localisation as an `R`-module map, `powers f ⊆ R`) or over `R_{s_j}`. Over-`R` avoids threading
`R_{s_j}`-algebra instances and matches how P1's per-`s_j` data is produced; strategy-critic confirmed it is
self-contained pure algebra provable from `IsLocalizedModule.mk`. Confirmed the over-`R` form for the prover.

## Disproof / soundness checks
- P1b sanity model: `M=R, N=R_f, g=` localisation map, `s` spanning. Each `g_{s_j}: R_{s_j} → R_{f s_j}` is
  localisation at `f` (since `R_{f s_j} = (R_{s_j})_f`) ⟹ `IsLocalizedModule (powers f)`; conclusion
  `R → R_f` is `IsLocalizedModule (powers f)` — TRUE. The three `.mk` fields are each local on a spanning
  cover (map_units = locality of iso; surj'/exists_of_eq = partition of unity). Statement holds, non-circular.
- Confirmed `affine_serre_vanishing`/`affine_cech_vanishing_qcoh` are GENUINELY blocked this iter (they
  `\uses` the unconditional `qcoh_iso_tilde_sections` which needs the full 01I8 chain) — so the
  AffineSerreVanishing lane correctly stops at `affineCoverSystem`. Not a tactic gap; a real dependency.

## Prior critique status
- strategy-critic `iter031` SOUND (no live challenge). strategy-critic `iter032` CHALLENGE → addressed (D2).
- progress-critic `iter032` CHURNING (Route B) → corrective executed (P1a/P1b split + dispatch only P1b).

## Subagent skips
- mathlib-analogist: not re-dispatched — the o1i8 route consult (`o1i8route`, iter-031) is still current and
  the P1b/P1a split is a decomposition of that already-chosen Route P, not a new design question. The
  progress-critic named the corrective as blueprint expansion (done), not an idiom consult.
- effort-breaker: not needed this iter — the blueprint-writer's P1a/P1b split IS the decomposition; P1b is a
  single atomic algebra lemma (no further breaking needed) and P1a is deferred (blueprint-only) to next iter
  where an effort-breaker on `lem:isQuasicoherent_restrict_basicOpen` is the planned move.
- lean-auditor / lean-vs-blueprint-checker: review-phase subagents (run in the review phase, not plan).
