# Session 6 (iter-006) — review summary

## Metadata
- **Prover lane**: one (P4 → `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`,
  `[prover-mode: mathlib-build]`). Model: sonnet.
- **Global sorry**: 2 → 2 (unchanged). Both in `CechHigherDirectImage.lean`
  (`CechAcyclic.affine` L774, `cech_computes_higherDirectImage` L811 — P3/P5, out of scope).
- **`AcyclicResolution.lean`**: 0 → 0 sorries; **14 new declarations added**, all axiom-clean
  (`{propext, Classical.choice, Quot.sound}`). File compiles `EXIT 0` (style/unused-var
  warnings only).
- **Targets attempted (5)**: solved / blocked = 4 / 1.
  - `quasiIso_τ₂` (missing-from-Mathlib supplement) — **solved**.
  - `ofShortExact_resolvesMiddle` (`lem:horseshoe_resolvesMiddle`) — **solved**.
  - `ofShortExact` (`lem:injective_resolution_of_ses`, TARGET 1, the horseshoe) — **solved**.
  - `rightDerivedShiftIsoOfAcyclic` (`lem:acyclic_dimension_shift`, TARGET 2) — **solved**
    (part (1) only; see partial-coverage note below).
  - `rightDerivedIsoOfAcyclicResolution` (`lem:acyclic_resolution_computes_derived`,
    TARGET 3, the staircase) — **blocked** (needs effort-break; two new ingredients).

## Headline — the multi-iter P4 bottleneck is closed
iter-004 built every *consumer* of the horseshoe; iter-005 built almost all of the horseshoe
itself (twisted-biproduct complex, the τ twist recursion + cocycle), leaving the entire P4
chain hinging on **one** precise gap: the middle-term quasi-isomorphism transfer
`HomologicalComplex.HomologySequence.quasiIso_τ₂`, ABSENT from Mathlib (which ships only the
last-term `quasiIso_τ₃`). **This iter built it** — a faithful general homology four-lemma
(`isIso_of_mono_of_epi` over the composableArrows₅ windows, with the ℕ degree-0 boundary
mono) — and then assembled, in one straight-line run:
- the middle-resolution quasi-iso `quasiIso_horseshoeι` → `ofShortExact_resolvesMiddle`;
- the dual Horseshoe Lemma `ofShortExact` (TARGET 1);
- the object-level dimension shift `rightDerivedShiftIsoOfAcyclic` (TARGET 2), by feeding the
  horseshoe lift into the iter-004 resolution-level engine
  `rightDerivedShiftIsoOfSplitResolutionSES`.

The strategy's stated reversal signal (horseshoe `τ`-recursion a multi-iter wall ⇒ reconsider
the injective-middle special case) was never triggered: the decompose-then-build response across
iters 005→006 carried the construction to completion.

## Per-target detail (attempts grounded in `attempts_raw.jsonl`)

### `quasiIso_τ₂` — RESOLVED, axiom-clean (line ~89)
Mirrored Mathlib's `quasiIso_τ₃`. For each degree `i`, `IsIso (homologyMap φ.τ₂ i)` via
`isIso_of_mono_of_epi`: **epi** from `epi_of_epi_of_epi_of_mono` on the successor window
`(δlastFunctor ⋙ δlastFunctor).map (mapComposableArrows₅ φ hS₁ hS₂ i j hij)`, boundary via
`epi_homologyMap_of_epi_of_not_rel`; **mono** from `mono_of_epi_of_mono_of_mono` on the
predecessor window, boundary via `mono_homologyMap_of_mono_of_not_rel`. Took two extra boundary
hyps `hbMono`/`hbEpi`; for `ComplexShape.up ℕ` only `hbMono` at degree 0 is non-vacuous.
- **Crucial gotcha**: the four-lemma side-condition args of form `Epi (app' …)` must be
  discharged with `exact hE1 i` (defeq match); `infer_instance` fails on the `app'` form.

### `ofShortExact_resolvesMiddle` → `ofShortExact` → `rightDerivedShiftIsoOfAcyclic` — RESOLVED
`horseshoeι := (fromSingle₀Equiv).symm ⟨horseshoeβ,…⟩`; `mono_horseshoeβ` via
`mono_biprod_lift_factorThru_of_exact`; `horseshoeφ : ses.map single₀ ⟶ horseshoeSES` with
source short-exact by `hses.map_of_exact (single₀ 𝒜)`; `quasiIso_horseshoeι := quasiIso_τ₂ …`.
Two repeated blockers, both diagnosed via minimal repros and resolved (see Knowledge Base):
1. `Mono (I_A.ι.f 0)` instance failed — **domain mismatch** (`I_A.ι.f 0` has domain
   `((single₀).obj Z).X 0`, not syntactically `Z`). Fix: ascribe the clean domain
   `(show ses.X₁ ⟶ I_A.cocomplex.X 0 from I_A.ι.f 0)`.
