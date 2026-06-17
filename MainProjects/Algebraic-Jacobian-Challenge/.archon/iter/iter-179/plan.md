# Iter-179 plan-agent run

## Headline outcome

**The "land both analogist correctives via parallel `refactor`
subagents + open the gm_grpObj 11-iter deferral via mathlib-analogist
consult + thread auditor 178A/B/C into prover lanes + fill `Thm32`
cap slack" iter.**

iter-178 returned `lake build` GREEN (first green build in 3 iters)
after the iter-177 HARD STOP corrective; both reversal-trigger consults
landed persistent recipes at `analogies/gmscaling-cover-bridge.md`
(Route 1) and `analogies/relative-spec-encoding.md` (Route 2). The
iter-178 review's lean-auditor produced 3 must-fix-this-iter findings
(178A RatCurveIso excuse-comment / weakened-wrong; 178B CodimOne shallow
body; 178C AB stale docstring).

iter-179 actions:

1. **TWO `refactor` subagents dispatched plan-phase**, in parallel:
   - `cover-bridge-uniform-i` — Steps 1+2 of the iter-178 cover-bridge
     consult recipe (hoist tactic-built proof closures in
     `BareScheme.lean`; rewrite `gmScalingP1_cover_X_iso` uniform-in-`i`
     in `GmScaling.lean`).
   - `relative-spec-block-a` — Block A of the iter-178 RelativeSpec
     consult recipe (add `coequifibered` field to `QcohAlgebra`; replace
     placeholder bodies of `RelativeSpec`, `RelativeSpec.structureMorphism`
     with `(AffineZariskiSite.relativeGluingData _).glued` / `.toBase`;
     insert `sorry` in the 3 downstream theorems whose proofs depended
     on the placeholder).
2. **ONE `mathlib-analogist` consult dispatched plan-phase**:
   - `gm-grpobj-representable` — break the 11-iter deferral on
     `Points.lean:251 gm_grpObj`. Critic verdict `route179` named this
     STUCK-by-persistent-deferral and required forced re-engagement.
