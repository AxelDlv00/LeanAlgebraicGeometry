# Blueprint Review Report

## Slug
ts229

## Iteration
229

## Top-level summaries

### Incomplete parts

- `Picard_FlatteningStratification.tex`: `thm:generic_flatness_algebraic` has no `\lean{}` pin; `sync_leanok` cannot track it. (Known deferred — HELD A.2.c-engine lane; recorded from ts228.)
- `AlgebraicJacobian_Cotangent_GrpObj.tex`: pointer chapter only, no formal declaration blocks for its covered Lean file. (Known deferred — PAUSED genus-0 arm; recorded from ts228.)
- `Albanese_CodimOneExtension.tex`: proof sketch stages 6.A/6.B/6.C for the codim-1 extension theorem are incomplete — the "smooth implies DVR" / Stacks-00TT stages lack key steps (depth ≥ 2 local-cohomology vanishing, Buchsbaum–Eisenbud exactness). Route-1 Albanese cone is EXCISED/held — no active prover work, but the completeness gap persists.
- `Picard_Pic0AbelianVariety.tex`: five theorem blocks carry `\leanok` markers per chapter prose, but agent read flags "No Lean skeleton yet (iter-192 directive)" — the `\leanok` status may be stale or anticipatory; `sync_leanok` cannot track declarations that don't exist in Lean. This chapter is gated (A.3; no dispatch before A.2.c); needs a writer pass to reconcile markers with Lean state when the lane de-gates.

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:open_immersion_slice_sheaf_equiv`: the sketch names both `IsDenseSubsite.sheafEquiv` and `Equivalence.sheafCongr` as the transfer tool. Since `overEquivalence U` is already a category equivalence (not merely a dense embedding), `Equivalence.sheafCongr` is the direct path; the "dense subsite" framing in the sketch is slightly imprecise. This does not block formalization — the prover will use the simpler equivalence route — but is worth a one-line comment in a subsequent writer pass. **Classified informational, not must-fix.**

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **HARD GATE: CLEARS.** All four iter-229 edits verified sound:
  - **NEW `lem:open_immersion_slice_sheaf_equiv`** (`\lean{AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv}`): statement well-formed (upgrades `overEquivalence U` to a sheaf-category equivalence for any `A`); forward pin acceptable. Proof sketch names `IsDenseSubsite.sheafEquiv`/`Equivalence.sheafCongr`, explains thinness → `Subsingleton.elim` kills coherence, names the down-set identity `ι₊(ι⁻¹V)=V`, and cites `Sites/Over` for continuity/cover-lifting instances. Adequate for formalization. Minor imprecision (dense vs. full equivalence framing) is informational only.
  - **CORRECTED `lem:dual_isLocallyTrivial`**: the proof body no longer asserts the falsified `restrictScalarsRingIsoDualEquiv` discharge. Steps 1–3 + H1 reused verbatim from tensor; post-H1 residual explicitly routed through `lem:open_immersion_slice_sheaf_equiv` (the slice internal hom vs. sectionwise mismatch now correctly identified and bridged). `\uses{}` updated. Mathematically sound.
  - **3 NEW helper definitions** (`def:presheaf_dual_precomp_equiv`, `def:presheaf_dual_iso_of_iso`, `def:scheme_modules_dual_iso_of_iso`): all well-formed. Precomposition equivalence on dual sections, presheaf-level dual iso of iso (contravariant), and sheaf-level dual iso of iso. No `\leanok` (forward pins on landed-but-not-yet-synced declarations; acceptable per directive). `\uses{}` cross-references check out (`def:presheaf_dual`, `def:presheaf_dual_precomp_equiv`, `lem:internal_hom_isSheaf`).
  - **REFINED `lem:sheafofmodules_hom_of_local_compat`**: `\uses{}` now includes `lem:open_immersion_slice_sheaf_equiv`; proof body explicitly identifies localSection naturality as the section-direction slice of the shared equivalence; names `existsUnique_gluing`, `presheafHom`, `presheafHomSectionsEquiv`, `homMk`. Adequately detailed; the four mechanical sub-steps (cocycle, glue, linearity, recover) are enumerated. No tensor stalk invoked.
  - Informational (standing, ts228): `lem:tensorobj_inverse_invertible` proof body still cites vestigial `lem:internal_hom_eval` in `\uses{}`; deferred to assembly-iter writer pass (non-blocking).

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `thm:generic_flatness_algebraic` lacks `\lean{}` pin; `sync_leanok` cannot track. All other declarations (`thm:generic_flatness`, `thm:flattening_stratification_exists`, `thm:flattening_stratification_universal`, sub-lemmas) have pins and complete proof sketches.
  - HELD lane (A.2.c-engine); deferred from ts228. Re-recorded per gate rules.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Pointer chapter only; no formal declaration blocks. The mathematical content and Lean declarations are described in prose but no `\definition`/`\lemma`/`\theorem` blocks are present with `\lean{}` pins for `sync_leanok` to track.
  - PAUSED genus-0 arm; deferred from ts228. Re-recorded per gate rules.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Proof sketch for `lem:codim_one_extension` (Milne Lemma 3.3) stages 6.A/6.B/6.C missing key steps: depth ≥ 2 local-cohomology vanishing and Buchsbaum–Eisenbud exactness (Stacks 00MF). The blueprint acknowledges these as Mathlib-absent but does not sketch a resolution path.
  - Route-1 Albanese cone is EXCISED/held (deletion gate closed); no active prover work. Plan agent should record deferral.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Five theorem blocks carry `\leanok` per chapter prose, but the agent flagged "No Lean skeleton yet (iter-192 directive)". If `\leanok` markers are present on declarations that don't exist in Lean, they are stale and `sync_leanok` will misbehave. Needs a reconciliation pass when lane A.3 de-gates.
  - Gated A.2.c; no dispatch before A.2.c.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

## Severity summary

**must-fix-this-iter** (3 findings — all from HELD/paused chapters; plan agent should record deferrals, not dispatch writers for held lanes):

1. `Picard_FlatteningStratification.tex` — `thm:generic_flatness_algebraic` lacks `\lean{}` pin (HELD A.2.c-engine; deferred from ts228 — re-record deferral in iter-229/plan.md or dispatch writer when lane de-gates).
2. `AlgebraicJacobian_Cotangent_GrpObj.tex` — pointer chapter, no formal declaration blocks (PAUSED genus-0 arm; deferred from ts228 — re-record deferral).
3. `Albanese_CodimOneExtension.tex` — stages 6.A/B/C proof sketch incomplete (Route-1 HELD; record deferral).

**soon** (1 finding):

- `Picard_Pic0AbelianVariety.tex` — `\leanok` markers may be stale if Lean skeleton not yet scaffolded; reconcile when A.3 lane de-gates.

**informational** (1 finding):

- `Picard_TensorObjSubstrate.tex` / `lem:open_immersion_slice_sheaf_equiv`: "dense subsite" framing slightly imprecise (overEquivalence U is a full equivalence; Equivalence.sheafCongr is the direct path). Non-blocking for prover dispatch.

**Overall verdict**: HARD GATE CLEARS for `Picard_TensorObjSubstrate.tex` (complete + correct, no must-fix touching it); 0 phases have no blueprint coverage; 3 must-fix findings all from HELD/paused chapters with standing deferrals — record deferrals in iter-229/plan.md rather than dispatching writers.
