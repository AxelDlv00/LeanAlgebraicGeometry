# Iter-239 plan-agent run

## Headline outcome

The **"group law DONE → open the A.1.c substrate `IsInvertible.pullback`; FlatBaseChange gets its one
post-corrective attempt"** iter. iter-238 landed `picCommGroup` axiom-clean (the ~20-iter group-law
bottleneck CLOSED). The critical path pivots to A.1.c — authoring the relative Picard functor on the
`IsInvertible` carrier. Investigation this iter found the consumer re-base is NOT cheap: its pullback maps
(projection `C×_S T → T`, base-change `g_C`) need `IsInvertible.pullback` for GENERAL morphisms. That is
FEASIBLE via Mathlib `(extendScalars f).Monoidal` (strong-monoidal extension of scalars, verified) +
`sheafificationCompPullback` — Route Y, chosen over the deferred dual-gluing Route X. Two prover lanes
dispatched; the RPF functor re-base itself deferred to next iter (gated on the substrate).

## What I processed (iter-238 outcomes)
- **TensorObjSubstrate.lean: `picCommGroup` + 9 deps DONE** axiom-clean (the by-hand carrier-pivot Picard
  `CommGroup`; step-0 also made `tensorObj_assoc_iso` unconditional). → migrated to task_done; processed
  result cleared.
- **FlatBaseChange.lean: no prover iter-238** (STUCK corrective = blueprint expansion of the
  `D(a)`-transport). The prover re-engages this iter.
- **lean-vs-blueprint ts238 majors** (stale `lem:tensorobj_assoc_iso` title + IsLocallyTrivial-hypothesis
  note + stale `\uses`) — FIXED this iter (plan-agent blueprint edits).
- **blueprint-doctor finding** (malformed `\uses{\leanok …}` in FlatBaseChange) — FIXED (`\leanok`
  relocated to its own line).

## Investigation that drove the decision
- The RPF carrier `Quotient (preimage_subgroup πC πT)` sits on `OnProduct = {M // IsLocallyTrivial M}`
  (LineBundlePullback.lean). The new group `picCommGroup` is on `IsInvertible`. The inverse is free ONLY on
  `IsInvertible`; `IsLocallyTrivial` has no free inverse (that was the whole point of the carrier pivot).
- So an honest RPF group needs EITHER the `IsLocallyTrivial ⟹ IsInvertible` bridge (dual-gluing, deferred
  as hard) OR re-basing `OnProduct` onto `IsInvertible` — which forces `IsInvertible.pullback` (since
  `pullbackAlongProjection`/`functorial` currently use `IsLocallyTrivial.pullback`).
