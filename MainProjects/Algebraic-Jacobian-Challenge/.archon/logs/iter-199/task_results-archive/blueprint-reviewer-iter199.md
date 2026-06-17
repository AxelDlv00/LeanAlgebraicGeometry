# Blueprint Review Report

## Slug
iter199

## Iteration
199

## Top-level summaries

### Incomplete parts

- `Albanese_AlbaneseUP.tex` / `lem:symmetric_product_to_jacobian`: the birationality proof
  invokes Riemann–Roch (`h⁰(D) - h¹(D) = 1` generically for `deg D = g`); the iter-199
  NOTE is correctly placed and clearly flags the Route C gate. No prover should touch the
  birationality argument until RR substrate is available. Chapter is appropriately marked as
  a HELD lane.
- `Picard_RelPicFunctor.tex` / `def:rel_pic_sharp`, `lem:rel_pic_sharp_functorial`,
  `thm:rel_pic_sharp_presheaf`, `def:rel_pic_etale_sheafification`,
  `thm:rel_pic_etale_sheaf_group_structure`: five declarations carry placeholder Lean bodies
  (constant-PUnit-functor / zero-AddMonoidHom / zero-NatTrans), not the intended mathematical
  construction. `% NOTE (iter-199 plan agent)` blocks on each explicitly say "DO NOT promote
  to `\leanok`". The blueprint-writer `rpf-placeholder-note` dispatched this iter has added
  all necessary warnings. Lane RPF is HELD; no prover action this iter.
- `RigidityKbar.tex` / `thm:rigidity_over_kbar`: named gap with sorry; gated on (gap i) global
  cotangent-triviality + (gap ii) Serre duality. Route C PAUSED. Blueprint is thorough as a
  specification; partial only in terms of Lean formalizability.
- Route C chapters (`RRFormula`, `OCofP`, `OcOfD`, `RationalCurveIso`, `H1Vanishing`,
  `BareScheme`-covered entries in `AbelianVarietyRigidity`): all carry open sorries in their
  covered Lean files. By design; USER Route C PAUSE standing directive.

### Proofs lacking detail

- `AbelJacobi.tex` proof of `thm:exists_unique_ofCurve_comp` (line ~67): contains `Theorem~REF`
  placeholder in the classical-description portion of the proof note. This is inside a `\leanok`
  proof block (the Lean-closure portion is complete); the `REF` is in the narrative classical
  description and does not affect `\uses{}` chains or prover direction. **Informational only.**

### Multi-route coverage

- **Route A bottom-up (primary)**: PASS — all active A.4.a (WD), A.4.b (AB), A.4.c.0 (COE),
  A.2.c probe (FGA) chapters are complete and correct with no must-fix findings.
- **Route C (Riemann–Roch)**: PAUSED per USER standing directive. Blueprint chapters exist for
  all four RR sub-build stages (RR.1–RR.4). Coverage is adequate for re-engagement; no gaps
  in the blueprint chapters themselves.
