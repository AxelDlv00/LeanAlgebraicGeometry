# Blueprint Review Report

## Slug
br258

## Iteration
258

## Top-level summaries

### Incomplete parts

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map_basechange` (D3′): The Sq2b sub-step ("monoidality of `pullbackComp`") is absent from the proof sketch — only the `comp_δ` decomposition and the (now-known-rfl) ring-map reconciliation are discussed. The genuine Mathlib-absent step needs its own named sub-lemma in the sketch.
- `Picard_LineBundleCoherence.tex` / `lem:lbc_chart_presentation`: The proof sketch elides the entire categorical bridge between `SheafOfModules (U_i:Scheme).ringCatSheaf` (open-subscheme site) and `SheafOfModules (X.ringCatSheaf.over U_i)` (slice site). The NOTE at L205–215 says a prover following the sketch verbatim hits an immediate type mismatch; a declaration block for `chartOverIso` (= `SheafOfModules.overEquivalence`, the SHARED ROOT) is required.
- **`Picard_SheafOverEquivalence.tex` does not exist** — the SHARED ROOT lane (`Picard/SheafOverEquivalence.lean`) has no blueprint coverage.

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map_basechange` Sq2: The sketch describes the ring-map reconciliation `toRingCatSheafHom_comp_hom_reconcile` as a "genuine prerequisite" transported by pseudofunctor-coherence bookkeeping atoms. This is factually wrong — the NOTE at L3959–3971 confirms it closes by `rfl`. The description leads a prover to build scaffolding that is not needed, while the actual hard step (Sq2b) goes unmentioned.

### Lean difficulty quality

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map_basechange`: The `\lean{pullbackTensorMap_restrict}` hint is correct, but the proof sketch's Sq2 paragraph overstates one sub-step (ring-map reconciliation) and omits another (Sq2b monoidality). A prover reading only the blueprint would spend effort on the wrong obstacle.

### Citation discipline

No citation-discipline findings. All blocks feeding active prover routes have well-formed `% SOURCE:` / `% SOURCE QUOTE:` / `\textit{Source:}` citations.

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Picard_SheafOverEquivalence.tex`

**Covers**: `AlgebraicJacobian/Picard/SheafOverEquivalence.lean`
**Strategy phase**: SHARED ROOT — `SheafOfModules.overEquivalence` (iter-257 finding; closes BOTH the engine `chartOverIso` and the dual `sliceDualTransport`)
**Why now**: Every iter of delay on this chapter defers two independent prover lanes (LineBundleCoherence engine + DualInverse dual chain); the math is fully understood (mirror of `overSliceSheafEquiv` at the `SheafOfModules` level) and the writer only needs the module-category analogue of `Opens.overEquivalence`.

**Key declarations** (in dependency order):

1. `\definition` `\label{def:sheafofmodules_over_equivalence}` — The category equivalence `SheafOfModules.overEquivalence : SheafOfModules (X.ringCatSheaf.over U) ≌ SheafOfModules (X|_U.ringCatSheaf)`, the modules-level lift of `Opens.overEquivalence U : Over U ≌ Opens ↥U` (Mathlib TODO `Topology/Sheaves/Over.lean:19–22`), transporting the ring-sheaf through the slice-site change. `\lean{AlgebraicGeometry.SheafOfModules.overEquivalence}` [expected]. Source: Archon-original (no direct external source; mirrors `AlgebraicGeometry.overSliceSheafEquiv` at the module level).

2. `\lemma` `\label{lem:sheafofmodules_over_unit_iso}` — The unit of `overEquivalence` identifies `M.over U` with the pullback of `M` to the slice site; at the unit object `SheafOfModules.unit (X.ringCatSheaf.over U) ≅ (SheafOfModules.unit X.ringCatSheaf).over U`. `\lean{AlgebraicGeometry.SheafOfModules.overEquivalence_unit_iso}` [expected]. Source: Archon-original (required for `chartOverIso`).

