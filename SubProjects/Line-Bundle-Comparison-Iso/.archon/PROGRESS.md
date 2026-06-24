# Project Progress

## Current Stage

prover

## Stages
- [x] init
- [x] autoformalize
- [ ] prover
- [ ] polish

## End-state overview

**Zero inline `sorry` in the dependency cone of the three seed declarations + kernel-only
axioms**, for the **Line-Bundle Comparison Iso** subproject (A.1.c.sub). Seeds:
`lem:pullback_tensor_iso_loctriv` (seed-1, D4′ — DELIVERED iter-042),
`lem:dual_isLocallyTrivial` (seed-2, DUAL — DELIVERED),
`thm:rel_pic_addcommgroup_via_tensorobj` (seed-3, consumer; gated on terminal).

## Build state (iter-073 plan turn)

- **iter-072 was a COMPLETE NO-OP** (`logs/iter-072/meta.json`: `planValidate = failed_all_noop`,
  `objectivesDispatched: 0`). The sole objective (`SliceTransport.lean`) was DROPPED because the file
  is sorry-free and its header said "**ADD** the forward apply lemma" — `ADD` is NOT a recognized
  validator scaffold keyword (`scaffold|skeleton|stub out|declarations for|does not exist`). No prover
  ran, no Lean changed, no review happened. Forward `sliceDualTransport_app_apply` STILL does not
  exist (only the inverse at SliceTransport.lean:563, `:= rfl`).
- **Main tree `lake build` GREEN-mod-sorry** (iter-071 prover verified `…PresheafDualPullback` EXIT 0,
  8324 jobs; no Lean touched since — build still green). Terminal `TensorObjInverse.lean`
  carries 4 `sorry`: S3, S4a, bridge-(b) `sheafificationCompPullback_restrict`, telescope. Sibling
  `PresheafDualPullback.lean` carries 3 `sorry`: c.2 `presheafDualPullbackComparison_restrict` (L764)
  + 2 OFF-path abandoned (L377, L434; deferred). Upstream `SliceTransport.lean` is **sorry-free**.
- **iter-071 BREAKTHROUGH (supersedes the iter-070 framing): c.2 FACTORS CLEANLY.** The iter-071 prover
  DISPROVED the 4-iter-old "interleaved two-immersion merge that does NOT factor" picture. c.2 reduces by
  pure category/naturality algebra to a SINGLE isolated residual identity (∗∗) via ONE ordinary
  `NatTrans` naturality of `H1_h.hom` at `θ_f.hom`: left-mult by `H1_{h≫f}.hom` + the `pushforwardComp`
  counit `FC.hom`, substitute cocycle (a) `presheafDualH1Cocycle` (CLOSED), cancel `pbComp`, slide
  `H1_h.hom`, collapse two `hom_inv_id`s. **(∗∗)** `FC.hom.app dM ; sDT_{h≫f} = pushβ_h.map(sDT_f) ;
  sDT_h(M|f) ; dualIsoOfIso(rfc).hom` is the SOLE genuine residual — the pushforward-flank
  `sliceDualTransport` pseudofunctoriality. Verified in code: the 3 `let`-transparent adjunctions + `have
  hcoc := presheafDualH1Cocycle …` instantiate cleanly (build EXIT 0).
- **TWO named blockers to close c.2 (both off the iter-071 tactic-depth):** (1) the abstract H1-cancel
  tail whnf-BOMBS across the `≫` seam under `rw`/`erw`/`cancel_epi`/`set`/`show` (lake-confirmed) — cure =
  local copies of the generic single-`[Category C]` bricks `comp_cancel_mid`/`comp_slide_nested`/
  `comp_cancel_three_lr` applied by `exact`/`refine` (they exist `private` at TensorObjSubstrate.lean:2981+);
  (2) (∗∗) needs a **FORWARD** `sliceDualTransport_app_apply` lemma in `SliceTransport.lean` — only the
  INVERSE `sliceDualTransportInv_app_apply` (`:= rfl`, L563) exists. The forward apply is in a DIFFERENT
  (upstream, sorry-free) file → this iter's lane.
