# Lean Audit Report

## Slug
ts230-auditor2

## Iteration
230

## Scope
- files audited: 9
- files skipped (per directive): 0

All 9 `.lean` files under `AlgebraicJacobian/Picard/`:
- `TensorObjSubstrate.lean` (primary, 2376 lines)
- `FGAPicRepresentability.lean`
- `RelPicFunctor.lean`
- `RelativeSpec.lean`
- `LineBundlePullback.lean`
- `QuotScheme.lean`
- `IdentityComponent.lean`
- `FlatteningStratification.lean`
- `Pic0AbelianVariety.lean`

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: 0 (sorry bodies are openly disclosed)
- **dead-end proofs**: 0
- **bad practices**: 1 flagged
- **excuse-comments**: 0
- **notes**:
  - **MUST-FIX** (stale narrative, line 2264–2288): the `overSliceSheafEquiv` section header claims "This is the single Mathlib-absent root on which BOTH remaining ⊗-inverse bridges (the A-engine `homOfLocalCompat` gluing and the C-bridge `dual_isLocallyTrivial`) reduce." This is directly contradicted by the iter-230 diagnostic added in the **same file** at lines 2118–2161, which states: "**This residual CANNOT be discharged by the shared root `overSliceSheafEquiv`** — outcome (ii), not (i)" and provides three bullet-point reasons (wrong category level — `Sheaf` vs `PresheafOfModules`; fixed value-category vs varying ring; per-open slice vs whole-`U` slice site). The section header has not been updated to reflect this probe result. As written, a future prover reading the section header (without seeing the 200-line-later diagnostic) will waste effort applying `overSliceSheafEquiv` to the C-bridge.
  - **Minor** (stale phrasing, line 219): "this ring-iso strong upgrade is **absent**" — the declared `restrictScalasRingIsoTensorEquiv` IS this upgrade; the sentence should read "absent from Mathlib" for clarity, but the current phrasing reads as if the upgrade is still absent.
  - **Minor** (`set_option backward.isDefEq.respectTransparency false`, lines 359, 375, 392, 960): used four times. Each occurrence drops the option silently with no per-site comment explaining the specific elaboration issue. This is non-standard and should carry a short justification.
  - The three `sorry` bodies (`isLocallyInjective_whiskerLeft_of_W` L691, `exists_tensorObj_inverse` L2210, `addCommGroup_via_tensorObj` L2256) are all honestly documented with precise decompositions of what remains. No excuse-comment quality — straight open-gap documentation.
  - `overSliceSheafEquiv` and `overEquivInverseIsDenseSubsite` are axiom-clean (no `sorry`). Proof structure looks sound.
  - `tensorObj_restrict_iso` (closed axiom-clean, iter-217): four-step proof body is technically correct and well-commented.
  - `internalHomEval` (closed axiom-clean, iter-224): six-step reduction is intact, no vestigial tactics.
  - `isIso_of_isIso_restrict` (B-connector, axiom-clean): proof via `restrictStalkNatIso` + `isIso_of_stalkFunctor_map_iso` is correct.
  - `dualIsoOfIso` and `dualPrecompEquiv`: axiom-clean, proofs are clean.

---

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - All 5 sorry burdens are properly isolated in `⟨sorry⟩` typeclass-instance bodies (`instHasPicSharp`, `instHasDivFunctor`, `instHasPicScheme`, `instHasAbelMap`, `instHasSmoothProperQuotient`, `instPicSharpRepresentable`, `instPicSchemeGroupObject`). The actual declaration bodies extract via `Classical.choice`/`.choose` and are axiom-clean relative to those instances. This is the project's authorized carrier-soundness pattern.
  - `smoothProperQuotient` body extracts cleanly from the typeclass field. No vestigial code.
  - The placeholder typeclasses `HasPicSharp`, `HasDivFunctor` and the `picSharp`/`divFunctor` defs are explicitly documented as forward references to sibling files. This is honest.

