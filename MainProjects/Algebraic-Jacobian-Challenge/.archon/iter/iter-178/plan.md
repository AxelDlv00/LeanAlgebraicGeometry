# Iter-178 plan-agent run

## Headline outcome

**The "post-HARD-STOP recovery + 2 reversal-trigger consults +
parallel-signature-race process change + 7 prover lanes" iter.**

iter-177 fired the HARD STOP corrective: 2 named TEMP project axioms
landed in `Genus0BaseObjects/GmScaling.lean` to retire 3 chart-bridge
sorries, and 3 deferred file-skeletons (CodimOneExtension, AlbaneseUP,
RationalCurveIso) landed. But (i) `lake build` is STILL BROKEN at
iter end (2nd consecutive iter via parallel signature-change race —
Lane WD's NEW `IsRegularInCodimensionOne` typeclass landed 4 minutes
after Lane FIX-BUILD threaded `[IsLocallyNoetherian]`, with no
integration check); (ii) the iter-177 plan's reversal triggers
(mathlib-analogist consults on cover-vs-`Proj.awayι` and on
`RelativeSpec` type encoding) are owed THIS iter.

This iter:

1. **Two mathlib-analogist consults dispatched THIS plan-phase** —
   `gmscaling-cover-bridge` (Route 1 reversal trigger) and
   `relativespec-encoding` (Route 2 CHURNING corrective). Both
   read at the time of objective composition. Persistence under
   `analogies/`.
2. **STRATEGY.md edits** — addressing strategy-critic `iter178`
   CHALLENGE items: (a) A.1.c arithmetic inconsistency (Iters left
   raised from ~4-8 to ~10-17 per `300/30 = 10, 500/30 = 17` per-row
   honesty); (b) format DRIFTED on per-iter references — replaced
   "iter-177 NEW skeleton" / "iter-176 skeleton landed" annotations
   with "skeleton landed; body gated"; (c) end-state contract
   ("kernel-only axioms") restated in Open Q; (d) iter-181
   RETIRE-OR-ESCALATE trigger added on temp axioms; (e) alt-route
   constancy step flagged for analogist confirmation (per critic).
3. **Parallel-signature-race PROCESS CHANGE** — per progress-critic
   `route178` must-fix on 2-consecutive-iter build-broken-by-race
   pattern: codify a "signature-mutating lane" planning checklist
   in the iter-178 objectives (see § Process change below).
4. **7 prover lanes** at cap (within ~10): FIX-BUILD #2 (priority),
   AVR-IOTAGM (axiom-clean over temp axioms), WD-DEGREE
   (2nd-attempt STRETCH), CodimOne-BODIES (2 ready sorries),
   RatCurveIso-FIX+BODY (auditor must-fix + smallest pin), QS-IsIso
   (Stacks 02KH attempt), AB-PROJDIM (one-liner concrete body).

## Critic verdicts (this iter)

| Critic | Slug | Verdict |
|---|---|---|
| progress-critic | `route178` | **Route 1 CHURNING** (correct corrective in-flight: mathlib-analogist consult); **Route 2 CONVERGING with caveat** (consult deferral pattern working); **Route 3 CONVERGING at lane level** but with **dispatch-level finding** on 2-consec parallel-signature-race build breaks (MUST-FIX as process change); **Route 4 CONVERGING by design**; **Route 5 UNCLEAR** (fresh). Dispatch=OK (8 within cap; planner will trim to 7 — Lane SymPower-SKEL deferred). |
| strategy-critic | `iter178` | **Routes A CHALLENGE + C SOUND with deferral watch**. Two CHALLENGES: (a) A.1.c iter band arithmetic inconsistency; (b) format DRIFTED on per-iter references. Genus-0 deferral remains below REJECT (concrete plan + iter-182 deadline). Two action items: restate kernel-only end-state contract in iter-178 plan; analogist consult must confirm alt-route CONSTANCY step, not just extension step. **Both addressed in STRATEGY.md edits + iter-178 plan.** |
| blueprint-reviewer | (skip — see Subagent skips) | iter-177 verdict cleared HARD GATE for all 26 chapters with zero must-fix-this-iter findings; sync_leanok marker additions only since then. |

## Subagent skips

