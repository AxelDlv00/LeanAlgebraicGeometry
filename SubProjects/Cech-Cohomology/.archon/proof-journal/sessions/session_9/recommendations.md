# Recommendations for the next plan iteration (post iter-009)

## Headline — P4 abstract layer is CLOSED; pivot the next lane to the Čech side (P3/P5)

iter-009 proved the last two P4 declarations (`rightDerivedOneIsoCokerOfAcyclic`,
`rightDerivedIsoOfAcyclicResolution`), both axiom-clean. `AcyclicResolution.lean` is sorry-free.
The DAG confirms it: `gaps` = 0 (no ∞ holes), and the entire `frontier` (3 nodes) is now on the
**Čech side**, in `CechHigherDirectImage.lean`:
- `AlgebraicGeometry.cech_eq_cohomology_of_basis` (`lem:cech_eq_cohomology_of_basis`)
- `AlgebraicGeometry.cechAugmented_exact`
- `AlgebraicGeometry.higherDirectImage_isSheafify_presheafCohomology`

The two remaining **global sorries** are both here:
- `CechHigherDirectImage.lean:774` — `CechAcyclic.affine` (acyclicity input feeding the collapse).
- `CechHigherDirectImage.lean:811` — `cech_computes_higherDirectImage` (the project's top theorem,
  **frozen protected signature**).

**Action:** the next prover lane should target the Čech chapter. Before dispatching, run the HARD GATE
on `Cohomology_CechHigherDirectImage.tex` — the iter-007 plan flagged it as the deferral-only chapter
(P3/P5 known-deferred), so it likely needs a blueprint-writer/effort-break pass first. The P4 engine
`rightDerivedIsoOfAcyclicResolution` is now the off-the-shelf tool these consumers plug into.

## MAJOR (from lean-auditor `iter009`) — stale `.lean` comment blocks (NOT review-agent-fixable)

The review agent cannot edit `.lean` files. These need a `refactor`/cleanup dispatch or the next
prover to delete/update them. All are factually contradicted by the current proof state:

- **`AcyclicResolution.lean:924-963`** — "Status (iter-006)" block claims TARGET 3 and its two
  sub-ingredients are "remaining"; **all three are proven above it in the same file**. Most misleading
  block in the project. Delete or rewrite to "P4 CLOSED (iter-009)".
- **`AcyclicResolution.lean:8-36`** — module-doc says three already-built decls "will be constructed",
  and omits `rightDerivedOneIsoCokerOfAcyclic` from the declaration list. Update.
- **`CechHigherDirectImage.lean:71-96`** — "push-pull functor is the remaining gap" / "CechNerve is
  the single genuine hole": both closed (lines 627/640/698). Stale.
- **`CechHigherDirectImage.lean:245-293`** — "Composition law … remaining": proved immediately below.
- **`CechHigherDirectImage.lean:410-449`** — "not yet closed (next-prover dead-ends)" for
  `pushPullMap_comp`: closed at lines 533-630. Stale.
- **`CechHigherDirectImage.lean:161-183`** — "currently unfilled" about `pushPullMap_comp`: filled.

Recommend a single `refactor` pass over both files to purge stale "remaining/not-yet-closed/TARGET-N"
narrative comments, since the next prover will be reading `CechHigherDirectImage.lean` anyway.

## MEDIUM — 1-to-1 coverage debt (28 unmatched `lean_aux` nodes)

`archon dag-query unmatched` reports 28 Lean declarations with no blueprint entry (invisible to the
DAG). The prover confirmed **no NEW orphans this iter** — these are accumulated helpers across
iters 002-007. The doctrine ("when there is Lean there must be tex") asks the planner to author thin
blueprint stubs. Grouped by file:

**`AcyclicResolution.lean` (18 — `CategoryTheory.*`)** — horseshoe/cosyzygy/twisted-biproduct helpers:
`cosyzygyShortComplex`, `gCosyzygyIsoCocycles_hom_iCycles`, `gCosyzygyIsoCocycles_toCycles`,
`isZero_homology_mapHomologicalComplex_of_isRightAcyclic`, `cosyzygyKernelFork`,
`cosyzygy_iCycles_comp_toCycles`, `epi_toCycles_of_exactAt`,
`shortExact_map_mapHomologicalComplex_of_degreewise_splitting`, `shortExact_of_degreewise_splitting`,
`twistedBiprod`, `twistedBiprodD`, `twistedBiprodD_fst`, `twistedBiprodD_snd`,
`twistedBiprodInl_comp_Snd`, `twistedBiprodInl_f`, `twistedBiprodSnd_f`, `twistedBiprod_X`,
`twistedBiprod_d`. Most are `simp`/component lemmas for the twisted-biproduct complex and the cosyzygy
SES; a small handful (`twistedBiprod`, `cosyzygyShortComplex`, `shortExact_*_degreewise_splitting`) are
genuine constructions worth a one-line blueprint node.

**`CechHigherDirectImage.lean` (10 — `AlgebraicGeometry.*`)** — push-pull machinery:
`coverCechNerveOver`, `coverCechNerveOverAug`, `pushPullMap_eq_raw`, `pushPull_pentagon`,
`pushPull_unit_comp`, `pushforwardComp_hom_app_id`, `rawPushPullMap`, `rawPushPullMap_comp`,
`rawPushPullMap_self`, `rawPushPullMap_self_gen`.

Lower priority than closing the Čech sorries, but if a blueprint-writer is dispatched on the Čech
chapter anyway, fold the 10 `AlgebraicGeometry.*` stubs into that pass.

## MINOR (from lean-auditor) — compilation fragility

- `CechHigherDirectImage.lean:404` — `set_option maxHeartbeats 1000000` on `pushPullMap_eq_raw`
  (proved by bare `rfl`). One-million heartbeats for a defeq check is a fragility/regression risk.
- `CechHigherDirectImage.lean:467` — `set_option maxHeartbeats 4000000` on `rawPushPullMap_self_gen`
  (a `subst`-based proof). Exceptional; same risk.
- These were load-bearing to land the proofs (see Knowledge Base: `conjugateEquiv`/`whnf` heartbeat
  explosion is a known blocker). Do NOT retry the `conjugateEquiv` route to lower them; if a refactor
  touches them, keep the `rawPushPullMap`/`subst` route. Flag only — not blocking.

## Blocked / do-NOT-reassign
- The two Čech-side sorries are **not blocked**, but they are a **separate effort** from the now-closed
  P4 abstract layer — do not re-dispatch a `mathlib-build` lane on `AcyclicResolution.lean` (nothing
  left to build there). The Čech consumers need their own blueprint readiness check first.

## Reusable proof patterns discovered (also added to Knowledge Base)
- **Two-step cokernel transport** when one naturality leg carries a `homologyMap`/`homologyFunctor.map`
  defeq: split into two `cokernel.mapIso` steps, each matched to its own off-the-shelf Mathlib
  naturality lemma (`isoRightDerivedObj_hom_naturality`, `rightDerivedZeroIsoSelf.hom.naturality`).
  A single combined `cokernel.mapIso` forces `rw`/`cancel_epi` through the non-syntactic homology type
  and fails.
- **Staircase as straight-line `Nat.rec`**: once leaf isos exist, the dimension-shift comparison is a
  generalized induction `stairGen m s` with exactly two `eqToIso`/`omega` index bridges
  (`(s+1)+m` vs `s+(m+1)`, `0+m` vs `m`); `s+0`/`m+0`/`m+2=(m+1)+1` are defeq.