---

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: 0
- **suspect definitions**: 2 flagged (MUST-FIX)
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 2 flagged (MUST-FIX — same as suspect definitions)
- **notes**:
  - **MUST-FIX + EXCUSE-COMMENT** (`PicSharp`, lines 327–331): the body is `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))` — a trivial constant functor returning `PUnit`, which is not the relative Picard functor. The accompanying comment (lines 310–326) openly admits: "This is a sorry-free placeholder used while the file-local `addCommGroup` sorry in §1 is open." The declaration is blueprint-pinned (`def:rel_pic_sharp`), is load-bearing (downstream `presheaf`/`etSheaf` consume it), and its body is structurally wrong relative to the named concept.
  - **MUST-FIX + EXCUSE-COMMENT** (`PicSharp.functorial`, lines 372–377): body is `0` (the zero `AddMonoidHom`). The comment (lines 357–373) admits: "the body is the zero AddMonoidHom". The declared type is a non-trivial group homomorphism; `0` is the wrong definition. Blueprint-pinned (`lem:rel_pic_sharp_functorial`).
  - **MUST-FIX** (`PicSharp.addCommGroup`, lines 235–269): body is `exact sorry`. This is a `:= sorry` on a load-bearing typeclass instance. The surrounding docstring is extensive and honest, describing the precise Mathlib monoidal gap blocking closure. Not an excuse-comment in quality, but mechanically a must-fix by the sorry-on-load-bearing-claim rule.
  - `PicSharp.presheaf` (line 421–424): body is `PicSharp _C`, which is correct given the current `PicSharp` body — it's a re-export rather than additional wrong content. But it inherits the wrongness of `PicSharp`.
  - `PicSharp.etSheaf` (line 486–490): body is `(presheafToSheaf J _).obj (PicSharp.presheaf _C)` — axiom-clean given the presheaf. The topology parameter is left abstract, honestly documented.
  - `PicSharp.etSheaf_group_structure` (line 539–544): body is `⟨0⟩`. Honest about being the zero natural transformation; the comment explains why this is sufficient for the `Nonempty` claim. No stronger claim is made.

---

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: 1 flagged (major)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - **Major** (`RelativeSpec.functor` docstring, lines 706–707): the docstring says "the body is concrete via `Over.mk (RelativeSpec.structureMorphism 𝒜)` but is left as `sorry` here because `RelativeSpec.structureMorphism` is itself a typed `sorry`". `RelativeSpec.structureMorphism` is NOT a sorry — it has been `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).toBase` since iter-179. The body itself (line 709) is correct; only the docstring is stale.
  - The bulk of the file is axiom-clean: `RelativeSpec.UniversalProperty`, `affine_base_iff`, `QcohAlgebra.pullback_fst_isAffineHom`, `QcohAlgebra.pullback_coequifibered`, `QcohAlgebra.pullback`, `pullback_iso_affine_piece`, `pullback_cocone`, `pullback_cocone_desc_comp_fst`, `pullback_iso_desc_isIso`, `pullback_iso_construction`, `pullback_iso`, `base_change` all have real proof bodies.
  - `set_option backward.isDefEq.respectTransparency false` at line 459 before `pullback_cocone` — one use, not commented; minor.

---

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: 0
- **suspect definitions**: 1 flagged (major)
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 1 flagged (major — same as suspect definition)
- **notes**:
  - **Major + EXCUSE-COMMENT** (`preimage_subgroup`, lines 349–356): the `Setoid` encodes the iso-class relation `L ~ L' ↔ Nonempty (L.carrier ≅ L'.carrier)`. This is NOT the correct relative Picard equivalence relation `L ~ L' ↔ L ⊗ L'⁻¹ ∈ π_T^* Pic(T)`. The comment acknowledges: "We encode the **iso-class setoid**... does not yet quotient by the pullback subgroup `π_T^* Pic(T)`. iter-187+: refine to `L ~ L' ↔ ∃ N, Nonempty (L ⊗ L'⁻¹ ≅ ...)` once both are available." This is a documented weakening with a "will fix later" excuse-comment.
  - `IsLocallyTrivial.pullback` (lines 156–193): the 7-step iso chain is axiom-clean and correct.
  - `pullbackAlongProjection`, `pullback_pullback_eq`, `OnProduct`, `OnProduct.carrier`, `OnProduct.isLocallyTrivial`: all axiom-clean or clean definitions.
  - `RelPicPresheaf.functorial` (lines 400–411): the `Quotient.lift` construction is correct (sends `L` to `[pullback g_C L]`).

