# Iter-180 plan-agent run

## Headline outcome

**The "armed iter-181 RETIRE-OR-ESCALATE trigger fires EARLY at iter-180 +
Mathlib-aligned canonical fix found + 8 prover lanes scheduled to address
UNDER_DISPATCH" iter.**

iter-179 returned `lake build` GREEN; the cover-bridge `refactor` lane
landed Step 1+2 of the iter-178 cover-bridge recipe; Lane A executed
the recipe but stuck on Step 3.1's `pullbackSpecIso_hom_base` rewrite
(diagnosed in the Lane A task_result as the `Algebra.compHom`-chain-driven
defeq heartbeat sink). Per the iter-179 Lane A reversal trigger and the
strategy's iter-181 RETIRE-OR-ESCALATE schedule, iter-180 fires the
escalation EARLY.

iter-180 plan-phase actions:

1. **TWO `[HIGHLY RECOMMENDED]` critics dispatched plan-phase**:
   - **progress-critic** `route180` — verdict: 5 routes STUCK/CHURNING
     (Routes 1, 3c, 3d, 3e, 4c, 5), 4 routes CONVERGING (2, 3a, 3b, 4a,
     4b), 1 UNCLEAR (6). Dispatch finding: **UNDER_DISPATCH** — at least
     4 files with iter-179 momentum were absent from the planner's
     proposal (RelativeSpec, RationalCurveIso, Thm32, plus one of
     AuslanderBuchsbaum/CodimOneExtension). Must-fix-this-iter: fill
     ready lanes.
   - **strategy-critic**: SKIPPED — STRATEGY.md SHA-equal to iter-179
     close, last verdict SOUND with no live CHALLENGE (iter-178
     CHALLENGEs addressed iter-178). iter-181 re-dispatch scheduled.
   - **blueprint-reviewer**: SKIPPED — only `sync_leanok` marker edits +
     1 `\lean{...}` correction (CodimOneExtension) since iter-177 HARD
     GATE clear; no chapter under blueprint/src/chapters/ has had prose
     edited since the prior verdict; all chapters under active prover
     work carry `complete: true correct: true`; no must-fix-this-iter
     finding remains live.

2. **ONE plan-phase `mathlib-analogist` consult** —
   `pullbackspeciso-bypass`. Verdict: **ALIGN_WITH_MATHLIB** on
   Decision 4 (`set_option backward.isDefEq.respectTransparency false`).
   The fix is the canonical Mathlib idiom for the
   `Algebra.compHom`-chain-driven defeq sink; Mathlib's
   `Normalization.lean`, `pullback.congrHom_inv`, `pullback.map_isIso`
   and ~14 RingTheory/TensorProduct sites use it for the same family
   of blockers. **EMPIRICALLY VERIFIED via `lean_multi_attempt`**:
   with the option, `pullbackSpecIso_hom_base` fires and reduces the
   stuck goal to its canonical post-pullback form; without the option,
   the same rewrite is reported "unused". Persistent file at
   `analogies/pullbackspeciso-bypass.md` with full recipe + reversal
   trigger.

3. **8 prover lanes for iter-180 prover phase** (within cap=10),
   addressing the UNDER_DISPATCH finding by filling all ready lanes:
   - **Lane A** `GmScaling.lean` — **iter-181 RETIRE-OR-ESCALATE
     EXECUTION**: retire 2 TEMP axioms via the
     `respectTransparency false` recipe from the analogist consult.
   - **Lane B** `Points.lean` — break 11-iter `gm_grpObj` deferral via
     the 8-step recipe at `analogies/gm-grpobj-representable.md`.
   - **Lane C** `RelativeSpec.lean` — close `QcohAlgebra.pullback`'s
     `coequifibered` field per Lane B iter-179 task_result Section 5.1
     "Discharge QcohAlgebra.pullback.coequifibered".
   - **Lane D** `OCofP.lean` — smallest body sorry first
     (`lineBundleAtClosedPoint` type-level OR `globalSections_iff`,
     prover picks).
   - **Lane E** `RRFormula.lean` — `l_eq_degree_plus_one_of_genus_zero`
     (smallest, RR.2 row).
   - **Lane F** `QuotScheme.lean` —
     `canonicalBaseChangeMap_app_app_isIso` helper body via Stacks
     02KH(ii) affine-local + Mayer-Vietoris reduction.
   - **Lane G** `Thm32RationalMapExtension.lean` — re-engage iter-179
     helper `av_isIntegral_and_codimOneFree`. Split into 2 smaller named
     pieces (`Smooth ⟹ IsIntegral` + `CodimOneFree`) OR close one of
     them directly. Helper budget = 2.
   - **Lane H** `AuslanderBuchsbaum.lean` — close `Module.depth` body
     re-export via the Stacks 00LF supremum form per Lane F iter-179
     task_result Section "Concrete next step".

