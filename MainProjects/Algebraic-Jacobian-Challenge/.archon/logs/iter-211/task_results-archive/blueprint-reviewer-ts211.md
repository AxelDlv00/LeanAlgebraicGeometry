# Blueprint Review Report

## Slug
ts211

## Iteration
211

## Top-level summaries

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_unit_iso`: The proof sketch covers the self-tensor
  case (O_X ⊗ O_X → O_X) more than the general-M case (O_X ⊗ M → M for arbitrary M).
  The sketch says "mapIso(λ) composed with the sheafification counit identifying the sheafified
  structure-sheaf presheaf with O_X", but omits the step that relates O_X.val (the
  underlying presheaf of O_X) to the presheaf-monoidal unit 𝟙, which is different: O_X = sheafify(𝟙),
  so O_X.val ≅ sheafify(𝟙).val requires the sheafification counit iso on 𝟙. The existing Lean
  code only handles O_X ⊗ O_X → O_X (the self-tensor case, `tensorObj_unit_iso`). A prover
  targeting the general `tensorObj_left_unitor` / `tensorObj_right_unitor` would benefit from
  an extra sentence spelling out this absorb step (analogous to Steps 1/3 of the associator).
  Not a blocker — a skilled prover can navigate it — but the sketch is thinner than lem:tensorobj_assoc_iso.

### Lean difficulty quality

- `Picard_TensorObjSubstrate.tex` / `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}`:
  `IsInvertible` does not exist in the Lean file. The blueprint defines `LineBundle.OnProduct` as
  `{M | IsInvertible M}` but the Lean file implements it with `LineBundle.IsLocallyTrivial`. A prover
  needs to (a) create `IsInvertible := ∃ N, Nonempty(M ⊗_X N ≅ 𝒪_X)`, (b) show `IsLocallyTrivial →
  IsInvertible` to connect the existing `tensorObjOnProduct` to the group-law engine, and (c) prove
  group axioms for `IsInvertible` objects. The blueprint does not spell out step (b). This is not a
  mathematical error but the prover will face a gap between the Lean file's predicate
  (`IsLocallyTrivial`) and the blueprint's predicate (`IsInvertible`). Flagged so a targeted writer
  note can add one sentence on how to bridge them.

### Citation discipline

- `Picard_TensorObjSubstrate.tex`: Stale `\leanok` markers on three blocks whose Lean bodies are
  typed sorrys:
  - `lem:tensorobj_restrict_iso` (`\lean{...tensorObj_restrict_iso}`) — sorry body in Lean, but
    blueprint carries `\leanok`. The proof section explicitly says "its full proof is deferred",
    which makes the `\leanok` internally inconsistent.
  - `lem:tensorobj_inverse_invertible` (`\lean{...exists_tensorObj_inverse}`) — sorry body in Lean,
    blueprint carries `\leanok`.
  - `thm:rel_pic_addcommgroup_via_tensorobj` (`\lean{...addCommGroup_via_tensorObj}`) — sorry body
    in Lean, blueprint carries `\leanok`.
  These should be cleared by `sync_leanok`. They do not affect the critical path (all three are
  off-path or downstream), but the inconsistency misleads the review agent.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex

- **complete**: true
- **correct**: true
- **notes**:
  - **[directive Q1 — PASS]** The flat-whiskerLeft associator proof sketch is rigorous. `lem:flat_whisker_localizer` gives a two-part proof (local surjectivity from right-exactness, local injectivity from `Module.Flat.lTensor_preserves_injective_linearMap`). The three-step composite in `lem:tensorobj_assoc_iso` (absorb left via flat-whiskering, transport presheaf associator via mapIso, restore right via flat-whiskering) is clearly laid out with explicit notation. The claim "⊗-invertible ⇒ flat" is adequately justified: locally free of rank 1 ⇒ sectionwise projective ⇒ sectionwise flat; the citation to `Module.Flat.of_projective` is correct in spirit. The reduction to `lTensor_preserves_injective_linearMap` + right-exactness is sound.
  - **[directive Q2 — PASS with note]** `lem:tensorobj_unit_iso` and `lem:tensorobj_comm_iso` are adequately described for formalization as `Nonempty`-truncated existence-of-iso statements. The mapIso pattern is explicit. `lem:tensorobj_isoclass_commgroup` is well-detailed: the well-definedness argument on iso-classes, closure, each axiom being a Nonempty proposition, and the inverse carried by `IsInvertible` are all described. Minor issue on `lem:tensorobj_unit_iso` proof sketch: see "Proofs lacking detail" above.
  - **[directive Q3 — NO SUCH SECTION EXISTS]** The blueprint chapter does NOT contain a section titled "Off-path declarations (retained, not on the critical path)". The directive's premise that such a section exists and makes incorrect claims about `monoidalCategory` being "retained in the Lean file" is not supported by the actual chapter. The actual last two sections are "Out of scope" (`sec:tensorobj_out_of_scope`) and "Internal-consistency check" (`sec:tensorobj_consistency_check`). Actual status: `tensorObj_restrict_iso`, `exists_tensorObj_inverse`, and `addCommGroup_via_tensorObj` ARE in the Lean file as typed sorrys, consistent with the blueprint's off-critical-path description. `monoidalCategory` is NOT in the Lean file (correctly removed at iter-206 pivot per the §2 Lean comment and per `rem:scheme_modules_monoidal_off_path`). Blueprint and Lean are consistent. The stale element is the **Lean file's module-level docstring** (still says "iter-202 Lane TS file-skeleton" and lists `monoidalCategory` as one of 4 pinned declarations) — this is a Lean file documentation issue, not a blueprint issue. Recommend a Lean-side docstring update but this does not block dispatch.
  - **[directive Q4 — PASS]** All `\lean{...}` targets name plausible declaration names for the prover to create: `W_whiskerLeft_of_flat`, `tensorObj_assoc_iso`, `tensorObj_left_unitor`, `tensorObj_right_unitor`, `tensorObj_braiding`, `IsInvertible`, `tensorObjIsoclassCommMonoid`. The `\uses{...}` dependency graph is verified acyclic in `sec:tensorobj_consistency_check`: the section explicitly enumerates the chain and confirms all targets resolve within this chapter, `chap:Picard_LineBundlePullback`, or `chap:Picard_RelPicFunctor`. No circular references detected.
  - **[known problem areas — BOTH CLEARED]** (a) δ-mate / `tensorObj_restrict_iso` route: correctly NOT on the critical path; the proof of `lem:tensorobj_assoc_iso` explicitly says "no open-immersion restriction-compatibility iso" is used. (b) Local-trivialization associator: correctly NOT the route; the chapter consistently uses the flat-whiskerLeft realization throughout, including in `rem:scheme_modules_monoidal_off_path`.
  - **[stale \leanok markers]** See "Citation discipline" above. `lem:tensorobj_restrict_iso`, `lem:tensorobj_inverse_invertible`, and `thm:rel_pic_addcommgroup_via_tensorobj` carry `\leanok` but are sorry in Lean. These should be corrected by `sync_leanok`; they don't block dispatch since all three are off-critical-path or downstream consumer.
  - **[IsInvertible vs IsLocallyTrivial mismatch]** See "Lean difficulty quality" above. The blueprint uses `IsInvertible` as the carrier predicate but the Lean file uses `IsLocallyTrivial`. The bridge is not stated in the blueprint.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Large chapter covering the char-free Gm-scaling route (the committed genus-0 path). The Rigidity Lemma (`thm:rigidity_lemma`) and `lem:hom_additivity_over_product` (Milne Cor 1.5) are proven axiom-clean per the chapter intro. The Gm-scaling shortcut (`def:gaTranslationP1`, `prop:morphism_P1_to_AV_constant`) is the primary route and is clearly blueprinted. `lem:rational_map_to_av_extends` (Milne Thm 3.2) and `lem:av_regular_map_is_hom` (Milne Cor 1.2) are demoted to Route-A-only items. `thm:genus_zero_curve_iso_p1` gating the headline `prop:rigidity_genus0_curve_to_AV` comes from the RR bridge (RR.4). The chapter correctly routes around `MonoidalClosed`, autoduality, and the df=0 approach.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:rigidity_over_kbar` is honestly disclosed as a named gap with sorry body. The chapter correctly identifies two closure routes (route (a) cotangent-bundle, route (b) dual-AV via Pic^0) and commits to neither. The alg-closed pivot (CharZero + IsAlgClosed hypotheses) is explained. This is the fallback route (a) artifact; the committed route is route (c) in `AbelianVarietyRigidity.tex`. Disposition is clear and consistent with STRATEGY.md.

