# Progress Critic Report

## Slug
iter113

## Iteration
113

## Routes audited

### Route: `AlgebraicJacobian/Differentials.lean` — Phase B opening L122 / helper #1

- **Sorry trajectory**: 5 → 5 → 5 across iter-110, 111, 112. Iter-110 and iter-111 had **no prover lane** (blueprint-prep iters), so the only iter producing prover signal in this window is iter-112. In iter-112 the count stayed at 5 because the L122 sorry was **migrated**, not closed: it moved into a new helper (`relativeDifferentialsPresheaf_isSheafOpensLeCover_type`) at L177. That is a structural advance under the hood, not a stall under the hood — the original target's proof body became closed via delegation.

- **Helper accumulation**: 0, 0, 2 added across iter-110/111/112. The two added in iter-112 split cleanly: one load-bearing with a sorry body, one fully closed and derived from the first. Main theorem body for the iter-112 target is fully closed via Step 1 + delegation. This is **not** the "wrapper helpers stacked but residual unchanged" pattern — the helper count grew once, the residual moved into a strictly narrower obligation.

- **Recurring blockers**: Two phrases recur across iter-111 + iter-112 reports — "basis-to-opens descent" and "no off-the-shelf sheaf-on-affine-basis-of-Scheme ⇒ sheaf lemma in Mathlib for Scheme.PresheafOfModules". Only 2 iters of overlap (not ≥3), so the recurring-blocker STUCK rule does not yet fire. The blockers are also **named, scoped sub-lemmas with LOC estimates** (Sub-lemma A ~40–80 LOC, Sub-lemma B ~50–100 LOC) — the planner has translated the blocker into a concrete prover assignment rather than re-circling it.

- **Prover status pattern**: N/A, N/A, PARTIAL (Bar B acceptable). One prover round of data total. PARTIAL→? — the second data point arrives only at iter-113. The CHURNING rule "PARTIAL ≥3 of last K" does not fire on a sample of one.

- **Verdict**: **UNCLEAR (trending CONVERGING)**

- **Why not CONVERGING yet**: Only one prover round in window; sorry count nominally unchanged. CONVERGING requires "strictly decreasing across K iters" — a single PARTIAL with sorry-migration is not enough signal to grant it outright.

- **Why not CHURNING**: No "≥2 of K iters added helpers" pattern (only 1 such iter); planner's proposal is **not** "another helper round" — it is "close the helper introduced last iter via two named sub-lemmas with concrete Mathlib hooks." That is the canonical escalation from PARTIAL Bar B → Bar A, exactly what the loop wants.

- **Watch flag for next iter** (iter-114 audit): If iter-113's prover round returns PARTIAL again and introduces ≥1 new helper without closing helper #1, this flips to CHURNING. The "decompose helper #1 into sub-lemmas A and B" plan must end with at least one of A or B fully closed — preferably the smaller affine-restriction Sub-lemma A. If iter-113 returns "we now have helpers A and B, both with sorry bodies, sorry count 5 → 5 again," that is the helper-explosion pattern to halt.

---

### Route: 3-signature-mismatch refactor on `Differentials.lean`

- **Sorry trajectory**: Not applicable. Fresh route, iter-113 only. Project sorry count is unchanged by definition (statements re-typed, bodies remain `sorry`).

- **Helper accumulation**: Zero — no helpers being added, this is a signature correction.

- **Recurring blockers**: Not applicable (fresh).

- **Prover status pattern**: No prior prover signal (no prover has touched `smooth_iff_locally_free_omega`, `cotangent_at_section`, or `serre_duality_genus` yet).

- **Verdict**: **UNCLEAR**

- **Convergence verdict does not apply directly**: This is a one-shot statement-alignment dispatch with no closure obligation. The plan-agent question is "is this the right move *this iter*", which is partially outside my normal scope — I assess it on signal-level grounds only:

  - The mismatches are **latent**, pre-existing, and would block any future prover work on those declarations regardless. Fixing them now costs the same as fixing them later.
  - The refactor is **structural-only** (no proof closure, no helper accretion). It cannot churn by construction.
  - The declaration ranges are **disjoint from the prover lane**: L159 (helper #1) ≪ L816–L982 (the three refactored signatures). Sequenced plan-phase → prover-phase, with the prover reading the post-refactor file, has no overlap on write access.

- **Watch flag**: The only failure mode I can construct is **downstream signature dependence** — if any declaration *below* L816 (or in another file that imports `Differentials.lean`) consumes the old signatures of `smooth_iff_locally_free_omega`, `cotangent_at_section`, or `serre_duality_genus`, the refactor breaks the build for the prover phase. Refactor subagent should run a build check after re-typing and report on any downstream breaks before the prover lane starts. If a downstream break surfaces, prover phase should be deferred one iter while the cascade is handled.

---

## Must-fix-this-iter

(No CHURNING or STUCK verdicts this iter.)

## Informational

- Route `Differentials.lean` helper #1 closure: **UNCLEAR (trending CONVERGING)**. Proceed with the planned prover lane on helper #1 via named Sub-lemmas A + B. Iter-114's progress-critic audit will resolve to CONVERGING if at least one sub-lemma closes, or flip to CHURNING if the response is "now we have two more sorry-bodied sub-helpers."

- Route 3-signature-mismatch refactor: **UNCLEAR (fresh)**. Dispatch is sound on disjoint-write grounds; the only material risk is downstream build breaks from re-typing, which the refactor subagent should validate via a `lake build` checkpoint before handing off to the prover phase.

## Overall verdict

Two routes audited, zero CHURNING/STUCK. Both are structurally healthy: the helper #1 route is one prover round into a clearly scoped two-sub-lemma decomposition, and the refactor route is a clean, low-risk statement-alignment task on declarations disjoint from the prover lane's write surface. The planner's proposed iter-113 shape — refactor in plan phase, prover lane on helper #1 in prover phase — is sound. Two priorities for iter-113 execution: (1) the refactor subagent must confirm a clean `lake build` after re-typing before the prover lane starts; (2) the prover lane on helper #1 must produce **closure of at least Sub-lemma A or Sub-lemma B**, not introduce two more sorry-bodied helpers. If iter-113 lands two helpers without closure, iter-114's audit will flip helper #1 to CHURNING with corrective = `mathlib-analogist` on the affine-basis-to-Opens descent (since the recurring-blocker phrase will then have crossed the 3-iter threshold).
