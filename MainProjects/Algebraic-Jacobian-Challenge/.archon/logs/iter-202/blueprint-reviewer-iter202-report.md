# Blueprint Review Report

## Slug
iter202

## Iteration
202

## Top-level summaries

### Incomplete parts

- `Albanese_AlbaneseUP.tex` / `lem:symmetric_product_to_jacobian`: birationality proof depends on Riemann–Roch (Route C, PAUSED); `def:symmetric_power_curve` has no Mathlib analogue and requires a project-side sub-build. Chapter is gated (priority-5, A.4.d).
- `RigidityKbar.tex` / `thm:rigidity_over_kbar`: named-gap sorry body awaiting gaps (i)+(ii) or route-(b) choice. PAUSED.
- `AbelianVarietyRigidity.tex`: the genus-0 classification sub-chain (`prop:morphism_P1_to_AV_constant`, `prop:rigidity_genus0_curve_to_AV`) contains sorries gated on RR.4 (`genusZero_curve_iso_P1`). PAUSED.
- `RiemannRoch_RRFormula.tex`: `lem:euler_char_shortExact_add` body gated on ModuleK-flavoured LES carrier + Grothendieck vanishing + six-term rank-count. PAUSED.
- `RiemannRoch_OCofP.tex`: `lem:lineBundleAtClosedPoint_carrierPresheaf_isSheaf` and related bodies have open substrates. PAUSED.
- `RiemannRoch_OcOfD.tex`: `def:sheafOf` and three lemmas are typed-sorry scaffolds. PAUSED.
- `RiemannRoch_RationalCurveIso.tex`: `lem:degree_one_morphism_iso` Step 2 (scheme-level lift via normalization) is a typed sorry; `lem:degree_via_pole_divisor` body (poleDivisor construction) is a typed sorry. PAUSED.
- `RiemannRoch_H1Vanishing.tex`: `lem:isFlasque_injective` deferred (no `j!` in Mathlib at b80f227); `lem:isFlasque_constant_irreducible` non-empty branch gated on constantSheaf Full/Faithful instance. PAUSED.
- `Picard_RelPicFunctor.tex`: all six declarations have placeholder bodies; root cause is Scheme.Modules monoidal gap (gated on A.1.c.SubT).
- `Picard_FGAPicRepresentability.tex`: Sorries 5–7 are Route-C-blocked; Sorries 1–4 depend on sibling A.1.c and A.2.b chapters landing.

### Lean difficulty quality