- **blueprint-reviewer**: iter-177 dispatch (`iter177-whole`) cleared HARD GATE for all 26 chapters with zero must-fix-this-iter findings. Since then, sync_leanok added 24 `\leanok` markers to 4 chapters — deterministic marker changes only, no prose changes. No chapter under blueprint/src/chapters/ has had prose edited since the prior verdict. iter-178 prover lanes target files whose chapters all carried `complete: true` `correct: true`. Re-verifying the gate adds no information; skipped.
- **lean-auditor**: not the plan agent's typical phase dispatch (lean-auditor is review-phase mandatory); also already ran iter-177 with comprehensive findings absorbed into this plan's pending must-fix list (auditor MUST-FIX items: 2 temp axioms tracked via iter-181 trigger; RelativeSpec `:= X` via consult; LineBundlePullback `OnProduct` type-level sorry deferred to A.1.b body lane; RationalCurveIso `functionField ≅` Lane 5 must-fix this iter; IsRegularInCodimensionOne rename deferred MEDIUM).

## Decisions made

### Decision 1 — Two mathlib-analogist consults dispatched plan-phase

Per iter-177 plan's iter-178 preliminary commitments + progress-critic
`route178` Route 1 CHURNING corrective + Route 2 CONVERGING-with-caveat:

- **Consult #1**: cover-vs-`Proj.awayι` API mismatch (Route 1 reversal
  trigger) + separated-locus universal-extension feasibility (alt
  route from STRATEGY Open Q). Directive at
  `.archon/logs/iter-178/mathlib-analogist-gmscaling-cover-bridge-directive.md`.
  Per strategy-critic action: directive asks the analogist to confirm
  the alt route's **constancy step** (valuative criterion supplies
  extension only — what produces constancy?), not just the extension step.

- **Consult #2**: `RelativeSpec` type encoding (A.1.a CHURNING
  corrective). Directive at
  `.archon/logs/iter-178/mathlib-analogist-relativespec-encoding-directive.md`.
  4 encoding options enumerated.

Both consults write persistent findings to `analogies/gmscaling-cover-bridge.md`
and `analogies/relative-spec-encoding.md` for iter-179+ planners to
build on.

### Decision 2 — Parallel-signature-race PROCESS CHANGE

Per progress-critic `route178` dispatch-level finding (2 consec iters
of build-broken-by-parallel-race; Lane WD's iter-177 typeclass addition
broke Lane FIX-BUILD's fix that targeted the iter-176 race; the loop
has no integration build gate; planner has been chasing the race
reactively).

**Process change for iter-178 onward**:

When composing `iter/iter-NNN/objectives.md`, the planner MUST flag
each lane that adds/modifies a typeclass parameter, instance argument,
or namespace-level `variable` block as a `### Signature-mutating lane`.
For each signature-mutating lane, the planner enumerates the downstream
files that consume the modified signature and flags them under
`### Downstream consumers requiring threading`. The prover task for
that lane is instructed to thread the new instance/binder into ALL
listed downstream consumers it touches OR explicitly defer to a
follow-up lane.

This iter (iter-178):
- **Lane FIX-BUILD #2** is the immediate fix for the iter-177 race.
- **No iter-178 lane introduces a new typeclass** (verified per
  objectives.md draft; AVR-IOTAGM, WD-DEGREE, CodimOne-BODIES, RatCurveIso,
  QS-IsIso, AB-PROJDIM are body-fills on existing signatures). Lane
  SymPower-SKEL would be a new file; deferred this iter.

This process change is recorded under `## Process change` in
`iter/iter-178/objectives.md`. Not a strategy edit — strategy is
content-level; this is dispatch-level loop hygiene.

### Decision 3 — Lane SymPower-SKEL DEFERRED iter-179+

The iter-177 plan-agent's iter-178 preliminary commitments listed
`A.4.d.i SymmetricPower.lean substrate scaffold` as a "may fire iter-178
if no other priority captures the lane" hedge. iter-178 has 7 lanes
already strong (1 PRIORITY + 6 body lanes); the file-skeleton SymPower
is gated (downstream consumers `AlbaneseUP.SymmetricPower` body, etc.
are themselves multi-iter Mathlib gaps). Defer to iter-179+ when (a)
the AlbaneseUP file-skeleton bodies start firing OR (b) the strategy
elevates A.4.d.i.

### Decision 4 — Lane CodimOne-BODIES batches 2 sorries into 1 lane

Per CodimOneExtension.lean task result: 4 ready sorries on the new
file. Smallest 2 are `localRing_dvr_of_codim_one` (Mathlib chain
`IsRegularLocalRing.isDiscreteValuationRing_of_dim_one`) and
`extend_iff_order_nonneg` (unfold `mem_domain` + iff). The other 2
(`extend_of_codimOneFree_of_smooth`, `indeterminacy_pure_codim_one_into_grpScheme`)
gate on `cor:regular_cohen_macaulay` (Auslander-Buchsbaum) and on
Krull's principal-ideal theorem, both substantial.

