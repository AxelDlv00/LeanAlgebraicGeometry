# Lean Audit Report

## Slug
iter201

## Iteration
201

## Scope
- files audited: 43
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **outdated comments**: 3 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 3 flagged (all documented substantive gaps)
- **bad practices**: 1 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - L28: `## Status (iter-172 file-skeleton)` — the file has grown from 9 skeleton declarations to 40+ declarations across 1648 lines. The header still describes only the iter-172 skeleton state. Minor stale comment.
  - L98: `Per iter-173 wd-spec-refine` — inline iter-reference in a code comment. Minor.
  - L222–236: The `Ring.ordFrac_ringEquiv` section comment references `PROGRESS.md L108--L122` — this is a plan-sidecar reference embedded in source code. Minor hygiene drift.
  - L248–268 (`Ring.ord_ringEquiv` body): the term `Module.length_eq_of_surjective (S := R) (R := S) ...` uses named arguments with swapped letter convention (what Mathlib calls the "base" ring is passed as `S :=` and vice versa). The logic is correct if `e.surjective` gives the right surjection direction, but it reads confusingly and will slow down any auditor or future prover. Minor bad practice.
  - L686–744 (`rationalMap_order_finite_support`): sorry in the `f ≠ 0` branch (Hartshorne II.6.1 / Stacks 02RV gap, expected).
  - L1017–1052 (`principal_degree_zero`): sorry in the non-constant branch (Milne/Hartshorne II.6.10 gap, expected).
  - L1518–1622 (`degree_positivePart_principal_eq_finrank`): sorry after Steps A+B+C (ramification-inertia bridge, Hartshorne II.6.9, expected).
  - L1264 (`isRegularInCodimOneProjectiveLineBar`): correctly promoted to `theorem` (not `instance`) per iter-196 audit. The body closes the `y.asIdeal ≠ ⊥` branch axiom-clean via generic-point argument; the substantive proof is sound.
  - New iter-201 private declarations (L238–537): `ord_ringEquiv`, `nonZeroDivisors_ringEquiv`, `ordMonoidWithZeroHom_ringEquiv`, `ordFrac_ringEquiv`, `Scheme.Opens.functionFieldIso`, `Scheme.PrimeDivisor.ordFrac_stalkIso_naturality` — all private; bodies look logically consistent on close reading; no headline-laundering detected.

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
- **outdated comments**: 3 flagged (2 major stale-sorry labels, 1 minor)
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 1 flagged (`auslander_buchsbaum_formula_succ_pd`, expected gap)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **MAJOR (L2415 section header)**: `/-! ### Helper iter-191 Lane G (substantive typed sorry): '(x)' is not a minimal prime ...` — The label `(substantive typed sorry)` in the section header is **stale**. The body of `notMem_minimalPrimes_of_regularLocal_succ` (L2460–2628) is a full axiom-clean proof (prime avoidance + Nakayama + domain argument). A reader sees "typed sorry" in the heading and will incorrectly believe the declaration is sorry-bodied. Must be updated.
  - **MAJOR (L1906 docstring)**: `finrank_cotangentSpace_quot_span_singleton_succ`'s docstring still says "structural scaffold with the assembled body left as a single named typed sorry (the κ-subspace identification step)". The body (L1930–2162) is a full proof with no sorry. The "typed sorry" label is stale from iter-187; the iter-188+ plan section was executed. Must be clarified.
  - **MINOR (L2963)**: Comment block in `regularLocal_inductive_step` says "**iter-185 typed `sorry` — TECHNICAL BRIDGE**" followed by "iter-186 Lane G: closed kernel-clean". The sorry was closed in iter-186 but the "typed sorry" label in the comment was not cleaned up.
  - L40–43 (module header): "remaining five typed `sorry` bodies (`depth`, `depth_eq_smallest_ext_index`, ...)" — `depth` now has a concrete body (the sSup expression). The count of remaining sorries in the header is outdated. Minor.
  - L1696: `auslander_buchsbaum_formula_succ_pd` has one sorry (Stacks 00MF gap). All setup code in that body is axiom-clean; the sorry is correctly positioned after the three substrate helpers are wired.
  - **Structural advance this iter**: `notMem_minimalPrimes_of_regularLocal_succ` is closed (full proof), which closes the chain: `isDomain_of_regularLocal` (Stacks 00NQ) → `exists_isSMulRegular_notMemSq_of_regularLocal_succ` → `exists_isSMulRegular_quotient_isRegularLocal_succ` → `regularLocal_inductive_step` → `exists_isRegular_of_regularLocal` → `CohenMacaulay.of_regular`. The `CohenMacaulay.of_regular` instance appears **axiom-clean** in iter-201 for the first time.
  - New iter-201 private declarations (L1397–1517): `elemMap`, `elemMap_apply`, `linearMap_finFunR_matrix_decomp`, `ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator` — all private, clean proofs; the matrix-collapse result is used by the Path B base-case plan. No headline laundering.
  - New iter-201 private declarations in `CodimOneExtension.lean` namespace: `submersivePresentation_relation_cotangent_mk_linearIndependent`, `..._localized` — axiom-clean; Analogue D of the coe-stacks00sw recipe.
  - `isDomain_of_regularLocal` is private — could be promoted to public Stacks 00NQ export in a future iter.

