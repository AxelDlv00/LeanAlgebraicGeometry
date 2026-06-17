# Recommendations — for the iter-209 plan agent

## 1. [CRITICAL — pre-commitment fired] Lane TS Route A is `prove`-mode-blocked. Do NOT autopilot a 5th framing.

The iter-208 plan committed to "Route A" (sectionwise unfolding of
`PresheafOfModules.pullback` along the open immersion, est. ~30–60 LOC) and armed
an explicit reversal pre-commitment. **The prover disproved Route A and the
pre-commitment fired.** `PresheafOfModules.pullback φ.hom = (pushforward φ.hom).leftAdjoint`
is opaque — no sectionwise formula. This is the 4th consecutive TS iter to land
"the foundational input" with a flat critical-path sorry count (iter-205/206/207/208).

**Do NOT re-dispatch TS as "one more reduction step / one more framing" in `prove`
mode.** The genuine closure is documented precisely (the prover's in-code comment
L357–398 + `informal/tensorObj_restrict_iso.md`): two project-side, Mathlib-absent
ingredients, ~200–300 LOC across 4 absent Mathlib lemmas:
- **H1** (~100–150 LOC): presheaf-level `pushforward β.hom ≅ pullback φ.hom` via
  `Adjunction.leftAdjointUniq` from a presheaf-level `pushforward β.hom ⊣ pushforward φ.hom`
  (presheaf analogue of `SheafOfModules.pushforwardPushforwardAdj`; needs presheaf
  `pushforwardNatTrans` + `pushforwardCongr`).
- **H2** (~60–100 LOC): strong-monoidal `(pushforward β.hom).obj (A⊗ₚB) ≅ … ⊗ₚ …`
  via upgrading the file's lax `restrictScalarsLaxMonoidal` to STRONG
  (`Functor.Monoidal.ofLaxMonoidal`), bottoming out in the **absent** lemma
  "`ModuleCat.restrictScalars` along a ring iso is strong monoidal" — a
  self-contained **~30–50 LOC algebra lemma worth building FIRST**.

**The fork (planner decision, NOT a prover round):**
- **(a)** Commit a dedicated `mathlib-build` lane on ingredients (1)–(4), building
  ingredient (4) — the strong-monoidal `restrictScalars`-along-a-ring-iso lemma —
  first as a self-contained, independently-useful spike. This is the
  "mathlib-gradient" response IF the USER directs Mathlib-infra work; it is
  genuinely buildable from current Mathlib (a lift, not an invention).
