# Blueprint Review Report

## Slug
ts241-fastpath

## Iteration
241

## Fast-Path Focus Verdicts

### Chapter 1 — `Picard_TensorObjSubstrate.tex`

**complete: true**
**correct: true**
**No must-fix-this-iter findings.**

The two new pinned coherence sub-lemmas are well-formed and the section remains complete+correct.

**`lem:unitToPushforwardObjUnit_comp`** (lines 2734–2768)
- `\lean{AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp}` — Lean decl confirmed in `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` line 882 (`lemma unitToPushforwardObjUnit_comp`).
- Statement: `upu(h;f) = upu(f) ; (pushforward f).map(upu h) ; (pushforwardComp h f).hom`, where `upu f` is `SheafOfModules.unitToPushforwardObjUnit f.toRingCatSheafHom`.
- Proof sketch: sectionwise check — each `upu` acts as the structure-sheaf ring map; the composition coherence is the functoriality identity `(h;f)♯ = h♯ ∘ f♯`, which holds definitionally. Sound and formalizable.

**`lem:pullbackObjUnitToUnit_comp`** (lines 2770–2817)
- `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` — Lean decl confirmed in same file at line 923.
- `\uses{lem:unitToPushforwardObjUnit_comp}` — correct single dependency.
- Statement: `pbu(h;f) = (pullbackComp h f).inv ; (pullback h).map(pbu f) ; pbu h`.
- Proof sketch: adjunction-mate transport. `pbu f` is the mate of `upu f`; transposing both sides under `(h;f)^* ⊣ (h;f)_*`, the LHS becomes `upu(h;f)` and the RHS transposes to the RHS of `lem:unitToPushforwardObjUnit_comp` via conjugation of pseudofunctoriality isos. Injectivity of the transpose closes the goal. Faithful and formalizable. Correctly described as "the genuinely-new ingredient for `lem:pullback_unit_iso`" because the left-adjoint pullback has no sectionwise value.

**Updated `lem:pullback_unit_iso`** proof (lines 2837–2895)
- `\uses{def:scheme_modules_tensorobj, lem:pullbackObjUnitToUnit_comp, lem:unitToPushforwardObjUnit_comp}` — correct.
- Proof: covers affine chart factorization `V.ι ; f = g ; U.ι`, applies `instIsIsoPullbackObjUnitToUnitOfFinal` on the Final-chart morphism `g`, applies `lem:pullbackObjUnitToUnit_comp` to get `pbu(V.ι;f)` as a composite of three isos, transports via `restrictFunctorIsoPullback`, and globalizes via `isIso_of_isIso_restrict`. The sole remaining step (assembling from per-chart to global) is named and actionable.

No regression to previously-correct content. `sec:tensorobj_pullback_monoidality` remains complete+correct.

---

### Chapter 2 — `Cohomology_FlatBaseChange.tex`

**complete: true**
**correct: true**
**Must-fix from ts240-fbc: RESOLVED.**

**`lem:gammaPushforwardIsoAt_naturality`** (lines 297–363)
- Intentionally unpinned (no `\lean{}`): correct per directive; the prover will add the `NatIso` decl.
- `\uses{lem:gammaPushforwardIsoAt}` — correct single dependency.
- Statement: two presheaves are defined — `P : U ↦ Γ((Spec φ)_*N, U)` and `Q : U ↦ restr_φ(Γ(N, (Spec φ)^{-1}U))` — and the family `{e_U}` of isomorphisms from `lem:gammaPushforwardIsoAt` is asserted to be a natural isomorphism `P ≅ Q`. The commutative naturality square is drawn explicitly for any inclusion `U' ⊆ U`.
- Proof sketch: each `e_U` is a composite of (a) structure-sheaf restriction maps of the two sheaves and (b) conjugation by a fixed ring map (the one from the restriction-of-scalars reconciliation + `globalSectionsIso_hom_comp_specMap_appTop`). Both kinds commute with further restriction along `U' ⊆ U`: (a) by the presheaf axiom applied to `V' ⊆ V` (where `V = (Spec φ)^{-1}U`), (b) because the ring map is independent of `U`. The three component squares paste to the outer naturality square. Each `e_U` is an iso, so the family is a natural iso. Faithful and formalizable.

**`lem:pushforward_spec_tilde_iso`** (lines 498–715): must-fix resolved.
- `\uses` list now includes `lem:gammaPushforwardIsoAt_naturality` (and the other required lemmas).
- The stale "carrier wall" framing is gone.
- Three-movement proof:
  - Movement (1): `e_{D(a)}` = `lem:gammaPushforwardIsoAt` at `U = D(a)`, using `(Spec φ)^{-1}D(a) = D(φa)` definitionally. No fresh construction.
  - Movement (2): naturality square for `D(a) ⊆ ⊤` from `lem:gammaPushforwardIsoAt_naturality`, intertwining `res_{⊤→D(a)}` on the pushforward with `res_{⊤→D(φa)}` on `Ñ`.
  - Movement (3): `lem:tildeRestriction_isLocalizedModule` supplies `R'`-side powers(φa)-localization; `lem:powers_restrictScalars` (with `A=R'`, submonoid `powers(a)`) transports to `R`-side powers(a)-localization; the naturality square transports this to `hloc(a)`. No per-`a` section-level identity re-proved.
- The proof is now sufficiently specified to formalize the NatIso route. The single remaining obligation (the NatIso decl for `lem:gammaPushforwardIsoAt_naturality`) is correctly left to the prover.

**HARD GATE STATUS: Both lanes satisfy the gate. Provers may be dispatched for Lane A (`pullbackUnitIso` assembly) and Lane B (`pushforward_spec_tilde_iso`).**

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Two new axiom-clean lemma blocks (`lem:unitToPushforwardObjUnit_comp`, `lem:pullbackObjUnitToUnit_comp`) added; Lean decls confirmed in `TensorObjSubstrate.lean`. `lem:pullbackUnitIso` handoff comment still present in Lean, consistent with the blueprint marking the proof route but not yet `\leanok`.
  - `lem:pullback_unit_iso` statement block lacks `\leanok` (correct: the Lean file still has a sorry/handoff note at line 1011–1043 for the instance-canonicity blocker). No discrepancy.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:gammaPushforwardIsoAt_naturality` is intentionally unpinned; the proof sketch is self-contained and the naturality argument is sound.
  - `thm:flat_base_change_pushforward` proof is a documented sorry referencing Čech infrastructure not yet in Mathlib; correctly marked as a multi-lane engine target, not a single-iter target.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

Both focus chapters (`Picard_TensorObjSubstrate.tex` and `Cohomology_FlatBaseChange.tex`) return `complete: true, correct: true` with no must-fix. The ts240-fbc must-fix is resolved. All 35 chapters are complete and correct. No unstarted-phase proposals; all strategy phases have adequate blueprint coverage.

Overall verdict: Both lanes' gates satisfied — Lane A (`pullbackUnitIso`, two new coherence lemmas land cleanly, proof route fully specified) and Lane B (`pushforward_spec_tilde_iso` must-fix resolved via `lem:gammaPushforwardIsoAt_naturality`); 35 chapters audited, 0 findings, 0 unstarted-phase proposals.