## Critic verdicts (this iter)

| Critic | Slug | Verdict |
|---|---|---|
| progress-critic | `route180` | STUCK/CHURNING-with-UNDER_DISPATCH — Route 1 STUCK (corrective REFACTOR; iter-180 directive correctly schedules); Route 2 CONVERGING; Route 3a CONVERGING (gate may be clearing post-iter-179); Route 3b CONVERGING; Route 3c STUCK (must add to dispatch); Route 3d STUCK (must add to dispatch); Route 3e STUCK (must add to dispatch); Route 4a CONVERGING (slow); Route 4b CONVERGING (slow); Route 4c STUCK by deferral-language (must address gating sub-phases or reclassify); Route 5 STUCK by inaction (must fire prover; 12-iter would be hardest avoidance signal). Dispatch: UNDER_DISPATCH. |
| strategy-critic | (skipped) | iter-179 SOUND with no live CHALLENGE; STRATEGY.md SHA-equal to iter-179 close; iter-181 re-dispatch scheduled. |
| blueprint-reviewer | (skipped) | iter-177 HARD GATE clear; only marker/`\lean{...}` edits since; all iter-180 chapters under prover work carry `complete: true correct: true`. |
| mathlib-analogist | `pullbackspeciso-bypass` | ALIGN_WITH_MATHLIB on Decision 4 (`set_option backward.isDefEq.respectTransparency false`). Empirically verified via `lean_multi_attempt`. |

## Subagent skips

- **strategy-critic**: STRATEGY.md SHA-unchanged from iter-179 close
  (`sha256sum` returns `a616893...`, last-known hash); prior verdict
  was SOUND with no live CHALLENGE (iter-178 CHALLENGEs were addressed
  in STRATEGY.md edits); iter-181 re-dispatch scheduled per iter-178
  commitment. No new strategy-level finding emerged this iter — the
  iter-181 RETIRE-OR-ESCALATE trigger fires per the existing schedule,
  not a new strategy fork.