---

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: 0
- **suspect definitions**: 3 flagged (major — data `def`s with `:= sorry`)
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - `hilbertPolynomial` (line 170–173): `sorry` body on a data-valued `def` (returns `Polynomial ℚ`). The function is meaningless until the body lands. Load-bearing for `QuotFunctor`. Honestly documented.
  - `QuotFunctor` (lines 208–213): `sorry` body returning a functor. Honestly documented as iter-176 file-skeleton.
  - `Grassmannian` (lines 245–249): `sorry` body returning a functor. Honestly documented.
  - The remaining 5 sorry bodies (`Grassmannian.representable`, `QuotScheme`, `genericFlatness`, `flatLocusStratification`, `flatLocusReduction`, `flatLocusAssembly`, `flatteningStratification`, `flatteningStratification_universal`, `flatteningStratification.ofCurve`) are all on `theorem`/`lemma` declarations with `:= sorry`. All honestly documented as deep Mathlib-gap work.
  - The private helpers `pullback_app_isoTensor_unitAtV`, `pullback_app_isoTensor_baseMap` are axiom-clean.
  - `pullback_of_openImmersion_iso_restrict`: has a real non-sorry proof body (LinearEquiv construction), axiom-clean.
  - `pullback_app_isoTensor_baseMap_sectionLinearEquiv`: partially built proof body, with sorry in "step d" (Beck-Chevalley check). Honest.
  - `pullback_tildeIso`, `pushforward_isQuasicoherent`, `tildeIso_of_isQuasicoherent_isAffineOpen`: private typed-sorry declarations, all honestly annotated as Mathlib-gap pins.
  - `CoherentSheafFlat` (line 170–174): clean `Prop` definition, no sorry.
  - `canonicalBaseChangeMap` (lines 409–420): axiom-clean via `mateEquiv`.

---

### AlgebraicJacobian/Picard/IdentityComponent.lean
- **outdated comments**: 0
- **suspect definitions**: 1 flagged (major — data `def` with `:= sorry`)
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - `Pic0Scheme` (lines 738–743): body is `sorry`. This is a `:= sorry` on a load-bearing data `def` returning `Over (Spec (.of k))`. The comment honestly documents it as iter-185 file-skeleton work.
  - `PicScheme.degree` (lines 779–784): `:= sorry` on a function `→ ℤ`. Honest.
  - `IdentityComponent.isSubgroupHomomorphism` (lines 591–595): `sorry`. Honest.
  - `IdentityComponent.isFiniteTypeGeometricallyIrreducible` (lines 615–635): partial proof — the `LocallyOfFiniteType` conjunct closes axiom-clean (line 627–628), the second conjunct has `sorry`. Honest; the split is well-documented.
  - `IdentityComponent.baseChangeIso` (lines 664–707): partial proof — `GrpObj` and `LocallyOfFiniteType` slots close axiom-clean (lines 681–687), the iso slot has `sorry`. Honest and well-structured.
  - `geometricallyConnected_of_connected_of_section` (lines 414–479): sorry body with extensive analysis of the Stacks 037Q / 04KV gap. The comment at lines 547–550 correctly notes this was demoted from `private instance` to `private theorem` to prevent silent `sorryAx` propagation into typeclass search — this is GOOD practice.
  - `identityComponent_geometricallyConnected` (lines 567–574): propagates the sorry; the comment explicitly warns consumers to invoke it via `letI := ...` rather than as an instance.
  - The axiom-clean helpers (`noetherianSpace_finite_connectedComponents`, `noetherianSpace_isOpen_connectedComponent`, `identityComponent_locallyConnectedSpace`, `identityComponentCarrier`, `IdentityComponent`, `IdentityComponent.isOpenSubgroupScheme`, `identityComponentCarrier_connectedSpace`, `identityComponent_connectedSpace`, `identityComponentSection_range_subset`, `identityComponentSection`, `identityComponentSection_isSection`) are all sound.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - 7 of 8 declarations have `:= sorry` bodies (`genericFlatness`, `flatLocusStratification`, `flatLocusReduction`, `flatLocusAssembly`, `flatteningStratification`, `flatteningStratification_universal`, `flatteningStratification.ofCurve`). All honestly documented as deep Nitsure §4 work.
  - `CoherentSheafFlat` (lines 170–174): clean `Prop` definition, no sorry.
  - No weakened-wrong definitions — all the sorry bodies are on Prop-valued theorems/lemmas, not on definitions that return data.