### AlgebraicJacobian/Albanese/CodimOneExtension.lean
- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 3 flagged (all substantive, expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - L39–48 (module header): "Status (iter-177 Lane 6 file-skeleton). Bodies are iter-178+ work" — historical, now at iter-201. Minor stale.
  - L1179: `isRegularLocalRing_stalk_of_smooth` sorry (Stacks 00TT Stage 6 ii.B Krull-dim formula gap, expected).
  - L1376: `extend_of_codimOneFree_of_smooth` sorry (Milne 3.1, gated on 00TT + local cohomology 0AVF, expected).
  - L1451: `indeterminacy_pure_codim_one_into_grpScheme` sorry (Milne 3.3, function-field-pullback gap, expected).
  - New iter-201 declarations (L843–1001): Six clean private declarations advancing the Stacks-00OE chain: `submersivePresentation_relation_cotangent_mk_linearIndependent`, `..._localized`, `ringKrullDim_quotient_localization_MvPolynomial_of_regular` — all axiom-clean. No sorry. The "Mathlib-gap-conditional" labeling on `ringKrullDim_quotient_localization_MvPolynomial_of_regular` is accurate.
  - `cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue` and siblings from iter-199 are clean.
  - `MvPolynomial.maximalIdeal_height_ge_card_of_field` and `maximalIdeal_height_eq_natCard` from iter-200 are clean.
  - `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` correctly delegates to the named sorry helper rather than inlining a bare sorry.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 7 flagged (all documented file-skeleton sorries, expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: File-skeleton with 6 pinned declarations all carrying typed-sorry bodies; `Pic0.bundle` typed-sorry carrier is the one helper carrying a sorry. Documentation is accurate.

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 2 flagged (sorry-bodied Milne 3.2 theorem + `extend_to_av`; expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: Single pinned declaration with sorry body; imports CodimOneExtension correctly.

### AlgebraicJacobian/Albanese/CoheightBridge.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: All four declarations appear axiom-clean (open embedding coheight preservation, spec vs height bridge, ringKrullDim stalk bridge, KrullDimLE codim-1 wrapper). No sorries detected.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged (all projections from `jacobianWitness`, no sorries)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: All 3 declarations are pure projections from `(jacobianWitness C).isAlbaneseFor P`; clean.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 1 flagged (minor, "Status (Phase C scaffolding)")
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 2 flagged (`genusZeroWitness.key` sorry; `positiveGenusWitness` := sorry)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - `genusZeroWitness.isAlbaneseFor` body has an inline `sorry` at `have key : f = toUnit C ≫ η[A] := by sorry` — this is a documented gap (k̄ pullback + descent step). Not an excuse-comment per se, but it's the only sorry inside a named `have`, which is slightly unusual. Minor.
  - `positiveGenusWitness := sorry` — correct Phase-C scaffolding.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 3 flagged (sorry bodies for Gm-scaling shortcut, `genusZero_curve_iso_P1`, and `rigidity_genus0_curve_to_grpScheme`; all expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: File imports and structure look clean. The `iotaGm_onePt_chart1_inChart1Range` proof at L81 appears axiom-clean per iter-190 progress.

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 1 flagged (sorry-bodied `eulerCharacteristic_eq_degree_plus_one_minus_genus`, expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: `eulerCharacteristic` concrete def (H⁰ - H¹ finranks). `l` and `sheafOf` placeholder carry typed sorries. All expected.

### AlgebraicJacobian/RiemannRoch/OcOfD.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 2 flagged (file-skeleton, expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: Skeleton with honest typed-sorry bodies per iter-183 Lane K.

### AlgebraicJacobian/RiemannRoch/OCofP.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 3 flagged (5 pinned declarations, 3 with sorry; expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: iter-183 Lane A sig-amend + scaffold landed; `lineBundleAtClosedPoint.carrierSet` is concrete. Clean structure.

### AlgebraicJacobian/RiemannRoch/H1Vanishing.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 2 flagged (iter-191 Lane H file-skeleton sorries, expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: 8 pinned declarations; all typed-sorry bodies per iter-191 skeleton.

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 4 flagged (all sorry-bodied, iter-177/181 skeleton; expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: `morphismToP1OfGlobalSections` and siblings carry substantive typed-sorry bodies.

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 1 flagged (addCommGroup instance sorry, L269)
- **bad practices**: 0 flagged
- **excuse-comments**: 1 flagged (see Must-fix-this-iter)
- **notes**:
  - L266–269: `-- TODO (Scheme.Modules monoidal-structure gate): close once Mathlib ships a monoidal-category instance on Scheme.Modules...` followed immediately by `exact sorry` inside the `addCommGroup` instance body. This is a `-- TODO` + sorry excuse-comment pattern. The `addCommGroup` instance on `Quotient (preimage_subgroup πC πT)` is a **load-bearing** declaration: four downstream declarations (`PicSharp`, `PicSharp.presheaf`, etc.) silently inherit a `sorryAx` taint through it (explicitly noted in the file header at L25–31). The TODO does not remove the obligation.

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged (no sorries visible)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 8 flagged (all quota-scheme skeleton sorries, expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: File-skeleton with documented Mathlib gaps (GIT representability, etc.).

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: all sorry-bodied (FGA chapter skeleton, expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Picard/IdentityComponent.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 9 flagged (all sorry, expected for Pic⁰ identity-component skeleton)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 7 flagged (all sorry, expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 5 flagged (all sorry, expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 1 flagged (projectiveLineBar_smooth or similar scaffold sorry; expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 3 flagged (Gm-scaling construction sorries; expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Genus0BaseObjects/Points.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged (rigidity_lemma chain is PROVEN axiom-clean per iter-157–162)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 1 flagged (sorry-body; route (a) fallback, expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 1 flagged (sorry-bodied chart algebra lemma, expected)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 2 flagged (expected Mayer-Vietoris sorries)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**: -

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:266–269` — `-- TODO (Scheme.Modules monoidal-structure gate): close once Mathlib ships a monoidal-category instance on Scheme.Modules (or once the project-side Scheme.Modules.tensorObj lemma lands).` followed by `exact sorry` in the body of the `addCommGroup` instance for `Quotient (preimage_subgroup πC πT)`. Why must-fix: this is a `-- TODO ... exact sorry` excuse-comment on a load-bearing group-structure declaration. The `addCommGroup` instance is the only group structure on the relative Picard quotient; four downstream declarations inherit a `sorryAx` taint through it. The TODO comment acknowledges the obligation but does not discharge it; it silences the alarm precisely where alarm is warranted. Per descriptor rules, any excuse-comment on a load-bearing declaration is must-fix regardless of the explanation's accuracy.

---

## Major

- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:2415` — section header `/-! ### Helper iter-191 Lane G (substantive typed sorry): '(x)' is not a minimal prime ...` is stale. The body of `notMem_minimalPrimes_of_regularLocal_succ` (L2460–2628) is a full axiom-clean proof landed this iter. The "substantive typed sorry" label will mislead any reader—including the plan agent—into thinking the declaration is sorry-bodied.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:1906` — docstring for `finrank_cotangentSpace_quot_span_singleton_succ` says "body left as a single named typed sorry (the κ-subspace identification step)". The body at L1930–2162 is a full proof. The "typed sorry" label is stale from iter-187 and falsely describes the current state.

---

## Minor

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:28` — Module-level header "Status (iter-172 file-skeleton)" describes only the original skeleton. The file has grown to 1648 lines across multiple iters; the status comment creates a misleading impression about the file's current scope.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:267` — `Module.length_eq_of_surjective (S := R) (R := S) ...` uses argument names in the opposite order from the obvious convention. The logic is probably correct (Lean's type checker would catch a type mismatch), but any future auditor or prover will spend time verifying the argument-name swap is intentional.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:2963` — Comment "**iter-185 typed `sorry` — TECHNICAL BRIDGE**" (immediately above a section that's now closed via the iter-186 bridge). The stale "typed sorry" label persists in the comment even though "iter-186 Lane G: closed kernel-clean via the explicit `R⧸(x)`-linear equiv" appears in the same block.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:40–43` — Module header still lists "remaining five typed `sorry` bodies" including `depth`, which now has a concrete sSup-based body. Count is outdated.
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean:39–48` — "Status (iter-177 Lane 6 file-skeleton). Bodies are iter-178+ work" — historical, now at iter-201 with substantial content added.

---

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:266`: "TODO (Scheme.Modules monoidal-structure gate): close once Mathlib ships a monoidal-category instance on `Scheme.Modules` (or once the project-side `Scheme.Modules.tensorObj` lemma lands)." (attached to the `addCommGroup` instance body for `Quotient (preimage_subgroup πC πT)`, which is load-bearing for four downstream declarations silently inheriting `sorryAx`). Severity: must-fix-this-iter / major.

---

## Severity summary

- **must-fix-this-iter**: 1 — blocks downstream Picard functor work from being axiom-clean.
- **major**: 2 — both are stale "typed sorry" labels in comments that actively misrepresent current proof status.
- **minor**: 5
- **excuse-comments**: 1 (also counted under must-fix-this-iter above).

Overall verdict: The three focus files carry clean, substantive new work — the `Ring.ordFrac_ringEquiv` substrate and the `notMem_minimalPrimes_of_regularLocal_succ` closure (making `CohenMacaulay.of_regular` axiom-clean for the first time) are genuine advances with no headline-laundering detected. The primary audit concern is the pre-existing excuse-comment in `RelPicFunctor.lean` and two stale "typed sorry" labels in `AuslanderBuchsbaum.lean` that falsely describe now-closed proofs.
