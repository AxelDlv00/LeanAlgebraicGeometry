# Blueprint Review Report

## Slug
br257

## Iteration
257

## Top-level summaries

### Incomplete parts

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map_basechange` (D3′): STATEMENT still
  describes the base-change-square specialization (open immersion j : U → X, restriction g :
  f⁻¹U → U). The Lean decl `pullbackTensorMap_restrict` proves the GENERAL composition coherence
  for any h : Z → Y, f : Y → X. The statement must be realigned to the general form. The
  `% NOTE (review iter-256)` embedded in the chapter records this mismatch but the actual text
  has not been updated.

- `Picard_LineBundleCoherence.tex` / `thm:lbc_isFinitePresentation` proof sketch: names
  `SheafOfModules.IsFinitePresentation.mk` as the closing call but does not specify the
  finiteness bridge (`Presentation.ofIsIso` + Mathlib `IsFinite` instance) that `mk` actually
  requires. A prover following the current sketch would stall at the `mk` call with no recipe.

- `Picard_LineBundleCoherence.tex` / `lem:lbc_chart_presentation` proof block: carries `\leanok`
  but `chartPresentation` is a sorry stub (iter-256 file-skeleton scaffold, no proof body).
  This is a purity violation — a false `\leanok` in an unformalized proof block.

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map_basechange` proof sketch: prescribes
  "same mate calculus as `pullbackObjUnitToUnit_comp`" (homEquiv.injective + conjugateEquiv_pullbackComp_inv).
  This was disproven iter-256 — pullbackTensorMap is NOT an adjunction transpose, so the mirror's
  homEquiv.injective opening stalls. The genuine route is the 4-square comp_δ build:
  Sq1 `sheafificationCompPullback`-comp, Sq4 `pullbackValIso`-comp, Sq2 ring-map reconciliation.
  No hint of this route appears in the current proof sketch.

### Citation discipline

No new citation-discipline findings. `Picard_LineBundleCoherence.tex` citations all use
`references/stacks-modules.tex` (file exists at `references/stacks-modules.tex`); SOURCE QUOTE
blocks present and verbatim; visible `\textit{Source: ...}` lines present; br256 cleared this
chapter. No violations found in the chapters audited this iter.

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

**Covers**: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` (new file; may share a
consolidated chapter with existing `Cohomology_HigherDirectImage.tex` via `% archon:covers` if
the files remain logically linked, or stand as a separate chapter)

**Strategy phase**: A.2.c-engine — `Rⁱf_*` (i ≥ 1), project Čech-build (~800–1200 LOC)

**Why now**: The existing `Cohomology_HigherDirectImage.tex` uses `[HasInjectiveResolutions]` as
an explicit hypothesis, which is absent from Mathlib for `SheafOfModules` over a varying-ring
sheaf of rings (only available for `Sheaf J A` with fixed value category). The engine needs `Rⁱf_*`
for the FlatBaseChange/HigherDirectImage pipeline; writing the Čech-build blueprint now enables
a prover lane to open as soon as A.2.c capacity frees, rather than waiting for another iter.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:cech_nerve}` — the Čech nerve of an affine open cover on a scheme, as
   an augmented simplicial object in `Scheme.Modules`. `\lean{AlgebraicGeometry.CechNerve}` [expected].
   Source: `references/stacks-coherent.tex`, §02KE–02KG (Čech complex approach to `Rⁱf_*`).
2. `\definition` `\label{def:cech_complex}` — the Čech complex `C̃ˑ(𝔘, ℱ)` for a quasi-coherent
   `ℱ` and affine cover `𝔘`, as a complex in the abelian category `QCoh(X)`.
   `\lean{AlgebraicGeometry.CechComplex}` [expected]. Source: `references/stacks-coherent.tex`.
3. `\lemma` `\label{lem:cech_acyclic_affine}` — Čech cohomology of a quasi-coherent sheaf on an
   affine scheme vanishes in positive degrees (Stacks 02KG). `\lean{AlgebraicGeometry.CechAcyclic.affine}` [expected].
   Source: `references/stacks-coherent.tex`, tag 02KG.
4. `\lemma` `\label{lem:cech_computes_cohomology}` — for a separated quasi-compact morphism
   `f : X → S` and an affine open cover of `X`, the Čech complex computes `Rⁱf_*ℱ`.
   `\lean{AlgebraicGeometry.cech_computes_higherDirectImage}` [expected].
   Source: `references/stacks-coherent.tex`, tag 02KE.
5. `\definition` `\label{def:cech_higher_direct_image}` — the unconditional definition of
   `Rⁱf_*(ℱ)` via the Čech complex, without `[HasInjectiveResolutions]`.
   `\lean{AlgebraicGeometry.cechHigherDirectImage}` [expected].
   Source: `references/stacks-coherent.tex`, tags 02KE–02KH.
