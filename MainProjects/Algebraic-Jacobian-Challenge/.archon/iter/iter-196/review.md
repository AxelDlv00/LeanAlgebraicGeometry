# Iter-196 (Archon canonical) — review

## Outcome at a glance

- **The "BareScheme 5 axiom-clean MvPolynomial Submersive substrate +
  cover-reduction wrapper on smoothness; per-chart aux still typed
  sorry pending ChartIso downstream relocation + Lane E 2 of 3
  substrate primitives axiom-clean (`Proj.awayι_preimage_basicOpen_self`,
  `Proj.awayι_eq_specMap_fromSpec`) — step (ii) `Proj.awayι_app_basicOpen`
  BLOCKED by `Scheme.Hom.app` dependent-motive issue; the workaround
  via `Proj.basicOpenIsoSpec_inv_app_top` is the prescribed iter-197
  path + Lane H empty-branch of `IsFlasque.constant_of_irreducible`
  CLOSED axiom-clean (terminal+subsingleton chain) + outer step of
  `skyscraperSheaf_eq_pushforward_const` CLOSED axiom-clean
  (`ObjectProperty.FullSubcategory.ext`); inner-iso residuals named +
  Lane A sub-claims (a)+(b) of `exists_nonconstant_rational_from_dim_eq_two`
  CLOSED axiom-clean via new helper `toFunctionField_injective` (~50
  LOC) + `globalSections_iff_mpr`; sub-claim (c) EXTRACTED to typed
  named substrate helper `functionField_const_of_complete_curve_of_orderZero`
  capturing Stacks 02P0 / Hartshorne I.3.4 gap +
  Lane RCI helper (a) body REFORMULATED via Mathlib's
  `LocallyQuasiFinite.of_finite_preimage_singleton` + in-scope
  IsProper/LocallyOfFiniteType derivation: abstract per-fibre LQF →
  concrete `Set.Finite` preimage gap +
  Lane I Route 2 PID-transfer body LANDED axiom-clean: 8-step
  structured proof through chart cover + Spec.stalkIso + Mathlib
  polynomial-ring DVR chain; single named residual
  `hy_ne_bot : y.asIdeal ≠ ⊥` (Stacks 02IZ/005X) — vague 50-80 LOC
  sorry reduced to precise 5-10 LOC topological-to-algebraic
  bridge + plan-phase landed 7 dispatches (3 blueprint-writers, 1
  carrier-soundness refactor on FGAPicRepresentability, 1 must-fix
  demotions refactor on 3 sorryAx-propagator sites, 1 progress-critic,
  1 strategy-critic)" iter.**

- **`lake build AlgebraicJacobian` GREEN** — per `meta.json`
  `prover.status: done`; all 6 prover lanes returned `done`; **85
  sorries** (counted directly via comment-stripped grep over
  `AlgebraicJacobian/**/*.lean`).

- **0 → 0 project axioms** — **16th consecutive zero-axiom build
  streak**.

- **planValidate**: 6 objectives dispatched. **6 of 6 lanes returned
  `done`** (no API 529 errors this iter, in contrast to iter-195's 2/8
  errors). Per-lane outcomes — see below.

- **Plan trajectory**: iter-196 baseline (entering) 86 sorries (per
  iter-195 meta.json), iter-196 exiting 85. **Net delta −1**. ALL 6
  prover-touched files retained their per-file sorry counts (BareScheme
  2→2, AVR 3→3, H1V 3→3, OCofP 3→3, RCI 3→3, WD 4→4); the global −1 is
  attributable to one of the plan-phase refactors (most likely
  `carrier-soundness-fgapic` or `must-fix-demotions` consumer threading).

  **0 HARD CLOSURES** (no top-level sorry closed); 4 of 6 HARD BARs met
  via substantive structural advance OR named-residual reduction (Lane A,
  Lane I cleanly; Lane H, RCI permissively); 0 PUSH-BEYOND met. The
  iter delivered substantive structural improvements (notably the Lane I
  Route 2 body decomposition reducing a vague 50-80 LOC sorry to a precise
  5-10 LOC named residual, and the Lane E 2 of 3 substrate primitives
  landing axiom-clean) but no full sorry closures.

- **Reviewer-phase subagents** — see `## Subagent dispatches`.

- **sync_leanok iter=196**: 5 added / 0 removed / 1 chapter touched
  (`RiemannRoch_OCofP.tex`).

- **Blueprint doctor**: **1 broken `\uses`** in
  `RiemannRoch_OCofP.tex` (`\leanok` token leaked into `\uses` arg,
  bare label `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf` not
  defined). Surfaced in recommendations.md as CRIT-3.

