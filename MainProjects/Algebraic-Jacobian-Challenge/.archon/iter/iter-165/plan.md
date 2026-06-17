# Iter-165 plan-agent run

## Headline outcome

**Depth conversion iter: idiom-aligned scaffold of the genus-0 base objects.** iter-164 cleared the
HARD GATE for the genus-0 base case (𝔾_m-scaling shortcut, Cor 1.5 + density) and surfaced an
explicit progress-critic watch item: **iter-165 MUST convert to depth — infra scaffold or a real
prover lane — not a 2nd cosmetic round.** This iter answers the watch item by:

1. Dispatching mathlib-analogist `gm-scaling-p1` proactively (BEFORE the scaffold ships) to choose
   the Mathlib idiom for `ProjectiveLineBar` / `Ga` / `Gm` / `gmScalingP1`. Four ALIGN_WITH_MATHLIB
   verdicts came back, with concrete Mathlib citations for every piece.
2. Extending the `% archon:covers` declaration of `AbelianVarietyRigidity.tex` to include the new
   file `Genus0BaseObjects.lean` (the chapter already contains the math via `def:genus0_base_objects`
   + `def:gaTranslationP1`, both cleared by the iter-164 `blueprint-reviewer avr-fastpath2` HARD
   GATE).
3. Setting iter-165's prover lane to a single-file **NEW-file file-skeleton dispatch** of
   `AlgebraicJacobian/Genus0BaseObjects.lean` per the analogist's chosen API: `Proj`-based ℙ¹,
   `GrpObj.ofRepresentableBy` for `Gm`/`Ga`, bare `gmScalingP1` glued via `Scheme.Cover.glueMorphisms`,
   `Smooth` derived FREE from `smooth_of_grpObj_of_isAlgClosed`. Deferring the AVR import + signature
   refactor + proof close to iter-166.

The iter-164 progress-critic watch item is satisfied: ≥3 of 4 defs landing this iter (best case all
4 + `gmScalingP1_collapse_at_zero` lemma) is "defs landed" in the bivalent gate, so iter-166 cannot
flip to CHURNING on the iter-165 evidence. The AVR refactor + proof close — the "B" half of the
critic's preferred-but-rejected single-iter (A)+(B) lane — is deferred to iter-166 by design (it
needs clean signatures from the scaffold first; see "Decision made" below).

## Decision made (file split + lane count)

**Adopt the file split into `AlgebraicJacobian/Genus0BaseObjects.lean` (NEW) + later AVR refactor
(iter-166); dispatch ONE prover lane this iter on the new file, NOT two parallel lanes.**

The analogist's D4 verdict (split into a focused new file mirroring `Mathlib.AlgebraicGeometry.Group.{Abelian,Smooth}`)
is sound: AVR.lean is already 992 lines and ~150–400 LOC of new scheme infrastructure inlined would
make both the rigidity proofs and the new infra harder to read and harder to upstream later. So the
file split is the right LOC/risk trade-off.

Lane count: I considered two options:

- (a) **ONE lane on `Genus0BaseObjects.lean` (chosen).** The scaffold is the depth conversion;
  iter-166 picks up the AVR refactor + proof close with full signatures known. Sequential within
  the iter-arc, parallel-free.
- (b) **TWO parallel lanes (`Genus0BaseObjects.lean` + `AbelianVarietyRigidity.lean`).** Downstream
  (AVR) lane attempts the refactor and proof body via the new defs. Higher reward (one-iter close
  of the headline `morphism_P1_to_grpScheme_const`) but higher risk: AVR's success depends on Lane
  1's exact instance/signature shape; if the scaffold trips on, say, `GrpObj.ofRepresentableBy`'s
  representable-by witness, AVR's lane fails on instance synthesis and the whole iter ships PARTIAL
  on both.

I chose (a). The progress-critic explicitly addressed this question (without yet knowing the
analogist would recommend a file split) and concluded "1 lane is the right count" with sequential
work within the iter. The split-file world re-reads as: ONE lane this iter (the scaffold), one
lane next iter (the AVR refactor + proof). The risk side: a deferred AVR lane is not "no progress"
because the critic's bivalent gate is `defs landed OR body started` — defs landing alone clears it.
The reward side: a clean signature-stable scaffold makes iter-166's AVR proof a focused single-shot
rather than a thrash over instance synthesis cross-pollution.