6. `\lemma` `\label{lem:cech_flat_base_change}` — the flat-base-change isomorphism
   `g^*(Rⁱf_*ℱ) ≅ Rⁱf'_*((g')^*ℱ)` for flat `g`, derived from the Čech computation.
   `\lean{AlgebraicGeometry.cech_flatBaseChange}` [expected].
   Source: `references/stacks-coherent.tex`, tag 02KH.

**`\uses` skeleton**:
- `lem:cech_flat_base_change` uses `def:cech_higher_direct_image`, `lem:cech_computes_cohomology`
- `def:cech_higher_direct_image` uses `lem:cech_computes_cohomology`
- `lem:cech_computes_cohomology` uses `lem:cech_acyclic_affine`, `def:cech_complex`
- `lem:cech_acyclic_affine` uses `def:cech_complex`
- `def:cech_complex` uses `def:cech_nerve`

**Main theorem proof strategy**: Build the Čech complex `C̃ˑ(𝔘, ℱ)` for an affine cover `𝔘`
of `X` using the pushforward `f_*` of each intersection; prove acyclicity on affine opens via
Stacks 02KG (quasi-coherence + affine vanishing); derive that the cohomology of `C̃ˑ(𝔘, ℱ)`
equals `Rⁱf_*ℱ` (Stacks 02KE). The flat-base-change isomorphism follows from the functoriality
of the Čech construction under base change plus the flatness of `g`.

**References for writer**:
- `references/stacks-coherent.tex`, tags 02KE–02KH (quasi-coherence of higher direct images,
  affine vanishing, flat base change) — the direct source for the Čech approach
- `references/stacks-coherent.md` — pointer to relevant lines in stacks-coherent.tex