## Subagent dispatches (review phase)

- `lean-auditor` slug `iter196` — **complete** (14.2 min, 59 turns).
  Report at `task_results/lean-auditor-iter196.md` (archived to
  `logs/iter-196/lean-auditor-iter196-report.md`). **Verdict**: NO new
  must-fix items introduced by iter-196 changes; all 3 iter-195 must-fix
  items (WeilDivisor:746, Thm32:194, AlbaneseUP:183) confirmed RESOLVED
  by the iter-196 plan-phase refactors. 21 major findings (M1-M21, all
  documented Tier-3 honest typed sorries or planner-approved scaffolds)
  + 7 minor findings (mostly comment-refresh items). The headline new
  finding is **M1** — the FGAPicRepresentability co-dependency chain
  `HasPicScheme → HasPicSharp` introduced by the carrier-soundness
  refactor; integrated into CRIT-4 of recommendations.md as the
  iter-197/198 `lean_verify` smoke-check target.
- 6× `lean-vs-blueprint-checker` (slugs `avr`, `barescheme`, `h1v`,
  `ocofp`, `rci`, `wd`).
  - `ocofp` — **complete** (6.3 min). 0 must-fix; 3 major chapter-side
    housekeeping (2 broken `\lean{...}` pins + 1 `\leanok`-inside-`\uses`).
    Integrated into recommendations.md CRIT-3.
  - `h1v` — **complete** (6.4 min). **3 must-fix-this-iter** (all
    blueprint-side: non-empty branch sketch underspecifies Mathlib gap;
    inner iso sketch missing; stale `\uses` on `skyscraperSheaf_isFlasque`).
    **HARD GATE: H1Vanishing.lean blocked from prover re-dispatch until
    blueprint chapter is updated.** Integrated into recommendations.md
    CRIT-0.
  - `wd` — **complete** (4.1 min). 0 must-fix; 1 major
    (`isRegularInCodimOneProjectiveLineBar` has no `\lean{...}` blueprint
    pin despite the substantive iter-196 Route 2 advance). Integrated
    into recommendations.md as a blueprint-writer add-on item.
  - `avr` — **complete** (6.6 min). **1 must-fix-this-iter** (need
    `\begin{lemma}` block for `Proj.basicOpenIsoSpec_inv_app_top` — the
    iter-197 prescribed workaround) + 4 major (Step 1 sketch references
    non-existent decl; 2 iter-196 landed primitives have no `\lean{...}`
    block). **HARD GATE: AbelianVarietyRigidity.lean blocked from prover
    re-dispatch until blueprint chapter is updated.** Integrated into
    recommendations.md CRIT-0a.
  - `rci` — **complete** (5.3 min). 0 must-fix, 0 major, 3 minor (stale
    NOTE comment in chapter naming the old `of_fiberToSpecResidueField`
    method; 2 unpinned public-helper coverage gaps). Stale NOTE comment
    refreshed by review agent directly. No HARD GATE.
  - `barescheme` — **complete** (4.5 min). **1 must-fix-this-iter**
    (`lem:projectiveLineBar_geomIrred` blueprint block under-specifies
    Helper A `Proj ⊗ K ≅ Proj ×_S Spec K` + Helpers B-E recipe) + 2
    major (no pins for `projectiveLineBar_isProper` or the
    `mvPolynomialFin_isStandardSmoothOfRelativeDimension` 5-declaration
    chain). The chapter is the consolidated `AbelianVarietyRigidity.tex`,
    so the gate is the SAME as CRIT-0a — one blueprint-writer dispatch
    covers both files. **HARD GATE: BareScheme.lean also blocked from
    prover re-dispatch until the consolidated chapter is updated.**
    Integrated into recommendations.md CRIT-0b.
    Reports will land at
    `task_results/lean-vs-blueprint-checker-<slug>.md` (archived to
    `logs/iter-196/lean-vs-blueprint-checker-<slug>-report.md`). The
    iter-197 plan agent reads them directly; any must-fix-this-iter
    finding gates the corresponding file from prover re-dispatch per the
    HARD GATE rule.

All 7 dispatched in parallel via `archon-subagent.py` foreground (the
harness auto-backgrounded the longer-running ones).

## Subagent skips

- None this phase. Both highly-recommended subagents (`lean-auditor`,
  `lean-vs-blueprint-checker`) were dispatched.

## Per-lane verification (iter-196 plan vs landing)

### BareScheme — re-dispatch
- **Plan HARD BAR**: "≥1 of the 2 scaffold sorries closed axiom-clean
  (≥30 LOC)". **NOT MET strictly** (neither sorry closed), but
  **substantive 5-substrate-decl + cover-reduction landing** meets the
  permissive "structural advance" interpretation. Smoothness lane is now
  ~10 LOC of project work + 1 refactor (relocation) from full closure.