**Cheapest reversal signal:** if iter-165's scaffold ships with ≥2 of the 4 main defs failing
instance synthesis (Mathlib idiom doesn't plug in as the analogist predicted), the next iter's
plan agent should re-dispatch mathlib-analogist (cross-domain mode this time) on the failing piece,
not re-attempt with the same idiom. Watch for `GrpObj.ofRepresentableBy` synthesis failures — that
is the most novel Mathlib API in the recipe; the rest are direct citations.

## Prior critique status

- **progress-critic `routec` iter-164 watch item "iter-165 MUST convert to depth"** — ADDRESSED this
  iter: dispatching a NEW-file infra-scaffold lane is the depth conversion the watch item demands.
  The lane is one file (1 prover), not a hygiene round. The bivalent gate (`defs landed OR body
  started`) is met by the "defs landed" branch — and the iter-166 plan dispatches the AVR refactor
  + proof close (the "body started" branch) immediately after.
- **mathlib-analogist `gm-scaling-p1` 4 ALIGN_WITH_MATHLIB verdicts** — ABSORBED into the
  iter-165 PROGRESS.md prover directive. The directive cites every Mathlib path the analogist
  recommended (Proj.toSpecZero, AffineSpace.homOverEquiv, GrpObj.ofRepresentableBy,
  Scheme.Cover.glueMorphisms, smooth_of_grpObj_of_isAlgClosed) so the prover can land the
  Mathlib-aligned code, not a parallel API.

## Subagent verdicts (absorbed)

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| progress-critic | routec | **CONVERGING** — Route C closing on the chain phase; base-case sub-phase opens iter-165; iter-165 1-lane scaffold is correct shape; iter-166 watch item: scaffold + body started or flips CHURNING | iter-165 lane = single scaffold lane per the critic's "1 lane is right" judgment; iter-166 plan immediately picks up the AVR refactor to clear the iter-166 watch tripwire. |
| mathlib-analogist | gm-scaling-p1 | **ALIGN_WITH_MATHLIB × 4** (Proj for ℙ¹; GrpObj.ofRepresentableBy for Gm/Ga; Spec k̄[t,t⁻¹] for Gm not basic-open; bare morphism + glueMorphisms for σ_× not typeclass; split to new file) | iter-165 PROGRESS directive cites every recommended Mathlib path. `analogies/gm-scaling-p1.md` carries the full design rationale + citations. |

## Subagent skips

- **strategy-critic** — STRATEGY.md is unchanged since iter-164's verbatim content (the only material
  change this iter is a tactical Mathlib-idiom selection for the scaffold, not a strategic
  modification: route still Route C, base case still 𝔾_m-scaling shortcut, same Iters-left
  estimate, same Mathlib gaps). iter-164's strategy-critic verdict was SOUND with no live
  CHALLENGE/REJECT (`basecase-reopen` CHALLENGE was addressed in-iter). Skip conditions met.
- **blueprint-reviewer** — `AbelianVarietyRigidity.tex` (the consolidated chapter that now covers
  both AVR.lean AND the new Genus0BaseObjects.lean via the `% archon:covers` extension) was
  HARD-GATE cleared in iter-164 (`blueprint-reviewer avr-fastpath2`). The iter-165 edit was a
  one-line `covers:` extension only — no math content changed, no `\lean{}` blocks touched, no
  proof sketches added. The two new `def:genus0_base_objects` + `def:gaTranslationP1` blocks that
  back the new file already existed in the chapter and were verified iter-164. The other chapters
  with stale-narrative debt (per the iter-164 lean-auditor 5 majors: Cotangent/GrpObj,
  Cotangent/ChartAlgebra, RigidityKbar, Jacobian) are NOT in this iter's prover scope and don't
  affect any active file's gate. Skip conditions met.

## Prover lane this iter

ONE lane on the NEW file `AlgebraicJacobian/Genus0BaseObjects.lean`. Scaffold per the analogist's
4 ALIGN verdicts. The full per-decision directive lives in `PROGRESS.md` `## Current Objectives` and
in `iter/iter-165/objectives.md`. Acceptable outcomes:
- **COMPLETE**: all 4 main defs + their primary instances + `gmScalingP1_collapse_at_zero` lemma
  land. Iter-166 picks up AVR refactor cleanly.
- **PARTIAL**: ≥3 of 4 defs land with primary instances; some instance synthesis (most likely
  `GrpObj.ofRepresentableBy`'s functor field) trips. Iter-166 hardens the failing instance, then
  resumes AVR.
- **INCOMPLETE** (failure to flag): <3 defs land. Triggers iter-166 plan-agent re-dispatch of
  mathlib-analogist on the failing piece (likely cross-domain mode for an analogous representable-by
  installer in another Mathlib domain).

## Open observations (informational, not driving this iter)

- **Lean-auditor `iter164` 5 stale-narrative majors** (`Cotangent/GrpObj.lean:297-327`,
  `Cotangent/GrpObj.lean:428-525`, `Cotangent/ChartAlgebra.lean:36-79`,
  `RigidityKbar.lean:20-29/70-74`, `Jacobian.lean:237-263`) are all on fallback-route files whose
  Lean code is axiom-clean; only the framing comments lag the iter-156 route pivot. Listed as
  off-limits this iter (depth-conversion takes priority over hygiene) and deferred to a future
  hygiene iter when no critical-path lane is open. The infra `\leanok` bug reported in
  iter-164's `.debug-feedback` is still outstanding — out of plan-agent scope; surfaced via the
  prior iter sidecar.
- **`Jacobian.tex` re-audit** was listed in iter-164's "Next iter" provisional but is deferred: the
  AVR.tex chapter cleared iter-164 and the Jacobian.tex stale gate analysis (lean-auditor major
  iter164) is inside a `genusZeroWitness.key` `sorry` body and doesn't gate any active prover
  lane. A blueprint-reviewer dispatch this iter on Jacobian.tex alone would burn a cycle for no
  active gain; deferring to the post-iter-166 AVR-refactor wave when `Jacobian.lean` itself
  becomes a live prover lane.
