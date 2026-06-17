# iter-019 review

## Overall progress this iter
- **Total sorry**: 2 → 2 (no regression). Both intentional: superseded relative-form
  `CechAcyclic.affine` (line 109, left per Q4) + frozen P5b assembly
  (`CechHigherDirectImage.lean:715`).
- **Build**: GREEN (3 touched files diagnostic-clean).
- **+29 axiom-clean declarations** across 3 parallel lanes; **0 new sorries**; **2 named lane
  targets landed** (the strongest landing pattern since the project began):
  - `SectionCechModule.dDiff_exact` — P3 section-form **step (a)**, positive-degree exactness of the
    un-localised section Čech module complex `D• = ∏_σ M_{s_σ}`.
  - `cechComplex_hom_identification` — P3b bridge, the named Lane-1 target
    (`homCechComplex 𝒰 F ≅ sectionCechComplex (coverOpen 𝒰) F`).

## Branches advanced
- **P3 L1 (`CechAcyclic.lean`, +24)**: the entire `R`-module exactness core of the section-form
  `lem:cech_acyclic_affine`, built bottom-up — the localisation-transitivity keystone
  (`comparison_isLocalizedModule`, `M_a[1/b]=M_{ab}`), the `D•` complex, the differential-naturality
  square, the `fLoc`/`IsLocalizedModule.pi` instance chain, and `dDiff_exact` via
  `exact_of_isLocalized_span`. This is the hardest, most-uncertain sub-task the L1 analysis flagged,
  now CLOSED. Remaining for the affine vanishing: the sheaf-section sub-build (b)–(d), a distinct
  layer independent of the P3b lanes.
- **P3b bridge (`CechBridge.lean`, +2)**: the named target `cechComplex_hom_identification` LANDED
  (was held back operationally last iter by a concurrent-lane build breakage; this iter the
  cosimplicial naturality square was discharged in full and the one-liner `mapIso` assembly closed
  it). `injective_cech_acyclic` remains correctly held on the Lane-3 quasi-iso.
- **P3b free (`FreePresheafComplex.lean`, +3)**: `quasiIso_of_evaluation` — the objectwise reduction
  (recipe step 1) reducing `cechFreeComplex_quasiIso` to a single per-`V` obligation, verified
  end-to-end. The named target is NOT built; the per-`V` contracting homotopy (steps 2–3) is a
  ~20-decl combinatorial build still ahead.

## This iter's analysis
- **Two named targets landing in one iter is the payoff of the iter-018 infrastructure round.**
  iter-018 landed the away-comparison algebra + the cosimplicial core + the augmentation chain; this
  iter assembled those into the two named results. The "0 named targets landed but residual shrank"
  pattern of iter-018 converted directly into closings here — the planner's read that those handoffs
  made the targets "genuinely reachable" was correct.
- **P3 L1 is no longer the project's scariest unknown.** The localisation-transitivity keystone — the
  single piece the iter-017 `l1bridge` consult and the iter-018 review both flagged as the highest-risk
  gap — is now a proved project lemma. What remains on the affine-vanishing route is sheaf-section
  bookkeeping (tilde-`M`, Stacks 01I8, degreewise identification), which is mechanical relative to the
  module algebra just completed.
- **The one genuine new blocker is blueprint-side, not Lean-side**: `lem:cech_free_complex_quasi_iso`
  is under-specified for the remaining homotopy build (lvb must-fix). This is exactly the
  "expand the blueprint before the prover" gate the loop is designed around — caught before a wasted
  prover round. The prover also *corrected* the recipe's dead-end note: there is no presheaf-level
  extra degeneracy (naturality fails across `V`), but sectionwise it is the Mathlib-blessed tool
  (`Rep.standardComplex` precedent). That correction should drive the blueprint expansion.
- **No code-quality regressions.** lean-auditor: 0 must-fix, all 29 decls axiom-clean, both sorries
  accounted for. The only debt is mechanical: 4 stale module-docstrings (one actively misleading —
  `pushPullMap_comp` described as a dead-end though proved) + 28 uncovered helpers. Neither blocks
  the math.

## Subagent skips
- _(none — all HIGHLY RECOMMENDED review subagents dispatched: lean-auditor + 3
  lean-vs-blueprint-checkers, one per prover-touched file.)_

## Markers
- No manual blueprint-marker changes this iter. No `\mathlibok` (no Mathlib re-exports among the new
  decls — `quasiIso_of_evaluation` etc. are project proofs), no `\lean{}` renames (provers used the
  planned names; `cechComplex_hom_identification` matches its `\lean{}`), no `\notready` present
  anywhere. Coverage-debt bundling + proof-sketch expansion are blueprint-writer (prose) tasks for the
  planner.
- `sync_leanok` (iter-019, sha 3e1f84b): +0 / −1 `\leanok` in `Cohomology_CechHigherDirectImage.tex`
  (deterministic). blueprint-doctor: no structural findings.

## Handoff to next plan iter (see recommendations.md)
1. **must-fix**: blueprint-writer to expand `lem:cech_free_complex_quasi_iso` (Lean packaging pathway)
   before re-dispatching the quasi-iso lane; consider an effort-breaker to split it.
2. P3 L1 continues with the sheaf-section sub-build (steps b–d) — a dispatchable lane, independent of
   P3b, with `dDiff_exact` as the ready `Function.Exact` input.
3. Hold `injective_cech_acyclic` until the quasi-iso lands.
4. Bundle 28 unmatched helpers; refactor to fix 4 stale docstrings.
