# Lean Audit Report

## Slug
iter203

## Iteration
203

## Scope
- files audited: 45
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Import-only shim. No declarations.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Single honest one-liner `Module.finrank k (Scheme.HModule k ...)`. Axiom-clean.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `Scheme.Over.ext_of_eqOnOpen` is closed axiom-clean. Historical hypothesis-history comment block is informative, not misleading.

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Entire rigidity-lemma chain (iters 157–162) + both Milne §I.1 corollaries proven axiom-clean. File docstring accurately reflects current state.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Single `sorry`-bodied `rigidity_over_kbar`. Honest typed sorry; body gated on cotangent-vanishing pile. Type is substantive and non-tautological.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Three scaffold declarations with honest sorry bodies; `SCAFFOLD` markers in comments are informative, not excuse-comments. Correctly imports `RigidityLemma` (axiom-clean upstream).

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: All three declarations are honest one-liner projections from the Jacobian witness's `isAlbaneseFor` field. Axiom-clean modulo `nonempty_jacobianWitness`.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Two sorry-bodied declarations: `genusZeroWitness` (iter-127 scaffold) and `nonempty_jacobianWitness` (Phase-C gate). Both are genuine mathematical obligations honestly labeled. The "Forbidden shortcut" note is informative and accurate.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Relative cotangent presheaf file. Headers visible; declarations use `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'` as the backbone. No visible issues in scanned portion.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Single instance closed iter-003 via `hasSheafCompose_of_preservesLimitsOfSize`. Axiom-clean.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Three declarations closed iter-004 axiom-clean. `inferInstance` pattern appropriate.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Re-export shim only. No declarations.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Categorical gap-fills and presheaf construction. Scanned header; declarations appear honest. `Functor.const_additive` instance at line 32 is a legitimate Mathlib gap-fill.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Sheaf property and bundled structure sheaf. Scanned header; declarations appear honest.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Finite-length carriers and producer instances. Note at line 30 documenting an abandoned `IsAffineHModuleHomFinite` attempt is informative dead-code documentation, not an excuse-comment.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Mayer-Vietoris LES core and `Abelian.Ext.chgUnivLinearEquiv` gap-fill. The "iter-034 Mathlib gap-fill" framing is accurate. Declarations appear honest.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 2-affine cover MV and cover-totality infrastructure. Scanned header; appears consistent with rest of cohomology chain.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `cotangentSpaceAtIdentity` and its rank lemma closed iter-132. Docstring accurately records the iter-128/129 body revision history.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 1 flagged (iter-145/146 notes referencing removed import)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Comment at lines 21-35 references `Mathlib.RingTheory.IsPushout` (a file that does not exist) and notes it was "intentionally omitted" — this is a stale note from iter-145 scaffolding describing a non-existent import. Minor.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Re-export shim only. Docstring accurately describes the four-stratum split.

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Standard grading, projective line construction, and instances. Scanned header; declarations appear honest.

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Chart-ring iso declarations. Scanned header; appears honest.

### AlgebraicJacobian/Genus0BaseObjects/Points.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Standard k̄-points + Ga + Gm declarations. Scanned header; scaffold `GrpObj Gm` noted, appears honest.

### AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Substrate lemmas for GmScaling. `IsClosedImmersion.lift_iff_range_subset` noted as axiom-clean iter-189. Scanned header.

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Scaling action infrastructure. Scanned header; scaffold sorry bodies noted as off-target (`gm_geomIrred`, `projGm_isReduced`).

### AlgebraicJacobian/Albanese/CoheightBridge.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Four declarations including `ringKrullDim_stalk_eq_coheight` (the key bridge). File is iter-183 closed content. No issues.

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
- **outdated comments**: 1 flagged (iter-195 "opaque" comment at line 1707 is about inline comment style, not an opaque Lean declaration; stale reference to `auslander_buchsbaum_formula` gap is the known issue)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Per Known Issues: stale comments referencing the now-closed `auslander_buchsbaum_formula` gap are pre-flagged and deferred.
  - `lean_verify` confirms `isDomain_of_regularLocal` and `regularLocal_quotient_isRegularLocal_of_notMemSq` are axiom-clean (only `{propext, Classical.choice, Quot.sound}`). The `opaque` warning from the tool was a false positive — the word "opaque" appears in a comment at line 1707 describing an inline comment style, not an actual `opaque` declaration.
  - `depth_eq_smallest_ext_index` carries honest residual sorries (forward and backward directions labeled with `-- iter-183 Lane G structural progress` and remaining gaps).
  - File is sorry-free in its closed declarations. ✓

### AlgebraicJacobian/Albanese/CodimOneExtension.lean [FOCUS FILE]
- **outdated comments**: 2 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Stale status header (lines 40–50)**: Section `## Status (iter-177 Lane 6 file-skeleton)` says "Each of the six blueprint-pinned declarations carries the *intended* substantive type signature ... with a `sorry` body." This is no longer true — the file has grown to 1883 lines with extensive axiom-clean content. The header was not updated to reflect post-iter-177 progress. **Minor** (misleading but does not admit wrong code).
  - **Stale Stacks 00TT scaffolding header (lines 196–218)**: Label `(Lane M↓ iter-191 first scaffold)` says "Stages 3-4 remain a single scoped sorry inside the main theorem." This is partially stale since many additional stages (3a through 6.B) have been built since iter-191. The sorry at line 1525 is still present but the description understates the surrounding axiom-clean content. **Minor**.
  - **New §3.C declarations (lines 1043–1303) — all axiom-clean per `lean_verify`**:
    - `quotSMulTop_quotientRing_linearEquiv` (line 1071): axiom-clean. `{propext, Classical.choice, Quot.sound}` only.
    - `isRegular_cons_of_quotient_ring` (line 1084): axiom-clean. `{propext, Classical.choice, Quot.sound}` only.
    - `matsumura_descent_cotangent` (line 1118, `set_option maxHeartbeats 1600000`): axiom-clean. The heartbeat bump is justified — the comment at line 1093–1095 correctly attributes the cost to the `linearIndependent_iff` argument and the cotangent-map kernel computation. Proof body is a genuine 90-line algebraic argument with no sorries. The bump is not masking an infinite loop.
    - `matsumura_isRegular_of_linearIndependent_cotangent` (line 1236): axiom-clean. Uses `isDomain_of_regularLocal` and `regularLocal_quotient_isRegularLocal_of_notMemSq` from AuslanderBuchsbaum.lean, which are themselves axiom-clean.
  - **No circular dependence**: The three pre-existing sorries (line 1525 `isRegularLocalRing_stalk_of_smooth`, line 1722 `extend_of_codimOneFree_of_smooth`, line 1797 `indeterminacy_pure_codim_one_into_grpScheme`) are in §§3, 4, 5 of the file. The new §3.C declarations are independent private helpers that do not call or depend on any of these three sorried declarations.
  - The three pre-existing sorries have substantive, correctly typed bodies (genuine mathematical content), properly labeled with their Mathlib-gap context. All three are scope-fenced Known Issues.

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Single scaffold declaration `extend_to_av` with honest sorry body. Gated on sibling chapters. Type is substantive.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Status header says "iter-177 Lane 7 file-skeleton" — not updated to reflect which bodies have since been attempted. Six sorry-bodied declarations. All honest typed sorries. **Minor** (stale iteration reference).

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: iter-179 Block A adopted `Scheme.AffineZariskiSite.relativeGluingData`. `RelativeSpec` and `structureMorphism` have honest Mathlib-canonical bodies; the three downstream theorems carry honest sorry bodies. Accurately documented.

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Five sorry-bodied declarations. The "typed sorry at the type level" note for `OnProduct` (citing missing `Module.Invertible` predicate on `Scheme.Modules`) is accurately documented infrastructure explanation, not an excuse-comment.

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged (see notes — **must-fix**)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 flagged (see notes — **must-fix**)
- **notes**:
  - **`PicSharp` (line 330) — weakened-wrong definition**: The body is `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))` — the constant functor at `PUnit`, which is mathematically wrong (the actual relative Picard functor `T ↦ Pic(C × T) / π_T^* Pic(T)` is non-constant and non-trivial). This is a textbook weakened-wrong definition.
  - **Excuse-comment at lines 313–326**: The docstring says "the body is a `Functor.const`-style trivial functor ... This is a sorry-free placeholder used while the file-local `addCommGroup` sorry in §1 is open" and "The trivial target is harmless." This is an explicit admission that the definition is wrong, with a "will fix later" justification. This is exactly the excuse-comment pattern the audit mandate flags.
  - The correct fix is to make `PicSharp` a sorry-bodied definition (matching the honest `addCommGroup` sorry at line 269) rather than a wrong-but-compilable placeholder. Using `sorry` directly on `PicSharp` would be semantically honest; the constant-functor body is semantically dishonest.
  - `addCommGroup` (line 269): `exact sorry` — correct and honest. Not an issue.
  - `PicSharp.functorial` (zero `AddMonoidHom` body per header description): also a weakened-wrong definition, follows from the `PicSharp` placeholder. Secondary issue to the primary `PicSharp` finding.

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean [FOCUS FILE]
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`tensorObj` (line 113)**: axiom-clean per `lean_verify` — `{propext, Classical.choice, Quot.sound}` only. Body lifts `PresheafOfModules.Monoidal.tensorObj` through the sheafification functor with an explicit type ascription `: SheafOfModules X.ringCatSheaf`. Genuine definition.
  - **`tensorObj_functoriality` (line 129)**: axiom-clean per `lean_verify` — `{propext, Classical.choice, Quot.sound}` only. The mid-session `sorryAx` report was a transient pre-fix state; the final body is sorry-free. The annotation `(C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))` is a sound named-argument disambiguation fixing the presheaf-level monoidal category; it relies on the Mathlib-shipped `MonoidalCategory` instance on `PresheafOfModules`, not on the sorry'd project-side `monoidalCategory` instance.
  - **`monoidalCategory := sorry` (line 152)**: confirmed has `sorryAx`. Correctly contained — neither `tensorObj` nor `tensorObj_functoriality` synthesizes from this instance (both fix the category explicitly via the `C := ...` annotation or use the presheaf-level functor directly). No axiom-clean declaration transitively depends on `monoidalCategory`.
  - **`tensorObjOnProduct` (line 194)**: inherits `sorryAx` from `tensorObj_isLocallyTrivial` (line 171, `:= sorry`). Expected scaffolding behavior; `tensorObjOnProduct` itself has a genuine body that calls the sorry'd helper.
  - **`addCommGroup_via_tensorObj` (line 221)**: `:= sorry`. Honest typed sorry; docstring correctly describes it as the iter-204+ closure target.

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Six scaffold declarations with `⟨sorry⟩` instance bodies. The "carrier sorry bodies isolated to Prop-valued typeclass instance constructors" approach is honestly documented and the type signatures are substantive.

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Six scaffold declarations with honest sorry bodies. Correctly describes the Nitsure §5 depth of the remaining work.

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Four scaffold declarations with honest sorry bodies. Type signatures substantive.