2. **`twistedBiprod`-flavoured projections** block all `biprod.*` simp lemmas (defeq but not
   reducibly `K.X n ⊞ L.X n`). Fix: `change` the goal to the clean biproduct before
   `biprod.hom_ext`.
Also: `ofShortExact_resolvesMiddle` needed `noncomputable` (depends on `Nonempty.some`).

### TARGET 3 `rightDerivedIsoOfAcyclicResolution` — BLOCKED, precise handoff
Not one step. Needs two new ingredients neither built nor in Mathlib: **(a)** the part-2
base-case coker iso `(R¹G)(A) ≅ coker(G(J) → G(Z))` (LES-boundary homological algebra, a sibling
of `rightDerivedShiftIsoOfSplitResolutionSES` using `homology_exact₂/₃` at degrees 0,1 +
`rightDerivedZeroIsoSelf`); **(b)** cosyzygy SES infrastructure (`Zᵐ := ker(Jᵐ→Jᵐ⁺¹)`, the SES
`0→Zᵐ→Jᵐ→Zᵐ⁺¹→0`, and `H⁰(G(J•))≅G(A)`, `Hⁿ(G(J•))≅(R¹G)(Zⁿ⁻¹)`). The prover correctly declined
to leave a sorry-bearing partial def. **Effort-break into (a) + (b) before re-dispatching.**

## Key findings / patterns
- The `\leanok` on `lem:acyclic_dimension_shift` is a real sync_leanok verdict but covers part
  (1) only — flagged by lean-vs-blueprint-checker as **partial coverage** (the blueprint lemma
  states two parts; the Lean delivers the k≥1 shift isos, not the part-(2) cokernel base case).
  Added a `% NOTE:`. This is the inverse of a laundering risk: the decl is genuine, but the
  *statement* over-claims relative to the Lean. The planner must split part (2) or narrow the
  statement so TARGET 3's dependency on the cokernel base case stays visible.
- Two iter-N review NOTEs are now obsolete and were updated: the iter-004 FALSE-DONE
  code-fence NOTE on `lem:injective_resolution_of_ses` (the real `ofShortExact` now exists),
  and the iter-005 `quasiIso_τ₂`-is-ABSENT NOTE on `lem:horseshoe_resolvesMiddle` (now built).

## Subagent dispatches
- **lean-auditor** (`iter006`): dispatched (`.lean` modified). iter-006 work **entirely clean** —
  all four focus decls axiom-clean, `quasiIso_τ₂` non-vacuous with correctly-quantified boundary
  hyps, code-fence trap not reintroduced. 2 must-fix + 2 major are **pre-existing**: the two
  `CechHigherDirectImage.lean` sorries (P3/P5) and two stale comment blocks there (L184,
  L246–449) claiming `pushPullMap_comp` is unimplemented when it is proved at L627. 9 minor.
  Report: `task_results/lean-auditor-iter006.md`.
- **lean-vs-blueprint-checker** (`acyclic`): dispatched. 0 must-fix; 4 major (partial coverage of
  `lem:acyclic_dimension_shift`; dangling `\lean{rightDerivedIsoOfAcyclicResolution}` for unbuilt
  TARGET 3 [expected]; `quasiIso_τ₂` and `rightDerivedShiftIsoOfSplitResolutionSES` have no
  blueprint block); 2 minor. Report: `task_results/lean-vs-blueprint-checker-acyclic.md`.

(No `## Subagent skips` — both highly-recommended review subagents dispatched.)

## Blueprint doctor
Clean — no orphan chapters, no broken `\ref`/`\uses`, no new `axiom` declarations.

## Blueprint markers updated (manual)
- `Cohomology_AcyclicResolution.tex`, `lem:injective_resolution_of_ses`: replaced the stale
  iter-004 FALSE-DONE `% NOTE` with a `% NOTE (iter-006 review): CLOSED` — `ofShortExact` now
  exists and is axiom-clean; the `\leanok` is a genuine sync_leanok verdict.
- `Cohomology_AcyclicResolution.tex`, `lem:horseshoe_resolvesMiddle`: replaced the stale iter-005
  `quasiIso_τ₂`-is-ABSENT scaffolding NOTE with a `% NOTE (iter-006 review): CLOSED` — the
  middle-term transfer was built; the gap framing is obsolete.
- `Cohomology_AcyclicResolution.tex`, `lem:acyclic_dimension_shift`: added a
  `% NOTE (iter-006 review): PARTIAL COVERAGE` — the `\leanok` decl covers part (1) only; part
  (2) cokernel base case is still-to-build (TARGET 3 ingredient (a)).

(No `\leanok` touched — owned by `sync_leanok`, which ran this iter: sha 79bc88b, added 6.)

## Recommendations
See `recommendations.md` — top item is to effort-break TARGET 3 into (a) base-case coker iso and
(b) cosyzygy staircase; second is the coverage debt (blueprint blocks for `quasiIso_τ₂`,
`rightDerivedShiftIsoOfSplitResolutionSES`, and the horseshoe helpers); third is the stale
`pushPullMap_comp` comment blocks in `CechHigherDirectImage.lean`.