- `Picard_RelPicFunctor.tex` / `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup}`: the Lean declaration body is a constant-PUnit-functor placeholder (documented in NOTE). Any prover targeting this file must replace the placeholder, not fill a sorry. The NOTE warns against `sync_leanok` promoting it incorrectly. SOON-severity (not in an active prover route this iter).
- `RiemannRoch_WeilDivisor.tex` / `\lean{AlgebraicGeometry.rationalMap_order_finite_support}`: the declaration is `private` in the Lean file (per iter-199 NOTE) — `sync_leanok` may not resolve private decls cleanly. The `\leanok` marker may be stale. Not on the Sub-build 3 critical path but could cause confusion in future dispatches.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Rigidity Lemma chain through `lem:morphism_eq_of_eqAt_closedPoints` is closed (axiom-clean, iter-162); `\leanok` markers present and current.
  - `lem:rational_map_to_av_extends` (Route-A-only) correctly has no `\leanok`.
  - `prop:morphism_P1_to_AV_constant` and `prop:rigidity_genus0_curve_to_AV` are in the PAUSED portion; their bodies depend on `genusZero_curve_iso_P1` (RR.4, PAUSED) and the `Gm-scaling shortcut` whose `prop:morphism_P1_to_AV_constant` body is not readable from the partial read. Partial verdict reflects the PAUSED status and documented sorry dependency.
  - PAUSED per STRATEGY.md USER 2026-05-28 directive — plan agent should record deferral.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `def:symmetric_power_curve`: no Mathlib analogue; sub-build needed (Milne's affine-and-glue recipe, ~Mumford III.7). `\leanok` present (sorry stub); sub-build is non-trivial dependency.
  - `lem:symmetric_product_to_jacobian` birationality proof (lines 424–466) references Riemann–Roch explicitly (iter-199 NOTE, lines 414–422): "gated on Route C re-engagement (or on a parallel construction that sidesteps RR)." PAUSED.
  - Chapter is priority-5 gated; not feeding an active prover lane this iter. Plan agent should record deferral.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Iter-201 SOON finding (matrix-collapse paragraph past-tense) CLOSED: the new `\paragraph{Iter-201 status update: matrix-collapse substrate landed; closure body deferred to iter-202.}` block is present and correct.
  - Iter-202 Lane AB closure recipe (§ subsec:succ_pd_gap_sequence, lines 985–1016): `induction k generalizing M`, base case ~50–80 LOC, inductive step ~30–50 LOC — adequate for a prover.
  - Three promotion commitments correctly documented: remove `private` from `auslander_buchsbaum_formula_succ_pd`, promote `isDomain_of_regularLocal` (L2657), promote `regularLocal_quotient_isRegularLocal_of_notMemSq` (L2293).
  - Iter-201 NOTE option (1) on `lem:auslander_buchsbaum_formula_succ_pd` (lines 418–436) remains as the operative resolution path. CONFIRMED.
  - **HARD GATE PASSES** for Lane AB-Path-B-Close.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Iter-202 correction applied: `IsRegularLocalRing.localization` status corrected from "EXISTS" to "MISSING" (lines 517–526). ✓
  - Step A1 reframed as cross-file import (lines 699–728): both project-local witnesses (`isDomain_of_regularLocal` L2657, `regularLocal_quotient_isRegularLocal_of_notMemSq` L2293) from `AuslanderBuchsbaum.lean` correctly identified with iter-202 Lane AB promotion path. ✓
  - Step A2 iter-201 done-vs-open split: two axiom-clean substrate declarations listed (L854, L889). ✓
  - Step A3 substrate composite reference: `ringKrullDim_quotient_localization_MvPolynomial_of_regular` (L924). ✓
  - `thm:weil_divisor_obstruction` has no `\lean{...}` pin — intentional documented detach (iter-179). Informational only.
  - **HARD GATE PASSES** for Lane COE-Step-B-Bridges (substrate-only).

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
(Pointer chapter; declarations are in AbelianVarietyRigidity.tex scope.)

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Carriers `HasCechToHModuleIso` and `HasAffineCechAcyclicCover` honestly documented as unproduced (Section 9.4). Conditional theorems are in place; no claim of full closure.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:nonempty_jacobianWitness` is a named-gap sorry body (by design; the operative end-state is option (c) per STRATEGY.md). `\leanok` correctly present. Blueprint documents both Route A and Route C dependencies.
  - `def:genusZeroWitness` and `def:positiveGenusWitness` have `\leanok` (sorry stubs) ✓.
  - `thm:albanese_universal_property` (Milne III §6 Prop 6.1) has no `\leanok` — correctly gated on A.4.d (priority-5).

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Seven typed-sorry carrier instances documented in §§ closure-order subsections. Sorries 5–7 Route-C-blocked; Sorries 1–4 sibling-chapter-dependent.
  - `lem:smooth_proper_quotient` and `thm:fga_pic_representability` body are honestly documented as deferred.
  - Plan agent should record deferral (gated on Route C + A.1.c + A.2.b).

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Multiple typed-sorry substrate helpers (`pullback_tildeIso`, `pullback_app_isoTensor_isBaseChange`, etc.) are documented with route choices (Route A/B) and LOC estimates. Correctly described.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - All six Lean-pinned declarations (`addCommGroup`, `PicSharp`, `PicSharp.functorial`, `PicSharp.presheaf`, `PicSharp.etSheaf`, `PicSharp.etSheaf_group_structure`) have placeholder bodies. Root cause: `Scheme.Modules` monoidal-structure gap (gated on A.1.c.SubT). Documented in NOTE blocks. No false claims.
  - Gated on A.1.c.SubT (priority-2.5). Plan agent should record deferral until SubT lands.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:scheme_modules_tensorobj` has `\leanok` (stub present). The three other pinned declarations (`tensorObj_functoriality`, `monoidalCategory`, `addCommGroup_via_tensorObj`) correctly lack `\leanok` (not yet stubbed).
  - All 4 pinned declarations have correct namespaces, parameter types, and target types for a typed-sorry scaffold.
  - LOC estimates and sequencing (Piece 1 → 2 → 3) clearly described.
  - **HARD GATE PASSES** for Lane TS-Scaffold (lower bar: signatures for typed-sorry stubs).

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:isFlasque_injective`: typed sorry pending `j!` Mathlib construction. Route A/B documented. PAUSED.
  - `lem:isFlasque_constant_irreducible`: non-empty branch gated on constantSheaf Full/Faithful instance (Route A/B documented). PAUSED.
  - `lem:skyscraperSheaf_iso_constantSheaf_punit`: inverse map `op top` component gated (Route A/B documented). PAUSED.
  - Plan agent should record deferral.

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:lineBundleAtClosedPoint_functionField_const_of_complete_curve_of_orderZero` (Sub-claim c substrate): carries typed sorry pending Stacks 0BCK + Hartshorne I.3.4 globalizations. PAUSED.
  - Chapter is well-structured with named sub-claims and LOC estimates.
  - Plan agent should record deferral.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `def:sheafOf` and three corollary lemmas are typed-sorry scaffolds. The sheaf-property correctness sections are detailed but bodies are deferred. PAUSED.
  - Plan agent should record deferral.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:euler_char_shortExact_add`: Tier-3 honest typed sorry. Three substrate gaps: ModuleK-flavoured LES carrier, Grothendieck vanishing, six-term rank-count. PAUSED.
  - `lem:H1_skyscraperSheaf_finrank_eq_zero`: gated on flasque-cohomology (feeds to H1Vanishing.tex). PAUSED.
  - `thm:riemannRoch_genus_zero` body depends on `h1_vanishing_genusZero` as an explicit named premise. ✓
  - Plan agent should record deferral.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:degree_one_morphism_iso` Step 2: typed sorry pending scheme-level lift via normalization / `Hom.toNormalization`. Sub-obligations (a)–(d) documented. PAUSED.
  - `lem:degree_via_pole_divisor` body: `Scheme.Hom.poleDivisor` degree calculation is a named typed sorry pending Hartshorne II.6.9 / `Ideal.sum_ramification_inertia` route. PAUSED.
  - `thm:genus_zero_curve_iso_p1` four-step proof structure is complete and correct as a blueprint.
  - Plan agent should record deferral.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:functionFieldIso` (new this iter): present at lines 376–397, `\lean{AlgebraicGeometry.Scheme.Opens.functionFieldIso}`, `\uses{lem:primeDivisor_stalkIso}`. No `\leanok` — expected; blueprint block is new this iter (Lean declaration was produced in Sub-build 2 iter-201; `sync_leanok` will set marker on next run). Archon-original, no source citation needed. ✓
  - Sub-build 2 description correctly updated to past-tense (CLOSED, 6 axiom-clean decls). ✓
  - Sub-build 3 description references `def:functionFieldIso` and cites `stalkSpecializes_stalkMap_assoc` API path — adequate for a prover. ✓
  - **HARD GATE PASSES** for Lane WD-A4a-Sub-build-3.
  - SOON: `lem:rationalMap_order_finite_support` has `\leanok` but iter-199 NOTE documents the declaration as `private` in the Lean file — `sync_leanok may not resolve private decls cleanly`. This `\leanok` may be stale. Not on Sub-build 3 critical path. Will be resolved once the declaration is made public (planned as part of the terminal closure of `rationalMap_order_finite_support`).

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `thm:rigidity_over_kbar`: named-gap sorry body. Gaps (i) (global cotangent-triviality of A) and (ii) (Serre duality H⁰(C,Ω) = 0) clearly documented. The chart-algebra envelope in §RigidityKbar_shared_pile correctly identified as supplying only the converse direction. Routes (a)/(b) documented; project commits to neither.
  - Citation note: `% SOURCE:` present but no `% SOURCE QUOTE:` — intentional and documented (source not locally available; recalled text must not be substituted). INFORMATIONAL only.
  - PAUSED per STRATEGY.md. Plan agent should record deferral.

## Cross-chapter notes

- **AB + COE promotion consistency** (PASSES): Both `Albanese_AuslanderBuchsbaum.tex` (lines 1007–1016) and `Albanese_CodimOneExtension.tex` (lines 699–724) describe the same two promoted declarations (`isDomain_of_regularLocal` at `AuslanderBuchsbaum.lean` L2657, `regularLocal_quotient_isRegularLocal_of_notMemSq` at L2293) with the same line numbers and the same iter-202 Lane AB promotion path. Descriptions are **CONSISTENT**.
- **AB iter-201 option (1) operative**: `Albanese_AuslanderBuchsbaum.tex` iter-201 NOTE (lines 418–436) confirms option (1) — remove `private` from `auslander_buchsbaum_formula_succ_pd` — as the selected and operative resolution path. **CONFIRMED**.
- `lem:rationalMap_order_finite_support` (`RiemannRoch_WeilDivisor.tex`) carries `\leanok` but is documented as `private`. The equivalent situation on `auslander_buchsbaum_formula_succ_pd` (`Albanese_AuslanderBuchsbaum.tex`) is being resolved this iter-202 by removing `private`. If WD's finite-support lemma is also intended to become public eventually, a similar fix will be needed; but that lemma is not on the Sub-build 3 critical path.

## Severity summary

**Must-fix-this-iter** (per descriptor severity rules — every `partial` chapter, regardless of strategic priority):

All of the following partial chapters require the plan agent to either dispatch a blueprint writer or record an explicit one-line deferral in `iter/iter-202/plan.md`:

1. `RiemannRoch_WeilDivisor.tex` — `complete: true`, `correct: true` — **CLEARS** (no must-fix; complete for Sub-build 3)
2. `Albanese_AuslanderBuchsbaum.tex` — `complete: true`, `correct: true` — **CLEARS** (no must-fix; complete for AB closure)
3. `Albanese_CodimOneExtension.tex` — `complete: true`, `correct: true` — **CLEARS** (no must-fix; complete for COE Step B)
4. `Picard_TensorObjSubstrate.tex` — `complete: true`, `correct: true` — **CLEARS** (no must-fix; complete for TS scaffold)
5. `Albanese_AlbaneseUP.tex` — partial — **must-fix-this-iter**: dispatch blueprint writer for birationality proof or record deferral (gated Route C + A.2.c).
6. `AbelianVarietyRigidity.tex` — partial — **must-fix-this-iter**: record deferral (PAUSED Route C).
7. `RigidityKbar.tex` — partial — **must-fix-this-iter**: record deferral (PAUSED Route C).
8. `RiemannRoch_H1Vanishing.tex` — partial — **must-fix-this-iter**: record deferral (PAUSED Route C).
9. `RiemannRoch_RRFormula.tex` — partial — **must-fix-this-iter**: record deferral (PAUSED Route C).
10. `RiemannRoch_OCofP.tex` — partial — **must-fix-this-iter**: record deferral (PAUSED Route C).
11. `RiemannRoch_OcOfD.tex` — partial — **must-fix-this-iter**: record deferral (PAUSED Route C).
12. `RiemannRoch_RationalCurveIso.tex` — partial — **must-fix-this-iter**: record deferral (PAUSED Route C).
13. `Picard_RelPicFunctor.tex` — partial — **must-fix-this-iter**: record deferral (gated on A.1.c.SubT).
14. `Picard_FGAPicRepresentability.tex` — partial — **must-fix-this-iter**: record deferral (Sorries 5–7 Route-C-blocked; Sorries 1–4 sibling-chapter-gated).

**HARD GATE VERDICTS (4 lanes):**
1. Lane WD-A4a-Sub-build-3 → `RiemannRoch_WeilDivisor.tex`: **PASSES** — complete + correct for Sub-build 3 and `def:functionFieldIso`.
2. Lane AB-Path-B-Close → `Albanese_AuslanderBuchsbaum.tex`: **PASSES** — complete + correct for body-closure recipe and 3 promotion commitments.
3. Lane COE-Step-B-Bridges → `Albanese_CodimOneExtension.tex`: **PASSES** — complete + correct for Step B scheme-to-algebra bridges (substrate-only).
4. Lane TS-Scaffold → `Picard_TensorObjSubstrate.tex`: **PASSES** (lower bar) — complete + correct for 4-declaration typed-sorry scaffold.

**Soon-severity:**
- `RiemannRoch_WeilDivisor.tex` / `lem:rationalMap_order_finite_support`: `\leanok` may be stale given `private` declaration status; will resolve naturally when declaration is made public as part of terminal closure sequence.
- `Picard_RelPicFunctor.tex` / `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup}`: placeholder body (PUnit functor); sync_leanok must not promote this block. Not in active prover route.

**Informational:**
- `def:functionFieldIso` lacks `\leanok` — expected for new blueprint block; sync_leanok will set on next run.
- `thm:weil_divisor_obstruction` in COE has no `\lean{...}` pin — intentional iter-179 detach.
- `RigidityKbar.tex` / `thm:rigidity_over_kbar`: no `% SOURCE QUOTE:` — intentional (source not locally available; clearly documented as such, not fabrication).

**Overall verdict**: 4 HARD GATE lanes PASS; 33 chapters audited; 14 partial-chapter must-fix findings (all expected: 10 are PAUSED Route C chapters whose deferral is recorded in STRATEGY.md, 3 are priority-4/5 gated chapters, 1 is A.1.c.SubT-gated); 0 unstarted-phase proposals (every STRATEGY.md phase has at least one chapter with ≥3 declaration blocks); 0 strategy-modifying findings.
