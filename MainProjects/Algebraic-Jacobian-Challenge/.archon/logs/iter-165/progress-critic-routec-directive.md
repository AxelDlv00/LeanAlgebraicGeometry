# Progress Critic Directive

## Slug
routec

## Iteration
165

## Active route(s)

### Route C — genus-0 rigidity (`AlgebraicJacobian/AbelianVarietyRigidity.lean`)

This is the only active route this iter. Route A (positive-genus FGA engine,
`positiveGenusWitness` in `Jacobian.lean`) is off-critical-path and not yet
blueprinted to prover-ready detail; iter-165 is not assigning provers to it.
The fallback `RigidityKbar.lean` `rigidity_over_kbar` (`[CharZero]`) is an
artifact, not active.

#### Strategy's current estimate (verbatim from STRATEGY.md `## Phases & estimations`)
- **Iters left**: `~10–18`
- **LOC remaining · realized/it**: `~2000–4000 · chain+Cor done, base-case 0/it`
- **Phase entered current state**: the route entered its current phase in
  iter-156 (post the iter-155 ChartAlgebraS3 deletion and the route (c) commit);
  the *base case* concrete `𝔾_m`-scaling shortcut sub-phase was committed
  iter-164.

#### Last K=5 iters' signals (iters 160–164)

Sorry counts on `AbelianVarietyRigidity.lean` (from PROGRESS.md per-iter snapshots
+ task_done.md closures):

| Iter | AVR.lean sorries | Net helpers added | Prover status (AVR) | Recurring blocker phrase |
|---|---|---|---|---|
| 160 | 1 (Step-1 residual) | +2 chain bridges (`morphism_eq_of_eqAt_closedPoints`, `eq_comp_of_isAffine_of_properIntegral` in progress) + signature-gap refactor `[LocallyOfFiniteType]` | COMPLETE (Step-2 proven; sig gap surfaced) | "the sig gap" |
| 161 | 1 (Step-1 residual) | +2 closures (`JacobsonSpace` discharge, `eq_comp_of_isAffine_of_properIntegral` proven) | PARTIAL (deep Step-1 still open, but algebraic core landed) | "Step-1 retract assembly" |
| 162 | 0 (chain CLOSED) + 3 scaffolds | +1 new helper (`isIntegral_of_retract`) + Step-1 closure (`rigidity_eqAt_closedPoint_of_proper_into_affine`) | COMPLETE (chain fully closed, axiom-clean) | none — chain done |
| 163 | 0 + 3 scaffolds | +2 corollaries (`hom_additive_decomp_of_rigidity` = Milne Cor 1.5; `av_regularMap_isHom_of_zero` = Milne Cor 1.2) | COMPLETE (both axiom-clean) | none |
| 164 | 0 + 3 scaffolds | 0 (HYGIENE iter: stale-docstring refresh + dropped 4 unused instance hyps on Cor 1.5 / Cor 1.2 — sound generalization) | COMPLETE (hygiene; no body changes) | "iter-165 MUST convert to depth" |

#### Currently-open sorries (`grep ^\s*sorry\s*$` on AVR.lean)
- L936  `morphism_P1_to_grpScheme_const`  — body deferred pending concrete ℙ¹/𝔾_m/σ_× infra (`ProjectiveLineBar`/`Gm`/`gmScalingP1` not yet defined)
- L960  `genusZero_curve_iso_P1`           — body deferred pending the genus-0 ⟹ ℙ¹ RR sub-build (Hartshorne IV.1.3.5; no Mathlib RR)
- L989  `rigidity_genus0_curve_to_grpScheme` — headline, downstream of the two above

#### Pre-iter-164 misconception correction
The base-case route was thought (iters 156–163) to need Milne Thm 3.2 / theorem
of the cube / Auslander–Buchsbaum / `Hom(𝔾_a, A) = 0`. iter-164 RESOLVED that
as illusory circularity (strategy-critic `basecase-reopen` CHALLENGE) and
adopted the 𝔾_m-scaling shortcut (blueprint-writer `basecase-4throute`
Finding 2). All of those alternatives are now off the genus-0 critical path.

#### Iter-164 progress-critic's tripwire (open for iter-165)
The prior progress-critic verdict was **CONVERGING** with an explicit watch
item: **"iter-165 MUST convert to depth — infra scaffold or a real prover lane —
not a 2nd cosmetic round."** Iter-165 is the consumed-budget iter.

## Planner's PROGRESS.md `## Current Objectives` proposal for iter-165

File count: **1** prover lane (+ a parallel mathlib-analogist consult dispatched
separately in this plan phase — `gm-scaling-p1`, BEFORE the prover lane).

1. **`AlgebraicJacobian/AbelianVarietyRigidity.lean`** — **file-skeleton +
   first-proof depth lane** (the iter-164 watch item's depth-conversion).
   Two-part directive, sequential within the one prover:
   - **(A) Scaffold the three new defs** `ProjectiveLineBar`, `Gm`,
     `gmScalingP1` (and `Ga`/`gaTranslationP1` for the alternative companion)
     into AVR.lean (or a sibling file if mathlib-analogist recommends),
     aligned to the Mathlib idiom mathlib-analogist returned. Bodies =
     `sorry` where the proof of an instance / lemma is non-trivial; full
     concrete bodies where Mathlib gives them for free (e.g. via `Proj`).
     This is a deliberate file-skeleton dispatch: a half-built scaffold landed
     this iter unblocks the *real proof* of `morphism_P1_to_grpScheme_const` in
     iter-166. The agent count is 1 lane, not 3, because the three objects are
     tightly coupled (their typeclass + `GrpObj` instances cross-reference).
   - **(B) Specialise + (attempt to) prove `morphism_P1_to_grpScheme_const`.**
     Refine its current abstract-`P1`-proxy signature to the concrete
     `ProjectiveLineBar`/`Gm`/`gmScalingP1` triple, then close via the proven
     Cor 1.5 + `ext_of_eqOnOpen` recipe described in the blueprint
     `prop:morphism_P1_to_AV_constant` proof body. PARTIAL is fine if (A)
     leaves typeclass-synthesis gaps the agent can't close this iter.

## Dispatch-sanity considerations (please assess)

- Is **1 lane** the right count this iter? The alternative is splitting (A) and
  (B) across two iters (scaffold this iter, prove next iter); the rationale for
  one lane is that the prover keeps file context warm and the (B) attempt
  surfaces any (A) signature problems immediately, rather than discovering them
  next iter.
- The prior iter (164) was hygiene-only (no sorry-count change). The iter
  before that (163) added 2 new theorems. The pattern across the last 5 iters
  is: 2 + 2 + 1 + 2 + 0 net new closed top-level theorems. The current proposal
  asks for ~3 new defs landed + ~1 sorry closed. Is the per-iter ambition
  realistic?
- Does the **`iter-165 MUST convert to depth`** watch item from your prior
  verdict cleanly map onto "scaffold + prove the headline base case" as the
  depth conversion? (My read: yes — the scaffolding *is* the gating depth, and
  attempting the proof in the same lane respects the warning's spirit. Please
  challenge if you disagree.)