- **Genus-0 arm (Route A `Pic⁰`-via-AV-wrap candidate)**: DEFERRED — `lem:symmetric_product_to_jacobian`'s birationality step uses RR (iter-199 NOTE confirmed). Candidate (b) (Mumford rigidity `J := Spec k`) is partially built in `AbelianVarietyRigidity.tex` but files are paused.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Chapter is 2994 lines; only the first 775 were read for this review. The covered Lean files include `AbelianVarietyRigidity.lean` (3 sorries, PAUSED), `GmScaling.lean` (2 sorries, PAUSED), `BareScheme.lean` (2 sorries, PAUSED), `RigidityLemma.lean` (0 sorries, DONE), `ChartIso.lean` (0 sorries, DONE), `Genus0BaseObjects.lean` / `Points.lean` (DONE).
  - The first 775 lines covering the Rigidity Lemma chain, Milne additivity, Milne Cor 1.2, and `lem:rational_map_to_av_extends` are all `\leanok` and well-specified.
  - Partial status reflects sorries in PAUSED covered files, not blueprint quality gaps.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:symmetric_product_to_jacobian` birationality proof is RR-gated; iter-199 NOTE correctly placed. ✓
  - `def:symmetric_power_curve` has no Mathlib analogue (scheme-theoretic symmetric power absent); chapter correctly marks this with a `notready`-candidate note.
  - All `\uses{}` chains verified intact; the NOTE introduces no `\uses{}` changes.
  - Route C dependency on birationality was already in STRATEGY.md A.4.d row; not a new finding.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:auslander_buchsbaum_formula_succ_pd`: correctly added as standalone block. `\lean{RingTheory.auslander_buchsbaum_formula_succ_pd}`, `\uses{thm:auslander_buchsbaum, lem:depth_drops_by_one}`. No `\leanok` (declaration not yet in Lean file — correct). ✓
  - `lem:depth_drops_by_one`: correctly added. `\lean{RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular}`, `\uses{def:depth, lem:depth_via_ext}`. Proof block has `\leanok` (closed iter-198 — correct). ✓
  - Per-gap dependency diagram in `\subsec:succ_pd_gap_sequence` is accurate: gap (4) CLOSED, gaps (1)-(3) open. The diagram sequences (1)→(3)→assembly correctly; gap (2) independent.
  - The `\section{Lean encoding}` optimistic opening ("Mathlib already exposes substantial parts") is superseded by the iter-184 NOTE empirical audit further down confirming gaps (i)-(iv). No contradiction: the "substantial parts" (RegularSequence, depth API) do exist; only the AB-formula-specific sub-ingredients are absent.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:smooth_to_regular_local_ring`: iter-199 `\lean{AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth}` pin added. ✓
  - `lem:stage6_regular_stalk_assembly`: iter-199 NOTE replaces `_aux` pin with "in-body assembly pattern" explanation. ✓ The NOTE clearly says to treat 6.C as the body of `isRegularLocalRing_stalk_of_smooth` rather than a separately-pinned declaration.
  - `thm:weil_divisor_obstruction`: `\lean{}` intentionally DETACHED (iter-179 NOTE still present and explains the pullback-machinery gap). Correct state.
  - All `\uses{}` chains intact: `lem:smooth_algebra_krull_dim_formula` (6.A), `lem:cotangent_kahler_over_field` (6.B), `lem:stage6_regular_stalk_assembly` (6.C) chain correctly set up.
  - Cascade-to-consumers paragraph accurately describes which sorries close on Stage 6 landing.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\cref{df:Pfs}` → `\cref{def:rel_pic_sharp}` fix: **verified correct**. In `Sorry 1`, the text now reads "the functor of \cref{def:rel_pic_sharp} specialised to X = C". The label `def:rel_pic_sharp` is the label in `Picard_RelPicFunctor.tex` for `AlgebraicGeometry.Scheme.PicSharp` = Kleiman's relative Picard presheaf (`df:Pfs`). **This was the right target** — `df:Pfs` defines the relative Picard functor (presheaf), which maps directly to `def:rel_pic_sharp`. The alternative candidate `def:rel_pic_etale_sheafification` (Kleiman's `\Pic_{(X/S)\et}`) would have been wrong; the broken reference was in the context of the `HasPicSharp` typeclass, which holds the presheaf (not the sheafification). ✓
  - Sorry-by-sorry closure order table: rank-1/2/3 partition accurate. Sorries 1-2-3 (gated on A.1.c/A.2.b sibling chapters), Sorry 4 (`smoothProperQuotient`, rank 2, recommended first attempt), Sorries 5-6-7 (rank 3, Route C blocked).
  - The `\uses{}` chain in the internal-consistency check is verified: `lem:line_bundle_quot_correspondence` ← A.1.b labels ✓; `thm:fga_pic_representability` ← `def:pic_scheme`, sibling labels ✓; `thm:pic_is_group_scheme` ← `def:pic_scheme`, sibling labels ✓.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - A.2.a sub-row; bypassed and deferred. Lean file has 7 sorries. Blueprint chapter has declarations present but the Lean skeleton is a deferred deliverable.

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - A.3.i EXCISED per Pic⁰ pivot. Lean file has 9 sorries and is deferred. Blueprint chapter exists as spec; no Lean skeleton yet created.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Gated on A.3.vii + A.2.c. Blueprint chapter has A.3.iii–vi declaration specs but no Lean skeleton yet. 5 sorries in covered file.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - A.2.b bypassed via Cartier route. 12 sorries in covered file. Blueprint chapter has significant detail on Grassmannian sub-build. Deferred.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - Five declarations (`PicSharp`, `PicSharp.functorial`, `PicSharp.presheaf`, `PicSharp.etSheaf`, `PicSharp.etSheaf_group_structure`) carry placeholder Lean bodies (constant PUnit functor, zero AddMonoidHom, zero NatTrans). These bodies satisfy the types but do not implement the stated mathematics.
  - `% NOTE (iter-199 plan agent)` blocks on each affected declaration are present, explicitly warning "DO NOT promote to `\leanok`" until the `Scheme.Modules.tensorObj` upstream gap is closed. The iter-199 blueprint-writer `rpf-placeholder-note` has addressed this. ✓
  - `thm:rel_pic_etale_sheaf_group_structure` carries `\leanok` on the statement block because the weakened `Nonempty (presheaf C ⟹ etSheaf.obj)` type is satisfied by `⟨0⟩`. The NOTE correctly says not to upgrade this weak statement to the canonical sheafification-unit form until the gap is closed. The forward-looking `thm:rel_pic_etale_sheaf_unit_canonical` (no `\leanok`) holds the canonical form.
  - All `\uses{}` chains verified: chain rooted in `Picard_LineBundlePullback.tex`, no forward references to chapters that don't exist on disk. ✓
  - Lane RPF HELD this iter; `correct: partial` is documented and does not block any prover.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSED. Blueprint chapter is thorough (dedicated to `H¹(skyscraperSheaf P k̄) = 0`). 2 sorries in covered file.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSED. 3 sorries in covered file (`sheafOf` def body structurally blocked).

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Route C PAUSED, but the chapter is thoroughly specified. All sub-claim lemmas for the non-constant-rational corollary (sub-claims a/b/c from iter-196) are present with `\lean{...}` pins. 3 sorries in covered file.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSED (Lane RCI HELD). 3 sorries in covered file.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSED. 1 sorry in covered file.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:rationalMap_order_finite_support`: iter-199 standalone block verified. Has `\lean{AlgebraicGeometry.Scheme.rationalMap_order_finite_support}` (the public `[IsLocallyNoetherian X]` declaration), `\uses{def:order_at_point, def:prime_divisor}`, complete proof sketch following Hartshorne II.6.1 / Stacks 02RV, `% SOURCE QUOTE PROOF:` verbatim. No `\leanok` on statement or proof (correct — the public declaration still carries a sorry; the iter-199 prover builds only the private `[IsNoetherian X]` helper). ✓
  - `def:principal_divisor` now correctly has `\uses{..., lem:rationalMap_order_finite_support}` in its `\uses{}` annotation. ✓
  - Hypothesis-health paragraph in the new lemma correctly explains the `[IsNoetherian X]` vs. `[IsLocallyNoetherian X]` split and why the public signature stays weaker. ✓
  - No `\uses{}` chain breakage introduced. All existing labels confirmed present.
  - Route C fence note still present (SCOPE FENCE on L538/L1108 — correct; those are the RR.1 sorries that Lane WD-A4a must not touch).

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `thm:rigidity_over_kbar` is a named gap (sorry); the chapter itself explicitly documents this as a fallback route (route (a)) with gapped prerequisites (gap i = global cotangent-triviality ~800–1500 LOC, gap ii = Serre duality ~3000–8000 LOC). Not on the critical path; Route C PAUSED.
  - Chapter correctly notes that the chart-algebra envelope (`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`, `lem:constants_integral_over_base_field`) supplies only the CONVERSE direction of `df = 0 ⟹ constant`, not the `df = 0` production itself.

## HARD GATE verdicts (active prover lanes)

### `WeilDivisor.lean` → `RiemannRoch_WeilDivisor.tex`: **CLEAR**

Chapter is `complete: true`, `correct: true`. No must-fix findings. The iter-199
`lem:rationalMap_order_finite_support` standalone block is present, well-specified, and
correctly placed in the `\uses{}` graph. Prover may proceed on Lane WD-A4a-Noeth.

### `AuslanderBuchsbaum.lean` → `Albanese_AuslanderBuchsbaum.tex`: **CLEAR**

Chapter is `complete: true`, `correct: true`. Iter-199 additions
(`lem:auslander_buchsbaum_formula_succ_pd` + `lem:depth_drops_by_one`) are correctly placed.
`\uses{}` chains intact. Prover may proceed on Lane AB-gap1.

### `CodimOneExtension.lean` → `Albanese_CodimOneExtension.tex`: **CLEAR**

Chapter is `complete: true`, `correct: true`. Iter-199 `\lean{...}` pin on
`lem:smooth_to_regular_local_ring` and NOTE on `lem:stage6_regular_stalk_assembly` are
correct. The target sub-gap (6.B `lem:cotangent_kahler_over_field`) is present with detailed
proof sketch and `\lean{Algebra.KaehlerDifferential.cotangent_iso_residue_tensor_kaehler}`.
Prover may proceed on Lane COE-stage6-iiA.

### `FGAPicRepresentability.lean` → `Picard_FGAPicRepresentability.tex`: **CLEAR**

Chapter is `complete: true`, `correct: true`. Iter-199 `\cref{df:Pfs}` → `\cref{def:rel_pic_sharp}`
fix is correct (`def:rel_pic_sharp` was the right target). Sorry 4 (`smoothProperQuotient`, rank 2)
proof sketch is detailed and actionable. Prover may proceed on Lane FGA-sorry4.

## Cross-chapter notes

- `Picard_FGAPicRepresentability.tex` / `thm:pic_is_group_scheme` uses
  `\cref{thm:relative_pic_quotient_well_defined}` (from `Picard_LineBundlePullback.tex`). This
  label is confirmed to exist in `Picard_LineBundlePullback.tex`. ✓
- `Albanese_Thm32RationalMapExtension.tex` / `thm:rational_map_to_av_extends` references
  `\cref{thm:codim_one_extension}` and `\cref{lem:milne_codim1_indeterminacy}` from
  `Albanese_CodimOneExtension.tex`. Both labels confirmed present. ✓
- `Albanese_AuslanderBuchsbaum.tex` note: the iter-183 "HARD BAR — land minimal-resolution
  carving substrate axiom-clean" in `lem:auslander_buchsbaum_formula_succ_pd` correctly
  matches the Lane AB-gap1 objective in PROGRESS.md. ✓

## Unstarted-phase blueprint proposals

Re-evaluation of the three iter-198 proposals deferred by the iter-199 plan:

### Re-evaluation: `Picard_CarrierSoundnessProbe.tex`
Verdict: **Deferral confirmed — chapter not needed.** The carrier-soundness probe is fully
documented inside `Picard_FGAPicRepresentability.tex` (§ "Sorry-by-sorry closure order",
§ "Internal-consistency check"). VERDICT CONFIRMED by iter-198/199 review; no dedicated
chapter warranted. The probe work is complete.

### Re-evaluation: `Picard_PicDSubstrate.tex` (A.4.d.0)
Verdict: **Deferral confirmed.** A.4.d.0 (Pic^d substrate) is gated on A.2.c + A.3.vii + RR
(Route C). All three are substrate-blocked under the current standing directive. Writing this
chapter now would require Route C re-engagement decisions not yet made. Defer until after
the Route C / A.2.c resolution.

### Re-evaluation: `Albanese_TangentSpaceSubstrate.tex` (A.3.0)
Verdict: **Deferral confirmed.** A.3.0 (tangent-space substrate, ~200–400 LOC) is priority-3
parallel but all its downstream consumers (A.3.iii, A.3.iv) are gated on A.2.c, which is
substrate-blocked on RR. Writing this chapter before A.2.c unblocks would be premature.
Relevant material is partially in `Picard_Pic0AbelianVariety.tex` and
`Picard_IdentityComponent.tex`; adequate for planning purposes.

### New proposal: `Picard_TensorObjSubstrate.tex` (A.1.c.SubT — `Scheme.Modules.tensorObj`)
**Why now**: A.1.c.SubT is priority-2.5 and directly gates A.1.c body closure. The only
current coverage is a NOTE in `Picard_RelPicFunctor.tex` §"Gate annotation" (≈30 lines).
A blueprint chapter would enable a dedicated prover lane to build the tensor-product
`AddCommGroup` structure on `LineBundle.OnProduct` without further direction from the plan
agent. The iter-198 review did not propose this, but the iter-199 plan's iter-200 commitments
explicitly list "Lane RPF: dispatch `Scheme.Modules.tensorObj` upstream-style substrate build".

**Assessment**: The A.1.c.SubT work is upstream-style Mathlib build (~200–400 LOC). Writing
a blueprint chapter would be cheap (mostly API-mapping; the mathematical content is
`PresheafOfModules.Monoidal.tensorObj` + `Module.tensorProduct` lift). However, Route A
bottom-up priority says prover capacity flows to ungated priority-1 roots first; A.1.c.SubT
is priority-2.5 and should not be dispatched before A.4.a and A.4.b close. **Recommended
action: defer until iter-200+ when A.4.a substrate lands; then dispatch a blueprint-writer
for A.1.c.SubT before dispatching a prover.** Record deferral rationale in
`iter/iter-199/plan.md`: "A.1.c.SubT chapter deferred iter-199: priority-1 roots A.4.a/A.4.b
still in progress; SubT blueprint needed before iter-200+ RPF prover dispatch."

## Severity summary

### Must-fix-this-iter

The following chapters have `correct: partial` or `complete: partial` statuses that, per the
gate rules, land here:

1. **`Albanese_AlbaneseUP.tex`** — `complete: partial` (RR-gated birationality in
   `lem:symmetric_product_to_jacobian`, `def:symmetric_power_curve` has no Mathlib scheme
   analogue). **Action taken this iter**: iter-199 NOTE added by plan agent. Lane HELD. No
   additional writer action needed; the partial status is by-design and fully documented.
   Record in `iter/iter-199/plan.md` under "deferred prover lanes".

2. **`Picard_RelPicFunctor.tex`** — `correct: partial` (five placeholder Lean bodies; `\lean{...}`
   hints point at declarations that don't implement the stated mathematics). **Action taken this
   iter**: blueprint-writer `rpf-placeholder-note` dispatched and NOTEs are in place. Lane RPF
   HELD. No additional writer action needed this iter; the partial status is documented and
   `sync_leanok` guards are active via the NOTE annotations.

3. **`Albanese_AlbaneseUP.tex` + all Route C paused chapters**: `complete: partial` due to
   sorries in covered Lean files. PAUSED by USER standing directive. No writer dispatch
   warranted for Route C chapters; record skip rationale.

4. **unstarted-phase proposal: A.1.c.SubT** — dispatch blueprint-writer for
   `Picard_TensorObjSubstrate.tex` OR record explicit deferral in `iter/iter-199/plan.md`.
   Recommended: record deferral with one-line rationale (see § Unstarted-phase proposals above).

Overall verdict: **4 active prover lanes gate CLEAR; all iter-199 blueprint edits correctly
applied; `def:rel_pic_sharp` was the right replacement for `\cref{df:Pfs}`; no new
strategy-modifying findings; 3 iter-198 unstarted-phase proposals remain deferred; A.1.c.SubT
flagged for iter-200 blueprint-writer dispatch before RPF prover re-engagement.**