3. `\lemma` `\label{lem:chart_over_iso}` — For every open affine `U ⊆ X` and every `M : X.Modules`, the `SheafOfModules.over` of `M` at `U` is isomorphic to `SheafOfModules.unit (X.ringCatSheaf.over U)` whenever `M` is locally trivial on `U`; more precisely, `chartOverIso : M.over U ≅ SheafOfModules.unit (X.ringCatSheaf.over U)` transports the trivialisation iso from the open-subscheme site to the slice site via `overEquivalence`. `\lean{AlgebraicGeometry.Scheme.Modules.chartOverIso}` [expected]. Source: Archon-original; this is the SOLE remaining sorry in `LineBundleCoherence.lean`.

4. `\lemma` `\label{lem:slice_dual_transport_via_over}` — `sliceDualTransport` (the leg-(A) atom of `dual_restrict_iso` Step-4) may alternatively be derived via `overEquivalence`: the Hom functor commutes with the slice-site change, so `dual(M.over U) ≅ (dual M).over U` via the equivalence. `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport_via_overEquivalence}` [expected]. Source: Archon-original; relates to the dual lane but is a consequence of the equivalence, not the primary proof route.

**`\uses` skeleton**:
- `lem:chart_over_iso` uses `def:sheafofmodules_over_equivalence`, `lem:sheafofmodules_over_unit_iso`
- `lem:slice_dual_transport_via_over` uses `def:sheafofmodules_over_equivalence`

**Main theorem proof strategy**: The equivalence `overEquivalence` is constructed by transporting `Opens.overEquivalence` from the sheaf-of-types level to the sheaf-of-modules level: the ring sheaf `X.ringCatSheaf.over U` is identified with the ring sheaf of the open subscheme `X|_U` via the `restrictScalars` reconciliation (the existing `overSliceSheafEquiv` handles the fixed-value-category case; the varying-ring case requires carrying the ring-sheaf identification). The key difficulty is that the pushforward functor along the slice change must be shown to intertwine the ring-module structures; `restrictScalars` coherence and the `HomEquiv` of the fully-faithful `opensFunctor` are the two technical inputs (both already available in the project from the `homOfLocalCompat` proof and from `dual_restrict_iso`). Approximately 200–350 LOC; new file `AlgebraicJacobian/Picard/SheafOverEquivalence.lean`.

**References for writer**:
- `analogies/dualstep4-257.md` → leg-(A) `sliceDualTransport` skeleton, directly parallel to `overEquivalence`; the Hom-set bijection and `eqToHom`-conjugation recipe carry over
- `informal/chartOverIso.md` → problem statement and existing wall description for the engine lane
- `task_results/lean-vs-blueprint-checker-lvb-lbc257.md` → type-mismatch details for `chartPresentation`
- Mathlib `Topology/Sheaves/Over.lean` L19–22 (the TODO this implements); `SheafOfModules` `Presheaf/Monoidal.lean`

**Subphase choices exposed**:
- Equivalence-first vs. iso-first: Build the full equivalence `overEquivalence` and derive `chartOverIso` as a corollary, OR prove `chartOverIso` directly (just the unit-to-unit iso at the specific object) without the full equivalence. Recommendation: equivalence-first — the full equivalence also closes `sliceDualTransport_via_overEquivalence` for free and gives the clean reusable construct; the iso-only route saves ~80 LOC but leaves the dual lane still needing its own approach.

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `lem:pullback_tensor_map_basechange` (D3′) Sq2 prose — ring-map reconciliation (`toRingCatSheafHom_comp_hom_reconcile`) described as "non-trivial" / "transported by pseudofunctor coherence". The NOTE at L3959–3971 (added by iter-257 review agent) states this is DISPROVEN: the step closes by `rfl` at default transparency. The stale prose has not been corrected by bw257-d3.
  - `lem:pullback_tensor_map_basechange` Sq2b MISSING — the genuine Mathlib-absent step (monoidality of `pullbackComp`, i.e. `comp_δ` transports through `pullbackComp` via mate calculus mirroring `isMonoidal_comp`) has no sub-step block or narrative in the sketch. The NOTE at L3965–3971 calls this out explicitly and says "Blueprint-writer must rewrite this paragraph and add the Sq2b sub-step."
  - `lem:dual_restrict_iso` (DualInverse lane, `sliceDualTransport` leg-A) — well-documented at L5671–5698 with detailed proof sketch. No findings on this block.
  - All other blocks in the chapter (D1′/D2′, `tensorObj_restrict_iso`, group-law bricks) appear complete and correct.
  - **Must-fix scope**: D3′ prover lane only. DualInverse prover lane is unaffected.