- **Cone A DONE iter-065; Cone B crux DONE iter-066; c.1 + (a) DONE.** Root + `DualInverse/*` GREEN.

## iter-073 — RE-DISPATCH iter-072's never-run work (scaffold-keyword fix)

iter-072's plan was correct and progress-critic-endorsed, but plan-validate dropped its sole objective
as a no-op: SliceTransport.lean is sorry-free and the header said "ADD …", which is NOT a recognized
scaffold keyword. So the forward apply lemma was never built. iter-073 re-dispatches the SAME objective
with a recognized keyword on the filename line ("Scaffold-and-prove … (does not exist yet)"). This is
NOT a 6th grind — it is iter-072's intended (and never-executed) de-risk probe, run correctly.

- **Blueprint state (carried, unchanged — no chapter edited since iter-072 since no prover ran):**
  `Picard_TensorObjSubstrate.tex` HARD GATE CLEARED iter-072 (complete:true / correct:true / 0 must-fix);
  block `lem:slice_dual_transport_app_apply` (L5933) is a faithful forward mirror of the proven inverse;
  c.2 proof already rewritten to the clean factorisation; deleted-block left 0 dangling refs.
- **Subagent skips (all three mandatory, rationale in iter/iter-073/plan.md):** blueprint-reviewer
  (gate cleared, no chapter touched since); progress-critic (iter-072 ran no prover phase — no new
  trajectory data; iter-072 critic already endorsed this exact pivot); strategy-critic (STRATEGY.md
  SHA-unchanged; single forced route, no fork to challenge).

## Decision (iter-073) — SOLO `mathlib-build` lane on `SliceTransport.lean`, scaffold-keyword header

- **Chosen:** one prover, **`mathlib-build`** mode, on `SliceTransport.lean`; objective header carries a
  recognized scaffold keyword so plan-validate does not drop it (the iter-072 trap fix). `mathlib-build`
  = build+prove the lemma fully, no sorry in output — correct for a NEW single atomic lemma (not `prove`:
  no stub; not `fine-grained`: one atom).
- **Why SOLO, not the 2-file co-dispatch the critic floated (MILD_UNDER_DISPATCH):** the forward lemma
  is the explicit DE-RISK PROBE. If it does NOT land as clean `:= rfl` (the trip-wire case), a
  co-dispatched PresheafDualPullback c.2 lane burns its whole budget grinding the whnf-seam against a
  missing lemma — the 6th grind the trip-wire forbids. Confirm the probe green THIS iter, co-dispatch
  the c.2 close NEXT iter with full confidence. Also: `SliceTransport → DualInverse → PresheafDualPullback`
  is one import chain; parallel co-dispatch risks the ARCHON_MEMORY iter-029 build race. Bounded 1-iter
  latency ≪ wasted-lane + race risk.
- **High confidence it lands:** forward def `sliceDualTransport` (L635) has `toFun := fun φ => { app :=
  fun W => … }` (L722-724), so `.app W` reduces definitionally exactly as the proven inverse `_app_apply`
  (L563-577, `:= rfl`) does.

## Current Objectives

