# Blueprint Review Report

## Slug
br256

## Iteration
256

## Top-level summaries

### Proofs lacking detail

- `Cohomology_HigherDirectImage.tex` / `def:higher_direct_image`: definition carries explicit `[HasInjectiveResolutions X.Modules]` hypothesis, with an in-chapter NOTE that Mathlib has `Abelian X.Modules` but NOT `EnoughInjectives`/`IsGrothendieckAbelian` for `SheafOfModules` over a varying ring. The file is flagged as "not yet imported by the aggregator (orphan module)". The chapter does not contain a proof that this instance is satisfiable, nor does it outline the alternative Čech-complex approach the strategy designates as the "DEFAULT" build. All other proof sketches in the chapter (quasi-coherence, affine vanishing, flat base change) are adequate.

### Citation discipline

No citation-discipline findings. All blocks in active prover chapters carry proper `% SOURCE:` lines with `(read from references/…)` parentheticals, verbatim `% SOURCE QUOTE:` blocks in the source language, and visible `\textit{Source: …}` prose lines. The parenthetical-referenced files exist on disk for every block checked (stacks-modules.tex, kleiman-picard-src/kleiman-picard.tex, stacks-coherent.tex, hartshorne-algebraic-geometry.pdf, nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex).

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Hard gate item 1: `lem:pullback_tensor_map_basechange` (D3', `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}`) — statement present, proof sketch present and sound. Proof uses mate calculus: `Functor.OplaxMonoidal.comp_δ` decomposes δ of the composite pullback, and `conjugateEquiv_pullbackComp_inv` conjugates the pseudofunctoriality isomorphism to identify the two restricted comparisons. Cites `lem:tensorobj_restrict_iso` for the strong-monoidal restriction. All `\uses{}` labels (`lem:pullback_tensor_map`, `lem:pullback_tensor_map_natural`, `lem:pullbackObjUnitToUnit_comp`, `lem:tensorobj_restrict_iso`) resolve within the chapter. No `\leanok` in statement or proof (correctly: not yet closed in Lean). GATE CLEARS for prover dispatch on D3'.
  - Hard gate item 2: `lem:sheafofmodules_hom_of_local_compat` (`\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}`) — `\leanok` in statement. Proof sketch is highly detailed: sub-steps (i) ab-sheaf gluing via `existsUnique_gluing` on `presheafHom`, (a) cocycle condition via sectionwise hypothesis + `Subsingleton.elim` on thin poset, (b) amalgamation + `presheafHomSectionsEquiv`, (d) recovery, (ii) promote to O_X-linear via `homMk`. The iter-256 sub-step (c) smul-bridge expansion is present and correct: (c.i) M-leg via `Scheme.Modules.map_smul M`; (c.ii) genuine obstacle: `appIso(ι_i) = Iso.refl` so restriction ring map = `𝟙`, bridge via `ModuleCat.restrictScalars.smul_def` + `restrictScalarsId'App`; (c.iii) N-leg via `Scheme.Modules.map_smul N` + `eqToHom` compose-to-identity on overlap. All `\uses{}` labels (`def:scheme_modules_homMk` at line 5706, `lem:open_immersion_slice_sheaf_equiv` at line 5417) resolve. GATE CLEARS for DualInverse.lean prover dispatch.
  - `lem:dual_restrict_iso` Step-4 (H1 + Leg(A)/(B) restructure) — `\leanok` in statement (sorry open in Lean, correctly); proof NOT `\leanok`. The iter-256 restructure is present: stage H1 rewrites pulled-back dual from `pullback φ`-form to `pushforward β`-form via `pushforwardPushforwardAdj` + `leftAdjointUniq`; Leg (A) is the slice-site Hom base-change at the presheaf-of-modules level (correctly NOT collapsed to the sheaf-site equivalence `lem:open_immersion_slice_sheaf_equiv`); Leg (B) is the ring-isomorphism transport via `lem:restrictscalars_ringiso_dualequiv`. Proof correctly explains why the strong-monoidal restriction has no direct dual analogue (non-sectionwise nature of dual forces Leg A). SOUND.
  - `\leanok`-inside-`\uses{}` corruptions: ZERO remaining (the 6 corruptions reported by planner-iter-256 as cleaned are confirmed absent).
  - All `\uses{}` cross-references checked: no broken labels found in either the D3' block or the homOfLocalCompat block or the dual_restrict_iso block.

### blueprint/src/chapters/Picard_LineBundleCoherence.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Re-confirmed complete + correct for scaffold gate. All five blocks present: `lem:lbc_trivializing_cover`, `lem:lbc_chart_presentation`, `thm:lbc_isFinitePresentation`, `cor:lbc_isFiniteType`, `lem:lbc_rank_flat`. Proof sketches adequate for all five; the main theorem proof correctly assembles `QuasicoherentData` from the trivialising cover and invokes `SheafOfModules.IsFinitePresentation.mk`. `\uses{}` cross-reference `def:line_bundle_on_product` resolves to `Picard_LineBundlePullback.tex` line 60. Site-instance caveat (`rem:lbc_site_instances`) correctly flagged as the single typecheck check at entry. Citation discipline clean: all blocks cite stacks-modules.tex with verbatim SOURCE QUOTEs present. SCAFFOLD GATE CLEARS.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - The chapter has 4 declaration blocks: `def:higher_direct_image` (conditional on `[HasInjectiveResolutions X.Modules]`), `lem:higher_direct_image_quasi_coherent`, `lem:higher_direct_image_affine_vanishing`, `thm:flat_base_change_higher`. Content for all four is adequate for their individual statements.
  - PARTIAL flag: `def:higher_direct_image` carries a conditional hypothesis (`[HasInjectiveResolutions X.Modules]`) noted in-chapter as non-satisfiable for `SheafOfModules` over a varying structure sheaf (Mathlib ships `Abelian X.Modules` but not `EnoughInjectives`/`IsGrothendieckAbelian`). The file is flagged as an orphan module. The strategy's designated "DEFAULT = project Čech build" for `Rⁱf_*` (strategy phrase: "blueprint chapter scheduled next iter") has no blueprint coverage: no chapter describes the Čech-complex approach to constructing `R^i f_*` without the injective-resolutions hypothesis. This doesn't block current A.1.c.sub prover work but gates the A.2.c engine lane.
  - Severity: **soon** — does not block iter-256 prover lanes (which target TensorObjSubstrate and LineBundleCoherence) but the Čech build blueprint should be written before the A.2.c-engine opening phase requires a prover.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

## Severity summary

- **must-fix-this-iter**: none — all three prover targets (D3' `lem:pullback_tensor_map_basechange`, `lem:sheafofmodules_hom_of_local_compat`, LineBundleCoherence scaffold) are backed by complete + correct blueprint chapters. No broken `\uses{}` cross-references. No strategy-modifying findings. No route with zero coverage. No `\leanok`-inside-`\uses{}` corruptions remaining.

- **soon** (1 item):
  - `Cohomology_HigherDirectImage.tex` — Čech-based `Rⁱf_*` blueprint not yet written. The strategy's "PARTIALLY OPENING" A.2.c-engine phase explicitly schedules this blueprint chapter and designates the Čech approach as the "DEFAULT" implementation (the injective-resolutions hypothesis on the existing definition is not satisfiable for SheafOfModules). Write a blueprint section or new chapter before dispatching a prover to the A.2.c-engine lane.

Overall verdict: **HARD GATE CLEARS for all three iter-256 prover targets** — `Picard_TensorObjSubstrate.tex` (D3' and homOfLocalCompat) and `Picard_LineBundleCoherence.tex` (scaffold gate) are each complete + correct; the two iter-256 chapter refinements (sub-step (c) smul-bridge expansion and dual_restrict_iso H1+Leg(A)/(B) restructure) are sound; 1 soon-severity finding (Čech `Rⁱf_*` blueprint deferred); no unstarted phases with zero coverage.