### blueprint/src/chapters/Picard_LineBundleCoherence.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `lem:lbc_chart_presentation` proof sketch — elides the categorical bridge between the open-subscheme-site `e_i : M|_{U_i} ≅ struct(U_i)` and the slice-site `Presentation.ofIsIso` call. The NOTE at L205–215 (iter-257 review) confirms: "A prover following this sketch verbatim hits an immediate type mismatch." The missing block is `chartOverIso` = `SheafOfModules.overEquivalence`, the SHARED ROOT.
  - `thm:lbc_isFinitePresentation` and `lem:lbc_trivializing_cover` / `cor:lbc_isFiniteType` / `lem:lbc_rank_flat` all look complete and correct.
  - The `\leanok` markers on `thm:lbc_isFinitePresentation` etc. presuppose `chartPresentation` closing, which is the blocker; the sorry count in the Lean file will remain 1 until `chartOverIso` lands.
  - **Fix path**: dispatch blueprint-writer for `Picard_SheafOverEquivalence.tex` (unstarted-phase proposal above), then update `lem:lbc_chart_presentation` proof to cite `def:sheafofmodules_over_equivalence` / `lem:chart_over_iso`.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - `\uses{\leanok ...}` corruption at L145: the `\leanok` macro appears inside the `\uses{...}` argument of the `lem:rel_pic_sharp_groupoid` proof block, making `\leanok` look like a label reference. Blueprint-doctor catches this every iter. PROGRESS.md iter-257 claims the planner fixed it at `Picard_RelPicFunctor.tex:145`, but the corruption is still present at that line. Must-fix regardless of lane status — this is a broken `\uses{}` syntax that will confuse the dependency graph.
  - All substantive proof sketches and `\lean{...}` hints are accurate for the lane's current objectives.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Incomplete sentence at L43–44: `"see~\)"` after the Hilbert polynomial definition — this is an unresolved cross-ref placeholder that truncates the sentence. DEFERRED lane (A.2.b), no active prover.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Several `Section~REF` and `Theorem~REF` internal cross-ref placeholders (unchanged from prior audit). GATED lane (A.3), no active prover.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Forward-looking `Theorem~REF` placeholders in several `\uses{...}` blocks. GATED lane (A.3), no active prover.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:base_change_map_affine_local` and `lem:pushforward_base_change_mate_cancelBaseChange` carry no proof bodies — intentional: both are recorded as Mathlib-absent "named obligations". No `\leanok` on either block, consistent with held-lane status. Not a new finding; unchanged from prior iter.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Similar to FlatBaseChange: the chapter uses `[HasInjectiveResolutions]`-gated infrastructure. HELD lane, no active prover.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Chapter~REF` and `Definition~REF` cross-ref placeholders. PAUSED (Route C arc), unchanged from prior audit.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Theorem~REF` and `Definition~REF` placeholders. PAUSED, unchanged.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Chapter~REF` and `Definition~REF` placeholders throughout. PAUSED, unchanged.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:symmetric_product_to_jacobian` proof: birationality argument invokes Riemann–Roch (`h⁰(D) - h¹(D) = deg(D) + 1 - g`). The NOTE at L415–422 records this is gated on Route C re-engagement. GATED lane (A.4), no active prover.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - "The Lean target file does not yet exist" (L28). All declaration blocks are forward-spec. GATED lane (A.4.c).

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `REF` cross-ref placeholders in the notation section (unresolved `\cref`). GATED lane (A.4.a).

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Setup section has at least one sentence fragment with apparent incomplete cross-ref. GATED lane (A.4.b).

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — (assessed above in its own block)

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes (Route C PAUSED, no active prover).

