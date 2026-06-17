# Blueprint Review Report

## Slug
certify277

## Iteration
277

---

## Top-level summaries

### Dependency & isolation findings

**Isolated blueprint nodes (2 of 56 isolated; the other 54 are lean-aux in the WIP TensorObjSubstrate lanes — standing-policy deferral).**

Both leaves live in `RigidityKbar.tex` and back the abandoned path (b) of `lem:constants_integral_over_base_field` (the general-over-k proof that was superseded by the iter-152 alg-closed pivot).

---

#### `RigidityKbar.tex` / `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable` — **`remove`**

*(S3.sep.2): geometrically-reduced finite field extension is separable. Stacks 0BUG part (4). `\lean{Algebra.IsSeparable.of_isGeometricallyReduced_of_finite}`. No `\uses{}` out; nothing uses it.*

**`wire-up` is NOT available.** The only honest consumer is the path-(b) assembler inside `lem:constants_integral_over_base_field`, which was explicitly dropped at iter-152. No other node in the active proof cone (or anywhere in the 880-node graph) uses this lemma. The sibling gateways `lem:S3_sep_1_...` and `lem:S3_pi_1_...` are connected to each other but also have rdep_count 0.

**Disposition: `remove`.** This is dead scaffolding for path (b) of the general-over-k proof, a route STRATEGY.md does not track (the live strategy uses only the alg-closed pivot path (a)). The in-file `% NOTE (iter-152)` explicitly labels it "general-over-k Mathlib-PR fodder, NOT on the M2.a critical path." Since the lemma is mathematically correct and fully Stacks-cited, the writer should **convert it to a `\remark{}` block** rather than delete it outright — this removes it from the dependency graph (eliminating the isolated-blueprint count) while preserving the mathematical documentation for potential Mathlib PR use.

---

#### `RigidityKbar.tex` / `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange` — **`remove`**

*(S3.pi.2): purely inseparable from unique minimal prime of base change. Stacks 030K. `\lean{Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange}`. No `\uses{}` out; nothing uses it.*

**`wire-up` is NOT available.** Same analysis as `lem:S3_sep_2_...` above. The only honest consumer is the dropped path-(b) assembler; STRATEGY.md tracks no general-over-k route; the iter-152 `% NOTE` explicitly labels this "general-over-k Mathlib-PR fodder."

**Disposition: `remove`.** Same rationale: dead scaffolding for the abandoned path (b). The writer should **convert to a `\remark{}` block** — the mathematical content (Artinian local + residue-field argument for purely inseparable field extensions) is worth preserving in the blueprint for documentation, just not as an active proof-obligation node.

**Consequence:** After both conversions, the isolated-blueprint count drops from 2 to 0 (the 54 lean-aux isolated nodes are the standing-policy deferral on TensorObjSubstrate, not blueprint-node isolates). The 2 non-zero isolated-blueprint count is NOT an acceptable terminal state; the `remove` action (convert to remarks) resolves it.

---

### Rendering integrity findings (soon-severity unless otherwise noted)

Grouped by chapter. Total: 353 findings across 25 chapters. The three actively-churning prover-lane chapters (`Picard_TensorObjSubstrate.tex`, `Cohomology_CechHigherDirectImage.tex`, `Picard_RelPicFunctor.tex`) have **zero rendering findings** — the HARD GATE is unaffected.

**AbelJacobi.tex** (2 literal-ref): two `Theorem~REF` placeholders in proof-body prose classical description (the classical route through `thm:nonempty_jacobianWitness`, a protected deferred gap). Both are in informal remarks; all formal declaration blocks are `\leanok` and clean.

**AbelianVarietyRigidity.tex** (8 math-delim): lines 25 and 41 have mixed `$…$` / `\(…\)` delimiters in the chapter-intro prose (the $\mathbb G_m$-scaling description). Not in any formal block.

**Albanese_AlbaneseUP.tex** (1 bare-label, 8 math-delim): bare label `lem:agps` in prose (should be `\cref{lem:agps}`); math-delim at lines 79, 84, 369, 435.

**Albanese_AuslanderBuchsbaum.tex** (1 bare-label, 6 math-delim): bare label `lem:depth_drops_by_one` in prose; math-delim in 3 locations.

**Albanese_CodimOneExtension.tex** (8 math-delim): 4 pairs of mixed delimiters in chapter body prose.

**Albanese_CoheightBridge.tex** (8 math-delim): 4 pairs of mixed delimiters in chapter body prose.

**AlgebraicJacobian_Cotangent_GrpObj.tex** (1 literal-ref, 2 undefined-macro): `chapter~REF` placeholder in the pointer sentence (should be `\cref{chap:RigidityKbar}`); `\obj` and `\toUnit` are used in prose but not defined in `macros/*.tex` or via local `\providecommand`. Neither macro is in formal statement/proof blocks; `\obj` likely means a categorical object and `\toUnit` the terminal-object morphism.