1. **`AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/SliceTransport.lean`** — scaffold the forward apply declaration (it does not exist yet) and prove it; SOLO `mathlib-build` lane.
   This is a sorry-free file; the objective ADDS one NEW declaration `sliceDualTransport_app_apply` and
   proves it fully (no sorry in output). Blueprint: `chapters/Picard_TensorObjSubstrate.tex` (consolidated;
   `% archon:covers` this file; HARD GATE CLEARED iter-072, block `lem:slice_dual_transport_app_apply`).
   - **Add and prove `sliceDualTransport_app_apply`** — the FORWARD mirror of the existing proven inverse
     `sliceDualTransportInv_app_apply` (L563–585, body `:= rfl`). State it as the `app`-component of the
     forward `sliceDualTransport f M V` (def at L635) evaluated at a dual section `φ`, equal to its
     explicit forward-transport formula (the `dualUnitRingSwapHom`/`unitRelabelSwap` reindex conjugated by
     `appIso`), with the leg reductions definitional. **Read the inverse apply lemma L563–585 and the
     forward def L635 first** and mirror the shape — it is expected to close by `rfl` once the down-set
     proofs are supplied (the inverse does). The blueprint block `lem:slice_dual_transport_app_apply`
     (Picard_TensorObjSubstrate.tex:5933) gives the statement and `\uses`.
   - **TRIP-WIRE:** if the forward apply lemma does NOT close as a clean `rfl`/short mirror — if it needs
     real new machinery or whnf-bombs — STOP and report the exact residual goal. Do NOT improvise
     un-anchored content; do NOT grind. (Per progress-critic: a hard outcome here is the escalation
     signal, not a cue to keep grinding.)
   - **AUTHORITATIVE = `lake build AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse.SliceTransport`
     EXIT 0, NOT LSP** (ARCHON_MEMORY stale-green hazard). The file is currently sorry-free — keep it that
     way (mathlib-build = no sorry in output; either the lemma is fully proved or it is absent + reported).
   - **Reference-driven:** internal categorical construction (Stacks Modules ch.17 tag 01CR internal-hom
     base-change is the statement anchor); the proof is the forward dual of the proven `:= rfl` inverse
     apply lemma in the same file. No external proof content to improvise.
   [prover-mode: mathlib-build]

## Deferred this iter (NOT prover objectives)

- **PresheafDualPullback.lean c.2 brick-tail close** — NEXT iter, once `sliceDualTransport_app_apply`
  lands green this iter. Plan: add LOCAL copies of the generic `[Category C]` bricks `comp_cancel_mid`/
  `comp_slide_nested`/`comp_cancel_three_lr` (`private` at TensorObjSubstrate.lean:2981+; copy ~6 lines
  each), run the verified iter-071 6-step reduction via `exact`/`refine` of those bricks (NEVER
  `rw`/`erw`/`cancel_epi`/`set`/`show` across the seam), and close the sole residual (∗∗) via the now-
  available forward apply lemma (eval-extensionality route, dual of the inverse). **iter-071-review
  TRIP-WIRE carries forward:** if the brick-`exact` tail ALSO whnf-bombs, escalate (raise maxHeartbeats /
  restructure) — do not grind further. Fold the iter-070 auditor hygiene fixes (L274 stale comment, L670
  `respectTransparency` comment, L671 `maxHeartbeats` style comment, L669 stale `DRAFT` label) into that lane.
- **TensorObjInverse.lean bridge-(b) `sheafificationCompPullback_restrict` (one-liner, Sq1 public) +
  S3/S4a assembly + telescope** — once c.2 lands. S3 assembles from dual-B1 + B2 + bridge-(b)
  + c.1 + c.2; S4a rides on S3 + bridge-(b) + `presheafDualUnitIso_naturality`; telescope wires all 5
  squares. Deferred this iter to avoid the build race with the `PresheafDualPullback` c.2 lane
  (TensorObjInverse imports it). Also clean the now-STALE in-code comments in `TensorObjInverse.lean`
  claiming Sq1 is still `private` (reviewer-flagged) when that lane runs.
- **2 off-path sorries in `PresheafDualPullback.lean`** (L377 L1 / L434 L3a) — cross-file-blocked,
  UPSTREAM; defer to post-terminal cleanup (likely DELETE — checker-confirmed no other `.lean`
  references them).
- **Consumer seed-3 `PicSharp.addCommGroup_via_tensorObj` (`RelPicFunctor.lean`)** — gated on terminal.
- **Blueprint hygiene (review-phase):** 3 isolated `\mathlibok` localization anchors (reviewer-flagged,
  wire via `\uses` or fold) + the 3 exposition sub-lemmas showing as false leandag frontier nodes.
- **Coverage / file-split debt:** ~118 isolated `lean_aux` nodes; `TensorObjSubstrate.lean` (>3600 LOC)
  split — scheduled cleanup phase after the terminal lands (STRATEGY phase owns it).
- **Extraction note:** module names / paths / labels unchanged from the parent for clean merge-back.