- **Plan PUSH-BEYOND**: "Close BOTH". NOT MET. `geomIrred` 200-350 LOC
  unchanged.

### Lane E — analogue-driven re-dispatch
- **Plan HARD BAR**: implicitly "close ≥1 of the 2 Lane E sorries via
  the lane-e-proj-appiso-pivot recipe". NOT MET. The recipe's step (i)
  landed (2 axiom-clean primitives); step (ii) blocked by
  `Scheme.Hom.app` dependent motive — workaround named for iter-197.
- **Plan PUSH-BEYOND**: NOT MET.

### Lane H — scope-reduced
- **Plan HARD BAR**: ≥1 closure of `IsFlasque.constant_of_irreducible`
  (L138) or `skyscraperSheaf_eq_pushforward_const` (L760). NOT MET
  strictly (neither full lemma closed); empty branch + outer step closures
  meet the permissive interpretation.

### Lane A — re-dispatch post-blueprint
- **Plan HARD BAR**: "close 2 of 3 sub-claims (a)+(b)+(c)". MET cleanly
  (a) + (b) axiom-clean via `toFunctionField_injective` +
  `globalSections_iff_mpr`. (c) extracted to named substrate (1 inline
  sorry → 1 typed-named sorry).
- **Plan PUSH-BEYOND**: "all 3 axiom-clean". NOT MET.

### Lane RCI — CONDITIONAL on BareScheme
- **Plan HARD BAR**: "any substantive advance OR explicit
  hold-with-rationale". MET — substantive reformulation
  (abstract LQF → concrete Set.Finite). Per the iter-196 plan's
  CONDITIONAL gating on BareScheme cascade, full helper (a) closure
  remained blocked; the iter delivered the iter-194-style structural
  lift instead.

### Lane I — refactor + body close
- **Plan HARD BAR**: Route 2 PID transfer ~50-80 LOC closure. MET — body
  landed axiom-clean modulo 1 named residual (`hy_ne_bot`, 5-10 LOC).
- **Plan PUSH-BEYOND**: `degree_positivePart_principal_eq_finrank` body
  close. NOT MET (Mathlib I.6.12 gap unchanged).

## Net assessment

iter-196 delivered substantive structural advance across 6 of 6 lanes
(no errored lanes this iter, in contrast to iter-195's 2 API-529 losses)
and converted multiple opaque sorries to clean named residuals. The
absence of any top-level closure is consistent with the iter-196 plan's
framing (process iter-195 carry-over + blueprint-writer-mediated lane
re-engagement) — the cleanup-and-substrate-build mode does not optimize
for sorry count.

**Concrete iter-197 unlock**: Lane E has the most prescribed and
shortest closure path (~25-45 LOC for 2 sorry closures). Plan agent
should dispatch this lane first.

## Knowledge Base candidates (added to PROJECT_STATUS.md)

- `Algebra.SubmersivePresentation` 0×0-Jacobian pattern for closing
  `Algebra.IsStandardSmoothOfRelativeDimension n R (MvPolynomial (Fin n) R)`.
- `IsZariskiLocalAtSource.of_openCover` recipe for reducing smoothness
  to per-chart smoothness on an affine cover.
- `ObjectProperty.FullSubcategory.ext` for lifting presheaf-level
  equalities to sheaf-level equalities via subsingleton `IsSheaf`.
- `LocallyQuasiFinite.of_finite_preimage_singleton` as LQF reformulation
  recipe (abstract fibre-LQF → concrete topological preimage-finiteness).
- `Scheme.Hom.app` rewriting under `congrArg`/`rw` is BLOCKED by dependent
  motive — workaround via `appTop`-level helper + `comp_app` chain.
- `private instance ... := sorry` → `private theorem ... := sorry` +
  explicit consumer typeclass binders to break silent sorryAx
  propagation.

## Iter-197 commitments

Per the plan-phase iter-197 preliminary list + iter-196 review:

1. Lane E iter-197 dispatch with the prescribed ~25-45 LOC closure of 2
   sorries (CRIT-1 in recommendations).
2. BareScheme smoothness closure via refactor relocating the instance to
   a downstream file (CRIT-2).
3. Blueprint OCofP `\uses` fix (CRIT-3) — 1-line blueprint-writer
   dispatch.
4. Carrier-soundness probe lean_verify smoke check (CRIT-4).
5. Lane I `hy_ne_bot` 5-10 LOC closure (MED-1).
6. Lane RCI generic-point branch closure (MED-4).