## Cross-chapter notes

- `Picard_TensorObjSubstrate.tex` blueprint uses `LineBundle.OnProduct` as `{M | IsInvertible M}` while the Lean file defines it with `IsLocallyTrivial`. The bridge lemma `IsLocallyTrivial → IsInvertible` (needed to connect existing code to the group-law engine) is not blueprinted in any chapter. Since `IsInvertible` is to be created by the prover, this is a prover-facing gap rather than a blueprint gap, but plan agent should be aware a prover dispatched to `TensorObjSubstrate.lean` will need to navigate this without an explicit blueprint guide.

- The Lean file `Picard/TensorObjSubstrate.lean`'s module-level docstring is stale: it describes the iter-202 file-skeleton state and lists `monoidalCategory` as a pinned declaration, but `monoidalCategory` was deliberately removed in the iter-206 pivot. This is a documentation inconsistency in the Lean file (not a blueprint issue) that a writer could fix in one line.

## Severity summary

**must-fix-this-iter**: NONE (no findings block the TensorObjSubstrate prover dispatch)

**soon**:
1. `Picard_TensorObjSubstrate.tex`: Three stale `\leanok` markers on sorry declarations
   (`lem:tensorobj_restrict_iso`, `lem:tensorobj_inverse_invertible`,
   `thm:rel_pic_addcommgroup_via_tensorobj`). Should be cleared by `sync_leanok`. Flagged because the
   stale markers could mislead the review agent into treating sorry declarations as proven.
2. `Picard_TensorObjSubstrate.tex`: The `IsInvertible` vs `IsLocallyTrivial` predicate mismatch
   should be addressed with a one-sentence writer note in the blueprint bridging
   `LineBundle.IsLocallyTrivial → Scheme.Modules.IsInvertible` so the prover has an explicit
   roadmap for the bridge step.

**informational**:
1. `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_unit_iso`: proof sketch for the general-M unitor
   case could add one sentence on the counit iso on 𝟙 (to relate O_X.val to the presheaf unit).
2. Lean file `Picard/TensorObjSubstrate.lean`: module-level docstring stale (iter-202 language, lists
   removed `monoidalCategory`). One-line Lean-side fix; not a blueprint action.

**HARD GATE DECISION: CLEARS.**
`Picard_TensorObjSubstrate.tex` is `complete: true`, `correct: true`, with no must-fix findings.
The prover dispatch to `Picard/TensorObjSubstrate.lean` is authorized.

Overall verdict: `Picard_TensorObjSubstrate.tex` clears the hard gate — the flat-whiskerLeft route is
rigorously blueprinted, the δ-mate and local-trivialization routes are correctly excluded from the
critical path, and no must-fix findings exist; 0 unstarted-phase proposals (all strategy phases have
blueprint coverage).