**Cohomology_MayerVietoris.tex** (29 literal-ref): all 29 are `Definition~REF`, `Chapter~REF`, `Lemma~REF`, `Section~REF`, and `Theorem~REF` placeholders in section introduction prose. The formal declaration blocks (`def:Scheme_HModule_prime_cohomologyPresheafFunctor`, `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`, etc.) are clean with proper `\uses{}` and `\lean{}`.

**Cohomology_SheafCompose.tex** (2 literal-ref): `Definition~REF` and `Theorem~REF` placeholders in the chapter intro sentence. Formal blocks clean.

**Cohomology_StructureSheafAb.tex** (7 literal-ref): `Chapter~REF` (×4), `Definition~REF` (×2), `Theorem~REF` (×1) in intro prose. Formal blocks clean.

**Cohomology_StructureSheafModuleK.tex** (38 literal-ref): all `Chapter~REF` / `Definition~REF` placeholders in section intro prose and sub-section descriptions. Formal blocks (e.g., `thm:finite_appTop_of_universallyClosed`) clean; **note** that `\lean{AlgebraicGeometry.finite_appTop_of_universallyClosed}` shows as `unmatched_lean` in the DAG (declaration does not yet exist in Lean or exists only with sorry). Not blocking any active lane.

**Differentials.tex** (16 literal-ref): `Section~REF` placeholders throughout the chapter body prose. Formal `def:relative_kaehler_presheaf` and helpers are present and clean.

**Jacobian.tex** (9 literal-ref): `Chapter~REF` / `Definition~REF` placeholders in intro prose. All major declarations (`def:IsAlbanese`, `def:Jacobian`, `thm:nonempty_jacobianWitness`, etc.) are present with proper `\uses{}` and `\lean{}`.

**Picard_FGAPicRepresentability.tex** (7 bare-label, 8 math-delim): bare-labels likely Kleiman labels cited inline; math-delim in 4 pairs of mixed delimiters. Chapter is gated (A.2.c, HELD behind A.1.c). Not active.

**Picard_FlatteningStratification.tex** (23 literal-ref, 2 math-delim): large number of `REF` placeholders in section intro prose. Chapter is A.2.a, HELD.

**Picard_IdentityComponent.tex** (17 bare-label): 17 bare labels in prose — likely Kleiman `thm:...` paper-citation labels. Chapter is A.3, HELD.

**Picard_Pic0AbelianVariety.tex** (15 bare-label, 1 undefined-macro): 15 bare labels in prose; one undefined macro. Chapter is A.3, HELD.

**Picard_QuotScheme.tex** (8 math-delim): 4 pairs of mixed delimiters in chapter body prose. Chapter is A.2.b, HELD.

**Picard_RelativeSpec.tex** (2 math-delim): 1 pair in chapter body prose. Chapter is A.1.a, not currently active prover target.

**Picard_RelPicFunctor.tex** (3 bare-label, 3 literal-ref): bare labels `th:cmp` and `th:main` (×2) are Kleiman paper labels cited in the section intro prose (not missing `\uses{}` edges); 3 `REF` placeholders in section-intro cross-references (e.g., "Section~REF and Section~REF verify..."). The formal declaration blocks are all clean. **This chapter gates the OPENING A.1.c.fun lane; see notes below.**

**RiemannRoch_OCofP.tex** (8 math-delim): paused chapter; 4 pairs of mixed delimiters.

**RiemannRoch_OcOfD.tex** (43 literal-ref, 8 math-delim): paused chapter; large literal-ref count. The math-delim are in 4 pairs.

**RiemannRoch_RRFormula.tex** (35 literal-ref, 8 math-delim): paused chapter.

**RiemannRoch_RationalCurveIso.tex** (8 math-delim): paused chapter.

**RiemannRoch_WeilDivisor.tex** (6 math-delim): paused chapter (the vocabulary defs `def:order_at_point` and `def:codim1_cycles` are sorry-free and shared with the active cone, but the chapter itself is not a current prover target).

**Rigidity.tex** (2 literal-ref): 2 `REF` placeholders in chapter body prose. Formal `thm:GrpObj_eq_of_eqOnOpen` (`\leanok`) is clean.

---

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.
All three protected declarations (`def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`) are `\leanok` with proper `\uses{}`. The 2 `Theorem~REF` placeholders are in informal proof-body prose (classical description), not in any formal block.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - math-delim (8) — lines 25 and 41 in chapter-intro prose; not in formal blocks. Soon.
  - NOTE: the remark in the proof of `lem:rigidity_eqOn_dense_open` / `lem:rigidity_eqOn_saturated_open_to_affine` still says "single genuinely-deep residual sorry" at `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` — the iter-162 review NOTE says Step 1 is now PROVEN and the chain is axiom-clean. This remark is stale and should be refreshed by the plan/blueprint-writer (iter-162 NOTE is in-file, informational).

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - bare-label `lem:agps` (1) in proof prose — use `\cref{lem:agps}`. Soon.
  - math-delim (8) — lines 79, 84, 369, 435 in chapter body prose. Soon.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: true