### AlgebraicJacobian/Picard/IdentityComponent.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Five scaffold declarations with honest sorry bodies. iter-185 file-skeleton correctly documented.

### AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Five scaffold declarations with honest sorry bodies. iter-193 file-skeleton correctly documented.

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Nine scaffold declarations with honest sorry bodies. Status correctly says iter-172 Lane C file-skeleton.

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Four scaffold declarations. `eulerCharacteristic` carrier definition is concrete (honest `finrank` difference). Three remaining bodies are honest sorry bodies.

### AlgebraicJacobian/RiemannRoch/OCofP.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Five scaffold declarations. iter-183 Lane A landed sig amend + `carrierSet` scaffold. Bodies honestly sorry'd with clear closure plan.

### AlgebraicJacobian/RiemannRoch/OcOfD.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Four scaffold declarations with honest sorry bodies. "Tier-3 honest typed sorry" vocabulary used in docstring is informative not problematic.

### AlgebraicJacobian/RiemannRoch/H1Vanishing.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Eight scaffold declarations with honest sorry bodies. iter-191 file-skeleton; closure plan (Hartshorne III.2.5 flasque-vanishing) correctly described.

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Three scaffold declarations. iter-181 Pin 3 signature refinement accurately documented. Honest sorry bodies.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:330` — `PicSharp` is defined as `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))` (the constant functor at the trivial group), standing in for the actual relative Picard functor `T ↦ Pic(C × T) / π_T^* Pic(T)`. The docstring at lines 313–326 explicitly calls this a "sorry-free placeholder used while the file-local `addCommGroup` sorry in §1 is open," which is an excuse-comment. Why must-fix: weakened-wrong definition (`PicSharp` should be mathematically the relative Picard functor) with an attached excuse-comment; the correct scaffolding form is `noncomputable def PicSharp ... := sorry`, matching the honest `addCommGroup` body at line 269.

---

## Major

None.

---

## Minor

- `AlgebraicJacobian/Albanese/CodimOneExtension.lean:40` — Section header `## Status (iter-177 Lane 6 file-skeleton)` says "each of the six blueprint-pinned declarations carries ... a sorry body," which is no longer true for the file (now 1883 lines, many axiom-clean helpers). Misleads a reader about the current file state; should be updated to reflect iter-203 status.
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean:196` — Stacks 00TT scaffolding section label `(Lane M↓ iter-191 first scaffold)` and the statement "Stages 3-4 remain a single scoped sorry inside the main theorem" is partially stale: many stages (3a through 6.B substrate) have been built since iter-191 around the single remaining sorry at line 1525.
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:21` — Comment references `Mathlib.RingTheory.IsPushout` (a non-existent file) as a "desired import" that was "intentionally omitted." The comment should either be removed or updated to reference the correct module (`Mathlib.RingTheory.IsTensorProduct`).
- `AlgebraicJacobian/Albanese/AlbaneseUP.lean:32` — Status header says "iter-177 Lane 7 file-skeleton"; the iteration label was never updated through subsequent work.

---

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:313`: "iter-198 Lane RPF closure: the body is a `Functor.const`-style trivial functor at `AddCommGrpCat.of PUnit.{u+2}`. This is a sorry-free placeholder used while the file-local `addCommGroup` sorry in §1 is open" (attached to `PicSharp`, a load-bearing definition consumed by `PicSharp.presheaf`, `PicSharp.etSheaf`, and `PicSharp.etSheaf_group_structure`). Severity: **must-fix**.

---

## Severity summary

- **must-fix-this-iter**: 1
- **major**: 0
- **minor**: 4
- **excuse-comments**: 1 (also counted under must-fix-this-iter above)

**Overall verdict**: The iter-203 focus work in `CodimOneExtension.lean` (§3.C Matsumura criterion — 4 new axiom-clean declarations) and `TensorObjSubstrate.lean` (`tensorObj`/`tensorObj_functoriality` sorry-free with contained monoidal sorry) is sound; one pre-existing weakened-wrong definition in `RelPicFunctor.lean` (`PicSharp := constant functor at PUnit`) requires replacement with an honest sorry body.
