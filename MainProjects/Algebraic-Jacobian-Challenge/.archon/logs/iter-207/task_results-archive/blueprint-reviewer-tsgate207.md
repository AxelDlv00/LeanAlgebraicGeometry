# Blueprint Review Report

## Slug
tsgate207

## Iteration
207

## Top-level summaries

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:restrictscalars_laxmonoidal`: The proof mentions "Packaging these as a `Functor.CoreLaxMonoidal`" — this is an informal name for the construction route; the actual Mathlib API (`Functor.LaxMonoidal.mk` or equivalent constructor) may differ. **Does not block formalizability** — the sectionwise lax maps and their naturality squares are fully specified, and the prover can adapt the packaging to the real API. Noted as informational only.

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_inverse_invertible`: Statement-level `\uses{..., lem:tensorobj_restrict_iso}` is over-inclusive — the proof body explicitly cites only `lem:tensorobj_preserves_locally_trivial`, and the contraction-map-is-locally-an-iso argument does not require `tensorObj_restrict_iso` (a morphism of scheme-modules is an iso iff it's locally an iso, by the sheaf-iso criterion). Informational mismatch.

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **HARD GATE: CLEARS.** Focused analysis below.
  - **F1 (comparison-map absent) — RESOLVED.** The proof of `lem:tensorobj_restrict_iso` now has four steps: (1) reduce restriction along open immersion to the abstract presheaf-of-modules pullback via `Scheme.Modules.restrictFunctorIsoPullback`; (2) commute pullback through sheafification via `SheafOfModules.sheafificationCompPullback`; (3) identify the comparison map as the oplax `δ` of `CategoryTheory.Adjunction.leftAdjointOplaxMonoidal` applied to `PresheafOfModules.pullbackPushforwardAdjunction φ`, whose sole hypothesis `[(pushforward φ).LaxMonoidal]` is furnished by the new `lem:restrictscalars_laxmonoidal`; (4) flatness upgrades `δ` to an iso via `Module.Invertible.lTensor_bijective_iff`. The comparison map is **explicitly constructed** at Step 3 before flatness is ever invoked at Step 4. The prior iter-206 defect (comparison map absent, flatness claimed to close the goal alone) is eliminated. The proof is formalizable.
  - **`lem:restrictscalars_laxmonoidal` — new block, mathematically sound.** The block states that `PresheafOfModules.restrictScalars φ` is lax monoidal when `φ` is a commutative-ring-presheaf map. The proof argument is: (a) per-section, `ModuleCat.restrictScalars (φ.app X)` is lax monoidal (cited from `Mathlib.Algebra.Category.ModuleCat.Monoidal.Adjunction` as the right adjoint of `extendRestrictScalarsAdj`); (b) the presheaf tensor product is sectionwise; (c) so the lax structure maps `μ` and `ε` assemble sectionwise from the per-section ones, with naturality coming from presheaf restriction morphisms; (d) the composite `pushforward φ` is then lax monoidal by `Functor.LaxMonoidal.comp`. The commutativity hypothesis is correctly flagged as essential (presheaf-of-modules monoidal category requires `CommRingCat`-factored rings). Estimated ~40–90 LOC. Adequately detailed for a `mathlib-build` prover.
  - **M2 (bifunctor scope mismatch) — RESOLVED.** `lem:scheme_modules_tensorobj_functoriality` explicitly states that the coherence data (unitors, associator, braiding) are NOT outputs; only the bifunctorial action on morphisms is claimed. The discrepancy is gone.
  - **M3 (lift-on-product scope mismatch) — RESOLVED.** `lem:tensorobj_lift_onproduct` has a `% NOTE:` clarifying that `tensorObjOnProduct` provides only operation-closure on the subtype; the group-law data (unit membership, dual/inverse, assoc/unit/comm iso facts) are separate items blocked on `lem:tensorobj_restrict_iso`.
  - **M4 (deferred iso blocks unblocked without notes) — RESOLVED.** All four deferred iso-lemma blocks (`lem:tensorobj_assoc_iso`, `lem:tensorobj_unit_iso`, `lem:tensorobj_comm_iso`, `lem:pullback_compatible_with_tensorobj`) carry `% NOTE: no Lean declaration yet; blocked on lem:tensorobj_restrict_iso (which is blocked on lem:restrictscalars_laxmonoidal)`. No `\lean{}` hints present on these four (correct).
  - **`\uses{}` graph is clean.** All intra-chapter `\uses{}` targets resolve to labels defined in the chapter. External targets: `thm:relative_pic_quotient_well_defined` and `def:pullback_along_projection` (→ `chap:Picard_LineBundlePullback`), `lem:rel_pic_sharp_groupoid` (→ `chap:Picard_RelPicFunctor`) — all confirmed present on disk. No broken cross-references.
  - **Citation discipline — clean.** Two citation blocks both reference `references/kleiman-picard-src/kleiman-picard.tex` (file confirmed to exist). `% SOURCE QUOTE:` verbatim LaTeX from the Kleiman source. Visible `\textit{Source: ...}` lines present and match the `% SOURCE:` pointers. `lem:restrictscalars_laxmonoidal` is Archon-original (no source block; correct per convention).
  - **Informational:** Statement-level `\uses{..., lem:tensorobj_restrict_iso}` on `lem:tensorobj_inverse_invertible` is over-inclusive (proof does not use it). Does not affect correctness.
  - **Informational:** "Functor.CoreLaxMonoidal" in `lem:restrictscalars_laxmonoidal` proof is an informal name; prover should use the actual Mathlib constructor for `Functor.LaxMonoidal`.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

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

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

## Severity summary

Severity summary: HARD GATE CLEARS — no must-fix findings.

Two informational notes for the prover on `Picard_TensorObjSubstrate.tex`:
- **informational** — `lem:restrictscalars_laxmonoidal`: "Functor.CoreLaxMonoidal" is an informal construction name; prover should use the real Mathlib `Functor.LaxMonoidal` constructor.
- **informational** — `lem:tensorobj_inverse_invertible`: statement-level `\uses` over-includes `lem:tensorobj_restrict_iso`; proof does not actually use it (contraction-map argument is direct). No action needed — the `\uses` is conservative, not wrong.

Overall verdict: `Picard_TensorObjSubstrate.tex` is **complete + correct** with no must-fix findings — HARD GATE CLEARS for the TS lane. The comparison-map construction defect (F1) is eliminated: the new four-step proof constructs `δ` from `leftAdjointOplaxMonoidal` applied to `pullbackPushforwardAdjunction φ` before invoking flatness, and the sole project-side gap is the new `lem:restrictscalars_laxmonoidal` block which is mathematically sound and adequately detailed for a `mathlib-build` prover. 33 chapters audited, 0 must-fix findings, 0 unstarted-phase proposals.
