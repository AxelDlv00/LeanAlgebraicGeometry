# iter-007 review (session_7)

## Overall Progress — this session
- **Prover lane**: one (P4 → `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`,
  `[prover-mode: mathlib-build]`). Model: sonnet.
- **Global sorry**: 2 → 2 (unchanged). Both in `CechHigherDirectImage.lean` (P3/P5, out of scope).
- **`AcyclicResolution.lean`**: 0 → 0 sorries; **11 new declarations added** (new `Cosyzygy`
  section), all axiom-clean `{propext, Classical.choice, Quot.sound}`; compiles clean.
- **TARGET-3 leaves (5 total)**: solved / partial / blocked / not_started = **3 / 0 / 0 / 2**.
  - Solved: `lem:cosyzygy_ses`, `lem:applied_cosyzygy_cycles`, `lem:cohomology_of_applied_resolution`
    (the last via two Lean decls — `cohomologyAppliedResolutionIso` n≥1 + `gHomologyZeroIso` n=0).
  - Not started (declined at a clean cut, recipe handed off): `lem:acyclic_one_iso_coker`
    (`rightDerivedOneIsoCokerOfAcyclic`) and the TARGET-3 assembly
    (`rightDerivedIsoOfAcyclicResolution`).

## This session's analysis
The decompose-then-build cadence continues to land exactly the frontier-ready pieces. iter-007 built
the entire **cosyzygy / applied-cohomology layer** the staircase needs — the cosyzygy SES
`0 → Zⁿ → Kⁿ → Zⁿ⁺¹ → 0`, the left-exact transport `G(Zⁿ) ≅ ker(G(dⁿ))`, and the cohomology
identification `Hⁿ(G(K)) ≅ coker(G(Jⁿ⁻¹)→G(Zⁿ))` (both degree-0 and positive) — collapsing the whole
P4 phase to **two remaining declarations** that are now the live frontier. The prover correctly
**declined** the next leaf `rightDerivedOneIsoCokerOfAcyclic` rather than risk a non-axiom-clean
partial under `mathlib-build`: it is the genuine new sub-obstacle (the `R⁰G ≅ G` naturality on the
homology-LES bottom segment, sized like the existing `rightDerivedShiftIsoOfSplitResolutionSES`), and
handed off a precise indexing-checked recipe. The assembly downstream is straight-line `Nat.rec`.

Two reusable Lean lessons came out of the build, both worth more than the headline decl count: (1)
Mathlib's `ShortComplex.mapCyclesIso` is **the wrong tool for a left-exact functor** (it needs
`PreservesLeftHomologyOf` = preserve a colimit); the right route is `isLimitForkMapOfIsLimit'` +
`conePointUniqueUpToIso`. (2) `← G.map_comp` / `simp ← Functor.map_comp` **silently fail** beside a
mapped-complex term (a `HasHomology`-diamond reducibility quirk) — the entire 23:04–23:18 burst of
`lean_run_code` failures in `attempts_raw.jsonl` is this single gremlin; the fix is to isolate the
`map_comp` rewrite on a clean `have` and close in term mode. Both are now in the Knowledge Base.

### Headline finding — frontier-leaf blueprint sketches under-specified (lean-vs-blueprint MAJOR)
No must-fix touched the formalized work, but the bidirectional checker flagged that the **two
remaining frontier leaves** are under-specified for a prover: `lem:acyclic_one_iso_coker` is silent
on the degree-0 LES mechanism (`δIso` doesn't apply at degree 0), and TARGET-3
(`lem:acyclic_resolution_computes_derived`) doesn't pin the Lean **input-type encoding** (QuasiIso vs
`ExactAt` family vs `InjectiveResolution` record), the n=0 empty-staircase case, or the
`cohomologyAppliedResolutionIso ↔ acyclic_one_iso_coker` bridge. This is the same partial/under-spec
pattern as iter-006's `acyclic_dimension_shift` flag. The right next move is an effort-break /
blueprint-writer pass on those two blocks **before** re-dispatching the prover — otherwise the prover
invents the encoding and the HARD GATE's purpose is defeated. Captured at the top of
`recommendations.md`.

### Stale `.lean` status comment (lean-auditor MAJOR — not review-agent fixable)
`AcyclicResolution.lean` ~L823 still claims "(b) Cosyzygy SES infrastructure NOT yet built", now
false (the whole layer is built). It is a `.lean` comment, outside my write domain — flagged in
`recommendations.md` for the next prover or a `refactor` dispatch to correct.

## Subagent dispatches
- **lean-auditor** (`iter007`): dispatched (`.lean` modified). Sound — 0 critical / 1 major / 4 minor.
  All 11 new decls sorry-free, axiom-clean, non-vacuous. Major = the stale L823 status comment.
  Minors = namespace-without-functor-arg naming + pre-existing linter clusters. No custom axioms, no
  excuse-comments. Report: `task_results/lean-auditor-iter007.md`.
- **lean-vs-blueprint-checker** (`acyclic`): dispatched (file received prover work). No must-fix; all
  3 formalized blocks faithful. 2 major open-work items = the two frontier leaves' under-specified
  sketches (above) + the `gCosyzygyIsoCocycles_toCycles` naturality square the blueprint glossed.
  Report: `task_results/lean-vs-blueprint-checker-acyclic.md`.

(No `## Subagent skips` — both highly-recommended review subagents dispatched.)

## Blueprint markers updated (manual)
- `Cohomology_AcyclicResolution.tex`, `lem:cohomology_of_applied_resolution`: corrected `\lean{}`
  from the single `cohomologyAppliedResolutionIso` to the pair
  `{cohomologyAppliedResolutionIso, gHomologyZeroIso}` (the lemma states both degree-0 and
  positive-degree; the Lean split into two decls is unavoidable — different target types). Added a
  `% NOTE (iter-007 review)` documenting the split. Both decls axiom-clean, so the `\leanok` added by
  `sync_leanok` this iter remains accurate.

## Pointers
- blueprint-doctor (`logs/iter-007/blueprint-doctor.md`): **no structural findings**.
- `sync_leanok` iter-007 (`sha 8c28d84`): `added 10, removed 2` on `Cohomology_AcyclicResolution.tex`
  — deterministic, confirmed against the axiom-clean Lean.