**Subphase choices exposed**:
- Whether to build a separate `CechHigherDirectImage.lean` or consolidate with
  `HigherDirectImage.lean`: the consolidated approach avoids a new file but risks conflating
  the conditional `[HasInjectiveResolutions]` definition with the unconditional Čech one.
  Recommendation: separate file to keep the `[HasInjectiveResolutions]`-gated definition
  (currently compiled) isolated from the new Čech build.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The rigidity-lemma chain STATUS NOTE at `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`
    proof (`% NOTE: (iter-162 review) STALE as of iter-162 — Step 1 is now PROVEN`) is stale prose
    inside a `% NOTE:` comment, not a missing proof sketch. informational only; no blueprint content at risk.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:symmetric_product_to_jacobian` birationality proof explicitly depends on Riemann–Roch
    (iter-199 NOTE block at line 414-422); gated on Route C PAUSED. Chapter correctly records
    this dependency. No new finding.
  - Chapter contains `NOTE: Alternative route history` dead-code block (retired moduli wording);
    no blueprint labels or `\uses` edges in that block. informational.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Setup section (§sec:ab_setup) uses literal `Definition~REF`, `Lemma~REF`, `Theorem~REF`
    placeholders for within-chapter forward references (the "packages" enumeration at L46–58).
    Standing deferral from PROGRESS.md iter-250. No active prover lane; deferral rationale holds.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Corollary~REF` and `Section~REF` placeholders in §sec:ab_application_to_a4a (L1153+);
    standing deferral from PROGRESS.md. No active prover; deferral rationale holds.
  - Stage 6.C sub-lemma `lem:stage6_regular_stalk_assembly` carries no `\lean{...}` pin
    (iter-199 NOTE: "treat as in-body closure pattern not as separately-pinned Lean declaration").
    Informational; not blocking.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The definition `def:higher_direct_image` carries an explicit `[HasInjectiveResolutions]`
    hypothesis (correctly noted in a `% NOTE (iter-233)` comment); this is an honest description
    of the current Lean body, NOT a blueprint error. The missing Čech-build approach is the
    subject of the unstarted-phase proposal above.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Definition~REF` and `Definition~REF` placeholders for within-chapter cross-references.
    Standing deferral from PROGRESS.md. No active prover; deferral rationale holds.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Definition~REF` placeholder for `def:genus` reference (upstream chapter). Standing
    deferral. No active prover; deferral rationale holds.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Chapter~REF` and `Theorem~REF` placeholders. Standing deferral from PROGRESS.md. No active
    prover; deferral rationale holds.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Section~REF` placeholders (§REF for the "bridge" section and the "converse framing" section).
    Standing deferral from PROGRESS.md. No active prover; deferral rationale holds.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `REF` placeholders (e.g. §sec:Jacobian_routeA4_albaneseUP references) in the Route A
    sub-phase budget section. Standing deferral from PROGRESS.md. No active prover; deferral
    rationale holds.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Theorem~REF` and cross-reference placeholders throughout. Standing deferral from PROGRESS.md.
    No active prover; deferral rationale holds.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Contains `\ ` / stray whitespace reference at §flatstrat_setup: "see~\ below" (PDF render glitch,
    not a blocking blueprint defect). Standing partial status due to placeholder references; deferral
    from PROGRESS.md holds.

### blueprint/src/chapters/Picard_IdentityComponent.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - No Lean file exists yet (`IdentityComponent.lean` does not exist); chapter is the prover-ready
    spec awaiting file scaffold. Chapter content is well-specified.

### blueprint/src/chapters/Picard_LineBundleCoherence.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **MUST-FIX (purity violation)** — `lem:lbc_chart_presentation` proof block carries `\leanok`
    but `chartPresentation` was only scaffolded as a sorry stub in iter-256. The `\leanok` was
    written into the blueprint text by the blueprint-writer but the Lean proof is not closed.
    `\leanok` in a proof block is exclusively managed by `sync_leanok`; a writer should not
    have added it manually (or it was added in error). Must remove the false `\leanok` from
    the proof block before the prover runs.
  - **MUST-FIX (insufficient proof sketch)** — `thm:lbc_isFinitePresentation` proof sketch
    says "Feeding it to `SheafOfModules.IsFinitePresentation.mk` gives `M.IsFinitePresentation`"
    but does not name the `Presentation.ofIsIso` bridge or the Mathlib `IsFinite` instance
    that `mk` requires. A prover following this sketch will stall at the `mk` constructor with
    no route specified. The sketch needs: (1) construct a `QuasicoherentData.IsFinitePresentation`
    from the trivialising cover charts via `Presentation.ofIsIso` applied to the `e_i` isos;
    (2) invoke `SheafOfModules.IsFinitePresentation.mk` with that data; (3) cite the Mathlib
    `instIsFiniteTypeOfIsFinitePresentation` / `instIsQuasicoherentOfIsFinitePresentation` chain
    for the corollary.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - No Lean file exists yet. Chapter is the prover-ready spec (A.3 row). Well-specified.
    Standing deferral from PROGRESS.md.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Section~REF` and internal reference placeholders. Standing deferral from PROGRESS.md.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Multiple `% NOTE (iter-199 plan agent)` comments correctly flag that the current Lean bodies
    of `PicSharp.addCommGroup`, `PicSharp.presheaf`, `PicSharp.etSheaf`, etc. are placeholders
    (constant-PUnit-functor or zero-map bodies), NOT the mathematically correct constructions.
    These NOTEs are blueprint-discipline markers, not blueprint text errors; they correctly
    instruct `sync_leanok` not to set `\leanok`. The BLUEPRINT prose is mathematically correct;
    the NOTE comments are the correct mechanism for flagging the Lean gap. No blueprint change
    needed — the Lean bodies need fixing, which is a prover task gated on A.1.c.sub.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `Section~REF` placeholders (e.g., §"Out of scope" references to planned sibling chapters).
    Standing deferral from PROGRESS.md. No active prover; deferral rationale holds.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **MUST-FIX (wrong statement form)** — `lem:pullback_tensor_map_basechange` (D3′) at L3856:
    STATEMENT describes the base-change-square specialization (f : Y → X, open U ⊆ X, restriction
    g : f⁻¹U → U, open immersions j, j'). The Lean decl `pullbackTensorMap_restrict` actually
    proves the GENERAL composition coherence for any h : Z → Y, f : Y → X. The statement must
    be realigned to state: "For h : Z → Y and f : Y → X, the comparison δ for f ∘ h decomposes
    through the comparisons for f and h via the pullbackComp pseudofunctoriality isomorphism".
    The `% NOTE (review iter-256)` comment at L3859–3868 records this issue and says
    "Blueprint-writer fix required before the next prover pass on this lemma."
  - **MUST-FIX (disproven proof sketch)** — `lem:pullback_tensor_map_basechange` proof (L3885–3907):
    prescribes "same mate calculus as lem:pullbackObjUnitToUnit_comp" using
    `Functor.OplaxMonoidal.comp_δ` + `conjugateEquiv_pullbackComp_inv`. The iter-256 prover
    established this route is Lean-INADEQUATE: pullbackTensorMap is NOT an adjunction transpose,
    so homEquiv.injective does not open the goal. The genuine route (per `ts256-d3-mirror-premise-wrong.md`)
    is the 4-square comp_δ build:
    - Sq1: `sheafificationCompPullback`-comp (absent project sub-lemma)
    - Sq4: `pullbackValIso`-comp (absent project sub-lemma)
    - Sq2: ring-map reconciliation
    The proof sketch must be replaced with a description of this 4-square route, naming the two
    absent project sub-lemmas as deferred items. The current mate-calculus prose will mislead the
    prover into a dead end.
  - The rest of the chapter (D1′, D2′, STEP A, homOfLocalCompat, stalk-tensor, group-law, dual
    chain) is well-specified and correct. The bw256 fixes to homOfLocalCompat sub-step (c) and
    dual_restrict_iso Step-4 are present and sound (reviewed). Status block at L41–43 still reads
    "TWO residuals (iter-254)"; should read ONE (D1′ closed iter-255) — informational.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - "The bridge consumed by REF of `AbelianVarietyRigidity.tex`" — literal `REF` placeholder
    in the setup prose. Route C PAUSED; no active prover. Standing deferral.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - "Uniqueness in the Albanese property. Used in the uniqueness half of Theorem~REF (the Albanese
    property of Jac(C))" — literal `Theorem~REF` in Section "Use in project". Standing deferral
    from PROGRESS.md ("Rigidity"). No active prover; deferral rationale holds.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:rigidity_over_kbar` carries `\leanok` but has a sorry body (explicitly "a gated NAMED GAP").
    This is intentional and correctly disclosed in the chapter. The sorry is managed separately
    from the blueprint review. No blueprint content at risk.

## Cross-chapter notes

- `Picard_RelPicFunctor.tex` (lem:rel_pic_sharp_groupoid proof `\uses`) cites
  `lem:pullback_tensor_iso_loctriv` (D4′), which itself depends on the still-unfixed D3′ in
  `Picard_TensorObjSubstrate.tex`. This creates a valid dependency chain: D3′ blocks D4′ blocks
  RPF addCommGroup. No new finding (this is the known critical-path dependency); confirming it
  is still the correct picture.

## Severity summary

**must-fix-this-iter**:

1. `Picard_TensorObjSubstrate.tex` / D3′ `lem:pullback_tensor_map_basechange` — **statement
   describes base-change-square, not general composition coherence; proof sketch prescribes
   disproven mate calculus, not the 4-square comp_δ route.** Dispatch blueprint-writer to
   realign statement to h : Z → Y, f : Y → X general form and replace proof sketch with
   Sq1/Sq4/Sq2 route description. This must clear before the D3′ prover lane runs.

2. `Picard_LineBundleCoherence.tex` / `lem:lbc_chart_presentation` — **false `\leanok` in proof
   block** (sorry stub from iter-256 scaffold). Dispatch blueprint-writer to remove the `\leanok`
   from the proof block (or the blueprint-clean subagent can strip it).

3. `Picard_LineBundleCoherence.tex` / `thm:lbc_isFinitePresentation` — **proof sketch omits
   `Presentation.ofIsIso` + `IsFinite` finiteness bridge** required by `mk`. Dispatch
   blueprint-writer to add the bridge recipe to the proof sketch.

4. **Unstarted-phase proposal: A.2.c-engine Čech `Rⁱf_*` build** — dispatch blueprint-writer
   for `Cohomology_CechHigherDirectImage.tex` or record explicit one-line deferral in
   `iter/iter-257/plan.md`. The proposal outline above is ready to hand to the writer.

5. **Standing deferrals (re-confirmed, no new action required if plan agent records the
   deferral rationale as before)**: all chapters with `Theorem~REF`/`Section~REF`/`Definition~REF`
   placeholders and no active prover lane:
   `Albanese_AuslanderBuchsbaum.tex`, `Albanese_CodimOneExtension.tex`,
   `Cohomology_MayerVietoris.tex`, `Cohomology_StructureSheafAb.tex`,
   `Cohomology_StructureSheafModuleK.tex`, `Differentials.tex`, `Jacobian.tex`,
   `Picard_FGAPicRepresentability.tex`, `Picard_FlatteningStratification.tex`,
   `Picard_IdentityComponent.tex`, `Picard_Pic0AbelianVariety.tex`, `Picard_QuotScheme.tex`,
   `Picard_RelativeSpec.tex`, `RiemannRoch_RRFormula.tex`, `Rigidity.tex`.
   All listed in PROGRESS.md deferral rationale; none block active prover lanes; deferral
   rationale from iter-250 unchanged.

**Overall verdict**: HARD GATE FAILS for both active prover targets this iter — `Picard_TensorObjSubstrate.tex` has a wrong statement + wrong proof sketch on D3′ (writer fix required before the D3′ prover runs), and `Picard_LineBundleCoherence.tex` has a false `\leanok` + missing finiteness bridge (writer fix required before the scaffold prover can progress); 1 unstarted-phase proposal (`Rⁱf_*` Čech-build) for immediate writer dispatch or recorded deferral.