### blueprint/src/chapters/RiemannRoch_OcOfD.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `REF` cross-ref placeholders for sibling chapters. Route C PAUSED.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `REF` cross-ref placeholders (L22, L24). Route C PAUSED.

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `REF` cross-ref placeholders. Route C PAUSED.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes (Route C PAUSED).

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes (Route C PAUSED).

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Chapter~REF` and `Definition~REF` cross-ref placeholders. GATED on Jacobian.tex delivery; no active prover.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Theorem~REF` placeholders for downstream gates. No active prover.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes (explicitly held fallback route).

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Section~REF` and `Chapter~REF` cross-ref placeholders. HELD lane.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

## Cross-chapter notes

- `Albanese_Thm32RationalMapExtension.tex` and `AbelianVarietyRigidity.tex` both declare `lem:rational_map_to_av_extends` / `thm:rational_map_to_av_extends` pointing at different Lean names (`extend_to_av` under two namespaces). The plan agent noted a reconciliation pass is needed; no prover is dispatched on this yet, so it doesn't block anything this iter.
- `Picard_LineBundleCoherence.tex` → `Picard_SheafOverEquivalence.tex` (proposed): the proof of `lem:lbc_chart_presentation` must eventually cite `lem:chart_over_iso` from the new chapter. Until that chapter exists the proof sketch remains incomplete. The LBC chapter should be treated as pending the new chapter's authoring.

## Severity summary

### must-fix-this-iter

1. **Unstarted-phase proposal: SHARED ROOT** — dispatch blueprint-writer for `blueprint/src/chapters/Picard_SheafOverEquivalence.tex` (outline above). Without it, `Picard/SheafOverEquivalence.lean` has no backing chapter and the iter's primary prover lane cannot start. This also gates the eventual fix for `lem:lbc_chart_presentation`.

2. **`Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map_basechange` D3′ Sq2** — (a) Stale prose: ring-map reconciliation still described as "non-trivial / transported by pseudofunctor coherence" — it is `rfl`. (b) Missing Sq2b sub-step: the genuine Mathlib-absent monoidality-of-`pullbackComp` step has no sketch. Blocks the D3′ prover lane. NOTE at L3959–3971 is an open must-fix directive not acted on by bw257-d3. **Dispatch blueprint-writer for `Picard_TensorObjSubstrate.tex` targeting the Sq2/Sq2b paragraph.**

3. **`Picard_LineBundleCoherence.tex` / `lem:lbc_chart_presentation`** — missing `chartOverIso` bridge block. Proof sketch leads prover to a type mismatch. Fix path: author `Picard_SheafOverEquivalence.tex` (item 1) then update the proof to cite it. **This finding is contingent on item 1** — dispatch is implied by the SheafOverEquivalence writer directive.

4. **`Picard_RelPicFunctor.tex` L145** — `\uses{\leanok ...}` corruption persists despite PROGRESS.md iter-257 claiming a fix. `\leanok` inside `\uses{...}` is a broken cross-ref syntax that confuses the dependency graph and blueprint-doctor. **Remove `\leanok` from inside the `\uses{...}` of `lem:rel_pic_sharp_groupoid`'s proof block.** (Can be a one-line planner-direct edit — no writer needed.)

### soon

- `Picard_QuotScheme.tex` L43–44: incomplete sentence `"see~\)"` (unresolved cross-ref in HELD lane).
- Multiple PAUSED/GATED chapters (`IdentityComponent`, `Pic0AbelianVariety`, `AlbaneseUP`, Albanese sub-rows, RR.*,  Cohomology.*): `Theorem~REF` / `Section~REF` / `Chapter~REF` placeholders — unchanged from prior audits, none blocking active routes.
- `Albanese_AlbaneseUP.tex` / `lem:symmetric_product_to_jacobian`: birationality proof is Route C gated (NOTE L415–422) — no active prover, but the NOTE should be escalated when Route C re-engagement is considered.

Overall verdict: HARD GATE FAILS on 3 fronts — the primary lane `Picard/SheafOverEquivalence.lean` has no blueprint chapter (proposal provided for immediate writer dispatch), the D3′ Sq2/Sq2b proof sketch in `Picard_TensorObjSubstrate.tex` has stale incorrect framing and a missing Mathlib-absent sub-step (writer needed), and the `\uses{\leanok}` corruption in `Picard_RelPicFunctor.tex` persists (planner-direct fix). 1 unstarted-phase proposal, 37 chapters audited, 4 must-fix findings.
