# Iter-260 (Archon canonical) — review

## Outcome at a glance
- **The "Sq2b residual falls cheap; the dual lane's route-1 is structurally refuted" iter.** Two
  prover-touched files (both `opus`, mode `prove`).
  - **`Picard/TensorObjSubstrate.lean` (D3′ Sq2b)**: **3 → 2.** `pushforwardComp_lax_μ` CLOSED
    axiom-clean ⇒ its consumer `pullbackComp_δ` (the ~90-line Sq2b mate calculus) is now
    axiom-clean too. **Both verified first-hand by review** (`lean_verify` →
    `{propext, Classical.choice, Quot.sound}`, no `sorryAx`). The full Sq2b ("`pullbackComp` is
    monoidal") obligation is discharged. lean-auditor independently confirmed honesty (no
    laundering). **Genuine critical-path frontier close.**
  - **`Picard/TensorObjSubstrate/DualInverse.lean` (`sliceDualTransport`)**: **2 → 2.** Reduced one
    step (`refine LinearEquiv.toModuleIso ?_`, committed) then determined route-(1) is
    **structurally insufficient** and left a typed `sorry` + the exact failing step — exactly as
    the armed reversing signal instructed. `dual_restrict_iso` naturality transitively blocked.
  - **`Picard/LineBundleCoherence.lean` (engine)**: untouched, transitively axiom-clean. DONE.
- **Builds:** both edited files green (prover-verified; the two closes re-verified by review).
- **`sync_leanok`** iter=260, sha `ea9efd91`, **+17 / −0** (`Picard_RelPicFunctor.tex`,
  `Picard_TensorObjSubstrate.tex`) — deterministic verdict after the Sq2b closes; not laundering.

## Plan-vs-actual divergence (process note, benign)
The iter-260 plan recorded **D3′ as HELD** (race avoidance: `DualInverse.lean` imports
`TensorObjSubstrate.lean`) with DualInverse as the *sole* lane, deferring `pushforwardComp_lax_μ` to
iter-261 with a prepared analogist recipe. In fact the prover phase worked **both** files and closed
the held one. The feared cross-lane compile race did **not** materialise — because the DualInverse
prover's failure is *structural* (route-1 has no dual content), so it never needed to consume the
in-flight TensorObjSubstrate edits, and TensorObjSubstrate closed cleanly. Outcome strictly positive;
the divergence cost nothing. (Mirrors, inverted, the iter-258 "ghost run" — there a dispatched lane
produced nothing; here a held lane produced the iter's best result.)

## The defining finding — a 3-iter difficulty estimate was wrong in BOTH directions
`pushforwardComp_lax_μ` carried two contradictory mis-estimates: iter-259 called it "~150-LOC
`extendScalarsComp` change-of-rings coherence"; the d3sq2b258 recipe predicted "rfl/short-ext". The
truth is between and to the side of both: **not `rfl`** (the d3sq2b258 prediction was rightly
refuted again), but **not change-of-rings either** — a short sectionwise pure-tensor collapse on two
`rfl`-foundations (`pushforward_μ_eq`: the pushforward μ reduces *definitionally* to the lighter
`restrictScalars` μ on strongly-monoidal `pushforward₀` objects; `restrictScalars_μ_app`), after
which `ModuleCat.restrictScalars_μ_tmul` kills every pure tensor. No `extendScalarsComp` anywhere.
The genuine engineering cost was the **whnf-wall** (direct `rw`/`erw`/`simp` of the Mathlib lemma
explodes >200k heartbeats even at 2M) — solved by atom-helpers instantiated with the heavy objects
as explicit args + `erw [have]`, and pinning `forget₂`-association implicits to defeat silent HO
no-match.

## The honest counterweight — the dual lane is now blocked on a planner decision + a blueprint that lies
This is real forward motion (a critical-path close), but the dual half ends the iter **blocked**, and
the block is compounded by a blueprint that now misdescribes the genuine route:
- **Route-(1) is dead** (`sliceDualTransport` cannot consume `restrictOverIso`/`unitOverIso` — they
  carry no `dual`/internal-hom content; the goal needs the avoided `MonoidalClosed`). Confirmed by
  the prover AND lvb-di260. The realistic close is **route-(2)** (~150–250 LOC sectionwise, leg A
  reindexing ∘ leg B `restrictScalarsRingIsoDualEquiv`), not decomposable into independent compiling
  pieces — needs explicit planner sanction + a dedicated multi-iter budget.
- **lvb-di260 raised 2 must-fix-this-iter**: the chapter's `dual_restrict_iso` proof sketch still
  describes route-(1) (structurally impossible), and the `\uses` DAG wires route-(1) tools in. A
  blueprint-writer must rewrite to route-(2) + remove the stale edges **before** any DualInverse
  re-dispatch. Review placed `% NOTE:` flags at all three sites; the rewrite is the plan agent's job.

## Subagent outcomes (full reports in logs/iter-260/)
- **lean-auditor aud260**: 0 must-fix; both closes honest, all `set_option`/`maxHeartbeats` scoped.
  3 major + 3 minor — **all stale `.lean` comments** (wrong sorry count in TensorObjSubstrate header;
  obsolete "left for the follow-up" inside the complete `pullbackComp_δ`; 2-iter-stale DualInverse
  header). Review can't edit `.lean` → folded into recommendations for the owning prover.
- **lvb-tos260**: 0 must-fix, 2 major blueprint staleness (wrong Sq2b primitives; Sq2b still in the
  "missing" list) → both `% NOTE:`-flagged this review.
- **lvb-di260**: 2 must-fix + 1 major (route-1 sketch impossible; stale `\uses`; `sliceDualTransport`
  needs a `\lean{}` block) → `% NOTE:`-flagged + escalated to recommendations.

## Subagent skips
- (none — all review-phase recommended subagents dispatched: lean-auditor + lean-vs-blueprint-checker
  ×2 prover-touched files.)

## Markers updated (manual)
3 `% NOTE:` added to `Picard_TensorObjSubstrate.tex` (Sq2b proof primitives; "missing ingredients"
list; `dual_restrict_iso` route-1→route-2 + stale `\uses`). No `\mathlibok`, no `\lean{}` rename, no
`\notready` change.

## Net critical-path position
- A.1.c.fun: Sq2b CLOSED → `pullbackTensorMap_restrict` reduced to Sq1 + Sq4 only.
- A.1.c.sub: dual chain blocked at `sliceDualTransport`, route-(2) pending sanction. A.1.c.sub is
  OVER-BUDGET (~24 iters vs ~10–16 est.) and the dual chain did not land — the plan agent's own
  trigger fires: do the STRATEGY.md re-estimate next iter.
- A.2.c engine: DONE.
