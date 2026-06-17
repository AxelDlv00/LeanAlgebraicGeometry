# Session 7 (iter-007) — review summary

## Metadata
- **Prover lane**: one (P4 → `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`,
  `[prover-mode: mathlib-build]`). Model: sonnet.
- **Global sorry**: 2 → 2 (unchanged). Both in `CechHigherDirectImage.lean`
  (`CechAcyclic.affine`, `cech_computes_higherDirectImage` — P3/P5, out of scope).
- **`AcyclicResolution.lean`**: 0 → 0 sorries; **11 new declarations added** (a new `Cosyzygy`
  section, ~lines 685–820), all axiom-clean `{propext, Classical.choice, Quot.sound}`,
  file compiles clean (style warnings only).
- **TARGET-3 leaves**: 5 total. **3 of 5 closed this iter**; 2 deliberately deferred.
  - Solved: `lem:cosyzygy_ses` (`cosyzygyShortExact`), `lem:applied_cosyzygy_cycles`
    (`gCosyzygyIsoCocycles`), `lem:cohomology_of_applied_resolution`
    (`cohomologyAppliedResolutionIso` n≥1 + `gHomologyZeroIso` n=0).
  - Not started (declined at a clean cut, recipe handed off): `lem:acyclic_one_iso_coker`
    (`rightDerivedOneIsoCokerOfAcyclic`) and the TARGET-3 assembly
    (`rightDerivedIsoOfAcyclicResolution`).
- **Solved / partial / blocked / not_started** (5 targets): 3 / 0 / 0 / 2.

## Targets attempted

### `Functor.cosyzygyShortExact` (lem:cosyzygy_ses) — SOLVED
For an exact cochain complex `K` the cosyzygy triple `0 → Zⁿ → Kⁿ → Zⁿ⁺¹ → 0`
(`Zⁿ = K.cycles n`) is short exact. Built as a `ShortComplex.ShortExact`:
`mono_f` = `iCycles` mono (`infer_instance`), `exact` = `ShortComplex.exact_of_f_is_kernel _
(cosyzygyKernelFork K n)`, `epi_g` = `epi_toCycles_of_exactAt K n h`.
- **Sub-obstacle**: Mathlib has no `exactAt_iff_epi_toCycles`. The prover hand-built
  `epi_toCycles_of_exactAt` via the cokernel cofork (`epi_of_isColimit_cofork`) — after several
  unknown-constant false starts (`Cofork.IsColimit.epi_of_isZero_of_isColimit`,
  `cokernel.IsColimit.epi_of_isZero_of_isColimit`).

### `Functor.gCosyzygyIsoCocycles` (lem:applied_cosyzygy_cycles) — SOLVED
`G(Zⁿ) ≅ cycles n of G(K)` for finite-limit-preserving `G`.
- **Key detour (reusable)**: `ShortComplex.mapCyclesIso` is **UNUSABLE** here — it needs
  `[F.PreservesLeftHomologyOf S]` (i.e. preserve a colimit too), but `f_*`/left-exact `G` only
  preserves finite limits. The working route is
  `Limits.IsLimit.conePointUniqueUpToIso (isLimitForkMapOfIsLimit' G … (cyclesIsKernel …)) …`.
  Compatibility lemma `gCosyzygyIsoCocycles_hom_iCycles` via
  `conePointUniqueUpToIso_hom_comp` at `WalkingParallelPair.zero`.

### `Functor.cohomologyAppliedResolutionIso` + `gHomologyZeroIso` (lem:cohomology_of_applied_resolution) — SOLVED
Positive degree: `Hᵐ⁺¹(G(K)) ≅ coker(G.map (K.toCycles m (m+1)))` via
`homologyIsCokernel ≪≫ cokernel.mapIso` using the naturality square
`gCosyzygyIsoCocycles_toCycles`. Degree 0: `H⁰(G(K)) ≅ G(Z⁰)` via
`gCosyzygyIsoCocycles K 0 ≪≫ CochainComplex.isoHomologyπ₀`.
- **Headline gotcha (reusable)**: `rw [← G.map_comp]` / `simp only [← Functor.map_comp]`
  **silently fail** ("pattern not found" / "no progress") on a goal whose LHS is literally
  `G.map f ≫ G.map g` when the rest of the goal contains a mapped-complex term — an
  instance/`HasHomology`-diamond reducibility quirk. The ~10 `lean_run_code` failures around
  23:04–23:18 in `attempts_raw.jsonl` are all this. **Workaround that works**: prove the
  `G.map _ ≫ G.map _ = G.map (_ ≫ _)` fact in an *isolated* `have` on a clean goal, then close
  the main goal in **term mode** (`toCycles_i` as a term, not `rw`/`simp`). Also
  `rw [Category.id_comp]` fails on `𝟙 (GK.X m) ≫ G.map f` (GK.X m not syntactically
  `G.obj (K.X m)`); a full `simp` closes it via defeq.