Per `plan.md` § Multi-agent coordination: "list every ready sorry
in that file that the prover should fill in this iter — not just one".
Batch the 2 ready sorries into one lane; defer the other 2.

### Decision 5 — Auditor MUST-FIX RationalCurveIso type weakening lands THIS iter

`_hφ_ff : Nonempty (C'.left.functionField ≅ C.left.functionField)` —
`functionField` is `Type u`, so `≅` is `Equiv`/set-bijection between
fields, NOT ring iso. Two infinite fields are always set-isomorphic
by cardinality, so the hypothesis is substantively trivial. Per
auditor: change to `≃+*` (or `Iso` in `CommRingCat`). 1 LOC fix.
Lane RatCurveIso bundles this with attempting the smallest pin
`morphismToP1OfGlobalSections` body via the `Proj.fromOfGlobalSections`
chain.

### Decision 6 — Temp axioms remain on the books; iter-181 RETIRE-OR-ESCALATE trigger landed in STRATEGY

The two TEMP project axioms (`gmScalingP1_chart_data_temp`,
`gmScalingP1_collapse_at_zero_temp`) violate the kernel-only-axioms
end-state contract. Per progress-critic `route178` secondary
corrective + strategy-critic `iter178` action item: STRATEGY.md
Open Q now carries the **iter-181 RETIRE-OR-ESCALATE** trigger.
If by iter-181 the mathlib-analogist consult #1 has not produced a
viable retirement path (either chart-bridge body OR separated-locus
alt route landed), the iter-181 plan-agent MUST either:
- (a) ship a body-fill or alt-route lane that retires the axioms, OR
- (b) formally re-escalate to USER via TO_USER.md naming a specific
  question whose answer would unblock retirement.

Iter-181 is 3 iters from now — long enough for consult #1's findings
to influence iter-179 and iter-180 prover phases, short enough that
the deadline is meaningful.

## Analogist consult outcomes

### Consult #1 — `gmscaling-cover-bridge` (cover-vs-`Proj.awayι` API)

**Report**: `task_results/mathlib-analogist-gmscaling-cover-bridge.md`.
**Persistent file**: `analogies/gmscaling-cover-bridge.md`.

**Diagnosis**: the project's `gmScalingP1_cover_X_iso` at
`GmScaling.lean:120-160` uses `match i with | ⟨0, _⟩ => … | ⟨1, _⟩ => …`.
Lean's elaborator does NOT unfold `(![X 0, X 1]) ⟨0, _⟩` to `X 0` —
the proof of `⟨0, h⟩.2` is a metavariable at elaboration time, so the
`Matrix.cons` / `Fin.cons` computation rule never fires. **This is
the precise reason 6 iters of helper-bridge attempts failed.**

**Recipe**:
- **Step 1** (~12 LOC, structural, `BareScheme.lean`): hoist the
  inline `(fun i => by fin_cases i <;> simp [...])` tactics in
  `projectiveLineBarAffineCover` to top-level named
  `projectiveLineBarAffineCover_fDeg` / `_hm` so the kernel doesn't
  `whnf` tactic-built proof closures during defeq.
- **Step 2** (~-8 LOC net, structural, `GmScaling.lean`): rewrite
  `gmScalingP1_cover_X_iso` uniform-in-`i` — eliminate the `match`,
  use `((![X 0, X 1]) i)` generically. Target type now defeq-matches
  the cover's generic `.f i` post-`openCover_f` ⟹ `pullbackSpecIso_hom_base`
  fires.
- **Step 3** (~80-125 LOC, body fills, `GmScaling.lean`):
  3 lemma bodies (`gmScalingP1_chart_PLB_eq`, `gmScalingP1_chart_agreement`,
  `gmScalingP1_collapse_at_zero`) retire BOTH temp axioms.

