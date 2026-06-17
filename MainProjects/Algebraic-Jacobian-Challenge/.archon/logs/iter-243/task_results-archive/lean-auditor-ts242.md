# Lean Audit Report

## Slug
ts242

## Iteration
242

## Scope
- files audited: 50 (all `.lean` files under `AlgebraicJacobian/` plus the root `AlgebraicJacobian.lean`)
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean *(focus file)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **NEW `gammaPushforwardNatIso`** (L664–670): `NatIso.ofComponents` with naturality closed by `ext x; rfl`. LSP: no errors; `lean_verify`: axiom-clean (propext / Classical.choice / Quot.sound only). The `rfl` naturality is legitimate — every component of `gammaPushforwardIso` is the identity on underlying elements.
  - **NEW `pullback_spec_tilde_iso`** (L686–693): uniqueness-of-left-adjoints route via `conjugateIsoEquiv`. LSP: no errors; `lean_verify`: axiom-clean. The directionality of the `Equiv.symm` application is subtle (adjL right-adjoint is `pushforward ⋙ Γ_R`, adjR right-adjoint is `Γ_{R'} ⋙ restrictScalars φ`, and `gammaPushforwardNatIso φ` types to `R_adjL ≅ R_adjR` which needs an outer `.symm` from `conjugateIsoEquiv`); the Lean type-checker accepts it and no error is raised, confirming the direction bookkeeping is correct.
  - **MODIFIED `gammaPushforwardIso`** (L285–302): middle iso now uses `restrictScalarsCongr` instead of `eqToIso`, making naturality `rfl`-provable. Axiom-clean; no errors.
  - **Pre-existing sorry — `affineBaseChange_pushforward_iso`** (L701, `sorry`): Status comment (L712–742) accurately enumerates two remaining Mathlib-absent obligations (affine reduction naturality and adjoint-mate ↔ cancelBaseChange identification). No excuse language. Appropriate documentation.
  - **Pre-existing sorry — `flatBaseChange_pushforward_isIso`** (L751, `sorry`): Comment (L753–764) accurately describes the Čech-cover strategy and the missing infrastructure. No excuse language.

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean *(focus file)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (see notes)
- **excuse-comments**: none
- **notes**:
  - **NEW `presheafPushforwardLaxMonoidal`** (L1137–1147): The proof body correctly defeq-casts `φ` to `φ'` (outer `⋙ forget₂` association) to avoid a kernel-rejected diamond, then `inferInstance`. LSP: no errors; `lean_verify`: axiom-clean. The `opaque` warning from `lean_verify`'s source scan is a false positive — the word appears in a prose comment at L488 ("a `have` would make `adj.unit` opaque and block the `congr` defeq"), not as a Lean keyword.
  - **NEW `presheafPullbackOplaxMonoidal`** (L1159–1166): one-line body `(pullbackPushforwardAdjunction φ).leftAdjointOplaxMonoidal`. LSP: no errors; `lean_verify`: axiom-clean. Correct doctrinal derivation of oplax structure from the lax right adjoint.
  - **Phase-2 STATUS comment** (L1168–1194, replacing earlier HANDOFF block): Accurately documents why `pullbackTensorIso` is a genuine Mathlib-scale build (abstract left adjoint has no concrete model; `PresheafOfModules.extendScalars` and topological inverse image absent). No excuse language. Appropriate.
  - **Pre-existing sorry — `exists_tensorObj_inverse`** (L715): Comment (L696–714) names the two specific remaining bridges (C: `dual_isLocallyTrivial`; A: `homOfLocalCompat`) and explains why the forbidden shortcuts are dead ends. No excuse language.
  - **Pre-existing sorry — `addCommGroup_via_tensorObj`** (L1227): Docstring (L1202–1222) documents the iter-202 scaffold origin and the `exists_tensorObj_inverse` dependency. No excuse language.
  - **Minor — namespace placement** (L1137, L1159): `presheafPushforwardLaxMonoidal` and `presheafPullbackOplaxMonoidal` are placed inside `AlgebraicGeometry.Scheme.Modules` but operate entirely at the general `PresheafOfModules` level; their own docstrings call them "reusable for the general pullback-monoidality build." This is an organizational mismatch — they would be more discoverable as `PresheafOfModules.pushforwardLaxMonoidal` etc. Not a correctness issue (axiom-clean, Lean is satisfied), but a reusability concern.

### AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `isLocallyInjective_whiskerLeft_of_W` (L478–572): full proof body via the stalk–tensor commutation (route-d). No `sorry`. Closed axiom-clean as of iter-237.
  - All other declarations (`isLocallySurjective_whiskerLeft`, `isLocallyInjective_whiskerLeft_of_flat`, `W_whiskerLeft/Right_of_flat/W`, `isIso_sheafification_map_of_W`, stalk-linear map family, stalk-bridge lemmas, `overSliceSheafEquiv`): axiom-clean, no issues.

### AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `stalkTensorIso` and the full stalk–tensor commutation family are in place axiom-clean. No issues.

### AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Internal hom, dual, pushforward adjunction, strong-monoidal restrictScalars family — all present. No issues.

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: **1 flagged**
- **notes**:
  - L266–269: `-- TODO (Scheme.Modules monoidal-structure gate): close once Mathlib ships a monoidal-category instance on Scheme.Modules (or once the project-side Scheme.Modules.tensorObj lemma lands). exact sorry`. The `TODO` keyword directly on a `sorry` body qualifies as an excuse-comment per the auditor's criteria. The context is mitigating (the condition is precisely named: a real Mathlib gap, and `TensorObjSubstrate.lean` now provides the project-side solution), but the language pattern is still present. Severity: **major** (pre-existing sorry, non-focus file, mitigation noted; but the `TODO` on a sorry must be called out).
  - All other declarations in the file: clean. `PicSharp.functorial := 0` placeholder is correctly documented as iter-198 RPF closure pending `addCommGroup`.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Two sorries (`genusZeroWitness` L236, `nonempty_jacobianWitness` L274) — both explicitly labeled Phase-C scaffolding; `nonempty_jacobianWitness` is the designated "OFF-LIMITS" sorry absorbing M2+M3 closure. No excuse language.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Single sorry for `rigidity_over_kbar` (L88) with documented cotangent-pile gate. Clean.

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Seven `⟨sorry⟩` instance bodies, each at a named "single sorry-carrying site" with explicit documentation isolating the `sorryAx`. Per the iter-196 lean-auditor must-fix, all inline sorries were demoted to named declarations; this structure is sound.

### AlgebraicJacobian/Picard/IdentityComponent.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Multiple sorry-bodied declarations, all with planner-sanctioned documentation citing specific missing Stacks/Mathlib infrastructure. No excuse language.

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Three named sorry-bodied declarations (`gmScalingP1_chart_agreement_cross01` and companions). Each is labeled as an "honest sorry" with a documented specific gap. No excuse language.

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Single sorry for `P1_geomIrred_kbar` (L220), labeled "Project-side scaffold sorry" with Mathlib gap documented. Clean.

### AlgebraicJacobian/Cohomology/HigherDirectImage.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Three sorry-bodied scaffold declarations; each documents the missing higher-direct-image infrastructure. No excuse language.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Multiple sorry bodies; all with clear A.3 chapter gate documentation. One helper `Pic0.bundle := sorry` is the "single sorry-carrying site" for the Albanese chain. No excuse language.

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Two named sorry helpers (`av_isIntegral_of_smooth_geomIrred` and `descentThroughBirationalSigma`); both demoted from inline sorries per iter-196 lean-auditor directive. Clean.

### AlgebraicJacobian/Albanese/{CodimOneExtension,AuslanderBuchsbaum}.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Scaffold sorry-bodies with accurate gate documentation. No issues.

### AlgebraicJacobian/{AbelJacobi,Genus,Rigidity,Differentials,RigidityLemma,AbelianVarietyRigidity}.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Clean or scaffold-sorry with documented gates. `AbelJacobi.lean` is sorry-free (delegates to the witness). `RigidityLemma.lean` is sorry-free. No issues.

### AlgebraicJacobian/Cotangent/{GrpObj,ChartAlgebra}.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Multiple sorry-bodied declarations in the iter-137 partial-close range; each documented with specific substep reference. No excuse language.

### All remaining files (Picard/{LineBundlePullback,QuotScheme,RelativeSpec,FlatteningStratification,Pic0AbelianVariety}, RiemannRoch/*, Cohomology/{SheafCompose,StructureSheafAb,MayerVietorisCover,MayerVietorisCore,StructureSheafModuleK/*}, Genus0BaseObjects/{Points,ChartIso,Cross01Substrate}, Albanese/CoheightBridge, RiemannRoch/H1Vanishing)
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Surveyed for sorry bodies and excuse-comment patterns. All sorry-bodied declarations in these files have standard scaffold-gate documentation or are axiom-clean. No issues found.

---

## Must-fix-this-iter

*(none)*

---

## Major

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:266` — `-- TODO (Scheme.Modules monoidal-structure gate): close once Mathlib ships…` is an excuse-comment on the `addCommGroup` sorry body. The `TODO` keyword directly preceding `exact sorry` matches the auditor's excuse-comment pattern. Mitigating factor: the condition is precisely named (a real Mathlib gap that the project is actively closing via `TensorObjSubstrate.lean`), so this is closer to "acknowledged technical debt" than "wrong but works." Still, per the auditor's rules, `TODO` on a sorry body requires a major call-out. The fix is to replace the `TODO` line with a status comment of the form "STATUS: open — gated on `exists_tensorObj_inverse` (iter-NNN target)", which is the style used in FlatBaseChange.lean and TensorObjSubstrate.lean.

---

## Minor

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1137,1159` — `presheafPushforwardLaxMonoidal` and `presheafPullbackOplaxMonoidal` are defined inside `AlgebraicGeometry.Scheme.Modules` but operate at the general `PresheafOfModules` level (neither declaration references any scheme object; their own docstrings call them "Project-local supplement; reusable for the general pullback-monoidality build"). Future callers looking for a presheaf-level pushforward lax-monoidal instance may not find them under the scheme namespace. Not a correctness issue; purely a discoverability concern.

---

## Excuse-comments (called out separately)

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:266`: `"-- TODO (Scheme.Modules monoidal-structure gate): close once Mathlib ships a monoidal-category instance on Scheme.Modules (or once the project-side Scheme.Modules.tensorObj lemma lands)."` (attached to `PicSharp.addCommGroup`, a load-bearing instance for the relative Picard functor). Severity: major (pre-existing sorry, specific condition cited, but `TODO` on sorry is an admitted deferral).

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1
- **minor**: 1
- **excuse-comments**: 1 (counted under major above; called out separately)

**Overall verdict**: Both focus files are clean — all four new declarations (`gammaPushforwardNatIso`, `pullback_spec_tilde_iso`, `presheafPushforwardLaxMonoidal`, `presheafPullbackOplaxMonoidal`) compile without errors, are axiom-clean (kernel triple only), and the four pre-existing sorry bodies carry accurate status documentation with no excuse language; the one flagged issue is a pre-existing `TODO` comment on a sorry in the non-focus `RelPicFunctor.lean`.