- **blueprint-reviewer**: no chapter under `blueprint/src/chapters/`
  has had prose edited since iter-177 HARD GATE clear (only `sync_leanok`
  marker edits + iter-179 review's `\lean{...}` correction on
  `Albanese_CodimOneExtension.tex:554` for CodimOneExtension — and even
  that chapter is no longer under active prover work this iter). All
  iter-180 prover-touched files' chapters were `complete: true
  correct: true` at the prior HARD GATE clear. No must-fix-this-iter
  finding from any prior dispatch remains live.

## Decisions made this iter

### Decision 1 — iter-181 RETIRE-OR-ESCALATE EXECUTES via Decision 4 fix

The iter-179 Lane A reversal trigger fired exactly as armed (Step 3.1
`pullbackSpecIso_hom_base` stuck on `Algebra.compHom` heartbeat sink).
Per `STRATEGY.md` line 103: "Retirement deadline — Trigger: iter-181
RETIRE-OR-ESCALATE. If retirement is not in hand by iter-181, either
ship the alt route (see below) or formally re-escalate via TO_USER."

**Decision**: iter-180 ships the Decision-4 fix from the
`pullbackspeciso-bypass` consult, EMPIRICALLY VERIFIED to fire
`pullbackSpecIso_hom_base` on the actual stuck goal. The reversal
trigger is RESOLVED IN-PLACE: the fix is the canonical Mathlib idiom,
not an escalation or alt-route fall-back. No TO_USER escalation, no
Route C valuative-criterion pivot, no wrapper-with-shifted-sink.

**Reversal trigger (iter-181 escalation backup)**: if iter-180 Lane A
prover phase also returns PARTIAL with the 2 TEMP axioms standing,
THEN iter-181 fires the formal TO_USER escalation via the review-phase
TO_USER.md. The progress-critic's iter-180 verdict explicitly
authorizes this fall-through.

### Decision 2 — Address UNDER_DISPATCH by filling all ready lanes

Progress-critic flagged ≥4 ready files absent from the iter-179
proposal: RelativeSpec, RationalCurveIso, Thm32, plus one of
AuslanderBuchsbaum/CodimOneExtension. **Decision**: 8-lane dispatch
this iter, including RelativeSpec (Lane C), Thm32 (Lane G), and
AuslanderBuchsbaum (Lane H). RationalCurveIso skipped because its
remaining 2 sorries (Pins 2 and 3) are gated on Hartshorne II.6.9 +
Stacks 0AVX — these are deep Mathlib-gap content, not ready bodies.
CodimOneExtension's remaining 3 sorries (`extend_of_codimOneFree_of_smooth`
and `indeterminacy_pure_codim_one_into_grpScheme`) are also substantive
non-ready bodies (the structural advance on
`smooth_codim_one_…` exposed 2 Mathlib gaps inline as named `hreg_dim`
hypothesis). **AuslanderBuchsbaum (`Module.depth` body) was the
cleanest ready lane to add.**

### Decision 3 — Route 4c (AlbaneseUP) deferral concretely named

Per progress-critic's "address deferred infrastructure or reclassify"
finding: the gating sub-phases for AlbaneseUP are A.3 (`Pic⁰` + degree
substrate, file `Picard/IdentityComponent.lean` skeleton owed), A.4.d.i
(`Sym^g` of schemes, file `Albanese/SymmetricPower.lean` skeleton owed),
and A.4.c (`extend_to_av` — Lane G this iter addresses). **Decision**:
this iter Lane G addresses A.4.c progress; A.3 and A.4.d.i remain
deferred (substrate-unowned, Mathlib gap CRITICAL PATH). Recorded in
PROGRESS.md "Off-limits this iteration" with the gate names.

### Decision 4 — Lane H AuslanderBuchsbaum `Module.depth` opens

Lane F iter-179 task_result documented the closure path: Stacks 00LF
supremum form using `RingTheory.Sequence.IsRegular`
(`Mathlib/RingTheory/Regular/RegularSequence.lean:146`). ~10-15 LOC,
unblocks 3 downstream sorries in the same file
(`depth_eq_smallest_ext_index`, `depth_of_short_exact`,
`auslander_buchsbaum_formula`). **Decision**: dispatch.

### Decision 5 — Lane D OCofP starts with smallest sorry

Lane D directive lets the prover pick between `lineBundleAtClosedPoint`
type-level and `globalSections_iff`. `lineBundleAtClosedPoint` is
type-level `sorry`; closing it requires constructing the ideal-sheaf
dual via `Scheme.IdealSheafData.idealOfPoint` + `Hom`-of-sheaves +
`HModule` forget. `globalSections_iff` is a Prop-level iff. Both have
~80-150 LOC bodies. **Decision**: prover picks based on iter-180
exploration; either is acceptable.

### Decision 6 — No-laundering boilerplate retained on every lane

Per iter-179 boilerplate: no new project axioms, no
placeholder-discharge-by-discarding-argument bodies. Lane A's
no-axioms rule is hardened by Decision 1's positive verification —
the Mathlib-aligned recipe is available; helper budget = 1 (an
optional wrapper if backup `change` is needed).

## Tool substitutions

(none this iter — `archon-informal-agent.py` had `OPENAI_API_KEY`
fallback available but not needed; the Mathlib-aligned recipe at
`analogies/pullbackspeciso-bypass.md` is sufficient.)

## Sorry landscape entering iter-180 prover phase

Post-plan-phase: **72 sorry warnings + 2 TEMP axioms + 0 errors**
(`lake build AlgebraicJacobian` GREEN, sha = identical to iter-179
close). No structural refactor lands plan-phase this iter (the consult's
`set_option` line is added by Lane A's prover, not by a refactor agent).

Per-file sorry counts entering iter-180:
- `AbelianVarietyRigidity.lean` — 2 (deferred).
- `RigidityKbar.lean` — 1 (off critical path).
- `Genus0BaseObjects/BareScheme.lean` — 2.
- `Genus0BaseObjects/ChartIso.lean` — 0.
- `Genus0BaseObjects/Points.lean` — 1 (Lane B target).
- `Genus0BaseObjects/GmScaling.lean` — 3 + **2 TEMP axioms** (Lane A target).
- `Picard/RelativeSpec.lean` — 2 (Lane C target: `coequifibered` field; `pullback_iso` deferred).
- `Picard/LineBundlePullback.lean` — 5 (gated on A.1.a body).
- `Picard/RelPicFunctor.lean` — 6 (gated).
- `Picard/FlatteningStratification.lean` — 7 (gated).
- `Picard/QuotScheme.lean` — 6 (Lane F target).
- `Picard/FGAPicRepresentability.lean` — 7 (gated).
- `RiemannRoch/WeilDivisor.lean` — 2 (deferred).
- `RiemannRoch/OCofP.lean` — 5 (Lane D target).
- `RiemannRoch/RRFormula.lean` — 3 (Lane E target).
- `RiemannRoch/RationalCurveIso.lean` — 2 (deferred — Pins 2/3 deep).
- `Jacobian.lean` — 2 (gated).
- `Albanese/AuslanderBuchsbaum.lean` — 5 (Lane H target: `depth` body re-export).
- `Albanese/Thm32RationalMapExtension.lean` — 1 (Lane G target: helper split or close).
- `Albanese/CodimOneExtension.lean` — 3 (deferred — substantive Mathlib gaps).
- `Albanese/AlbaneseUP.lean` — 7 (gated).

**Total: 72**.

**Iter-180 best case** (Lane A retires 2 axioms; Lane B closes gm_grpObj;
Lanes C/F/H each close 1 helper; Lanes D/E close 1 sorry; Lane G splits
helper):
- Sorries: 72 → 72 - 1(gm_grpObj) - 1(coequifibered) - 1(canonicalBC)
  - 1(depth) - 1(OCofP smallest) - 1(RRFormula smallest) - 1(Lane A
  bodies closed) + 0(Thm32 split = relocation) = **65 sorries**.
- Axioms: 2 → **0 axioms** (Decision 4 recipe lands).

**Iter-180 worst case** (Lane A's recipe sticks even with the
`respectTransparency` option; Lane B sticks at `homEquiv` field;
Lanes C/F/H stick at substantive Mathlib gaps; Lanes D/E only PARTIAL;
Lane G adds 1 helper):
- Sorries: 72 → 72 + 1 (Lane A intermediate body) + 1 (Lane G helper
  split) + 0 (others stick or PARTIAL) = **74 sorries**.
- Axioms: 2 → 2 (TEMP axioms standing) — iter-181 fires formal TO_USER
  escalation.

## Active monitors

- **iter-181 RETIRE-OR-ESCALATE backup**: if iter-180 Lane A closes
  axiom-clean, RESOLVED. If PARTIAL, formal TO_USER escalation fires
  iter-181 via review-phase TO_USER.md (Decision 1 reversal trigger).
- **iter-180 sorry trajectory watch**: best case −7 sorries, worst case
  +2 sorries (both within the strategy's "Iters left" estimates).
- **Parallel-signature-race process**: NO signature-mutating prover
  lanes this iter (all 8 lanes work intra-file or add lemmas without
  modifying existing signatures). Watch iter-181+ for mutations.
- **Project-level laundering watch**: no-laundering boilerplate on
  every lane; helper budgets stated explicitly. iter-180 review will
  spot-check.
- **Route 4c (AlbaneseUP) gate-clearance plan**: this iter's Lane G
  progresses A.4.c (one of the three gating sub-phases). A.3 + A.4.d.i
  remain on the substrate-unowned UNOWNED list. Reassess in iter-182+
  when A.4.c lands and the Sym^g chapter can be re-prioritized.
- **gm_grpObj 11→12 iter trigger**: if Lane B sticks, 12-iter persistence
  becomes the hardest avoidance signal in the project. Escalation:
  switch to direct `GrpObj.mk` fallback per analogy file.
- **OCofP / RRFormula deferral pattern broken**: both files re-engaged
  iter-180 after 4-iter deferral (Lanes D + E). Future iters should
  maintain dispatch frequency.

## Per-lane sorry trajectory predictions

| Lane | File | Sorry Δ (best) | Sorry Δ (worst) | Notes |
|---|---|---|---|---|
| A | GmScaling.lean | −1 (+ retire 2 axioms) | +1 (helper) | Decision-4 fix verified by analogist |
| B | Points.lean | −1 | 0 (Yoneda stick) | Recipe at gm-grpobj-representable.md |
| C | RelativeSpec.lean | −1 | 0 | `coequifibered` via `isLocalization_basicOpen` |
| D | OCofP.lean | −1 | 0 (deep substrate) | prover picks smallest sorry |
| E | RRFormula.lean | −1 | 0 (depends on `Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus`) | smallest of file's 3 sorries |
| F | QuotScheme.lean | −1 (helper close) | 0 | Stacks 02KH(ii) affine-local + MV |
| G | Thm32.lean | 0 (helper relocation) | +1 (split into 2 helpers) | re-engage iter-179 helper |
| H | AuslanderBuchsbaum.lean | −1 | 0 | `depth` body via Stacks 00LF supremum |

**Net best**: −7 sorries + 2 axioms retired.
**Net worst**: +2 sorries, axioms persist → iter-181 formal escalation.

## Next iter (iter-181) — preliminary commitments

1. **iter-181 strategy-critic re-dispatch** (per iter-178 commitment).
2. **iter-181 RETIRE-OR-ESCALATE FORMAL** if Lane A iter-180 returns
   PARTIAL with TEMP axioms standing (TO_USER.md via review).
3. **iter-181 review focus**: spot-check Lane A for laundering signals
   (any new helper-with-sorry whose body is "rfl-trivial under the
   axiom assumption" rather than substantive).
4. **iter-181 LineBundlePullback `OnProduct` type-level sorry**: now
   that RelativeSpec Lane C lands, the gate may clear (`OnProduct`
   depends on `pullback_iso` which depends on `QcohAlgebra.pullback`).
   Verify gate status iter-181 plan-phase.
5. **iter-181 RatCurveIso Pins 2/3 Mathlib-gap consults**: dispatch
   analogist on Hartshorne II.6.9 multiplicativity of degree + Stacks
   0AVX scheme-theoretic argument. These have been deferred 3 iters.