**Reversal trigger** (if Step 2 doesn't suffice): partial `Fin.cases`
refactor using canonical `(0 : Fin 2)` (not `⟨0, _⟩`) — empirically
verified.

**Alt route** (valuative criterion / separated-locus universal
extension): **REJECTED**. Mathlib has the valuative criterion, but
the genus-0 sub-case still requires the `Cover.glueMorphisms` step,
which surfaces the same defeq blocker. NO savings.

**iter-179 commitment**: dispatch `refactor` subagent on Steps 1-2
(structural, cross-file BareScheme.lean + GmScaling.lean); then
prover lane on GmScaling.lean for Step 3. After Step 3 lands clean,
DELETE the 2 temp axiom declarations from the file. iter-181
RETIRE-OR-ESCALATE trigger remains on the books; this plan retires
the temp axioms well before iter-181.

### Consult #2 — `relativespec-encoding` (4 encoding options)

**Report**: `task_results/mathlib-analogist-relativespec-encoding.md`.
**Persistent file**: `analogies/relative-spec-encoding.md`.

**Diagnosis**: Mathlib has already packaged the construction —
`AffineZariskiSite.relativeGluingData` at
`Mathlib/AlgebraicGeometry/Sites/SmallAffineZariski.lean:293` +
`Cover.RelativeGluingData.glued` at
`Mathlib/AlgebraicGeometry/RelativeGluing.lean:102`. The header
verbatim is: "Quasi-coherent `𝒪ₓ`-algebras … Under [Coequifibered]
we can construct a family of gluing data (See `relativeGluingData`)
and glue `F` into a scheme over `X` via `(relativeGluingData _).glued`."
Mathlib hasn't *named* it `RelativeSpec`, but the construction IS
there. The existing consumer `Hom.normalization` at
`Mathlib/AlgebraicGeometry/Normalization.lean:120,127` shows the
exact 2-line idiom.

**Recipe** (~85 LOC for Blocks A+B, ~125 LOC for A+B+C):
- **Block A** (~25 LOC, carrier upgrade): add `coequifibered`
  field to the `QcohAlgebra` structure carrying
  `NatTrans.Coequifibered`; replace `RelativeSpec _𝒜 := X` with
  `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued`;
  replace `structureMorphism _ := 𝟙 X` with
  `(...).toBase`.
- **Block B** (~60 LOC, downstream theorem rewrites):
  `UniversalProperty` via `HasAffineProperty.iff_of_iSup_eq_top`;
  `affine_base_iff` via `SmallAffineZariski.isColimitCocone`-style
  argument; `base_change` via `Coequifibered` stability under
  pullback + universal property of gluing.
- **Block C** (~40 LOC, iter-180+): `UniversalProperty` upgrade
  to `Functor.RepresentableBy` via
  `RelativeGluingData.isPullback_natTrans_ι_toBase`.

**Critical**: the overlay is `NatTrans.Coequifibered`, **NOT**
`SheafOfModules.IsQuasicoherent` (the latter was the
`analogies/qcohalgebra-structure.md` Decision 1 worry — a Mathlib
upstream-tensor gap). `Coequifibered` is pointwise `IsLocalization.Away`;
no monoidal-SheafOfModules dependency. The construction unblocks
WITHOUT waiting for upstream Mathlib.

**iter-179 commitment**: dispatch `refactor` subagent on Block A
(structural, `RelativeSpec.lean` + `QcohAlgebra` struct upgrade);
then prover lane on Block B (downstream theorem rewrites against
the new body). Block C deferred iter-180+.

### Net effect on STRATEGY estimations

**Genus-0 chart-bridge body row**: ~80-150 LOC · ~0/it (5 iters
realized) → after iter-179 lands Steps 1-2 + iter-179/180 lands
Step 3, temp axioms RETIRED at iter-180/181. End-state-contract
restored.

**A.1.a RelativeSpec row**: ~200-400 LOC · ~50/it → ~85 LOC
(Mathlib does most of the work) · realized rate TBD. Iter-179 lands
Block A (~25 LOC); iter-180 lands Block B (~60 LOC). Phase
likely closes iter-180 (vs the ~6-10 iters estimated).

These savings DON'T re-license a STRATEGY edit (per the
"30% estimation change" rule); will re-estimate next iter when
realized rates are available.

## TO_USER fyi

iter-177 review already wrote TO_USER.md flagging the HARD STOP +
the 2 TEMP axioms + the iter-178 reversal-trigger consult. iter-178
plan-agent will let iter-178 review refresh TO_USER.md with:
- iter-178 consult outcomes (cover-bridge + RelativeSpec encoding);
- the iter-181 RETIRE-OR-ESCALATE trigger;
- the parallel-signature-race process change (FYI; not user-actionable).

## Sorry landscape entering iter-178 prover phase

Confirmed via `lake build AlgebraicJacobian` warnings + 1 error
(L335 OCofP):

