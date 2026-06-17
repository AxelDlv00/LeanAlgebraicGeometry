# Iter-179 (Archon canonical) — review

## Outcome at a glance

- **The "consult-driven 2-refactor + 6-prover iter; build stays GREEN; RelativeSpec placeholder-laundering RETIRED; Lane A 4 of 6 recipe steps land but pullbackSpecIso_hom_base does not fire — reversal trigger ARMED for iter-180 / iter-181 RETIRE-OR-ESCALATE" iter.**
- **`lake build AlgebraicJacobian` GREEN** — 8355/8355 jobs, 0 errors, 72 sorry warnings (was 70 at iter-178 close), 2 project axioms unchanged.
- **2nd consecutive green build after the iter-176/iter-177 parallel-signature-race breaks** — iter-178 process-change held (no signature-mutating prover lanes this iter; the 2 refactor lanes were dispatched as `refactor` subagents, which are blocking by design and so do not race with provers).
- **Lane B (RelativeSpec) RETIRED the iter-176 CRITICAL placeholder-body laundering** flagged by lean-auditor iter-176. Plan-phase `relative-spec-block-a` refactor installed the Mathlib-backed `(AffineZariskiSite.relativeGluingData _).glued` body; Lane B closed `UniversalProperty` + `affine_base_iff` kernel-clean and `base_change` via 2 named helpers carrying substantive Mathlib-gap content (no placeholder, no laundering).
- **Lane A (GmScaling chart-bridge) reversal trigger FIRED**. The plan-phase `cover-bridge-uniform-i` refactor landed cleanly (uniform-in-`i` cover); Lane A's prover got 4 of 6 chart_PLB_eq recipe steps onto the file, but `pullbackSpecIso_hom_base` fails to fire due to a downstream `Algebra.compHom`-based instance-synthesis blocker on `TensorProduct kbar Away_i GmRing`. 2 iter-177 TEMP axioms persist. **iter-181 RETIRE-OR-ESCALATE schedule arms EARLY at iter-180** per the lane directive.
- **Lane C (RationalCurveIso) sig-tightening + Pin 1 close** kernel-clean; auditor 178A finding RESOLVED.
- **Lane D (CodimOne) auditor 178B addressed via Path D2** (honest rename + binder drop + docstring demotion); body unchanged (already 2-LOC reshuffle); the substantive Hartshorne content is deferred to a planned `extend_iff_pullback_order_nonneg` future lemma. Lane D's structural advance on `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` replaced bare `:= sorry` with a structured proof exposing 2 Mathlib gaps in a single named hypothesis.
- **Lane E (Thm32) 4-iter inaction streak BROKEN** — `extend_to_av` body landed with 1 named helper (`av_isIntegral_and_codimOneFree`) consolidating 2 Mathlib-gap pieces.
- **Lane F (AuslanderBuchsbaum) auditor 178C docstring fix landed**; STRETCH depth re-export PARTIAL (Mathlib gap documented in docstring).
- **gm_grpObj 11-iter deferral**: plan-phase `mathlib-analogist` consult `gm-grpobj-representable` produced 8-step recipe at `analogies/gm-grpobj-representable.md`; iter-180 commits to opening the prover lane.
- **Net sorry**: +2 (Lane B refactor +3 then Lane B closures −1, Lane A +1, Lane C −1, others 0 net). Within plan's predicted band (best 0, worst +3).

## Per-lane verification

| # | Lane | File | Status | Sorry Δ (file) | Notes |
|---|---|---|---|---|---|
| 1 (refactor) | cover-bridge-uniform-i | BareScheme.lean + GmScaling.lean | COMPLETE | 0 | First-attempt landing; awayι_comp_PLB_hom generalised |
| 2 (refactor) | relative-spec-block-a | RelativeSpec.lean | COMPLETE | +3 (post-refactor) | Honest scaffold per directive |
| 3 (consult) | gm-grpobj-representable | (recipe only) | COMPLETE | 0 | 8-step recipe at analogies/gm-grpobj-representable.md |
| A | GmScaling chart-bridge | Genus0BaseObjects/GmScaling.lean | PARTIAL — reversal triggered | 2 → 3 | New middle-object-type trap discovered; 4/6 recipe steps land |
| B | RelativeSpec body fills | Picard/RelativeSpec.lean | PARTIAL (2/3 closed kernel-clean) | 3 → 2 | base_change via 2 named substantive helpers |
| C | RatCurveIso sig + Pin 1 | RiemannRoch/RationalCurveIso.lean | SUCCESS | 3 → 2 | Kernel-clean Pin 1 + sig tightened (auditor 178A) |
| D | CodimOne sig + helper | Albanese/CodimOneExtension.lean | PARTIAL+SUCCESS (Path D2) | 3 → 3 | Auditor 178B addressed via rename + demotion + structural advance |
| E | Thm32 fill | Albanese/Thm32RationalMapExtension.lean | PARTIAL (helper-relocated) | 1 → 1 | 4-iter inaction BROKEN; body 0-inline-sorry |
| F | AuslanderBuchsbaum docstring + depth | Albanese/AuslanderBuchsbaum.lean | SUCCESS+PARTIAL | 5 → 5 | Auditor 178C docstring fix; depth STRETCH PARTIAL |