---

### AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - All 5 pinned declarations (`tangentSpaceIso`, `smooth`, `proper`, `geometricallyIrreducible`, `isAbelianVariety`) have `sorry` bodies. All are Prop-valued (or `Nonempty Σ'`), so these are not data-level wrong definitions. All honestly documented as iter-193 file-skeleton work.

---

## Must-fix-this-iter

- `TensorObjSubstrate.lean:2264` — Section header for `overSliceSheafEquiv` claims "BOTH remaining ⊗-inverse bridges (the A-engine `homOfLocalCompat` gluing and the C-bridge `dual_isLocallyTrivial`) reduce" to this root. **This is directly contradicted by the iter-230 diagnostic in the same file at lines 2118–2161**, which explicitly states `dual_isLocallyTrivial` CANNOT be discharged by `overSliceSheafEquiv` for three distinct structural reasons (wrong category level, fixed vs varying ring, wrong slice granularity). A future prover reading the section header without the diagnostic will be misled. Why must-fix: the contradiction is live in the same file and will actively mislead the next iteration's prover targeting the C-bridge.

- `RelPicFunctor.lean:327` — `PicSharp` (blueprint pin `def:rel_pic_sharp`) has body `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))`. The concept is the relative Picard functor `T ↦ Pic(C ×_k T)/π_T^* Pic(T)`; the body is an unrelated constant functor at a trivial group. Why must-fix: weakened-wrong definition on a load-bearing blueprint-pinned declaration.

- `RelPicFunctor.lean:372` — `PicSharp.functorial` (blueprint pin `lem:rel_pic_sharp_functorial`) has body `0` (the zero `AddMonoidHom`). The concept is the group-homomorphism action of base change; `0` is the wrong morphism. Why must-fix: weakened-wrong definition on a load-bearing blueprint-pinned declaration.

- `RelPicFunctor.lean:235` — `PicSharp.addCommGroup` has body `exact sorry`. This is `:= sorry` on a load-bearing `AddCommGroup` instance (the gateway for everything downstream of the relative Picard quotient). Why must-fix: sorry on a load-bearing claim.

---

## Major

- `RelativeSpec.lean:706` — Docstring for `RelativeSpec.functor` says "`RelativeSpec.structureMorphism` is itself a typed sorry". Since iter-179, `RelativeSpec.structureMorphism` has body `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).toBase` — not a sorry. The body of `functor` itself is correct; only the docstring is stale.

- `LineBundlePullback.lean:349` — `RelPicPresheaf.preimage_subgroup` encodes `L ~ L' ↔ Nonempty (L.carrier ≅ L'.carrier)` (iso-class relation), not the mathematically correct `L ~ L' ↔ L ⊗ L'⁻¹ ∈ π_T^* Pic(T)`. The docstring admits this: "does not yet quotient by the pullback subgroup." This is a documented weakening with a "iter-187+: refine to..." excuse-comment.

- `TensorObjSubstrate.lean:219` — In the `restrictScalars_isIso_μ` docstring: "this ring-iso strong upgrade is **absent** and is the documented 'REAL bottom gap'". The word "absent" without qualification ("from Mathlib") is ambiguous — the declaration being documented IS the upgrade. The surrounding context makes the intent clear, but the sentence is confusing.