- **(b)** Pause TS and pivot strategic focus (the pre-commitment's stated `option
  c`). The plan's own top open question (the Quot-engine feasibility spike + the
  RR-free A.2.c excision investigation) is read-only / USER-#4-compliant and would
  make productive use of the iter while TS is parked.

I do not pick for the planner, but note the pre-commitment explicitly named
`option c` (pause) as the consequence of the firing. Run **progress-critic** on TS
before any (a) re-dispatch — it returned STUCK on TS at iter-208 and the corrective
(structural re-route) has now itself bottomed out.

**Dead ends — do NOT retry (carry forward):** abstract mate-δ via
`(pullback φ).Monoidal`; "sectionwise unfold the opaque pullback"; adding
`IsLocallyTrivial`/line-bundle hyps (the comparison map they'd act on does not
exist; iter-206 already disproved the flat/line-bundle pivot).

## 2. [MUST-FIX before any TS re-dispatch] Blueprint `lem:tensorobj_restrict_iso` still asserts the disproven sectionwise route in its main prose.

lean-vs-blueprint-checker ts-iter208
(`task_results/lean-vs-blueprint-checker-ts-iter208.md`) must-fix: the `% NOTE:`
the review agent added covers only the proof block. The **main prose** still
directs a prover into the dead end in FOUR places:
- proof block **Step 3** (~L489–517) and the **closing "30–60 line helper"
  paragraph** (~L529–539) — must-fix;
- the **API survey intro** (~L155–177) and **LOC estimates Piece 2** (~L963–990) —
  major.

Dispatch a **blueprint-writer** on `Picard_TensorObjSubstrate.tex` to rewrite all
four to the H1/H2 decomposition (and update the LOC estimate to ~200–300 LOC /
mathlib-build scale), THEN re-clear the HARD GATE, BEFORE any TS prover round. If
the planner picks fork (b) (pause TS), this can be deferred — but if (a), it is a
hard prerequisite.

Minor (same writer pass, optional): add `\lean{...}` pins for the three
substantive helpers `tensorObjIsoOfIso`, `tensorObj_unit_iso`, `restrictIsoUnitOfLE`;
reconcile `tensorObj_functoriality` `lemma`-vs-`def` wording.

## 3. Cascade-blocked TS sorries — do NOT re-assign.

`exists_tensorObj_inverse` (L442) and `addCommGroup_via_tensorObj` (L481) are
strictly downstream of `tensorObj_restrict_iso`. Both bodies remain `:= sorry`,
honestly labelled. Hold until the blocker lands; assigning them is wasted work.

## 4. Held-lane re-engagement gates (carry forward, unchanged).

- `RelPicFunctor.lean` `PicSharp := const PUnit` + `functorial := 0` dishonest
  placeholders — RPF re-engagement gate (a `refactor` to honest `:= sorry` before
  any RPF prover work). The TS `addCommGroup_via_tensorObj` is the eventual swap-in.
- `IdentityComponent.lean` sanctioned-temporary sorry; `BareScheme.lean` ~L220
  sorry-instance (not load-bearing now). Re-confirm via lean-auditor (see §6).

## 5. Albanese Route 2 — open questions the plan recorded (deferred, USER-#4-gated).

The iter-208 plan committed Route 2 and excised the Route-1 cone, but the
strategy-critic clean208 CHALLENGE left open (all read-only, no prover dispatch
before A.2.c): (1) Quot-engine feasibility spike; (2) second-verify autoduality
RR-free (read EGK Thm 2.1 directly) before any physical file deletion; (3) keep
excision reversible + preserve the valuative-criterion repair sketch; (4) k̄→k
Galois descent re-earn; (5) completion-altitude honesty. These are the natural
read-only work for an iter where TS is paused (fork (b)).

## 6. lean-auditor iter208 findings (44 files audited).

`task_results/lean-auditor-iter208.md`. **Verdict: sound state, 0 NEW must-fix.**

- **TS edit confirmed honest** (the central audit question): the new Step-3
  `(PresheafOfModules.sheafification …).mapIso ?_` at L356 is a GENUINE reduction
  (strips the outer sheafification, converts a sheaf-level goal to the
  presheaf-level iso goal); the L399 sorry is correctly placed INSIDE the opened
  `refine ?_` goal, NOT instead of the step. The L358–398 analysis comment is
  accurate expert analysis (the opaque-pullback + lax-not-strong `restrictScalars`
  finding), NOT comment-laundering. All 3 file sorries honestly labelled.
- **5 PRE-EXISTING held-lane must-fix re-confirmed still-present + honestly
  annotated** (carry forward, do NOT treat as new): RelPicFunctor `PicSharp` L327
  (`const PUnit`), `PicSharp.functorial` L372 (`0`), `addCommGroup` L237–269
  (sorry); IdentityComponent L479 sanctioned sorry; BareScheme L218–220
  `projectiveLineBar_geomIrred` sorry-instance. These remain RPF/IC/BareScheme
  re-engagement gates (see §4).
- **Major (2, both low-urgency, carry forward)**: (1) `RiemannRoch/OcOfD.lean`
  L137–141 — `sheafOf` uses `if D = 0 then concrete else sorry` as its body; the
  `else sorry` silently returns sorry for all `D ≠ 0` (downstream propagation is
  correctly disclosed, but the pattern is a code smell worth a future cleanup to a
  typed-`sorry` def). (2) `BareScheme.lean` L300 — stale "relocated to ChartIso"
  NOTE with no code following; trivial comment removal on a future BareScheme pass.
- **Minor**: unused `[IsAlgClosed]`/`[CharZero]` hyps on `RigidityKbar`
  (route-(c)-dependent); IdentityComponent L615–635
  `isFiniteTypeGeometricallyIrreducible` `refine ⟨?_,?_⟩` closes only
  `LocallyOfFiniteType`, sorrys the conjunction (misleading structure, honest);
  10+ all-sorry scaffold files (methodologically sound).
- **Positive milestones noted**: the RigidityLemma chain is axiom-clean;
  `RelativeSpec.lean` has reached near-total closure (no sorry bodies).

## Reusable patterns discovered this iter.

- **Strip an outer sheafification from an iso goal via `sheafification.mapIso`** —
  reduce a `SheafOfModules`-level iso whose both sides are `sheafification.obj _`
  to the presheaf-level residual (PROJECT_STATUS Proof Patterns, iter-208). Caveat:
  exposes, does not close, the residual; if it's an opaque-pullback base change,
  you hit the abstract-left-adjoint wall.
- **The opaque-abstract-left-adjoint trap, re-confirmed against a "sectionwise"
  framing**: a functor `(rightAdjoint).leftAdjoint` (here `PresheafOfModules.pullback`)
  has no sectionwise formula; any plan that proposes "unfold it sectionwise" is a
  dead end regardless of how concrete the ring map is. Check concrete-vs-abstract
  BEFORE budgeting a sectionwise route (PROJECT_STATUS Known Blockers, iter-206/208).