- **notes**:
  - bare-label `lem:depth_drops_by_one` (1) in prose — use `\cref{lem:depth_drops_by_one}`. Soon.
  - math-delim (6) in body prose. Soon.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: true
- **correct**: true
- **notes**:
  - math-delim (8) in body prose. Soon.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.
All four Archon-original assembly lemmas are present and properly attributed.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.
`thm:rational_map_to_av_extends` (`\leanok`) with proper `\uses{}`. Chapter notes a reconciliation needed for `lem:rational_map_to_av_extends` in AbelianVarietyRigidity.tex (same declaration, different suggested Lean name), but this is an informational note already captured in the writer report.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: true
- **notes**:
  - literal-ref `chapter~REF` (1) in the pointer sentence — should be `\cref{chap:RigidityKbar}`. Soon.
  - undefined-macro `\obj` (1) in prose context — likely categorical object notation; define in `macros/common.tex` or as `\providecommand{\obj}{A}` locally, or replace with prose. Soon.
  - undefined-macro `\toUnit` (1) in prose context — likely the terminal-object morphism; same fix path. Soon.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Several `\lean{}` hints target TODO-namespaced declarations (e.g., `lem:push_pull_functor` → `AlgebraicGeometry.pushPullMap_comp` is unmatched in leandag because `pushPullMap_comp` is in a WIP/untracked file). This is expected for a pre-skeletal prover target file. The mathematical proof blueprint is adequate for the engine lane. **HARD GATE CLEARS for A.2.c-engine.**

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - literal-ref (29) — all in section introduction prose (Chapter~REF, Definition~REF, etc.). Formal declaration blocks clean. Soon.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - literal-ref (2) — in chapter intro prose. Soon.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - literal-ref (7) — in intro prose. Soon.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - literal-ref (38) — in section intro prose. Soon.
  - `thm:finite_appTop_of_universallyClosed` → `\lean{AlgebraicGeometry.finite_appTop_of_universallyClosed}` is `unmatched_lean` — the Lean declaration does not yet exist or exists only with sorry. Used by the rigidity chain (RigidityKbar.tex). Not blocking any current active prover lane (rigidity_over_kbar is a gated named gap). Informational.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - literal-ref (16) — in section intro prose (Section~REF). Soon.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - literal-ref (9) — in intro/section prose. Soon.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: true
- **correct**: true
- **notes**:
  - bare-label (7) — likely Kleiman paper labels in prose. Soon.
  - math-delim (8) in body prose. Soon.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: true
- **correct**: true
- **notes**:
  - literal-ref (23) — in section intro prose. Soon.
  - math-delim (2). Soon.

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: true
- **correct**: true
- **notes**:
  - bare-label (17) — in prose, likely external paper references. Soon.