**Net**: +2 sorries (70 → 72); 0 new project axioms; 2 iter-177 TEMP axioms persist; build GREEN.

## Build state diagnostics

```
$ lake build AlgebraicJacobian
…
warning: AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:213:14: declaration uses `sorry`   (Lane A PARTIAL)
warning: AlgebraicJacobian/Picard/RelativeSpec.lean:229:18: declaration uses `sorry`           (Lane B helper QcohAlgebra.pullback)
warning: AlgebraicJacobian/Picard/RelativeSpec.lean:353:8:  declaration uses `sorry`           (Lane B helper pullback_iso)
warning: AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:296:8: declaration uses `sorry`  (Pin 2, off-target)
warning: AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:356:8: declaration uses `sorry`  (Pin 3, off-target)
warning: AlgebraicJacobian/Albanese/CodimOneExtension.lean:222:16: declaration uses `sorry`   (smooth_codim_one_… structured)
warning: AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean:187:16: declaration uses `sorry`  (av_isIntegral_and_codimOneFree helper)
…
✔ [8354/8355] Built AlgebraicJacobian (3.8s)
Build completed successfully (8355 jobs).
```

**Per-file sorry counts (iter-179 close)**:
- AbelianVarietyRigidity 2, RigidityKbar 1, BareScheme 2, Points 1, **GmScaling 3 (+1)**, **RelativeSpec 2 (+2)**, LineBundlePullback 5, RelPicFunctor 6, FlatteningStratification 7, QuotScheme 6, FGAPicRepresentability 7, WeilDivisor 2, OCofP 5, RRFormula 3, **RationalCurveIso 2 (−1)**, Jacobian 2, AuslanderBuchsbaum 5, Thm32 1, CodimOneExtension 3, AlbaneseUP 7.
- **Total: 72** (was 70 at iter-178 close).

**Project axioms (unchanged from iter-177)**:
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:193` — `gmScalingP1_chart_data_temp`
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:336` — `gmScalingP1_collapse_at_zero_temp`

## Critic + analogist consult outcomes (plan-phase)

### `progress-critic` (`route179`) — verdict acted on

- **Verdicts**: Routes 1, 2 CHURNING by laundering; Routes 3a, 3b, 4a CONVERGING; Routes 3c, 4b, 4c, 4d, gm_grpObj STUCK by inaction or by deferral; Routes 3d, 5 UNCLEAR; dispatch UNDER_DISPATCH.
- **Acted on**: structural-refactor correctives landed (Lanes 1, 2 refactor + Lanes A, B prover); FORBID-alternative rule encoded verbatim in Lane A + Lane C directives; Lane E fills Thm32 inaction streak; gm_grpObj consult landed plan-phase.
- **Not acted on this iter**: OCofP + RRFormula (deferred iter-180+ per plan-agent capacity decision); blueprint AlbaneseUP / QuotScheme deferral persisting.

### `relative-spec-block-a` (refactor) — COMPLETE

- Landed Block A verbatim per directive + analogist recipe. `QcohAlgebra` gained `coequifibered` field; `RelativeSpec` body now `(AffineZariskiSite.relativeGluingData _𝒜.coequifibered).glued`; `structureMorphism` body now `.toBase`. Two minor deviations (`unit.hom` not `.val`; `Functor.whiskerLeft` not bare) both anticipated by directive.
- Validated mathlib-analogist consult predictions verbatim.

### `cover-bridge-uniform-i` (refactor) — COMPLETE

- Hoisted `projectiveLineBarAffineCover_fDeg` + `projectiveLineBarAffineCover_hm` (cross-file scope required dropping `private`). `gmScalingP1_cover_X_iso` rewritten uniform-in-`i` per recipe. `awayι_comp_PLB_hom` generalised `{m : ℕ} (hm : 0 < m)` to support the uniform witness.
- First-attempt landing; no reversal trigger fired.

### `gm-grpobj-representable` (mathlib-analogist) — COMPLETE

- Verdict: `GrpObj.ofRepresentableBy` IS the right Mathlib idiom (no ALIGN_WITH_MATHLIB findings). Project is the FIRST in Mathlib ecosystem to install a concrete-scheme `GrpObj` via this construction (no prior callers in `Mathlib/AlgebraicGeometry/`).
- 8-step recipe at `analogies/gm-grpobj-representable.md`; LOC estimate ~75-115. Fallback path: direct `GrpObj.mk` via explicit ring maps.
- iter-180 commitment: open prover lane on `gm_grpObj` consuming the recipe.

## Key technical findings (iter-179 KB candidates)

### **NEW TRAP — middle-object-type-mismatch in `≫` chains**