- Probe: `tensorObj_restrict_iso` is open-immersion-only (routes through the lax `pushforward`/
  `restrictScalars`, strong only because an open immersion's ring map is a local iso). But pullback =
  inverse image = extension of scalars is **strong monoidal for ANY ring map** — Mathlib ships
  `(extendScalars f).Monoidal`. So `IsInvertible.pullback` for general morphisms is feasible, and matches
  the Stacks proof of `lemma-pullback-invertible` exactly. → Route Y is tractable; Route X (dual-gluing)
  is the harder deferred path. **Decision: Route Y.**

## Subagents dispatched
| Subagent | Slug | Verdict |
|---|---|---|
| progress-critic | ts239 | **STUCK (FlatBaseChange — 1 post-corrective attempt justified, then route-pivot) / UNCLEAR (IsInvertible.pullback, fresh, backbone confirmed).** Dispatch-sanity OK. |
| strategy-critic | ts239 | **Route Y SOUND** (backbone lemmas verified). 2 must-fix: bridge reclassification (A.2.c) + STRATEGY.md format drift — both addressed. |
| blueprint-writer | invpull | **COMPLETE** — 3 pullback-monoidality blocks (`lem:pullback_tensor_iso/unit_iso/isinvertible_pullback`) + verbatim Stacks quotes. |
| blueprint-clean | ts239 | **PASS** — 1 Lean-leakage strip; all 3 source quotes byte-accurate. |
| blueprint-reviewer | ts239 | **BOTH active-lane chapters CLEAR HARD GATE** (must-fix NONE). |

## Decision made — dispatch the substrate + FlatBaseChange; defer the RPF functor re-base

**Chosen:** TWO prover lanes — (1) `Picard/TensorObjSubstrate.lean` [mathlib-build] = `IsInvertible.pullback`
+ its two component isos (the A.1.c substrate prerequisite); (2) `Cohomology/FlatBaseChange.lean` [prove] =
the ONE justified post-corrective attempt to close `affineBaseChange_pushforward_iso`. The RPF functor
re-base (LineBundlePullback + RelPicFunctor) is DEFERRED to next iter, gated on the substrate landing, and
needs a chapter-rewrite writer pass first.

- **Why the substrate now (not the RPF functor directly):** an RPF prover lane = one file, but the re-base
  spans LineBundlePullback.lean (OnProduct/pullbackAlongProjection) AND RelPicFunctor.lean
  (addCommGroup/functorial/PicSharp), and ALL of it depends on `IsInvertible.pullback`. Building the
  substrate first (bottom-up, USER directive #4) de-risks the whole re-base and keeps each lane to one file.
- **Why FlatBaseChange gets the attempt despite STUCK:** progress-critic ts239 explicitly sanctions exactly
  ONE post-corrective dispatch — the iter-238 blueprint expansion gave the prover the element-free `D(a)`
  recipe it lacked (material new info, not a verbatim re-dispatch). The reversing signal is armed: a 4th
  sorry-flat iter triggers a route pivot, NOT a 5th expansion.
- **LOC/risk:** substrate ≈ 3 isos, backbone Mathlib-verified, Stacks-matched — UNCLEAR but clean (watch
  the ≥3-helper churn marker). FlatBaseChange ≈ the `hloc` discharge via a known recipe.
- **Cheapest reversing signals:** (substrate) ≥3 helpers w/o closing → mathlib-analogist consult on
  `sheafificationCompPullback` carriers; (FlatBaseChange) sorry stays 2 → route pivot.

## Strategy-critic must-fixes — how addressed
1. **Bridge reclassification:** the `IsInvertible ⟺ IsLocallyTrivial` bridge was mislabeled "off critical
   path." Resolved: the FORWARD `IsInvertible ⟹ locally-free-rank-1` (coherence; Stacks
   `lemma-invertible-is-locally-free-rank-1`, the EASY direction) is now classified ON-critical-path at
   A.2.c (Quot embedding), ~1–2 iters, scheduled at A.2.c entry. The REVERSE dual-gluing stays genuinely
   off-path (never needed if the project carries `IsInvertible` throughout). STRATEGY.md + PROGRESS.md
   Standing-deferrals updated.
2. **STRATEGY.md format drift:** stripped all iter-NNN tags (verified 0 remain), deleted the completed
   A.1.c.SubT table row + collapsed its long Routes prose, resolved the cheap/not-cheap self-contradiction,
   added the A.1.c `IsInvertible.pullback` gap + the A.2.c bridge. 144 lines, within budget.

The strategy-critic also noted sub-step (ii) is better framed as "author OnProduct/RPF directly on
`IsInvertible`" (the stubs are dishonest placeholders, not honest code to migrate) — adopted in the
STRATEGY wording and the RPF deferral note.

## Subagent skips
- (none — all four highly-recommended plan-phase subagents dispatched: progress-critic, strategy-critic,
  blueprint-reviewer, plus blueprint-writer + blueprint-clean for the new section.)

## Deferrals recorded (blueprint-reviewer ts239 re-proposals)
- `Picard_CMRegularity`, `Picard_SemiContinuity` — re-deferred, same rationale as ts238 (every `\uses`
  roots at `def:higher_direct_image`, itself deferred; SemiContinuity also needs Hartshorne III §12
  retrieval). Re-open when the higher-direct-image sub-lane opens. Outlines in the ts239 reviewer report.

## Next iter (anticipated)
- If `IsInvertible.pullback` lands: writer pass on `Picard_RelPicFunctor.tex` + `Picard_LineBundlePullback.tex`
  (carrier-pivot rewrite onto `IsInvertible`), then dispatch the RPF re-base (2 files). Repoint
  `thm:rel_pic_addcommgroup_via_tensorobj` `\uses` → `thm:pic_commgroup`.
- If FlatBaseChange stays sorry-flat: route pivot + mathlib-analogist consult (do NOT re-expand the blueprint).