- `AbelianVarietyRigidity.lean` — **2** (gated; Lane 2 targets one).
- `RigidityLemma.lean` — **0**.
- `RigidityKbar.lean` — **1** (off critical path).
- `Genus0BaseObjects/BareScheme.lean` — **2** (Mathlib gap).
- `Genus0BaseObjects/ChartIso.lean` — **0**.
- `Genus0BaseObjects/Points.lean` — **1** (Mathlib gap).
- `Genus0BaseObjects/GmScaling.lean` — **2** (off-target Mathlib gaps `gm_geomIrred`, `projGm_isReduced`).
- `Picard/RelativeSpec.lean` — **0** placeholder body (consult #2 fires).
- `Picard/LineBundlePullback.lean` — **5** (gated).
- `Picard/RelPicFunctor.lean` — **6** (gated on A.1.b).
- `Picard/FlatteningStratification.lean` — **7** (gated).
- `Picard/QuotScheme.lean` — **6** ⟹ Lane QS-IsIso target -0/-1.
- `Picard/FGAPicRepresentability.lean` — **7** (gated).
- `RiemannRoch/WeilDivisor.lean` — **2** ⟹ Lane WD-DEGREE target -0/-1.
- `RiemannRoch/OCofP.lean` — **4** + 1 error ⟹ Lane FIX-BUILD #2 +0 sorries, errors → 0.
- `RiemannRoch/RRFormula.lean` — **3** (gated).
- `RiemannRoch/RationalCurveIso.lean` — **3** ⟹ Lane RatCurveIso -0/-1.
- `Jacobian.lean` — **2** (gated).
- `Albanese/AuslanderBuchsbaum.lean` — **6** ⟹ Lane AB-PROJDIM -1.
- `Albanese/Thm32RationalMapExtension.lean` — **1** (gated).
- `Albanese/CodimOneExtension.lean` — **4** ⟹ Lane CodimOne-BODIES -2.
- `Albanese/AlbaneseUP.lean` — **7** (gated; all 6 pins + 1 helper).

**Iter-178 best case** (Lane 2 -1; Lane 3 -1; Lane 4 -2; Lane 5 -1;
Lane 6 -1; Lane 8 -1; FIX-BUILD +0 sorries, errors → 0):
71 → 65 + 0 errors.

**Iter-178 worst case** (Lane 2-6 STRETCH slips; only FIX-BUILD +
AB-PROJDIM close):
71 → 69 + 0 errors.

## Lane assignments (7 lanes)

See `iter/iter-178/objectives.md` for per-lane prover directives.

1. **`OCofP.lean`** — FIX-BUILD #2 (PRIMARY MUST-FIX). 1 LOC.
2. **`AbelianVarietyRigidity.lean`** — AVR-IOTAGM. Axiom-clean
   over temp axioms.
3. **`WeilDivisor.lean`** — WD-DEGREE. 2nd-attempt STRETCH.
4. **`Albanese/CodimOneExtension.lean`** — CodimOne-BODIES. 2 ready sorries.
5. **`RationalCurveIso.lean`** — RatCurveIso-FIX+BODY. Auditor MUST-FIX
   + smallest pin attempt.
6. **`Picard/QuotScheme.lean`** — QS-IsIso. Stacks 02KH attempt.
7. **`Albanese/AuslanderBuchsbaum.lean`** — AB-PROJDIM. One-liner.

## Next iter (iter-179) — preliminary commitments

1. **Apply analogist findings from iter-178 consults**:
   - Cover-bridge: dispatch a body-fill lane on `gmScalingP1` if the
     consult identifies a Mathlib lemma that retires the temp axioms.
   - RelativeSpec: dispatch a structural refactor lane (via the
     `refactor` subagent) to land the consult-recommended encoding.
2. **Body lanes that gain gating-relief from iter-178 closures**:
   - If Lane AVR-IOTAGM closes, `genusZero_curve_iso_P1` becomes
     1 step closer (still gated on RR.4 chain).
   - If Lane RatCurveIso closes `morphismToP1OfGlobalSections`, the
     other 2 pins (`morphism_degree_via_pole_divisor`, `iso_of_degree_one`)
     become the next priority.
3. **OCofP body lanes** post FIX-BUILD #2.
4. **`Albanese/SymmetricPower.lean` skeleton** if no other priority
   captures the lane.
5. **AuslanderBuchsbaum `depth` + `depth_eq_smallest_ext_index`**
   if AB-PROJDIM lands clean.
6. **Strategy-critic** scheduled iter-181 (RETIRE-OR-ESCALATE
   trigger check). Otherwise per skip rule.