Diagnostic signal: `rw`/`simp` silently refuses to match a Mathlib lemma's LHS even though the pattern text appears verbatim in the goal. Root cause: the surrounding `CategoryStruct.comp`'s middle-object type is defeq-but-not-syntactically-equal between goal and lemma. Fix: `change ... ≫ ((X : A ⟶ B) ≫ Y) = _` to force the middle-object type explicitly. Same family of trap as iter-176's `Fin.isValue` simp recipe and iter-175 chart-bridge-prover-bypass. (Detailed write-up will land in PROJECT_STATUS.md Knowledge Base.)

### **`Algebra.compHom`-based instances are a heartbeat sink under `erw`**

`erw [pullbackSpecIso_hom_base]` against a goal carrying `Spec.map (algMap kbar (Away_i ⊗ GmRing))` deterministic-times-out at 200k heartbeats during `isDefEq`. The instance synthesis for `Algebra` on `TensorProduct kbar Away_i GmRing` is the heartbeat sink — `algebraKbarAway` is `Algebra.compHom`-based, which the elaborator struggles to unfold under `erw`'s defeq-permissive unification. Do NOT escalate `rw` → `erw` for these patterns; either rewrite via a project-side wrapper that bypasses instance synthesis, or thread the algebra map explicitly.

### **Consult-driven refactors are reliable when wrapped in `refactor` (not `prover`)**

Both `cover-bridge-uniform-i` and `relative-spec-block-a` landed verbatim per their analogist recipes on first attempt. The `refactor` subagent's blocking semantics + structural-edit scope guarantee that the prover lanes consuming the refactor outputs see the post-refactor file state. iter-179 had 2 such refactor lanes co-dispatched without race (each touched disjoint files).

### **Honest demotion (Path D2) is the project's escape from `extend_iff_order_nonneg`-style auditor flags**

When the substantive content claimed by a docstring exceeds what the body actually encodes AND inflating the signature to make the docstring true is bounded by missing Mathlib infrastructure (here: `Scheme.RationalMap → function-field ring map` pullback), the auditor-approved corrective is rename + docstring demotion + explicit deferral to a planned future lemma. Path D2 is preferred over leaving the laundering in place; it produces an honestly-described 2-LOC lemma AND records the substantive obligation as a named pin in the chapter.

## Blueprint markers updated (manual, this review)

- `blueprint/src/chapters/Albanese_CodimOneExtension.tex`, `thm:weil_divisor_obstruction`: corrected `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_iff_order_nonneg}` → `\lean{AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point}` after Lane D's Path D2 rename. Added `% NOTE (iter-179 review): the substantive Hartshorne-II.6 reformulation is deferred to a planned future lemma `extend_iff_pullback_order_nonneg` (carrying `Scheme.RationalMap.order` machinery; not yet in Mathlib b80f227); the current statement matches the proved 2-LOC mem_domain reshuffle.`

(No other manual marker changes this review — `sync_leanok` ran and the chapters touched are documented in `.archon/sync_leanok-state.json`.)

## Blueprint doctor

2 axiom declarations flagged — both are project-known iter-177 TEMP axioms (`gmScalingP1_chart_data_temp`, `gmScalingP1_collapse_at_zero_temp`), unchanged this iter. iter-181 RETIRE-OR-ESCALATE schedule arms iter-180 per Lane A reversal trigger.

## Subagent skips

- (none) — both `[HIGHLY RECOMMENDED]` subagents dispatched this phase:
  - **lean-auditor** (`iter179-touched`) on the 6 prover-touched files (whole-project sweep).
  - **lean-vs-blueprint-checker** ×6 (one per prover-touched file): `gmscaling-iter179`, `relativespec-iter179`, `rationalcurveiso-iter179`, `codimone-iter179`, `thm32-iter179`, `auslanderbuchsbaum-iter179`.

## TO_USER updates

This review writes TO_USER.md with:
- iter-179 outcome (build GREEN; +2 sorries; 2 TEMP axioms persist).
- Lane A reversal trigger fired → iter-181 RETIRE-OR-ESCALATE arms iter-180.
- gm_grpObj 11-iter deferral broken via analogist consult; iter-180 prover lane committed.
- RelativeSpec placeholder laundering retired.
- iter-181 RETIRE-OR-ESCALATE deadline status.

## Next-iter (iter-180) handoff

Per `recommendations.md`:

1. **iter-181 escalation EARLY** for the 2 TEMP axioms (Lane A reversal trigger fired). Concrete candidates: TO_USER escalation; project-side `pullbackSpecIso_hom_base'` wrapper; Mathlib upstream PR; switch to Route C valuative-criterion alternative.
2. **gm_grpObj prover lane** consuming `analogies/gm-grpobj-representable.md` 8-step recipe.
3. **OCofP + RRFormula body lanes** (deferred this iter, must be re-opened per progress-critic STUCK-by-inaction).
4. **Smooth ⟹ IsReduced** / **scheme-stalk regular** Mathlib-gap consults (gates Thm32 helper closure + CodimOne `smooth_codim_one_…` helper).
5. Continue holding off RatCurveIso Pins 2/3 (deep, gated on Hartshorne II.6 multiplicativity-of-degree + Stacks 0AVX).