- `IdentityComponent.lean:738` — `Pic0Scheme` has body `:= sorry`. This is a data-valued `def` returning `Over (Spec (.of k))` with a sorry body. The conceptual content exists (it should be `GroupScheme.IdentityComponent (PicScheme C)`) but is not wired up due to a missing `[LocallyOfFiniteType (PicScheme C).hom]` instance.

- `QuotScheme.lean:170` — `hilbertPolynomial` has body `:= sorry` returning `Polynomial ℚ`. A sorry on a data `def` is a weakened-wrong definition; every consumer of this function gets an arbitrary polynomial.

- `QuotScheme.lean:208` — `QuotFunctor` has body `:= sorry` returning a functor. Same issue — any downstream use of the functor is meaningless.

---

## Minor

- `TensorObjSubstrate.lean:359,375,392,960` — `set_option backward.isDefEq.respectTransparency false` used four times. Each use silently drops the option without a per-site comment explaining the specific elaboration goal that triggered it.

- `TensorObjSubstrate.lean` (multiple `erw` calls): `erw` is used in around a dozen places (e.g., lines 237, 370, 388, 455, 465, 550–551). Most appear justified for definitional-but-not-syntactic equalities. Worth reviewing to see if any have become `rw`-able after Mathlib updates.

- `FlatteningStratification.lean` (7 sorry bodies): all on `Prop`-valued `theorem`/`lemma` declarations. Mechanically flagged as load-bearing sorries but all honestly documented as Nitsure §4 deep work. No deceptive content.

- `IdentityComponent.lean:414–479` (`geometricallyConnected_of_connected_of_section`): sorry-bodied `private theorem`, Stacks 037Q / 04KU gap. The sorry propagates through `identityComponent_geometricallyConnected` to `baseChangeIso`'s iso slot. All documented; the demotion from `instance` to `theorem` to prevent sorryAx propagation is correct defensive practice.

- Historical iter-NNN narrative in comments (throughout `TensorObjSubstrate.lean` header and docstrings): accurate but verbose. Not stale, just dense.

---

## Excuse-comments (always called out separately)

- `RelPicFunctor.lean:310`: "This is a sorry-free placeholder used while the file-local `addCommGroup` sorry in §1 is open: the *intended* construction... requires the AddCommGroup operations on the quotient to be available concretely to verify the functor identity and composition laws, which is gated on the Mathlib `Scheme.Modules` monoidal-structure upgrade... The trivial target is harmless" — attached to `PicSharp`, which is a load-bearing blueprint-pinned declaration whose body is structurally wrong (constant `PUnit` functor). **Severity: must-fix.**

- `RelPicFunctor.lean:357`: "the body is the zero AddMonoidHom. The math-correct construction — wrapping `RelPicPresheaf.functorial` with `map_zero` and `map_add` proofs... needs the AddCommGroup operations on the quotient to be concrete... This is gated on the same upstream Mathlib upgrade." — attached to `PicSharp.functorial`, body `0`. Load-bearing, blueprint-pinned. **Severity: must-fix.**

---

## Severity summary

- **must-fix-this-iter**: 4 — these block correct downstream reasoning in their files:
  1. Stale `overSliceSheafEquiv` claim (TensorObjSubstrate.lean)
  2. `PicSharp` wrong body (RelPicFunctor.lean)
  3. `PicSharp.functorial` wrong body (RelPicFunctor.lean)
  4. `PicSharp.addCommGroup` sorry (RelPicFunctor.lean)
- **major**: 6
- **minor**: 5
- **excuse-comments**: 2 (also counted under must-fix-this-iter above; both on load-bearing wrong definitions in RelPicFunctor.lean)

Overall verdict: The primary file `TensorObjSubstrate.lean` is structurally sound — its three sorry bodies are honestly documented, the closed proofs are clean, and the iter-230 diagnostic is accurate — but carries one must-fix stale comment (the `overSliceSheafEquiv` section header contradicts the iter-230 probe outcome). The most serious findings are in `RelPicFunctor.lean`, where two blueprint-pinned declarations (`PicSharp`, `PicSharp.functorial`) have weakened-wrong bodies with excuse-comments, and one load-bearing instance (`addCommGroup`) carries a raw sorry.