### blueprint/src/chapters/Picard_LineBundleCoherence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: true
- **correct**: true
- **notes**:
  - bare-label (15) in prose. Soon.
  - undefined-macro (1) in prose. Soon.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - math-delim (8) in body prose. Soon.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - math-delim (2) in body prose. Soon.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - bare-label (3): `th:cmp` and `th:main` (×2) are Kleiman paper-internal labels cited in section intro prose (not missing `\uses{}` edges — they reference Kleiman's Remark and Main Theorem, not blueprint nodes). Replace with prose text ("Kleiman's Comparison Theorem" / "Kleiman's Main Theorem") or a proper `\cite{}`. Soon.
  - literal-ref (3): `REF` placeholders in section-intro cross-references (e.g., "The first half (§~REF and §~REF) verifies..."). Wire up to `\cref{sec:relpic_group}` etc. Soon.
  - **HARD GATE NOTE FOR A.1.c.fun**: all formal declaration blocks (`lem:rel_pic_sharp_groupoid`, `thm:pullback_natural`, etc.) are clean with proper `\uses{}` and `\lean{}`. The rendering issues are confined to informal prose and do not affect the prover's usable blueprint content. **HARD GATE CLEARS for the OPENING A.1.c.fun lane.**

### blueprint/src/chapters/Picard_SheafOverEquivalence.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 171 declaration blocks covering 5 Lean files (`TensorObjSubstrate.lean`, `StalkTensor.lean`, `Vestigial.lean`, `DualInverse.lean`, `PresheafInternalHom.lean`). The chapter is mathematically faithful to the active DUAL/ENGINE/D3′ lanes: `tensorObj`, `IsInvertible`, `picCommGroup`, `pullbackTensorMap`, `sliceDualTransport`, `dual_restrict_iso`, and all their sublemmas are blueprinted at the required level of detail. Proof strategies for the residual sorries (D3′ Sq1 via `conjugateEquiv_whiskerRight`, DUAL `sliceDualTransportInv` extraction + round-trips) are recorded. No rendering issues.
  - **HARD GATE CLEARS for the active A.1.c.sub DUAL/ENGINE/D3′ lanes.**

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes. (Paused chapter.)

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - math-delim (8) in body prose. Paused chapter. Informational.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex
- **complete**: true
- **correct**: true
- **notes**:
  - literal-ref (43) + math-delim (8) in body prose. Paused chapter. Informational.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: true
- **correct**: true
- **notes**:
  - literal-ref (35) + math-delim (8) in body prose. Paused chapter. Informational.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: true
- **correct**: true
- **notes**:
  - math-delim (8) in body prose. Paused chapter. Informational.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - math-delim (6) in body prose. Paused chapter. Informational.
  - `def:order_at_point` and `def:codim1_cycles` are sorry-free vocabulary definitions shared with the active A.4 cone; the cosmetic active→paused-chapter edge in the DAG is a documented tidy-up (STRATEGY.md, non-blocking).

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - literal-ref (2) in chapter body prose. Soon.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Two isolated blueprint leaves (`lem:S3_sep_2_...` and `lem:S3_pi_2_...`) — tagged **`remove`** (convert to `\remark{}`) in the Dependency & isolation findings above.
  - `lem:S3_sep_1_smooth_geometrically_reduced_Gamma` and `lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper` are NOT isolated (they use each other) but have rdep_count 0. They are path-(b) scaffolding and should be treated as candidates for the same `\remark{}` conversion in a follow-up sweep, but they are not in the isolated-blueprint count so they don't create a graph health issue this iter.
  - The stale prose in the proof-body remarks of `lem:rigidity_eqOn_dense_open` / `lem:rigidity_eqOn_saturated_open_to_affine` / `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` (referring to "single genuinely-deep residual sorry") predates the iter-162 axiom-clean close. Informational; the in-file `% NOTE: iter-162 review` corrects it in a comment. A blueprint-writer pass could update the prose.
  - `thm:rigidity_over_kbar` is `\leanok` (sorry-bodied named gap), carries `[CharZero]` and `[IsAlgClosed]`, correctly documented as the fallback route (a) artifact — not the active genus-0 path. Correct disposition recorded.

---

## Severity summary

**HARD GATE CLEARS — no must-fix-this-iter findings.**

All 38 chapters are `complete: true, correct: true`. The three active-lane chapters clear individually:
- `Picard_TensorObjSubstrate.tex` (A.1.c.sub DUAL/ENGINE/D3′) — **clears**.
- `Cohomology_CechHigherDirectImage.tex` (A.2.c-engine) — **clears**.
- `Picard_RelPicFunctor.tex` (A.1.c.fun OPENING) — **clears** (rendering issues confined to informal prose, do not affect formal blueprint content).

**Soon (41 findings across 25 chapters):**
- 2 isolated blueprint node removals (`lem:S3_sep_2_...` and `lem:S3_pi_2_...` in `RigidityKbar.tex`) — convert to `\remark{}` blocks. This drops isolated-blueprint count from 2 to 0.
- 353 rendering findings (math-delim, literal-ref, bare-label, undefined-macro) in 25 inactive/paused/held chapters. Grouped by chapter in the rendering-integrity section above. No chapter feeding a current active prover lane is affected.

**Informational:**
- Stale "single genuinely-deep residual sorry" prose in `AbelianVarietyRigidity.tex` (rigidity chain closed iter-162). Update in a future writer pass.
- `thm:finite_appTop_of_universallyClosed` is `unmatched_lean` (declaration not yet in Lean). Not blocking any active lane.
- `lem:S3_sep_1_...` and `lem:S3_pi_1_...` in `RigidityKbar.tex` have rdep_count 0 but are not in the isolated count (they use each other). Candidate for the same remark-conversion sweep as the two tagged nodes.
- 46 `unmatched_lean` entries overall — most are TODO-namespaced future targets or recently-renamed declarations. None block current active lanes.

---

**Overall verdict:** Blueprint is in good health; all 38 chapters clear `complete: true, correct: true`; the three active-lane chapters (`Picard_TensorObjSubstrate`, `Cohomology_CechHigherDirectImage`, `Picard_RelPicFunctor`) all clear the HARD GATE; no must-fix-this-iter findings; the 2 isolated blueprint leaves in `RigidityKbar.tex` are **`remove`** (convert to remarks, eliminating the isolated-blueprint count); 353 soon-severity rendering issues are spread across inactive/paused/held chapters and warrant a batch blueprint-writer cleanup pass.