### `Functor.rightDerivedOneIsoCokerOfAcyclic` (lem:acyclic_one_iso_coker) — NOT STARTED (declined)
The prover correctly declined this leaf under `mathlib-build` rather than risk a non-axiom-clean
partial. It is a genuine multi-step obstacle (the `R⁰G ≅ G` naturality on the homology-LES bottom
segment), comparable in size to the existing `rightDerivedShiftIsoOfSplitResolutionSES`. Precise
indexing-checked recipe handed off (see recommendations.md and the task_result). Key insight:
`δIso` (used for the higher-degree shift) does NOT apply at degree 0 — needs cokernel-from-epi-exact
extraction (`ShortComplex.Exact.gIsCokernel` + `IsColimit.coconePointUniqueUpToIso`).

### `Functor.rightDerivedIsoOfAcyclicResolution` (TARGET-3 assembly) — NOT STARTED
Downstream of the above. With the 3 closed leaves + that one leaf, the assembly is a straight-line
`Nat.rec` composition (n=0 via `rightDerivedZeroIsoSelf ≪≫ G.mapIso e ≪≫ gHomologyZeroIso`;
n=m+1 via the cosyzygy staircase + cokernel description + `cohomologyAppliedResolutionIso.symm`).
`ses.g` of `cosyzygyShortComplex K m` **is** `K.toCycles m (m+1)`, so the cokernels match on the nose.

## Key findings / patterns discovered
- **`mapCyclesIso` is the wrong tool for a left-exact functor** — use `isLimitForkMapOfIsLimit'`.
  (Added to Knowledge Base.)
- **`← G.map_comp` silently fails next to a mapped-complex term** — isolate the rewrite + close in
  term mode. (Added to Knowledge Base.)
- The decompose-then-build cadence (effort-break TARGET-3 → build the ready leaves) again landed
  exactly the frontier-ready pieces and left the one genuinely-new sub-obstacle for a focused next
  round — same healthy pattern as iters 005→006 on the horseshoe.

## Subagent dispatches
- **lean-auditor** (`iter007`): dispatched (`.lean` modified). **Sound** — 0 critical, 1 major,
  4 minor. All 11 new decls sorry-free, axiom-clean, non-vacuous. Major = a **stale `.lean` status
  comment** (~L823) still claiming "(b) Cosyzygy SES infrastructure NOT yet built", directly
  contradicted by the new section. Minors: `cosyzygyShortComplex`/`cosyzygyShortExact` sit in
  `Functor.` namespace but take no functor arg; pre-existing linter clusters. Report:
  `task_results/lean-auditor-iter007.md`.
- **lean-vs-blueprint-checker** (`acyclic`): dispatched (file received prover work). **No must-fix.**
  All 3 formalized cosyzygy blocks faithful (signatures + proof sketches match; `gHomologyZeroIso`'s
  benign "more general than blueprint" divergence is pre-documented by my iter-007 `% NOTE`). 2 major
  open-work items = the two frontier leaves' blueprint sketches are **under-specified for a prover**
  (TARGET-3 input-type encoding, n=0 staircase case, and the `cohomologyAppliedResolutionIso ↔
  acyclic_one_iso_coker` bridge; `acyclic_one_iso_coker` silent on the degree-0 LES mechanism).
  Report: `task_results/lean-vs-blueprint-checker-acyclic.md`.

(No `## Subagent skips` — both highly-recommended review subagents dispatched.)

## Blueprint markers updated (manual)
- `Cohomology_AcyclicResolution.tex`, `lem:cohomology_of_applied_resolution`: corrected
  `\lean{...cohomologyAppliedResolutionIso}` → `\lean{...cohomologyAppliedResolutionIso,
  ...gHomologyZeroIso}` (the lemma states both degree-0 and positive-degree; the Lean split is
  unavoidable since the n=0 and n≥1 targets have different types). Added a `% NOTE (iter-007 review)`
  documenting the split. Both decls are sorry-free + axiom-clean, so the existing `\leanok` (added by
  `sync_leanok` this iter) stays accurate.

## Notes (LOW)
- `sync_leanok` ran for iter-007 (`sha 8c28d84`, `added: 10, removed: 2`) on
  `Cohomology_AcyclicResolution.tex` — the three new leaf blocks' `\leanok` markers are the script's
  deterministic verdict, confirmed against the axiom-clean Lean.
- blueprint-doctor: **no structural findings** (no orphan chapters, no broken `\ref`/`\uses`, no new
  axioms).