3. **6 prover lanes** for iter-179's prover phase (post-plan), within
   the 10-lane cap:
   - Lane A `GmScaling.lean` — Step 3 retires 2 TEMP axioms via 3 body
     lemmas (`gmScalingP1_chart_PLB_eq`, `gmScalingP1_chart_agreement`,
     `gmScalingP1_collapse_at_zero`). DEPENDS ON Lane 1 refactor landing.
   - Lane B `RelativeSpec.lean` — Block B downstream rewrites
     (`UniversalProperty`, `affine_base_iff`, `base_change` against the
     Mathlib builder). DEPENDS ON Lane 2 refactor landing.
   - Lane C `RationalCurveIso.lean` — auditor 178A signature tightening
     (add `kbar`-algebra hypothesis on `f`) + Pin 1 body close.
   - Lane D `CodimOneExtension.lean` — auditor 178B signature fix on
     `extend_iff_order_nonneg` (add the order condition) + helper body
     `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`.
   - Lane E `Thm32RationalMapExtension.lean` — fill 1 sorry (fresh
     dispatch after 4 iters' inaction per critic STUCK finding).
   - Lane F `AuslanderBuchsbaum.lean` — auditor 178C docstring fix +
     stretch on `depth` re-export body.

Dropped from iter-178 plan's preliminary commitments:
- **AVR-IOTAGM (Lane 2 of iter-178's prelim list)** — DEFER iter-180+.
  Per `route179` STUCK finding, the morphism is gated on `gmScalingP1`
  AND on `gm_grpObj`; working on `iotaGm_isDominant` before either
  resolves risks repeating iter-178's dead-end dance.

## Critic verdicts (this iter)

| Critic | Slug | Verdict |
|---|---|---|
| progress-critic | `route179` | **Routes 1, 2 CHURNING** (chart-bridge axiom-laundered, RelativeSpec placeholder-laundered); **Routes 3a, 3b, 4a CONVERGING**; **Route 3c (Thm32), 4b (RatCurveIso), 4c (OCofP), 4d (RRFormula), Points.gm_grpObj STUCK** (some by inaction, RatCurveIso by recurring prover-bypass); **Routes 3d (AlbaneseUP), 5 (QuotScheme) UNCLEAR**. **Dispatch UNDER_DISPATCH** for ≥3 iters on ≥2 ready files; must-fix-this-iter to either fill or name the skip on each. Project-level laundering pattern (axiom-for-sorries on chart-bridge; placeholder-bodies on RelativeSpec) flagged as red-line. |
| strategy-critic | (skipped — see Subagent skips) | |
| blueprint-reviewer | (skipped — see Subagent skips) | |

### Acting on progress-critic findings

- **CHURNING Routes 1, 2** — Critic-prescribed structural-refactor
  correctives are EXACTLY the iter-179 dispatch (Lanes 1, 2 refactor
  subagents + Lanes A, B prover lanes consuming the post-refactor file
  states). Action: dispatch as planned.
- **STUCK Route 4b (RatCurveIso)** — Critic prescribes "Lane 5 must
  encode FORBID-alternative + name the verified hypothesis structure".
  Action: Lane C directive (formerly Lane 5) EXPLICITLY encodes the
  signature tightening + bans helper-substitution.
- **STUCK Route 3c (Thm32)** — Critic prescribes "fill ready lane".
  Action: Lane E added.
- **STUCK Points.gm_grpObj** — Critic prescribes "Mathlib analogy
  consult". Action: `gm-grpobj-representable` consult dispatched
  plan-phase.
- **STUCK Routes 4c (OCofP), 4d (RRFormula)** — Critic prescribes
  "fill ready lane". Action: **DEFERRED iter-180+** with rationale:
  iter-179 already at 6 prover lanes + 2 refactor + 1 consult = 9
  dispatched items; OCofP body and RRFormula body each involve
  multi-iter Mathlib gaps (Hartshorne II.7.7 cohomological vanishing,
  Riemann-Roch SES + dimension count). Adding 2 more lanes risks
  thrashing. Rationale recorded under § OCofP / RRFormula deferral.
- **Project-level laundering red-line** — Recorded in iter-179
  prover-directive boilerplate (Lanes A, B, C, D all carry the
  "no axiom-laundering / no placeholder bodies" no-go rule).

### Decision — Project-level laundering as red-line

Per the progress-critic's project-level laundering observation, every
iter-179 prover lane directive ends with the boilerplate clause:

```
HARD RULE — no laundering. Do NOT close a sorry by introducing a NEW
project axiom (kernel-only end-state contract). Do NOT close a sorry by
making the body a placeholder that discards the meaningful argument
(`def F := <something not containing the argument>`). If the body
mathematically requires content you cannot produce honestly, leave
PARTIAL with a substantive named helper sorry, NOT a laundered closure.
```

This is the iter-178 "process change" extended from
"signature-mutation accountability" to "honest-body accountability".

## Subagent skips

- **strategy-critic**: SHA of STRATEGY.md at this iter's plan-phase
  start = `a616893902347c0dfb02d7c9d9a510270bda6b819bebd744742ad8a5c364fc82`
  (unchanged from iter-178 close). iter-178 verdict was "Routes A
  CHALLENGE + C SOUND with deferral watch", with CHALLENGES addressed
  in iter-178 STRATEGY.md edits (A.1.c arithmetic, format DRIFTED) and
  recorded as addressed in iter-178 plan's `## Critic verdicts` table.
  No new CHALLENGE-worthy strategic shifts this iter; the iter-179 work
  is purely the iter-178 plan's pre-committed consult-application path.
  Per iter-178 plan's commitment, strategy-critic re-dispatch is
  scheduled iter-181 (RETIRE-OR-ESCALATE trigger check). Skipping safely.
- **blueprint-reviewer**: 4 chapter files were touched since
  iter-177's `iter177-whole` HARD GATE clear, but the edits were
  ENTIRELY `sync_leanok` marker additions (deterministic, not
  prose-changing). One marker-placement bug (broken xref at
  `Albanese_CodimOneExtension.tex:594-596` `\leanok` tucked inside
  `\uses{}`) was deterministically flagged by blueprint-doctor and
  fixed inline by THIS plan agent. The substantive content of all 26
  chapters is unchanged since iter-177's HARD GATE clear, and all 6
  iter-179 prover-touched files have chapters that carried
  `complete: true correct: true` then. Per skip-rule intent (no
  *prose* changed). Skipping safely.

## Decisions made

### Decision 1 — Dispatch both analogist correctives this iter via parallel `refactor` subagents

Per iter-178 plan's preliminary commitment + iter-179 progress-critic
verdict (Routes 1 + 2 both CHURNING). The cover-bridge refactor
(Steps 1+2) and the RelativeSpec carrier upgrade (Block A) are
INDEPENDENT (different files, different content) so they dispatch in
parallel. Refactor lanes are blocking — provers wait for them to
finish before consuming the post-refactor file states.

The Step 3 prover (Lane A) and the Block B prover (Lane B) are
sequenced post-refactor automatically by the loop (their `.lean` file
targets only finalize at refactor commit). The provers see the
refactored state; the directives are fully self-contained about what
the refactored state looks like.

### Decision 2 — Defer AVR-IOTAGM to iter-180+

Per `route179` STUCK-by-gating chain finding. `iotaGm_isDominant` is
gated on (i) the chart-bridge body retirement (Lane A's job) AND (ii)
the `gm_grpObj` resolution (the analogist consult will inform iter-180
lane). Filing AVR-IOTAGM this iter risks the iter-178 dead-end dance
repeating. Re-add iter-180 once Lane A closes successfully.

### Decision 3 — Defer OCofP body + RRFormula body to iter-180+

Per `route179` UNDER_DISPATCH finding. Critic prescribes "fill ready
lane" for both. Counter: iter-179 already has 6 prover + 3 plan-phase
subagent dispatches = 9 items; both OCofP body and RRFormula body
involve multi-iter Mathlib gaps (Hartshorne II.7.7 cohomological
vanishing / SES additivity + R-R dimension count). Each is a deep
single-sorry that needs careful per-sorry decomposition, not a
mechanical-tier lane. Capacity-balance favours Thm32 (1 sorry,
unambiguous Mathlib-gap-style content) over the deep RR.2/RR.3 lanes
this iter.

iter-180 prelim commitment: open `OCofP.lean` smallest body sorry
(globalSections_iff via Hartshorne II.7.7) OR `RRFormula.lean`
`l_eq_degree_plus_one_of_genus_zero` (RR for genus 0; smaller bite
than the dim-count SES). Pick whichever has a less load-bearing
Mathlib-gap dependency.

### Decision 4 — Dispatch `gm-grpobj-representable` analogist consult

Per `route179` STUCK-by-persistent-deferral finding (~12 iters since
iter-167 escalation watch fired). The `gm_grpObj` body's recipe was
flagged "needs api-alignment consult" iter-167 and never came. This
iter dispatches that consult in plan-phase. Output to
`analogies/gm-grpobj-representable.md`; consumed by iter-180 prover
lane.

### Decision 5 — Lane RatCurveIso (Lane C) MUST encode FORBID-alternative + named verified hypothesis

Per `route179` STUCK-by-recurring-prover-bypass on RatCurveIso (auditor
178A — body `sorry` would silently accept inputs for which no morphism
exists; iter-175 chart-bridge bypass pattern recurring). The Lane C
prover directive:

1. Quotes verbatim the section-condition `_halg` hypothesis the auditor
   identified as missing.
2. Names the verification audit trail (`Genus0BaseObjects/Points.lean:86
   pointOfVec` as the closed precedent template).
3. Encodes the no-helper-substitution rule (helper budget = 0).
4. Encodes the no-laundering boilerplate (Decision boilerplate clause).

### Decision 6 — Lane CodimOne (Lane D) MUST address auditor 178B by tightening signature

Per auditor 178B (CodimOne `extend_iff_order_nonneg` body shallow + unused
`KrullDimLE` binder). The Lane D directive:

1. Tightens the signature to USE the `KrullDimLE` binder (or removes it
   if the binder is genuinely unneeded — but the docstring claims the
   substantive valuation content, so the binder should be threaded
   through).
2. EITHER: adds the order-≥0 condition to the iff (the docstring's
   claimed content) AND threads `Scheme.RationalMap.order`.
3. OR: renames the lemma / weakens the docstring to match the existing
   shallow body (the second option is honest but mathematically less
   valuable).

The prover decides which based on what discharges in ≤30 LOC. PARTIAL
acceptable.

## Plan-phase subagent outcomes (post-dispatch)

All 3 plan-phase subagents returned cleanly.

### Refactor `cover-bridge-uniform-i` — COMPLETE

- Steps 1 + 2 landed verbatim per directive.
- 2 hoisted decls `projectiveLineBarAffineCover_fDeg` + `projectiveLineBarAffineCover_hm`
  in `BareScheme.lean` (visibility downgraded from `private` to default
  per cross-file consumer requirement — `private` is file-scoped in Lean
  4; harmless divergence).
- `gmScalingP1_cover_X_iso` rewritten uniform-in-`i` with target type
  `((![X 0, X 1]) i)` per directive.
- `awayι_comp_PLB_hom` generalised to `{m : ℕ} (hm : 0 < m)` (was specialised
  to `m = 1` / `Nat.one_pos`; needed for the new uniform target). NO new
  helper — existing helper made parametric.
- `gmScalingP1_chart` body updated to consume the new iso target type.
- Build state: GmScaling 2 sorries + 2 TEMP axioms (unchanged); BareScheme
  2 sorries (unchanged). Full `lake build` green.
- Reversal trigger NOT fired (clean first-attempt landing).
- **iter-179 prover Lane A** (Step 3) consumes the post-refactor file
  state.

### Refactor `relative-spec-block-a` — COMPLETE

- Block A landed verbatim per directive.
- `QcohAlgebra` carrier gains `coequifibered` field;
  `RelativeSpec` body now `(AffineZariskiSite.relativeGluingData _).glued`;
  `structureMorphism` body now `.toBase`.
- 3 downstream theorems (`UniversalProperty`, `affine_base_iff`, `base_change`)
  get honest `sorry` bodies — Lane B target.
- Directive deviations (both anticipated by directive): `unit.hom` (not
  `.val`; `.val` deprecated at pinned commit) and `Functor.whiskerLeft`
  (not bare `whiskerLeft`; not aliased under current opens). Mathematical
  content identical.
- File sorry count: 0 → 3 (matches directive Expected Outcome).
- Full `lake build` green; no breakage in 4 consumer files
  (`LineBundlePullback`, `RelPicFunctor`, `FlatteningStratification`,
  `FGAPicRepresentability`).
- **iter-179 prover Lane B** (Block B) consumes the post-refactor file
  state.

### Mathlib-analogist `gm-grpobj-representable` — COMPLETE

- **`GrpObj.ofRepresentableBy` EXISTS** in Mathlib at
  `Mathlib/CategoryTheory/Monoidal/Cartesian/Grp_.lean:35`. The project's
  planned path IS the Mathlib idiom.
- **No prior Mathlib art**: zero callers of `ofRepresentableBy` in
  `Mathlib/AlgebraicGeometry/`. The project will be the FIRST in the
  ecosystem to install a concrete-scheme `GrpObj` via this construction.
- **8-step recipe** captured at `analogies/gm-grpobj-representable.md`:
  (1) define `F : (Over (Spec k̄))ᵒᵖ ⥤ GrpCat.{u}` via units functor;
  (2a-c) build 3-step homEquiv chain (Over-cat unfold → Spec adjunction
  → IsLocalization.Away.lift bijection); (3) build `homEquiv_comp`
  naturality; (4) apply `GrpObj.ofRepresentableBy`. LOC ~75-115.
- **Reversal trigger** if Yoneda path stalls: direct `GrpObj.mk` via
  explicit ring maps (`t ↦ t ⊗ t`, `t ↦ 1`, `t ↦ t⁻¹`); ~150-200 LOC
  but no over-cat Yoneda.
- **iter-180 commitment**: fire `gm_grpObj` body lane consuming this
  recipe. iter-179 does NOT open a prover lane on this — the consult was
  the corrective for the 11-iter deferral; body fill is iter-180's job
  per the directive's "NO project edits this iter beyond the report"
  clause.

### Net iter-179 plan-phase outcomes on the sorry landscape

- Pre-plan-phase: 70 sorry warnings + 2 TEMP axioms + 0 errors.
- Post-plan-phase (refactors landed): **73 sorry warnings + 2 TEMP axioms
  + 0 errors** (the +3 is RelativeSpec's expected honest scaffold; the 2
  TEMP axioms stay until Lane A closes Step 3 in the prover phase).

The +3 increase is the *honest* form of Block A — the 3 downstream
theorems were silently discharging trivializations; replacing those with
`sorry` bodies makes the project state HONESTLY reflect the work that
remains.

## Sorry landscape entering iter-179 prover phase

Confirmed via iter-178 review (post-build GREEN, 70 warnings, 0 errors):

- `AbelianVarietyRigidity.lean` — **2** (Lane 2 of iter-178 PARTIAL+DEAD-END
  on directive recipe; staged for structural decomposition iter-180+).
- `RigidityLemma.lean` — **0**.
- `RigidityKbar.lean` — **1** (off critical path).
- `Genus0BaseObjects/BareScheme.lean` — **2** (Mathlib gap).
- `Genus0BaseObjects/ChartIso.lean` — **0**.
- `Genus0BaseObjects/Points.lean` — **1** (`gm_grpObj`; analogist consult dispatched this iter).
- `Genus0BaseObjects/GmScaling.lean` — **2** + **2 TEMP project axioms**
  (Lane A target retires the 2 axioms; the 2 honest scaffold sorries
  remain).
- `Picard/RelativeSpec.lean` — **0** (placeholder; refactor + Block B
  introduces 3 honest scaffold sorries; net file +3).
- `Picard/LineBundlePullback.lean` — **5** (gated).
- `Picard/RelPicFunctor.lean` — **6** (gated on A.1.b).
- `Picard/FlatteningStratification.lean` — **7** (gated).
- `Picard/QuotScheme.lean` — **6** (Lane 6 of iter-178 STRETCH PARTIAL;
  not iter-179 target).
- `Picard/FGAPicRepresentability.lean` — **7** (gated).
- `RiemannRoch/WeilDivisor.lean` — **2** (Lane 3 iter-178 PARTIAL; not
  iter-179 target).
- `RiemannRoch/OCofP.lean` — **5** (deferred iter-180+; see Decision 3).
- `RiemannRoch/RRFormula.lean` — **3** (deferred iter-180+; see Decision 3).
- `RiemannRoch/RationalCurveIso.lean` — **3** (Lane C target — sig + Pin 1).
- `Jacobian.lean` — **2** (gated).
- `Albanese/AuslanderBuchsbaum.lean` — **5** (Lane F target — sub-stretch).
- `Albanese/Thm32RationalMapExtension.lean` — **1** (Lane E target).
- `Albanese/CodimOneExtension.lean` — **3** (Lane D target — sig + helper body).
- `Albanese/AlbaneseUP.lean` — **7** (gated).

**Sorry entering iter-179**: 70 (per `lake build` warnings post iter-178)
PLUS 2 TEMP project AXIOMS.

**Iter-179 best case** (Lane A −2 axioms + closes 3 chart-bridge lemmas /
file count stays; Lane B Block A net +3 honest scaffold sorries; Lane C
sig + Pin 1 closes (−1); Lane D sig fix + helper body (−1); Lane E
Thm32 closes (−1); Lane F docstring fix + depth body attempt (PARTIAL,
0 sorry change)): 70 + 2 axioms → 70 + 3 (RelativeSpec exposure) − 3
(Lanes C, D, E) = 70 sorries / 0 axioms. **Net: TEMP AXIOMS RETIRED;
sorry count unchanged at 70**.

**Iter-179 worst case** (Lane A fails / sticks → axioms stay; Lane B
refactor lands but Block B provers stick → +3 honest sorries surface;
Lanes C-F mostly PARTIAL): 70 + 2 axioms → 73 + 2 axioms. **Net: +3
sorries; axioms persist**.

The asymmetry between best/worst case is intentional — the refactor
correctives are the dominant axis. If Lanes 1 + 2 land but Lane A's
prover sticks on Step 3, that's a HARD STOP signal to either escalate
TO_USER or pivot to alt route.

## Lane assignments (subagents + prover lanes)

See `iter/iter-179/objectives.md` for per-lane prover directives.

### Plan-phase subagent dispatches (this phase, BEFORE prover-fanout)

1. **`refactor` subagent — `cover-bridge-uniform-i`** —
   `BareScheme.lean` + `GmScaling.lean` Steps 1+2.
2. **`refactor` subagent — `relative-spec-block-a`** —
   `RelativeSpec.lean` Block A.
3. **`mathlib-analogist` consult — `gm-grpobj-representable`** —
   `Points.lean:gm_grpObj` 11-iter deferral break.

### Prover lanes (post-plan dispatch)

A. `GmScaling.lean` — Step 3 body retirements (3 lemmas → 2 axioms retired).
B. `RelativeSpec.lean` — Block B downstream rewrites (3 theorems).
C. `RationalCurveIso.lean` — sig tightening (auditor 178A) + Pin 1 body.
D. `CodimOneExtension.lean` — sig fix (auditor 178B) + helper body.
E. `Thm32RationalMapExtension.lean` — fill 1 sorry (per critic STUCK).
F. `AuslanderBuchsbaum.lean` — docstring fix (auditor 178C) + depth body stretch.

## Process change validation

iter-178's "signature-mutating lane" checklist held — the iter-178
review noted Lane 5 was correctly audited as the only mutating lane
this iter. iter-179 has TWO refactor lanes (each by design
signature-mutating across files). Both are dispatched via the
`refactor` subagent (NOT via prover lanes), so the
parallel-signature-race risk is moot — refactors are blocking by design
and prover lanes consume the post-refactor file state.

## Process change watch (iter-180)

Lane A and Lane B both consume the iter-179 refactor outputs. If iter-179
review reports:
- Lane A's prover started against the OLD GmScaling.lean signature
  (refactor didn't commit before prover dispatch), OR
- Lane B's prover started against the OLD RelativeSpec.lean signature,
THEN the iter-180 plan-agent investigates the loop's refactor → prover
sequencing.

## TO_USER fyi

iter-178 review wrote TO_USER.md with the iter-178 consult outcomes +
iter-181 RETIRE-OR-ESCALATE trigger + iter-178 process-change validation.
iter-179 review will refresh TO_USER.md with:
- iter-179 refactor outcomes (cover-bridge + RelativeSpec Block A).
- gm_grpObj consult outcomes (whether iter-180 lane is feasible).
- the iter-181 RETIRE-OR-ESCALATE trigger status (whether Lane A retired
  the 2 TEMP axioms).
- the OCofP / RRFormula iter-180+ deferral decision.

## OCofP / RRFormula deferral rationale (detail)

`OCofP.lean` has 5 body sorries:
- `lineBundleAtClosedPoint` (L140) — the type-level definition; multi-iter.
- `globalSections_iff` (L192) — Hartshorne II.7.7(b) iff.
- `h1_vanishing_genusZero` (L242) — Hartshorne IV.1.3 specialised to D=0.
- `dim_eq_two_of_genusZero` (L277) — RR dimension count.
- `exists_nonconstant_genusZero` (L326) — extracts non-constant function
  via dim_eq_two.

The 5 sorries inter-depend in a chain (smaller → larger). Closing
`globalSections_iff` requires the type-level `lineBundleAtClosedPoint`
to be more substantive than the bare typed sorry. Each sorry needs
careful per-sorry decomposition; a single 1-lane iter likely closes
0–1 of them.

`RRFormula.lean` has 3 body sorries — similar story.

Both files are CONVERGING-by-skeleton but body work is multi-iter. The
iter-180 lane will pick the *one* sorry across these 8 with the cleanest
Mathlib-idiom recipe (likely `RRFormula.l_eq_degree_plus_one_of_genus_zero`
or `globalSections_iff` if the type-level `lineBundleAtClosedPoint` can
factor into a Stacks-tag re-export).
